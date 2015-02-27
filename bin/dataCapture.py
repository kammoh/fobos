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
		channel1Data =  numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		channel1Data = getDataFromOscilloscope('CHANNEL1') if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		channel2Data =  numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		channel2Data = getDataFromOscilloscope('CHANNEL2') if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		channel3Data =  numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		channel3Data = getDataFromOscilloscope('CHANNEL3') if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		channel4Data =  numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
		channel4Data = getDataFromOscilloscope('CHANNEL4') if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
	elif(cfg.config_attributes['CAPTURE_MODE'] == globals.CAPTURE_MODE_SINGLE):
		runCount = 0
		channel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		channel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		channel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		channel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
		print cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']
		if(runCount < cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']):
			armOscilloscope()
			tempChannel1Data = getDataFromOscilloscope('CHANNEL1') if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
			tempChannel2Data = getDataFromOscilloscope('CHANNEL2') if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
			tempChannel3Data = getDataFromOscilloscope('CHANNEL3') if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
			tempChannel4Data = getDataFromOscilloscope('CHANNEL4') if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
			if (runCount == 0):
				channel1Data =  tempChannel1Data  if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
				channel2Data =  tempChannel2Data  if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
				channel3Data =  tempChannel3Data  if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
				channel4Data =  tempChannel4Data  if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
				tempChannel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
				tempChannel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
				tempChannel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
				tempChannel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None								
			else:
				channel1Data = numpy.vstack((channel1Data, tempChannel1Data))  if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
				channel2Data = numpy.vstack((channel2Data, tempChannel2Data))  if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
				channel3Data = numpy.vstack((channel3Data, tempChannel3Data))  if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
				channel4Data = numpy.vstack((channel4Data, tempChannel4Data))  if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
				tempChannel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
				tempChannel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
				tempChannel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
				tempChannel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None				
			runCount += 1
	if (channel1Data != None):		
		numpy.savetxt(cfg.CHANNEL1_MEASUREMENT_FILE, channel1Data)
	if (channel2Data != None):		
		numpy.savetxt(cfg.CHANNEL2_MEASUREMENT_FILE, channel2Data)
	if (channel3Data != None):		
		numpy.savetxt(cfg.CHANNEL3_MEASUREMENT_FILE, channel3Data)
	if (channel4Data != None):		
		numpy.savetxt(cfg.CHANNEL4_MEASUREMENT_FILE, channel4Data)
	closeOscilloscopeConnection()
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
	

