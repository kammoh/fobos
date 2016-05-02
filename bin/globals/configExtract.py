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
import array, re
import time
import sys
import os
import support
import globals
import printFunctions
import cfg
import shutil
from  analysis import signalAnalysisModule
import logging

def configureWorkspace():
	runNo = 1
	tag = cfg.config_attributes['TAG']
	dateString = support.currentDateTime()
	cfg.WORKSPACEDIR = os.path.normpath(os.path.join(cfg.ROOTDIR,cfg.config_attributes['WORK_DIR']))
	cfg.PROJECTDIR = os.path.join(cfg.WORKSPACEDIR, cfg.config_attributes['PROJECT_NAME'])
	cfg.PLOT_SCRIPT = os.path.join(cfg.BINDIR, "oscilloscope", "viewPlots.py")
	support.createDirectory(cfg.WORKSPACEDIR)
	support.createDirectory(cfg.PROJECTDIR)
	if(tag == 'date'):
		cfg.WORKSPACE = os.path.join(cfg.PROJECTDIR,dateString+'-'+cfg.config_attributes['PROJECT_NAME'])
	elif(tag == 'counter'):
		cfg.WORKSPACE = os.path.join(cfg.PROJECTDIR,str(runNo)+'-'+cfg.config_attributes['PROJECT_NAME'])
		while os.path.exists(cfg.WORKSPACE):
			runNo += 1
			cfg.WORKSPACE = os.path.join(cfg.PROJECTDIR,str(runNo)+'-'+cfg.config_attributes['PROJECT_NAME'])
			
	support.createDirectory(cfg.WORKSPACE)
	cfg.OUTPUT_FOLDER = os.path.join(cfg.WORKSPACE,globals.OUTPUT_FOLDERNAME)
	cfg.MEASUREMENT_FOLDER = os.path.join(cfg.WORKSPACE,globals.MEASUREMENT_FOLDERNAME)
	cfg.FOBOS_LOG_FILE = os.path.join(cfg.WORKSPACE,globals.FOBOS_LOG_FILE_NAME)
	cfg.PLAIN_TEXT_FILE = os.path.join(cfg.OUTPUT_FOLDER,globals.PLAIN_TEXT_FILE_NAME)
	cfg.CIPHER_TEXT_FILE = os.path.join(cfg.OUTPUT_FOLDER,globals.CIPHER_TEXT_FILE_NAME)
	cfg.KEY_FILE = os.path.join(cfg.OUTPUT_FOLDER,globals.KEY_FILE_NAME)
	cfg.config_attributes['DATA_FILE'] = os.path.join(cfg.ROOTDIR,cfg.config_attributes['SOURCE_DIR'],cfg.config_attributes['DATA_FILE'])	
	cfg.config_attributes['KEY_FILE'] = os.path.join(cfg.ROOTDIR,cfg.config_attributes['SOURCE_DIR'],cfg.config_attributes['KEY_FILE'])
	support.createDirectory(cfg.OUTPUT_FOLDER)
	support.createDirectory(cfg.MEASUREMENT_FOLDER)
	shutil.copy(cfg.PLOT_SCRIPT, cfg.MEASUREMENT_FOLDER)
	shutil.copy(cfg.OSC_CONFIGFILE, cfg.MEASUREMENT_FOLDER)
	
def extractConfigAttributes():
	data_list = support.readFile(cfg.CONFIG_FILE)
	data_list = support.removeComments(data_list)
	for object in data_list:
		if re.match('^WORK_DIR', object) :
			value = re.split("=", object)
			cfg.config_attributes['WORK_DIR'] = value[1].strip(" ")
			cfg.analysisConfigAttributes['WORK_DIR'] = value[1].strip(" ")
		if re.match('^SOURCE_DIR', object) :
			value = re.split("=", object)
			cfg.config_attributes['SOURCE_DIR'] = value[1].strip(" ")
		if re.match('^PROJECT_NAME', object) :
			value = re.split("=", object)
			cfg.config_attributes['PROJECT_NAME'] = value[1].strip(" ")
			cfg.analysisConfigAttributes['PROJECT_NAME'] = value[1].strip(" ")
		if re.match('^TAG', object) :
			value = re.split("=", object)
			cfg.config_attributes['TAG'] = value[1].strip(" ")
			cfg.analysisConfigAttributes['TAG'] = value[1].strip(" ")
		if re.match('^LOGGING', object) :
			value = re.split("=", object)
			cfg.config_attributes['LOGGING'] = value[1].strip(" ")
			cfg.analysisConfigAttributes['LOGGING'] = value[1].strip(" ")
		if re.match('^GENERATE_EPS_PDF_GRAPHS', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] = value[1].strip(" ")		
		if re.match('^PLOT_SIZE_LENGTH', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['PLOT_SIZE_LENGTH'] = float(value[1].strip(" "))	
		if re.match('^PLOT_SIZE_BREADTH', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['PLOT_SIZE_BREADTH'] = float(value[1].strip(" "))	
		if re.match('^PLOT_LABELS_FONT_FAMILY', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['PLOT_LABELS_FONT_FAMILY'] = value[1].strip(" ")	
		if re.match('^PLOT_LABELS_FONT_WEIGHT', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['PLOT_LABELS_FONT_WEIGHT'] = value[1].strip(" ")
		if re.match('^PLOT_LABELS_FONT_SIZE', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['PLOT_LABELS_FONT_SIZE'] = int(value[1].strip(" ")	)
		if re.match('^DISPLAY_THREE_SIGMAS', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] = int(value[1].strip(" ")	)			

	data_list = support.readFile(cfg.OSC_CONFIGFILE)
	data_list = support.removeComments(data_list)
	for object in data_list:
		if re.match('^VICTIM_RESET', object) :
			value = re.split("=", object)
			cfg.config_attributes['VICTIM_RESET'] = value[1].strip(" ")
		if re.match('^DATA_FILE', object) :
			value = re.split("=", object)
			cfg.config_attributes['DATA_FILE'] = value[1].strip(" ")
		if re.match('^KEY_FILE', object) :
			value = re.split("=", object)
			cfg.config_attributes['KEY_FILE'] = value[1].strip(" ")
		if re.match('^INPUT_FORMAT', object) :
			value = re.split("=", object)
			cfg.config_attributes['INPUT_FORMAT'] = value[1].strip(" ")
		if re.match('^TRIGGER_WAIT_CYCLES', object) :
			value = re.split("=", object)
			cfg.config_attributes['TRIGGER_WAIT_CYCLES'] = int(value[1].strip(" "))
		if re.match('^TRIGGER_LENGTH_CYCLES', object) :
			value = re.split("=", object)
			cfg.config_attributes['TRIGGER_LENGTH_CYCLES'] = int(value[1].strip(" "))
		if re.match('^OUTPUT_FORMAT', object) :
			value = re.split("=", object)
			cfg.config_attributes['OUTPUT_FORMAT'] = value[1].strip(" ")
		if re.match('^TIMEOUT_VAL', object) :
			value = re.split("=", object)
			cfg.config_attributes['TIMEOUT_VAL'] = value[1].strip(" ")
		if re.match('^CLK_FREQ', object) :
			value = re.split("=", object)
			cfg.config_attributes['CLK_FREQ'] = value[1].strip(" ")
		if re.match('^MEASUREMENT_FORMAT', object) :
			value = re.split("=", object)
			cfg.config_attributes['MEASUREMENT_FORMAT'] = value[1].strip(" ")
		if re.match('^CONTROL_BOARD', object) :
			value = re.split("=", object)
			cfg.config_attributes['CONTROL_BOARD'] = value[1].strip(" ")
		if re.match('^NUMBER_OF_ENCRYPTIONS_PER_TRACE', object) :
			value = re.split("=", object)
			cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] = int(value[1].strip(" "))
		if re.match('^BLOCK_SIZE', object) :
			value = re.split("=", object)
			cfg.config_attributes['BLOCK_SIZE'] = int(value[1].strip(" "))	
		if re.match('^KEY_SIZE', object) :
			value = re.split("=", object)
			cfg.config_attributes['KEY_SIZE'] = int(value[1].strip(" "))				
		if re.match('^NUMBER_OF_TRACES', object) :
			value = re.split("=", object)
			cfg.config_attributes['NUMBER_OF_TRACES'] = int(value[1].strip(" "))
		if re.match('^PLAINTEXT_GENERATION', object) :
			value = re.split("=", object)
			cfg.config_attributes['PLAINTEXT_GENERATION'] = value[1].strip(" ")
		if re.match('^KEY_GENERATION', object) :
			value = re.split("=", object)
			cfg.config_attributes['KEY_GENERATION'] = value[1].strip(" ")			
		if re.match('^DUMMY_RUN', object) :
			value = re.split("=", object)
			cfg.config_attributes['DUMMY_RUN'] = value[1].strip(" ")
			
def updatePowerAndTriggerFileNames():
	powerFileExistsFlag = False
	triggerFileExistsFlag = False
	print os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL1_MEASUREMENT_FILE_NAME)
	if (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL1_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_POWER_FILE_NAME = globals.ANALYSIS_CHANNEL1_MEASUREMENT_FILE_NAME
		powerFileExistsFlag = True
	elif (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL2_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_POWER_FILE_NAME = globals.ANALYSIS_CHANNEL2_MEASUREMENT_FILE_NAME
		powerFileExistsFlag = True
	elif (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL3_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_POWER_FILE_NAME = globals.ANALYSIS_CHANNEL3_MEASUREMENT_FILE_NAME
		powerFileExistsFlag = True
	elif (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL4_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_POWER_FILE_NAME = globals.ANALYSIS_CHANNEL4_MEASUREMENT_FILE_NAME
		powerFileExistsFlag = True
		
	if (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL1_TRIGGER_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_TRIGGER_FILE_NAME = globals.ANALYSIS_CHANNEL1_TRIGGER_MEASUREMENT_FILE_NAME
		triggerFileExistsFlag = True
	elif (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL2_TRIGGER_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_TRIGGER_FILE_NAME = globals.ANALYSIS_CHANNEL2_TRIGGER_MEASUREMENT_FILE_NAME
		triggerFileExistsFlag = True
	elif (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL3_TRIGGER_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_TRIGGER_FILE_NAME = globals.ANALYSIS_CHANNEL3_TRIGGER_MEASUREMENT_FILE_NAME
		triggerFileExistsFlag = True
	elif (os.path.isfile(os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL4_TRIGGER_MEASUREMENT_FILE_NAME))):
		cfg.RAW_UNALIGNED_TRIGGER_FILE_NAME = globals.ANALYSIS_CHANNEL4_TRIGGER_MEASUREMENT_FILE_NAME
		triggerFileExistsFlag = True
	if (powerFileExistsFlag == False or triggerFileExistsFlag == False):
		os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
		printFunctions.printToScreenBold("\tMeasurement Directory @\n\t"+cfg.MEASUREMENT_FOLDER+"\n\tdoes not contain Power/Trigger trace files. Please re-run the FOBOS Analysis again\n")
		support.exitProgram()
		

		
def configureAnalysisWorkspace():
	runNo = 1
	tag = cfg.analysisConfigAttributes['TAG']
	dateString = support.currentDateTime()
	cfg.ANALYSISDIR = support.getProjectPath()
	tempFolderName = cfg.ANALYSISDIR
	cfg.ANALYSISDIR = os.path.join(cfg.ANALYSISDIR, globals.ANALYSIS_FOLDER_NAME)
	support.createDirectory(cfg.ANALYSISDIR)
	
	if(cfg.analysisConfigAttributes['TAG'] == 'date'):
		temp = dateString+'-'+'-'+cfg.analysisConfigAttributes['PROJECT_NAME']
		cfg.ANALYSIS_WORKSPACE = os.path.join(cfg.ANALYSISDIR,temp)
	elif(cfg.analysisConfigAttributes['TAG'] == 'counter'):
		cfg.ANALYSIS_WORKSPACE = os.path.join(cfg.ANALYSISDIR,str(runNo)+'-'+cfg.analysisConfigAttributes['PROJECT_NAME'])
		while os.path.exists(cfg.ANALYSIS_WORKSPACE):
			runNo += 1
			cfg.ANALYSIS_WORKSPACE = os.path.join(cfg.ANALYSISDIR,str(runNo)+'-'+cfg.analysisConfigAttributes['PROJECT_NAME'])		
	support.createDirectory(cfg.ANALYSIS_WORKSPACE)
	printFunctions.printToScreen("This Analysis will be located @ - " + cfg.ANALYSIS_WORKSPACE)
	cfg.MEASUREMENT_FOLDER = os.path.join(tempFolderName, globals.MEASUREMENT_FOLDERNAME)
	cfg.OUTPUT_FOLDER= os.path.join(tempFolderName, globals.OUTPUT_FOLDERNAME)
	printFunctions.printToScreen("This Analysis uses data from - " + cfg.MEASUREMENT_FOLDER)
	if (os.path.isdir(cfg.MEASUREMENT_FOLDER) == False):
		os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
		printFunctions.printToScreenBold("\tMeasurement Directory @\n\t"+cfg.MEASUREMENT_FOLDER+"\n\tdoes not exits. Please re-run the FOBOS Analysis again\n")
		support.exitProgram()
	cfg.ALIGNED_DATA_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.ALIGNED_DATA_FILE_NAME)
	updatePowerAndTriggerFileNames()
	cfg.RAW_UNALIGNED_POWER_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, cfg.RAW_UNALIGNED_POWER_FILE_NAME)
	cfg.RAW_UNALIGNED_TRIGGER_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, cfg.RAW_UNALIGNED_TRIGGER_FILE_NAME)
	cfg.POWERMODELDIR = os.path.join(cfg.ROOTDIR, globals.POWERMODELS_DIRNAME)
	cfg.FOBOS_ANALYSIS_LOG_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, globals.FOBOS_ANALYSIS_LOG_FILE_NAME)
	cfg.GRAPHS_FOLDER = os.path.join(cfg.ANALYSIS_WORKSPACE, globals.GRAPHS_FOLDERNAME)
	cfg.LOCAL_CONFIGDIR = os.path.join(cfg.ANALYSIS_WORKSPACE, globals.ANALYSIS_CONFIG_DIRNAME)
	cfg.KEY_FILE = os.path.join(cfg.OUTPUT_FOLDER,globals.KEY_FILE_NAME)

	cfg.KEYARRAY = [0]* (cfg.config_attributes['KEY_SIZE'] + 1)
	if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
		support.createDirectory(cfg.GRAPHS_FOLDER)	
	support.createDirectory(cfg.LOCAL_CONFIGDIR)
	shutil.copy(cfg.ANALYSIS_SCRIPT_FILE, cfg.LOCAL_CONFIGDIR)
	
def extractAnalysisConfigAttributes(CONFIG_FILE):
	CONFIG_FILE = os.path.join(cfg.ANALYSISCONFIGDIR, CONFIG_FILE)
	FILE_COPY = os.path.join(cfg.LOCAL_CONFIGDIR, CONFIG_FILE)
	shutil.copy(CONFIG_FILE, cfg.LOCAL_CONFIGDIR)
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
		if re.match('^PROJECT_NAME', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['PROJECT_NAME'] = value[1].strip(" ")
		if re.match('^TAG', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['TAG'] = value[1].strip(" ")
			