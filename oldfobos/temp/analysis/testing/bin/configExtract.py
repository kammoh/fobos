#!/usr/bin/python
import array
import time
import sys
import os
import cfg
import re
import support
import globals
import signalAlignmentModule
   
   
def configureWorkspace():
	runNo = 1
	tag = cfg.analysisConfigAttributes['TAG']
	dateString = support.currentDateTime()
	cfg.WORKSPACEDIR = os.path.normpath(os.path.join(cfg.ROOTDIR,cfg.analysisConfigAttributes['WORK_DIR']))
	support.createDirectory(cfg.WORKSPACEDIR)
	if(cfg.analysisConfigAttributes['TAG'] == 'date'):
		temp = dateString+'-'+cfg.analysisConfigAttributes['MEASUREMENT_WORK_DIR']+'-'+cfg.analysisConfigAttributes['MEASUREMENT_PROJECT_DIR']
		cfg.WORKSPACE = os.path.join(cfg.WORKSPACEDIR,temp)
	elif(cfg.analysisConfigAttributes['TAG'] == 'counter'):
		cfg.WORKSPACE = os.path.join(cfg.WORKSPACEDIR,str(runNo)+'-'+cfg.analysisConfigAttributes['MEASUREMENT_WORK_DIR']+'-'+cfg.analysisConfigAttributes['MEASUREMENT_PROJECT_DIR'])
		while os.path.exists(cfg.WORKSPACE):
			runNo += 1
			cfg.WORKSPACE = os.path.join(cfg.WORKSPACEDIR,str(runNo)+'-'+cfg.analysisConfigAttributes['MEASUREMENT_WORK_DIR']+'-'+cfg.analysisConfigAttributes['MEASUREMENT_PROJECT_DIR'])		
	support.createDirectory(cfg.WORKSPACE)
	cfg.MEASUREMENTDIR = support.getProjectPath()
	cfg.MEASUREMENTDIR = os.path.join(cfg.MEASUREMENTDIR, globals.MEASUREMENT_FOLDERNAME)
	if (os.path.isdir(cfg.MEASUREMENTDIR) == False):
		os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
		support.printToScreenBold("\tMeasurement Directory @\n\t"+cfg.MEASUREMENTDIR+"\n\tdoes not exits. Please re-run the FOBOS Analysis again\n")
		support.exitProgram()
	cfg.ALIGNED_DATA_FILE = os.path.join(cfg.MEASUREMENTDIR, globals.ALIGNED_DATA_FILE_NAME)
	cfg.RAW_UNALIGNED_POWER_FILE = os.path.join(cfg.MEASUREMENTDIR, globals.RAW_UNALIGNED_POWER_FILE_NAME)
	cfg.RAW_UNALIGNED_TRIGGER_FILE = os.path.join(cfg.MEASUREMENTDIR, globals.RAW_UNALIGNED_TRIGGER_FILE_NAME)
	cfg.POWERMODELDIR = os.path.join(cfg.ROOTDIR, globals.POWERMODELS_DIRNAME)
	cfg.FOBOS_ANALYSIS_LOG_FILE = os.path.join(cfg.WORKSPACE, globals.FOBOS_ANALYSIS_LOG_FILE_NAME)
	signalAlignmentModule.readRawTraces()
	
def extractConfigAttributes(CONFIG_FILE):
	CONFIG_FILE = os.path.join(cfg.CONFIGDIR, CONFIG_FILE)
	data_list = support.readFile(CONFIG_FILE)
	data_list = support.removeComments(data_list)
	for object in data_list:
		if re.match('^SAMPLE_WINDOW', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['SAMPLE_WINDOW'] = int(value[1].strip(" "))
		if re.match('^WINDOW_START_POINT', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['WINDOW_START_POINT'] = int(value[1].strip(" "))
		if re.match('^TRIGGER_THRESHOLD', object) :			
			value = re.split("=", object)
			cfg.analysisConfigAttributes['TRIGGER_THRESHOLD'] = float(value[1].strip(" "))			
		if re.match('^CAPTURE_MODE', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['CAPTURE_MODE'] = value[1].strip(" ")
		if re.match('^COMPRESSION_LENGTH', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['COMPRESSION_LENGTH'] = int(value[1].strip(" "))
		if re.match('^COMPRESSION_TYPE', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['COMPRESSION_TYPE'] = value[1].strip(" ")
		if re.match('^SAMPLE_SPACE_DISPOSITION', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] = value[1].strip(" ")
		if re.match('^COMPRESS_DATA', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['COMPRESS_DATA'] = value[1].strip(" ")
		if re.match('^CORRELATION_PEARSONS', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['CORRELATION_PEARSONS'] = value[1].strip(" ")
		if re.match('^TRACE_EXPUNGE', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['TRACE_EXPUNGE'] = value[1].strip(" ")
		if re.match('^COMPUTE_AUTOCORRELATION', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['COMPUTE_AUTOCORRELATION'] = value[1].strip(" ")
		if re.match('^TRACE_EXPUNGE_PARAMS', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['TRACE_EXPUNGE_PARAMS'] = value[1].strip(" ")
		if re.match('^WORK_DIR', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['WORK_DIR'] = value[1].strip(" ")
		if re.match('^MEASUREMENT_PROJECT_DIR', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['MEASUREMENT_PROJECT_DIR'] = value[1].strip(" ")
		if re.match('^MEASUREMENT_WORK_DIR', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['MEASUREMENT_WORK_DIR'] = value[1].strip(" ")
		if re.match('^TAG', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['TAG'] = value[1].strip(" ")
		