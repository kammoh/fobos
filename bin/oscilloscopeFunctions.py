#!/usr/bin/python

import cfg
from support import *
from oscilloscope.oscilloscope_core import *
from printFunctions import *


def extractOscilloscopeConfigAttributes():
	data_from_file = readFile(cfg.OSC_CONFIGFILE)
	data_list = removeComments(data_from_file)
	printToLog("Obtaining oscilloscope attributes")
	cfg.osc_attributes = get_attribs(data_list)
	
	
