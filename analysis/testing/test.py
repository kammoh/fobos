#!/usr/bin/python
import os
import sys
import numpy
import matplotlib.pyplot as plt
import cfg
from configExtract import *
import sca
import signalAlignmentModule
import postProcessingModule
import plottingModule

def init():
	sys.stdout.write("Initializing Data Analysis Module ..\n")
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.TESTDIR = os.path.join(cfg.ROOTDIR, cfg.TESTDIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.TESTDIR, cfg.CONFIGFILENAME)
	cfg.ALIGNED_DATA_FILE = os.path.join(cfg.TESTDIR, cfg.ALIGNED_DATA_FILE_NAME)
	cfg.RAW_UNALIGNED_POWER_FILE = os.path.join(cfg.TESTDIR, cfg.RAW_UNALIGNED_POWER_FILE_NAME)
	cfg.RAW_UNALIGNED_TRIGGER_FILE = os.path.join(cfg.TESTDIR, cfg.RAW_UNALIGNED_TRIGGER_FILE_NAME)
	cfg.POWER_MODEL_FILE = os.path.join(cfg.TESTDIR, cfg.POWER_MODEL_FILE_NAME)
	cfg.TRACE_EXPUNGE_DATA_FILE = os.path.join(cfg.TESTDIR, cfg.TRACE_EXPUNGE_DATA_FILE_NAME)
	
def main():	
	clear_screen()
	print_header()
	init()
	extractConfigAttributes()
	alignedData = signalAlignmentModule.getAlignedMeasuredPowerData()
	alignedData = postProcessingModule.trace_expunge(alignedData)
	postProcessedData = postProcessingModule.postProcessing(alignedData)
	hypotheticalPowerData = signalAlignmentModule.acquireHypotheticalValues()
	c = sca.correlation_pearson(postProcessedData, hypotheticalPowerData) 
	#sp = sca.correlation_spearman(postProcessedData, hypotheticalPowerData)
	#ac = sca.calculate_autocorrelation(postProcessedData)
	#m = sca.calculate_mean(postProcessedData, cfg.ROW)
	#s = sca.calculate_std(postProcessedData, cfg.ROW)
	#v = sca.calculate_var(postProcessedData, cfg.ROW)
	
	
if __name__ == "__main__":
    main()		
	
	