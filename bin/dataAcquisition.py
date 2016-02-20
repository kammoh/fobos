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
import os
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
###### Version 0.2 of FOBOS Capture
###### Only Oscilloscope comm is instantiated
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
	#displayReg(0x0C)
	while (traceCount < cfg.config_attributes['NUMBER_OF_TRACES']):
		armOscilloscope()
		print "a"
		runEncrytionOnControlBoard(traceCount)
		print "b"
		populateOscilloscopeDataStorage(traceCount)
		print "c"
		populateControlBoardOutputDataStorage(traceCount)
		print "d"
		traceCount += 1
	saveOscilloscopeDataStorage()	
	saveControlBoardOutputDataStorage()
	closeOscilloscopeConnection()
	closeControlBoardConnection()
#############################################################################
########### Show Plots for Power and Trigger
##############################################################################
	#plottingModule.showRawTrace(channel1Data)
	
if __name__ == "__main__":
    main()

	# if(cfg.config_attributes['CAPTURE_MODE'] == globals.CAPTURE_MODE_MULTI):
		# armOscilloscope()
		# channel1Data =  numpy.zeros(0)
		# channel2Data = numpy.zeros(0)
		# channel1Data = get_waveform_power()
		# channel2Data = get_waveform_trigger()
	# elif(cfg.config_attributes['CAPTURE_MODE'] == globals.CAPTURE_MODE_SINGLE):
		# runCount = 0
		# channel1Data = numpy.zeros(0)
		# channel2Data = numpy.zeros(0)
		# if(runCount < cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']):
			# armOscilloscope()
			# tempChannel1Data = get_waveform_power()
			# tempChannel2Data = get_waveform_trigger()
			# if (runCount == 0):
				# channel1Data =  tempChannel1Data
				# channel2Data = tempChannel2Data
				# tempChannel1Data = numpy.zeros(0)
				# tempChannel2Data = numpy.zeros(0)
			# else:
				# channel1Data = numpy.vstack((channel1Data, tempChannel1Data))
				# channel2Data = numpy.vstack((channel2Data, tempChannel2Data))
				# tempChannel1Data = numpy.zeros(0)
				# tempChannel2Data = numpy.zeros(0)				
			# runCount += 1
	

