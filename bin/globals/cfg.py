#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2016 Cryptographic Engineering Research Group (CERG)               #
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
import numpy

##################################################
##### GLOBAL SETTINGS ############################
##################################################
ROOTDIR = ''
CONFIGDIR = ''
BINDIR  = ''
CONFIGFILE = ''
OSC_CONFIGFILE = ''
PROGRAM_CALL = ''

##################################################
##### DATA CAPTURE SETTINGS ######################
##################################################
WORKSPACEDIR = ''
PROJECTDIR = ''
WORKSPACE = ''
OUTPUT_FOLDER = ''
MEASUREMENT_FOLDER = ''
GRAPHS_FOLDER = ''
FOBOS_LOG_FILE = ''
PLAIN_TEXT_FILE = ''
CIPHER_TEXT_FILE = ''
KEY_FILE = ''

USB_HANDLE = ''

Oscilloscope = ''
channel1Data = None
channel2Data = None
channel3Data = None
channel4Data = None
dataToControlBoard = None
keyToControlBoard = None
dataFromControlBoard = None
dataToCtrlBrdByteNum = None
dataFromCtrlBrdNum = None

SAMPLE_LENGTH_FROM_OSC = None
TEMP_PREAMBLE_FILE = ''
TEMP_MEASUREMENT_FILE = ''
CHANNEL1_MEASUREMENT_FILE = ''
CHANNEL2_MEASUREMENT_FILE = ''
CHANNEL3_MEASUREMENT_FILE = ''
CHANNEL4_MEASUREMENT_FILE = ''

config_attributes = {
 'WORK_DIR' : "",        'DATA_FILE' : "",     'VERBOSE' : "",       'TIMEOUT_VAL' : "",
 'SOURCE_DIR' : "",      'KEY_FILE' : "",      'TRIGGER_WAIT_CYCLES' : "",   'CLK_FREQ' : "",
 'VICTIM_RESET' : "",    'INPUT_FORMAT' : "",  'OUTPUT_FORMAT' : "", 'MEASUREMENT_FORMAT' : "",
 'OSC_CONFIG_FILE' : "", 'PROJECT_NAME' : "",  'TAG' : "", 			 'CONTROL_BOARD' : "",
 'NUMBER_OF_ENCRYPTIONS_PER_TRACE' : 0, 'BLOCK_SIZE': 0, 'PLAINTEXT_GENERATION': "", 'KEY_GENERATION': "",
 'KEY_SIZE': "", 'NUMBER_OF_TRACES' : "", 'TRIGGER_LENGTH_CYCLES' : "", 'DUMMY_RUN' : "", 'LOGGING': "",
 }
 
osc_attributes = {
 'RESOURCE' : "",        'AUTOSCALE' : "",        'IMPEDANCE' : "",        'CHANNEL_RANGE1' : "",
 'CHANNEL_RANGE2' : "",   'CHANNEL_RANGE3' : "",   'CHANNEL_RANGE4' : "",   'TIME_RANGE' : "",
 'TIMEBASE_REF' : "",     'TRIGGER_SOURCE' : "",   'TRIGGER_MODE' : "",     'TRIGGER_SWEEP' : "",
 'TRIGGER_LEVEL' : "",    'TRIGGER_SLOPE' : "",    'SAMPLE_INPUT' : "",     'ACQUIRE_TYPE' : "",
 'ACQUIRE_MODE' : "",     'ACQUIRE_COMPLETE' : "", 'WAVE_DATA_SIZE' : "",   'NUM_PWR_TRACE' : "",
 'SCREEN_CAP' : "",       'SCREEN_FORMAT' : "",    'SCREEN_NAME' : "",      'OUTPUT_DIR' : "",
 'OSCILLOSCOPE_IP' : "",  'OSCILLOSCOPE_PORT' : "", 'WAVEFORM_SIZE' : "",
 }

##################################################
##### ANALYSIS SETTINGS ##########################
##################################################
CONFIG_FILE = ""
LOCAL_CONFIGDIR = ""
ROOTDIR = ""
TESTDIR = ""
BINDIR = ""
ANALYSISCONFIGDIR = ""
ALIGNED_DATA_FILE = ""
RAW_UNALIGNED_POWER_FILE = ""
RAW_UNALIGNED_TRIGGER_FILE = ""
TRACE_EXPUNGE_DATA_FILE = ""
COMPRESSED_DATA_FILE = ""
SAMPLE_SPACE_DISP_DATA_FILE = ""
ANALYSIS_WORKSPACE = ""
ANALYSISDIR = ""
FOBOS_ANALYSIS_LOG_FILE = ""
POWERMODELDIR = ""
SNAPSHOT_FILE = ""
RAW_POWER_DATA = numpy.zeros(0)
RAW_TRIGGER_DATA = numpy.zeros(0)
MEASUREMENT_PROJECT_PATH_FILE = ""
MEAN_OF_DATA_FILE = ""
STD_OF_DATA_FILE = ""
VAR_OF_DATA_FILE = ""
ANALYSIS_SCRIPT_FILE = ""
SPECTOGRAM_FILE = ""
PEARSON_GRAPH_FILE = ""
SPEARMAN_GRAPH_FILE = ""
HISTOGRAM_PEARSON_FILE = ""
HISTOGRAM_SPEARMAN_FILE = ""
AUTOCORR_GRAPH_FILE = ""
ANOVA_GRAPH_FILE = ""
MAXGUESSENT_FILE = ""
MGE_GRAPH_FILE = ""
RAW_UNALIGNED_POWER_FILE_NAME = ""
RAW_UNALIGNED_TRIGGER_FILE_NAME = ""

CORR_PEARSON_RESULT_FILE = ""
CORR_SPEARMAN_RESULT_FILE = ""
ANOVA_RESULT_FILE = ""

KEYARRAY = None
EXPECTED_KEY = None
LAST_POWER_MODEL = None
KEY_INDEX = 0
KEY_BYTE_MAX_CORR = None
KEY_BYTE_CORR = None
KEY_BYTE_HIST = None

analysisConfigAttributes = {
'SAMPLE_WINDOW' : "", 'WINDOW_START_POINT' : "", 'CAPTURE_MODE' : "",
'COMPRESSION_LENGTH' : "", 'COMPRESSION_TYPE' : "", 'TRIGGER_THRESHOLD': "",
'SAMPLE_SPACE_DISPOSITION' : "", 'COMPRESS_DATA' : "", 'CORRELATION_PEARSONS' : "",
'TRACE_EXPUNGE': "", 'COMPUTE_AUTOCORRELATION' : "", 'TRACE_EXPUNGE_PARAMS': "",
'WORK_DIR' : "", 'PROJECT_NAME':"", 'PLOT_SIZE_LENGTH':"", 'PLOT_SIZE_BREADTH': "",
'TAG':"", 'GENERATE_EPS_PDF_GRAPHS' :"", 'PLOT_LABELS_FONT_FAMILY':"",
'PLOT_LABELS_FONT_WEIGHT': "", 'PLOT_LABELS_FONT_SIZE': "",
}

	
	
	
						 
						 
						 
						 
						 
						 
						 
						 
						 
						 
						 
						
						    
