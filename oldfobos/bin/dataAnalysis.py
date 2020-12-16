#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2016 Cryptographic Engineering Research Group (CERG)           #
#	George Mason University							 #	
#   http://cryptography.gmu.edu/fobos                                            #                            
#									         #                             	 
#	Licensed under the Apache License, Version 2.0 (the "License");        	 #
#	you may not use this file except in compliance with the License.       	 #
#	You may obtain a copy of the License at                                	 #
#	                                                                       	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                         	 #
#	                                                                       	 #
#	Unless required by applicable law or agreed to in writing, software    	 #
#	distributed under the License is distributed on an "AS IS" BASIS,      	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#	See the License for the specific language governing permissions and      #
#	limitations under the License.                                           #
#                                                                           	 #
##################################################################################
import os
import time
from globals import cfg, globals,support, printFunctions, configExtract, dataGenerator
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
	cfg.EXPECTED_KEY = dataGenerator.getKeyForAnalysis()
	#################################################################
	############# USER DEFINED SECTION FROM HERE #######################
	#################################################################
	#plottingModule.plotRawTrace(cfg.RAW_POWER_DATA, 200750, 204750)
	configExtract.extractAnalysisConfigAttributes("signalAlignmentParams.txt")
	alignedData = signalAnalysisModule.getAlignedMeasuredPowerData() # Aligned Power traces with respect to trigger
	plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')	
	#sampleVarTimeWise = statisticsModule.calculate_std(alignedData, globals.TRACE_WISE) 	
	#support.wait()
	#configExtract.extractAnalysisConfigAttributes("traceExpungeParams.txt")
	#alignedData = postProcessingModule.traceExpunge(alignedData)
	#plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	configExtract.extractAnalysisConfigAttributes("sampleSpaceDispParams.txt")
	windowedData = postProcessingModule.sampleSpaceDisp(alignedData)
	#plottingModule.plotTrace(windowedData, 'ALL', 'OVERLAY')
	configExtract.extractAnalysisConfigAttributes("compressionParams.txt")
	compressedData = postProcessingModule.compressData(windowedData)
	#plottingModule.plotTrace(compressedData, 'ALL', 'OVERLAY')
	#autoCorrelatedData = sca.calculate_autocorrelation(alignedData)
	#plottingModule.plotCorr(autoCorrelatedData, globals.AUTOCORR)
	for byteNum in range(0, 16):
		fileName = 'HW_byte_' + str(byteNum) + '.txt'
		hypotheticalPowerData = signalAnalysisModule.acquirePowerModel(fileName, globals.ADAPTIVE_CPA)
		correlationData = sca.correlation_pearson(compressedData, hypotheticalPowerData) 
		plottingModule.plotCorr(correlationData, globals.PEARSON)
		plottingModule.plotHist(correlationData, globals.PEARSON)
		cfg.KEYARRAY[cfg.KEY_INDEX] = cfg.KEY_BYTE_CORR # cfg.KEY_BYTE_HIST|| cfg.KEY_BYTE_CORR
		#mge = sca.findMinimumGuessingEntropy(compressedData, hypotheticalPowerData,globals.PEARSON,20,cfg.KEYARRAY[cfg.KEY_INDEX])

	printFunctions.printKeyFound(cfg.KEYARRAY)
        #m1 = statisticsModule.calculate_mean(alignedData, globals.SAMPLE_WISE)
	#m2 = statisticsModule.calculate_mean(alignedData, globals.TRACE_WISE)
	#s1 = statisticsModule.calculate_std(alignedData, globals.SAMPLE_WISE)
	#s2 = statisticsModule.calculate_std(alignedData, globals.TRACE_WISE)
	#v1 = statisticsModule.calculate_var(alignedData, globals.SAMPLE_WISE)
	#v2 = statisticsModule.calculate_var(alignedData, globals.TRACE_WISE)

	
if __name__ == "__main__": 
	start_time=time.time()
        main()		
	print("\tTotal Execution Time=%s seconds" %(time.time() - start_time))
	
