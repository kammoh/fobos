#!/usr/bin/python
#############################################################################
#                                                                           #
#	Copyright 2016 CERG                                                     #
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
import os
import time
from globals import cfg, globals,support, printFunctions, configExtract
from oscilloscope.oscilloscope_core import *
from analysis import plottingModule
import pickle
from usb.usbcomm_core import *
from globals.dataGenerator import *
import logging

	
def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.BINDIR = os.path.join(cfg.ROOTDIR,globals.BIN_DIRNAME)
	cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,globals.CONFIG_DIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.CONFIGDIR, globals.CONFIG_FILENAME)
	cfg.OSC_CONFIGFILE = os.path.join(cfg.CONFIGDIR, globals.OSC_CONFIGFILENAME)


#############################################
###### Version 0.9 Beta of FOBOS Capture ####
#############################################
def main():	
	support.clear_screen()                                     
	init()
	configExtract.extractConfigAttributes()
	configExtract.configureWorkspace()	
	printFunctions.printHeaderToScreenAndLog()
	extractOscilloscopeConfigAttributes()
	cfg.dataToControlBoard = getPlainText()
	cfg.keyToControlBoard = getKey()
	openOscilloscopeConnection()
	setOscilloscopeConfigAttributes()
	initializeOscilloscopeDataStorage()
	openControlBoardConnection()
	setControlBoardConfigAttributes()
	traceCount = 0
	while (traceCount < cfg.config_attributes['NUMBER_OF_TRACES']):
		armOscilloscope()
		runEncrytionOnControlBoard(traceCount)
		populateOscilloscopeDataStorage(traceCount)
		populateControlBoardOutputDataStorage(traceCount)
		traceCount += 1
	saveControlBoardOutputDataStorage()
	closeOscilloscopeConnection()
	closeControlBoardConnection()
#############################################################################
########### End of Main                                                  ####
##############################################################################
	
	
if __name__ == "__main__":
    start_time=time.time()#to print execution time:Panci
    main()
    print("Total Run time=%s" %(time.time() -  start_time))#to print execution time:Panci

