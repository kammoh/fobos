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
from ctypes import *
import sys, cfg
import os
import time
# Get DLL depending on OS
if(cfg.PROGRAM_CALL == "ACQUISITION"): 
	if (sys.platform == "linux2" ):
		cdll.LoadLibrary("libdepp.so")
		depp = CDLL("libdepp.so")
		cdll.LoadLibrary("libdmgr.so")
		dmgr = CDLL("libdmgr.so")
	elif (sys.platform == "win32" ):
		cdll.LoadLibrary("dmgr.dll")
		dmgr = CDLL("dmgr.dll")
		cdll.LoadLibrary("depp.dll")
		depp = CDLL("depp.dll")
 
VERSION = '0.1'
SUCCESS = True
FAILURE = False

YES = True
NO = False

DATA = 'data'
CIPHERTEXT = 'ciphertext'
KEY = 'key'

USER = 'USER'
RANDOM = 'RANDOM'

COUNTER = 'counter'
WAVECAP = 'waveCapture'
OPENADC = 'openADC'

BINARY = 'binary'
INTEGER = 'integer'

# Register File Addresses
DATAREG0 = 0x00
DATAREG1 = 0x01
BRAM_HIGHBYTE = 0x10
BRAM_LOWBYTE = 0x11
MAINCLOCKBYTE3 = 0x20
MAINCLOCKBYTE2 = 0x21
MAINCLOCKBYTE1 = 0x22
MAINCLOCKBYTE0 = 0x23
CONTROLREG = 0x30
STATUSREG = 0x31
DISPLAYREG = 0x40
PROGRAMOK = 0x50
DCMTAPSREG = 0x60

# Register Fixed Values

#Graphs Constant Values
COUNTER_XAXIS_LABEL = '# of Count Values'
COUNTER_YAXIS_LABEL = 'Count Values'
COUNTER_TITLE = 'Counter Test'
WAVECAP_XAXIS_LABEL = 'Time'
WAVECAP_YAXIS_LABEL = 'Value'
WAVECAP_TITLE = 'Captured Signal'
OPENADC_XAXIS_LABEL = 'Time'
OPENADC_YAXIS_LABEL = 'Voltage'
OPENADC_TITLE = 'openADC Wave-Snapshot'

BIN_DIRNAME = "bin"
CONFIG_DIRNAME = "config"
ANALYSIS_CONFIG_DIRNAME = "config"
OUTPUT_FOLDERNAME = "outputs"
MEASUREMENT_FOLDERNAME = "measurements"
GRAPHS_FOLDERNAME = "graphs"
CONFIG_FILENAME = "config.txt"
DATASTREAM_FILENAME = "data"
WAVECAPFIG_FILENAME = "snapshot"
OSC_CONFIGFILENAME = "oscilloscope_config.txt"
FOBOS_LOG_FILE_NAME = "FOBOSLog.txt"
PLAIN_TEXT_FILE_NAME = "plaintexts.txt"
CIPHER_TEXT_FILE_NAME = "ciphertexts.txt"
KEY_FILE_NAME = "keys.txt"

if(cfg.PROGRAM_CALL == "ACQUISITION"):
	#Error Pointer Definition
	ERC = c_int
	INTP  = POINTER(ERC)
	num = c_int(42)
	addr = addressof(num)
	ERCP = cast(addr, INTP)

	#Result String pointer Definition
	RS = c_char
	CHP = POINTER(RS)
	buf = c_int(128)
	ResultString = cast(addressof(buf), CHP)

	#Handle pointer definition
	HIF = c_uint
	HIFP = POINTER(HIF)
	HIFbuf = c_uint(8)
	handle = cast(addressof(HIFbuf), HIFP)


	#Device Name pointer Definition
	DS = c_char
	DSP = POINTER(RS)
	DSbuf = c_int(128)
	DeviceName = cast(addressof(DSbuf), DSP)

	#General Definitions
	regBYTE = c_ubyte
	VOIDP = c_void_p

	dataBYTE = c_ubyte
	dataP = POINTER(dataBYTE)
	bufBYTE = c_ubyte(10)
	dataBYTEP = cast(addressof(bufBYTE), dataP)

	#DPC Call functions

	dmgr.DmgrOpen.argtypes = [POINTER(c_uint), POINTER(c_char)]
	dmgr.DmgrOpen.restypes = c_int

	dmgr.DmgrClose.argtypes = [c_uint]
	dmgr.DmgrClose.restypes = None

	depp.DeppGetVersion.argtypes = [POINTER(c_char)]

	depp.DeppEnableEx.argtypes = [c_uint, c_uint32]

	depp.DeppGetReg.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int]
	depp.DeppGetReg.restypes = c_int

	depp.DeppPutReg.argtypes = [c_uint, c_ubyte, c_ubyte, c_int]
	depp.DeppPutReg.restype = c_int

	depp.DeppGetRegRepeat.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int, c_int]
	depp.DeppGetRegRepeat.restype = c_int

#Capture Globals
TEMP_PREAMBLE_FILE_NAME = "tempPreambleData.dat"
TEMP_MEASUREMENT_FILE_NAME = "tempMeasurementData.dat"
CHANNEL1_MEASUREMENT_FILE_NAME = "channel1Data.dat"
CHANNEL2_MEASUREMENT_FILE_NAME = "channel2Data.dat"
CHANNEL3_MEASUREMENT_FILE_NAME = "channel3Data.dat"
CHANNEL4_MEASUREMENT_FILE_NAME = "channel4Data.dat"
CAPTURE_MODE_SINGLE = "single"
CAPTURE_MODE_MULTI = "multi"


#Analysis globals
ANALYSIS_FOLDER_NAME = "analysis"
TESTDIRNAME = "testing"
POWERMODELS_DIRNAME = "data"
PROJECTPATH_FILENAME = "projectPath.txt"
ALIGNED_DATA_FILE_NAME = "rawDataAligned.dat"
RAW_UNALIGNED_POWER_FILE_NAME = "wave1.dat"
RAW_UNALIGNED_TRIGGER_FILE_NAME = "wave2.dat"
SNAPSHOT_FILE_NAME = "traces.png"
FOBOS_ANALYSIS_LOG_FILE_NAME = "FOBOSAnalysisLog.txt"
ANALYSIS_SCRIPT_FILENAME = "dataAnalysis.py"
COMPRESSED_DATA_FILE_NAME = "compressedData.dat"
SAMPLE_SPACE_DISP_FILE_NAME = "sampleSpaceDispData.dat"
TRACE_EXPUNGE_DATA_FILE_NAME = "traceExpunge.dat"



MEAN_OF_DATA_FILE_NAME = "meanOfData.png"
STD_OF_DATA_FILE_NAME = "stdOfData.png"
VAR_OF_DATA_FILE_NAME = "varOfData.png"
SPECTOGRAM_FILE_NAME = "spectogram.png"

PEARSON_GRAPH_FILE_NAME = "pearsonsCorrelationGraph.png"
SPEARMAN_GRAPH_FILE_NAME = "spearmanCorrelationGraph.png"
AUTOCORR_GRAPH_FILE_NAME = "autocorrelationGraph.png"
ANOVA_GRAPH_FILE_NAME = "oneWayANOVAGraph.png"
MAXGUESSENT_FILE_NAME = "maximumGuessingEntropy.png"

CORR_PEARSON_RESULT_FILE_NAME = "correlationPearsonResults.txt"
CORR_SPEARMAN_RESULT_FILE_NAME = "correlationSpearmanResults.txt"
ANOVA_RESULT_FILE_NAME = "oneWayANOVAResults.txt"

TRACES = 0
SAMPLE_MEAN = 1
SAMPLE_VAR = 2
SAMPLE_STD = 3
TRACE_MEAN = 4
TRACE_VAR = 5
TRACE_STD  = 6

SAMPLE_WISE = 0
TRACE_WISE = 1


PEARSON = 'PEARSON'
SPEARMAN = 'SPEARMAN'
AUTOCORR = 'AUTOCORRELATION'
ANOVA = 'ANOVA'
MAXGUESSENTROPY = "MAXGUESSENTROPY"
