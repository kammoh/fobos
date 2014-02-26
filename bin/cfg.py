#!/usr/bin/python

ROOTDIR = ''
CONFIGDIR = ''
BINDIR  = ''
CONFIGFILE = ''
OSC_CONFIGFILE = ''
WORKSPACEDIR = ''
WORKSPACE = ''
OUTPUT_FOLDER = ''
MEASUREMENT_FOLDER = ''
GRAPHS_FOLDER = ''
FOBOS_LOG_FILE = ''
PLAIN_TEXT_FILE = ''
CIPHER_TEXT_FILE = ''
KEY_FILE = ''

config_attributes = {
 'WORK_DIR' : "",        'DATA_FILE' : "",     'VERBOSE' : "",       'TIMEOUT_VAL' : "",
 'SOURCE_DIR' : "",      'KEY_FILE' : "",      'TRIGGER_VAL' : "",   'CLK_FREQ' : "",
 'VICTIM_RESET' : "",    'INPUT_FORMAT' : "",  'OUTPUT_FORMAT' : "", 'MEASUREMENT_FORMAT' : "",
 'OSC_CONFIG_FILE' : "", 'PROJECT_NAME' : "",  'TAG' : "", 			 'CONTROL_BOARD' : "",
 'NUMBER_OF_ENCRYPTIONS' : 0, 'BLOCK_SIZE': 0, 'PLAINTEXT_GENERATION': "", 'KEY_GENERATION': "",
 'KEY_SIZE': ""
 }
 
osc_attributes = {}