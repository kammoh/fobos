#!/usr/bin/python
#############################################################################
#                                                                           #
#	Copyright 2014 CERG                                                     #
#	                                                                        #
#	Licensed under the Apache License, Version 2.0 (the "License");         #
#	you may not use this file except in compliance with the License.        #
#	You may obtain a copy of the License at                                 #
#	                                                                        #
#	    http://www.apache.org/licenses/LICENSE-2.0                          #
#	                                                                        #
#	Unless required by applicable law or agreed to in writing, software     #
#	distributed under the License is distributed on an "AS IS" BASIS,       #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#	See the License for the specific language governing permissions and     #
#	limitations under the License.                                          #
#                                                                           #
#############################################################################
import os
import cfg, globals,support, printFunctions
import configExtract
from analysis import signalAlignmentModule
from analysis import postProcessingModule
from analysis import plottingModule
from analysis import sca

def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.BINDIR = os.path.join(cfg.ROOTDIR,globals.BIN_DIRNAME)
	cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,globals.CONFIG_DIRNAME)
	cfg.ANALYSISCONFIGDIR = os.path.join(cfg.ROOTDIR, globals.ANALYSIS_CONFIG_DIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.CONFIGDIR, globals.CONFIG_FILENAME)
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
	configExtract.extractAnalysisConfigAttributes("signalAlignmentParams.txt")
	alignedData = signalAlignmentModule.getAlignedMeasuredPowerData() # Aligned Power traces with respect to trigger
	#plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	#sampleVarTimeWise = sca.calculate_var(alignedData, globals.TRACE_WISE) 
	# #support.wait()
	configExtract.extractAnalysisConfigAttributes("traceExpungeParams.txt")
	alignedData = postProcessingModule.traceExpunge(alignedData)
	#plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	configExtract.extractAnalysisConfigAttributes("sampleSpaceDispParams.txt")
	windowedData = postProcessingModule.sampleSpaceDisp(alignedData)
	#plottingModule.plotTrace(windowedData, 'ALL', 'OVERLAY')
	configExtract.extractAnalysisConfigAttributes("compressionParams.txt")
	compressedData = postProcessingModule.compressData(windowedData)
	#plottingModule.plotTrace(compressedData, 'ALL', 'OVERLAY')
	hypotheticalPowerData = signalAlignmentModule.acquireHypotheticalValues("key_guess.txt")
	correlationData = sca.correlation_pearson(compressedData, hypotheticalPowerData) 
	#plottingModule.plotCorr(correlationData, globals.PEARSON)
	sp = sca.correlation_spearman(compressedData, hypotheticalPowerData)
	#plottingModule.plotCorr(sp, globals.SPEARMAN)
	#ac = sca.calculate_autocorrelation(alignedData)
	#plottingModule.plotCorr(ac, globals.AUTOCORR)
	#m1 = sca.calculate_mean(alignedData, globals.SAMPLE_WISE)
	#m2 = sca.calculate_mean(alignedData, globals.TRACE_WISE)
	#s1 = sca.calculate_std(alignedData, globals.SAMPLE_WISE)
	#s2 = sca.calculate_std(alignedData, globals.TRACE_WISE)
	v1 = sca.calculate_var(alignedData, globals.SAMPLE_WISE)
	v2 = sca.calculate_var(alignedData, globals.TRACE_WISE)

	
if __name__ == "__main__": 
	main()		
	
	