#!/usr/bin/python
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
	configExtract.extractAnalysisConfigAttributes("signalAlignmentParams.txt")
	alignedData = signalAlignmentModule.getAlignedMeasuredPowerData() # Aligned Power traces with respect to trigger
	plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	sampleVarTimeWise = sca.calculate_var(alignedData, globals.TRACE_WISE) 
	#support.wait()
	configExtract.extractAnalysisConfigAttributes("traceExpungeParams.txt")
	alignedData = postProcessingModule.traceExpunge(alignedData)
	plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	configExtract.extractAnalysisConfigAttributes("sampleSpaceDispParams.txt")
	windowedData = postProcessingModule.sampleSpaceDisp(alignedData)
	plottingModule.plotTrace(windowedData, 'ALL', 'OVERLAY')
	configExtract.extractAnalysisConfigAttributes("compressionParams.txt")
	compressedData = postProcessingModule.compressData(windowedData)
	plottingModule.plotTrace(compressedData, 'ALL', 'OVERLAY')
	hypotheticalPowerData = signalAlignmentModule.acquireHypotheticalValues("key_guess.txt")
	correlationData = sca.correlation_pearson(compressedData, hypotheticalPowerData) 
	plottingModule.plotCorr(correlationData, globals.PEARSON)
	sp = sca.correlation_spearman(compressedData, hypotheticalPowerData)
	plottingModule.plotCorr(sp, globals.SPEARMAN)
	ac = sca.calculate_autocorrelation(alignedData)
	plottingModule.plotCorr(ac, globals.AUTOCORR)
	m1 = sca.calculate_mean(alignedData, globals.SAMPLE_WISE)
	m2 = sca.calculate_mean(alignedData, globals.TRACE_WISE)
	s1 = sca.calculate_std(alignedData, globals.SAMPLE_WISE)
	s2 = sca.calculate_std(alignedData, globals.TRACE_WISE)
	v1 = sca.calculate_var(alignedData, globals.SAMPLE_WISE)
	v2 = sca.calculate_var(alignedData, globals.TRACE_WISE)

	
if __name__ == "__main__":
    main()		
	
	