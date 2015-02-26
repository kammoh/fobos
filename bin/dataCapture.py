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
import pickle

	
def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.BINDIR = os.path.join(cfg.ROOTDIR,globals.BIN_DIRNAME)
	cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,globals.CONFIG_DIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.CONFIGDIR, globals.CONFIG_FILENAME)
	cfg.OSC_CONFIGFILE = os.path.join(cfg.CONFIGDIR, globals.OSC_CONFIGFILENAME)

#############################################
###### Version 0.1 of FOBOS Capture
###### Only Oscilloscope comm is instantiated
#############################################
def main():	
	support.clear_screen()
	init()
	configExtract.extractConfigAttributes()
	configExtract.configureWorkspace()	
	printFunctions.printHeaderToScreenAndLog()
	extractOscilloscopeConfigAttributes()
	#dataToEncrypt = getPlainText()
	#keyToEncrypt = getKey()
	#controlboardCommunicationcheck()
	#oscilloscopeCommunicationcheck()
	openOscilloscopeConnection()
	setOscilloscopeConfigAttributes()
	if(cfg.config_attributes['CAPTURE_MODE'] == globals.CAPTURE_MODE_MULTI):
		armOscilloscope()
		measuredPowerData =  numpy.zeros(0)
		measuredTriggerData = numpy.zeros(0)
		measuredPowerData = get_waveform_power()
		meausredTriggerData = get_waveform_trigger()
	elif(cfg.config_attributes['CAPTURE_MODE'] == globals.CAPTURE_MODE_SINGLE):
		runCount = 0
		measuredPowerData = numpy.zeros(0)
		measuredTriggerData = numpy.zeros(0)
		if(runCount < cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']):
			armOscilloscope()
			tempMeasuredPower = get_waveform_power()
			tempMeasuredTrigger = get_waveform_trigger()
			if (runCount == 0):
				measuredPowerData =  tempMeasuredPower
				measuredTriggerData = tempMeasuredTrigger
				tempMeasuredPower = numpy.zeros(0)
				tempMeasuredTrigger = numpy.zeros(0)
			else:
				measuredPowerData = numpy.vstack((measuredPowerData, tempMeasuredPower))
				measuredTriggerData = numpy.vstack((measuredTriggerData, tempMeasuredTrigger))
				tempMeasuredPower = numpy.zeros(0)
				tempMeasuredTrigger = numpy.zeros(0)				
			runCount += 1
	fileId = open(cfg.POWER_MEASUREMENT_FILE, "wb")
	#pickle.dump(measuredPowerData, fileId)
	fileId.write(str(measuredPowerData))
	fileId.close()
	fileId = open(cfg.TRIGGER_MEASUREMENT_FILE, "wb")
	#pickle.dump(measuredTriggerData, fileId)
	fileId.write(str(measuredTriggerData))
	fileId.close()
	closeOscilloscopeConnection()

if __name__ == "__main__":
    main()
	

