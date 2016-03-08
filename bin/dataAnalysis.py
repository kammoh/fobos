#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2014 Cryptographic Engineering Research Group (CERG)               #
#	George Mason University														 #	
#   http://cryptography.gmu.edu/fobos                                            #                            
#									                                             #                             	 
#	Licensed under the Apache License, Version 2.0 (the "License");         	 #
#	you may not use this file except in compliance with the License.        	 #
#	You may obtain a copy of the License at                                 	 #
#	                                                                        	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                          	 #
#	                                                                        	 #
#	Unless required by applicable law or agreed to in writing, software     	 #
#	distributed under the License is distributed on an "AS IS" BASIS,       	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.	 #
#	See the License for the specific language governing permissions and     	 #
#	limitations under the License.                                          	 #
#                                                                           	 #
##################################################################################
import os
import time
from globals import cfg, globals,support, printFunctions, configExtract
from analysis import signalAnalysisModule
from analysis import postProcessingModule
from analysis import plottingModule
from analysis import statisticsModule
from analysis import sca

def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.BINDIR = os.path.join(cfg.ROOTDIR,globals.BIN_DIRNAME)
	cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,globals.CONFIG_DIRNAME)
	cfg.ANALYSISCONFIGDIR = os.path.join(cfg.ROOTDIR, globals.ANALYSIS_CONFIG_DIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.CONFIGDIR, globals.CONFIG_FILENAME)
	cfg.OSC_CONFIGFILE = os.path.join(cfg.CONFIGDIR, globals.OSC_CONFIGFILENAME)
	cfg.ANALYSIS_SCRIPT_FILE = os.path.join(cfg.BINDIR, globals.ANALYSIS_SCRIPT_FILENAME)
	cfg.PROGRAM_CALL = "ANALYSIS"
	
def main():	
	#################################################################
	############# PLEASE DO NOT MODIFY THIS SECTION #################
	#################################################################
	support.clear_screen()
	init()
	printFunctions.printAnalysisHeaderToScreen()
	
	configExtract.extractConfigAttributes()
	
	configExtract.configureAnalysisWorkspace()
	
	printFunctions.printAnalysisHeaderToLog()
	support.setPlotAttributes()
	#################################################################
	############# USER DEFINED SECTION FROM HERE #######################
	#################################################################
	#plottingModule.plotRawTrace(cfg.RAW_POWER_DATA, 200750, 204750)
	#plottingModule.plotRawTrace(cfg.RAW_TRIGGER_DATA,200750, 204750)
	#plottingModule.showRawTrace(cfg.RAW_POWER_DATA)
	#plottingModule.showRawTrace(cfg.RAW_TRIGGER_DATA)
	#print cfg.RAW_POWER_DATA.shape
	#print cfg.RAW_TRIGGER_DATA.shape
	configExtract.extractAnalysisConfigAttributes("signalAlignmentParams.txt")
	
	#plottingModule.plotRawTrace(cfg.RAW_POWER_DATA, 0, 2000000)	
	#plottingModule.plotRawTrace(cfg.RAW_TRIGGER_DATA , 0, 2000000)	
	alignedData = signalAnalysisModule.getAlignedMeasuredPowerData() # Aligned Power traces with respect to trigger
	#signalAnalysisModule.spectogram(cfg.RAW_POWER_DATA)
	plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')	
	sampleVarTimeWise = statisticsModule.calculate_std(alignedData, globals.TRACE_WISE) 	
	support.wait()
	configExtract.extractAnalysisConfigAttributes("traceExpungeParams.txt")
	alignedData = postProcessingModule.traceExpunge(alignedData)
	plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	#configExtract.extractAnalysisConfigAttributes("sampleSpaceDispParams.txt")
	#windowedData = postProcessingModule.sampleSpaceDisp(alignedData)
	#plottingModule.plotTrace(windowedData, 'ALL', 'OVERLAY')
	#configExtract.extractAnalysisConfigAttributes("compressionParams.txt")
	#compressedData = postProcessingModule.compressData(windowedData)
	#plottingModule.plotTrace(compressedData, 'ALL', 'OVERLAY')
	hypotheticalPowerData = signalAnalysisModule.acquireHypotheticalValues("hw4000x256.txt")
	correlationData = sca.correlation_pearson(alignedData, hypotheticalPowerData) 
	plottingModule.plotCorr(correlationData, globals.PEARSON)
	plottingModule.plotHist(correlationData, globals.PEARSON)
	#mge = sca.findMinimumGuessingEntropy(compressedData, hypotheticalPowerData,globals.PEARSON,50,22)
	sp = sca.correlation_spearman(alignedData, hypotheticalPowerData)
	plottingModule.plotCorr(sp, globals.SPEARMAN)
	plottingModule.plotHist(sp, globals.SPEARMAN)
	#an = sca.anova(compressedData, hypotheticalPowerData)
	#plottingModule.plotCorr(an, globals.ANOVA)	
	#ac = sca.calculate_autocorrelation(alignedData)
	#plottingModule.plotCorr(ac, globals.AUTOCORR)
        #m1 = statisticsModule.calculate_mean(alignedData, globals.SAMPLE_WISE)
	#m2 = statisticsModule.calculate_mean(alignedData, globals.TRACE_WISE)
	#s1 = statisticsModule.calculate_std(alignedData, globals.SAMPLE_WISE)
	#s2 = statisticsModule.calculate_std(alignedData, globals.TRACE_WISE)
	#v1 = statisticsModule.calculate_var(alignedData, globals.SAMPLE_WISE)
	#v2 = statisticsModule.calculate_var(alignedData, globals.TRACE_WISE)

	
if __name__ == "__main__": 
	start_time=time.time()
        main()		
	print("Total Execution Time=%s seconds" %(time.time() - start_time))
	
