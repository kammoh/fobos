#!/usr/bin/python
import os
import cfg, globals,support
import configExtract
import signalAlignmentModule
import postProcessingModule
import plottingModule
import sca

def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.BINDIR = os.path.join(cfg.ROOTDIR,globals.BIN_DIRNAME)
	cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,globals.CONFIG_DIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.CONFIGDIR, globals.CONFIGFILENAME)
	
def main():	
	#################################################################
	############# PLEASE DO NOT MODIFY THIS SECTION #################
	#################################################################
	support.clear_screen()
	init()
	support.printHeaderToScreen()
	configExtract.extractConfigAttributes(globals.CONFIGFILENAME)
	configExtract.configureWorkspace()
	support.printHeaderToLog()
	#################################################################
	############# USER DEFINED SECTION FROM HERE #######################
	#################################################################
	configExtract.extractConfigAttributes("signalAlignmentParams.txt")
	alignedData = signalAlignmentModule.getAlignedMeasuredPowerData() # Aligned Power traces with respect to clock
	plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	#sampleVarTimeWise = sca.calculate_var(alignedData, globals.TRACE_WISE) 
	#support.wait()
	#configExtract.extractConfigAttributes("traceExpungeParams.txt")
	#alignedData = postProcessingModule.traceExpunge(alignedData)
	plottingModule.plotTrace(alignedData, 'ALL', 'OVERLAY')
	configExtract.extractConfigAttributes("sampleSpaceDispParams.txt")
	windowedData = postProcessingModule.sampleSpaceDisp(alignedData)
	plottingModule.plotTrace(windowedData, 'ALL', 'OVERLAY')
	configExtract.extractConfigAttributes("compressionParams.txt")
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
	
	