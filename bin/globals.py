#!/usr/bin/python
from ctypes import *
import sys
import os
import time
# Get DLL depending on OS
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
 
VERSION = '0.2'
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
ANALYSIS_CONFIG_DIRNAME = "config-analysis"
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


#Analysis globals
ANALYSIS_FOLDER_NAME = "analysis"
TESTDIRNAME = "testing"
POWERMODELS_DIRNAME = "powermodels"
PROJECTPATH_FILENAME = "projectPath.txt"
ALIGNED_DATA_FILE_NAME = "rawDataAligned.dat"
RAW_UNALIGNED_POWER_FILE_NAME = "wave1.dat"
RAW_UNALIGNED_TRIGGER_FILE_NAME = "wave2.dat"
SNAPSHOT_FILE_NAME = "traces.png"
FOBOS_ANALYSIS_LOG_FILE_NAME = "FOBOSAnalysisLog.txt"

COMPRESSED_DATA_FILE_NAME = "compressedData.dat"
SAMPLE_SPACE_DISP_FILE_NAME = "sampleSpaceDispData.dat"
TRACE_EXPUNGE_DATA_FILE_NAME = "traceExpunge.dat"



MEAN_OF_DATA_FILE_NAME = "meanOfData.png"
STD_OF_DATA_FILE_NAME = "stdOfData.png"
VAR_OF_DATA_FILE_NAME = "varOfData.png"

PEARSON_GRAPH_FILE_NAME = "pearsonsCorrelationGraph.png"
SPEARMAN_GRAPH_FILE_NAME = "spearmanCorrelationGraph.png"
AUTOCORR_GRAPH_FILE_NAME = "autocorrelationGraph.png"

CORR_PEARSON_RESULT_FILE_NAME = "correlationPearsonResults.txt"
CORR_SPEARMAN_RESULT_FILE_NAME = "correlationSpearmanResults.txt"

POWER_CHANNEL_PREAMBLE_FILE_NAME = "channel1PreambleData.dat"
TRIGGER_CHANNEL_PREAMBLE_FILE_NAME = "channel2PreambleData.dat"
POWER_MEASUREMENT_FILE_NAME = "channel1Data.dat"
TRIGGER_MEASUREMENT_FILE_NAME = "channel2Data.dat"

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
AUTOCORR = "AUTOCORRELATION"
