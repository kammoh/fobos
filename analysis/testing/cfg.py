#!/usr/bin/python

CONFIGFILENAME = "analysis_config.txt"
CONFIG_FILE = ""
ROOTDIR = ""
TESTDIRNAME = "testing"
TESTDIR = ""
ALIGNED_DATA_FILE_NAME = "rawDataAligned.dat"
ALIGNED_DATA_FILE = ""
RAW_UNALIGNED_POWER_FILE_NAME = "wave1.dat"
RAW_UNALIGNED_POWER_FILE = ""
RAW_UNALIGNED_TRIGGER_FILE_NAME = "wave2.dat"
RAW_UNALIGNED_TRIGGER_FILE = ""
POWER_MODEL_FILE_NAME = "key_guess.txt"
POWER_MODEL_FILE = ""

SNAPSHOT_FILE_NAME = "snapshot.png"

analysisConfigAttributes = {
'SAMPLE_WINDOW' : "", 'WINDOW_START_POINT' : "", 'CAPTURE_MODE' : "",
'COMPRESSION_LENGTH' : "", 'COMPRESSION_TYPE' : "", 'TRIGGER_THRESHOLD': "",
'SAMPLE_SPACE_DISPOSITION' : "", 'COMPRESS_DATA' : "", 'CORRELATION_PEARSONS' : "",
}