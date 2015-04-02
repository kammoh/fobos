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
import re
from sys import argv
from socket import *
import sys
from oscilloscope_agilent import *
from oscilloscope_global import *
import shutil
import numpy
from globals import support,cfg , printFunctions, globals
from analysis import signalAnalysisModule

def get_attribs(data_list) :
    for object in data_list :
        if re.match('^OSCILLOSCOPE\W', object) :
            value = re.split("=", object)
            cfg.osc_attributes['OSCILLOSCOPE'] = value[1].strip(" ")
        elif re.match('^OSCILLOSCOPE_IP\W', object) :
            value = re.split("=", object)
            cfg.osc_attributes['OSCILLOSCOPE_IP'] = str(value[1].strip(" "))
        elif re.match('^OSCILLOSCOPE_PORT\W', object) :
            value = re.split("=", object)
            cfg.osc_attributes['OSCILLOSCOPE_PORT'] = int(value[1].strip(" "))	  
        #elif re.match('^AUTOSCALE', object) :
            #value = re.split("=", object)
            #cfg.osc_attributes['AUTOSCALE'] = value[1].strip(" ")
        elif re.match('^IMPEDANCE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['IMPEDANCE'] = value[1].strip(" ")
        elif re.match('^CHANNEL_RANGE1', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL_RANGE1'] = value[1].strip(" ")
        elif re.match('^CHANNEL_RANGE2', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL_RANGE2'] = value[1].strip(" ")
        elif re.match('^CHANNEL_RANGE3', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL_RANGE3'] = value[1].strip(" ")
        elif re.match('^CHANNEL_RANGE4', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL_RANGE4'] = value[1].strip(" ")
        elif re.match('^TIME_RANGE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['TIME_RANGE'] = value[1].strip(" ")
        elif re.match('^TIMEBASE_REF', object) :
            value = re.split("=", object)
            cfg.osc_attributes['TIMEBASE_REF'] = value[1].strip(" ")
        elif re.match('^TRIGGER_SOURCE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['TRIGGER_SOURCE'] = value[1].strip(" ")
        elif re.match('^TRIGGER_MODE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['TRIGGER_MODE'] = value[1].strip(" ")
        elif re.match('^TRIGGER_SWEEP', object) :
            value = re.split("=", object)
            cfg.osc_attributes['TRIGGER_SWEEP'] = value[1].strip(" ")
        elif re.match('^TRIGGER_LEVEL', object) :
            value = re.split("=", object)
            cfg.osc_attributes['TRIGGER_LEVEL'] = value[1].strip(" ")
        elif re.match('^TRIGGER_SLOPE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['TRIGGER_SLOPE'] = value[1].strip(" ")
        elif re.match('^SAMPLE_INPUT', object) :
            value = re.split("=", object)
            cfg.osc_attributes['SAMPLE_INPUT'] = value[1].strip(" ")
        elif re.match('^ACQUIRE_TYPE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['ACQUIRE_TYPE'] = value[1].strip(" ")
        elif re.match('^ACQUIRE_MODE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['ACQUIRE_MODE'] = value[1].strip(" ")
        elif re.match('^ACQUIRE_COMPLETE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['ACQUIRE_COMPLETE'] = value[1].strip(" ")
        elif re.match('^WAVE_DATA_SIZE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['WAVE_DATA_SIZE'] = value[1].strip(" ")
        elif re.match('^NUM_PWR_TRACE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['NUM_PWR_TRACE'] = value[1].strip(" ")
        elif re.match('^SCREEN_CAP', object) :
            value = re.split("=", object)
            cfg.osc_attributes['SCREEN_CAP'] = value[1].strip(" ")
        elif re.match('^SCREEN_FORMAT', object) :
            value = re.split("=", object)
            cfg.osc_attributes['SCREEN_FORMAT'] = value[1].strip(" ")
        elif re.match('^SCREEN_NAME', object) :
            value = re.split("=", object)
            cfg.osc_attributes['SCREEN_NAME'] = value[1].strip(" ")
        elif re.match('^OUTPUT_DIR', object) :
            value = re.split("=", object)
            cfg.osc_attributes['OUTPUT_DIR'] = value[1].strip(" ")                        
	
def setOscilloscopeConfigAttributes():
  cfg.Oscilloscope.send("*RST" + '\n')
  if cfg.osc_attributes['IMPEDANCE'] :
    cmd_string = ":CHANNEL1:IMPEDANCE "+osc_attributes['IMPEDANCE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE1'] :
    cmd_string = ":CHANNEL1:RANGE "+osc_attributes['CHANNEL_RANGE1']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE2'] :
    cmd_string = ":CHANNEL2:RANGE "+osc_attributes['CHANNEL_RANGE2']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE3'] :	
    cmd_string = ":CHANNEL3:RANGE "+osc_attributes['CHANNEL_RANGE3']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE4'] :
    cmd_string = ":CHANNEL4:RANGE "+osc_attributes['CHANNEL_RANGE4']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TIME_RANGE'] :
    cmd_string = ":TIM:RANG "+osc_attributes['TIME_RANGE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TIMEBASE_REF'] :
    cmd_string = ":TIMEBASE:REFERENCE "+osc_attributes['TIMEBASE_REF']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_SOURCE'] :
    cmd_string = ":TRIGger:EDGE:SOURce "+osc_attributes['TRIGGER_SOURCE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_MODE'] :
    cmd_string = ":TRIGGER:MODE "+osc_attributes['TRIGGER_MODE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_SWEEP'] :
    cmd_string = ":TRIGGER:SWEEP "+osc_attributes['TRIGGER_SWEEP']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_LEVEL'] :
    cmd_string = ":TRIGGER:EDGE:LEVEL "+osc_attributes['TRIGGER_LEVEL']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_SLOPE'] :
    cmd_string = ":TRIGGER:EDGE:SLOPE "+osc_attributes['TRIGGER_SLOPE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['ACQUIRE_TYPE'] :
    cmd_string = ":ACQUIRE:TYPE "+osc_attributes['ACQUIRE_TYPE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['ACQUIRE_MODE'] :
    cmd_string = ":ACQUIRE:MODE "+osc_attributes['ACQUIRE_MODE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['ACQUIRE_COMPLETE'] :
    cmd_string = ":ACQUIRE:COMPLETE "+osc_attributes['ACQUIRE_COMPLETE']
    cfg.Oscilloscope.send(cmd_string+'\n')
 
def extractOscilloscopeConfigAttributes():
  data_from_file = support.readFile(cfg.OSC_CONFIGFILE)
  data_list = support.removeComments(data_from_file)
  printFunctions.printToLog("Obtaining oscilloscope attributes")
  get_attribs(data_list)

  
def get_waveform_power() :
  cfg.Oscilloscope.send(":WAVEFORM:FORMAT BYTE" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:SOURCE CHAN1" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS 8000000" + '\n')
  printFunctions.printToLog("\tReading Preamble of Power Source")
  cfg.Oscilloscope.send(":WAVEFORM:PREAMBLE?" + '\n')
  preamble = cfg.Oscilloscope.recv(200)
  fpowerpreamble = open(cfg.POWER_CHANNEL_PREAMBLE_FILE, "wb")
  fpowerpreamble.write(preamble)
  fpowerpreamble.close()
  fid = open(cfg.POWER_CHANNEL_PREAMBLE_FILE, "rb")
  preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
  fid.close()
  printFunctions.printToLog("\tTotal Number of Points to Receive: " + str(int(preamble[2])))
  printFunctions.printToScreenAndLog("\tReading Data of Power Source")
  cfg.Oscilloscope.send(":WAVEFORM:DATA?" + '\n') 
  tData = int(preamble[2])
  wavedata = ""
  count = 0
  temp = cfg.Oscilloscope.recv(tData)
  lowerBound = tData - len(temp)
  rData = lowerBound
  temp = temp[10:]
  while(count < lowerBound):
    wavedata = wavedata + temp
    temp = cfg.Oscilloscope.recv(rData)
    count += len(temp)
    rData = tData - count
  printFunctions.printToLog("No. of Bytes transferred per turn: " + str(len(temp)))
  printFunctions.printToLog("\t\tWriting to file -> " + cfg.POWER_MEASUREMENT_FILE)
  #print wavedata
  fpower = open(cfg.POWER_MEASUREMENT_FILE, "wb")
  fpower.write(str(wavedata))
  fpower.close()
  measuredPowerData = signalAlignmentModule.acquireDataValues(cfg.POWER_CHANNEL_PREAMBLE_FILE, cfg.POWER_MEASUREMENT_FILE)
  support.removeFile(cfg.POWER_CHANNEL_PREAMBLE_FILE)
  support.removeFile(cfg.POWER_MEASUREMENT_FILE)
  return (measuredPowerData)

def get_waveform_trigger() :
  cfg.Oscilloscope.send(":WAVEFORM:FORMAT BYTE" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:SOURCE CHAN2" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS 8000000" + '\n')
  printFunctions.printToScreenAndLog("\tReading Preamble of Trigger Source")
  cfg.Oscilloscope.send(":WAVEFORM:PREAMBLE?" + '\n')
  preamble = cfg.Oscilloscope.recv(200)
  fpowerpreamble = open(cfg.TRIGGER_CHANNEL_PREAMBLE_FILE, "wb")
  fpowerpreamble.write(preamble)
  fpowerpreamble.close()
  fid = open(cfg.TRIGGER_CHANNEL_PREAMBLE_FILE, "rb")
  preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
  fid.close()
  printFunctions.printToLog("\tTotal Number of Points to Receive: " + str(int(preamble[2])))
  printFunctions.printToScreenAndLog("\tReading Data of Trigger Source")
  cfg.Oscilloscope.send(":WAVEFORM:DATA?" + '\n') 
  tData = int(preamble[2])
  wavedata = ""
  count = 0
  temp = cfg.Oscilloscope.recv(tData)
  lowerBound = tData - len(temp)
  rData = lowerBound
  temp = temp[10:]
  while(count < lowerBound):
    wavedata = wavedata + temp
    temp = cfg.Oscilloscope.recv(rData)
    count += len(temp)
    rData = tData - count
  printFunctions.printToLog("No. of Bytes transferred per turn: " + str(len(temp)))
  printFunctions.printToLog("\t\tWriting to file ->" + cfg.TRIGGER_MEASUREMENT_FILE )
  #print wavedata
  fpower = open(cfg.TRIGGER_MEASUREMENT_FILE, "wb")
  fpower.write(str(wavedata))
  fpower.close()
  measuredTriggerData = signalAlignmentModule.acquireDataValues(cfg.TRIGGER_CHANNEL_PREAMBLE_FILE, cfg.TRIGGER_MEASUREMENT_FILE)
  support.removeFile(cfg.TRIGGER_CHANNEL_PREAMBLE_FILE)
  support.removeFile(cfg.TRIGGER_MEASUREMENT_FILE)
  return (measuredTriggerData)  

def getDataFromOscilloscope(channelName) :
  cfg.Oscilloscope.send(":WAVEFORM:FORMAT BYTE" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
  if(channelName == 'CHANNEL1'):
	chanType = 'CHAN1'
  if(channelName == 'CHANNEL2'):
	chanType = 'CHAN2'
  if(channelName == 'CHANNEL3'):
	chanType = 'CHAN3'
  if(channelName == 'CHANNEL4'):
	chanType = 'CHAN4'	
  cmdString = ":WAVEFORM:SOURCE " + chanType 
  cfg.Oscilloscope.send(cmdString + '\n')
  cmdString = ":WAVEFORM:POINTS " + cfg.osc_attributes['WAVE_DATA_SIZE']
  cfg.Oscilloscope.send(cmdString + '\n')
  printFunctions.printToLog("\tReading Preamble of " + channelName)
  cfg.Oscilloscope.send(":WAVEFORM:PREAMBLE?" + '\n')
  preamble = cfg.Oscilloscope.recv(200)
  fileId = open(cfg.TEMP_PREAMBLE_FILE, "wb")
  fileId.write(preamble)
  fileId.close()
  fid = open(cfg.TEMP_PREAMBLE_FILE, "rb")
  preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
  fid.close()
  printFunctions.printToLog("\tTotal Number of Points to Receive: " + str(int(preamble[2])))
  printFunctions.printToLog("\tReading Data of " + channelName)
  cfg.Oscilloscope.send(":WAVEFORM:DATA?" + '\n') 
  tData = int(preamble[2])
  wavedata = ""
  count = 0
  temp = cfg.Oscilloscope.recv(tData)
  lowerBound = tData - len(temp)
  rData = lowerBound
  temp = temp[10:]
  while(count < lowerBound):
    wavedata = wavedata + temp
    temp = cfg.Oscilloscope.recv(rData)
    count += len(temp)
    rData = tData - count
  printFunctions.printToLog("No. of Bytes transferred per turn: " + str(len(temp)))
  #print wavedata
  fileId = open(cfg.TEMP_MEASUREMENT_FILE, "wb")
  fileId.write(str(wavedata))
  fileId.close()
  measuredChannelData = signalAnalysisModule.acquireDataValues(cfg.TEMP_PREAMBLE_FILE, cfg.TEMP_MEASUREMENT_FILE)
  support.removeFile(cfg.TEMP_PREAMBLE_FILE)
  support.removeFile(cfg.TEMP_MEASUREMENT_FILE)
  return (measuredChannelData)

def initializeOscilloscopeDataStorage():
	cfg.channel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
	cfg.channel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
	cfg.channel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
	cfg.channel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None

def populateOscilloscopeDataStorage(traceCount):
	sampleLength = 2000000
	printFunctions.printToScreenAndLog("\tGetting data for Trace No ->" + str(traceCount+1))
	tempChannel1Data = getDataFromOscilloscope('CHANNEL1') if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
	tempChannel2Data = getDataFromOscilloscope('CHANNEL2') if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
	tempChannel3Data = getDataFromOscilloscope('CHANNEL3') if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
	tempChannel4Data = getDataFromOscilloscope('CHANNEL4') if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
	if (traceCount == 0):
		cfg.channel1Data =  signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel1Data)  if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		cfg.channel2Data =  signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel2Data)  if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		cfg.channel3Data =  signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel3Data)  if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		cfg.channel4Data =  signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel4Data)  if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
		tempChannel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		tempChannel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		tempChannel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		tempChannel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None								
	else:
		cfg.channel1Data = numpy.vstack((cfg.channel1Data, signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel1Data)))  if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		cfg.channel2Data = numpy.vstack((cfg.channel2Data, signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel2Data)))  if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		cfg.channel3Data = numpy.vstack((cfg.channel3Data, signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel3Data)))  if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		cfg.channel4Data = numpy.vstack((cfg.channel4Data, signalAnalysisModule.adjustSampleSize(sampleLength, tempChannel4Data)))  if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
		tempChannel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		tempChannel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		tempChannel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		tempChannel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None				

def saveOscilloscopeDataStorage():
	if (cfg.channel1Data != None):		
		numpy.savetxt(cfg.CHANNEL1_MEASUREMENT_FILE, cfg.channel1Data, fmt = '%5.4g')
	if (cfg.channel2Data != None):		
		numpy.savetxt(cfg.CHANNEL2_MEASUREMENT_FILE, cfg.channel2Data, fmt = '%5.4g')
	if (cfg.channel3Data != None):		
		numpy.savetxt(cfg.CHANNEL3_MEASUREMENT_FILE, cfg.channel3Data, fmt = '%5.4g')
	if (cfg.channel4Data != None):		
		numpy.savetxt(cfg.CHANNEL4_MEASUREMENT_FILE, cfg.channel4Data, fmt = '%5.4g')
 
def get_snapshot():
  print "Capturing Snapshot of the Scope"
  cfg.Oscilloscope.send(":DISPlay?\n")
  disp_source = cfg.Oscilloscope.recv(200)
  #print "\t\t Display Source - " + disp_source
  cfg.Oscilloscope.send(":DISPlay:DATA? PNG, SCReen, COLor\n")
  rawpic = cfg.Oscilloscope.recv(30000)
  fsnapshot = open(cfg.osc_attributes['SCREEN_NAME']+".png", "wb")
  fsnapshot.write(rawpic)
  fsnapshot.close()
	
def openOscilloscopeConnection():
  cfg.Oscilloscope = socket( AF_INET, SOCK_STREAM )
  cfg.Oscilloscope.connect((cfg.osc_attributes['OSCILLOSCOPE_IP'], cfg.osc_attributes['OSCILLOSCOPE_PORT']))#have to put in error checks dummy
  cfg.Oscilloscope.send("*IDN?"+'\n')
  osc_id = cfg.Oscilloscope.recv(200)
  printFunctions.printToScreenAndLog("\tConnected to Oscilloscope ID :"+ osc_id+'\n')
  if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL1'):
	cfg.CHANNEL1_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL1_TRIGGER_MEASUREMENT_FILE_NAME)
  else:
	cfg.CHANNEL1_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL1_MEASUREMENT_FILE_NAME)
	
  if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL2'):
	cfg.CHANNEL2_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL2_TRIGGER_MEASUREMENT_FILE_NAME)
  else:
	cfg.CHANNEL2_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL2_MEASUREMENT_FILE_NAME)

  if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL3'):
	cfg.CHANNEL3_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL3_TRIGGER_MEASUREMENT_FILE_NAME)
  else:
	cfg.CHANNEL3_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL3_MEASUREMENT_FILE_NAME)

  if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL4'):
	cfg.CHANNEL4_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL4_TRIGGER_MEASUREMENT_FILE_NAME)
  else:
	cfg.CHANNEL4_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.CHANNEL4_MEASUREMENT_FILE_NAME)
	
  cfg.TEMP_PREAMBLE_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals. TEMP_PREAMBLE_FILE_NAME)
  cfg.TEMP_MEASUREMENT_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.TEMP_MEASUREMENT_FILE_NAME)


def armOscilloscope():
	channelsToDigitize = None
	if (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):
		channelsToDigitize = None
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):	
		channelsToDigitize =	'CHAN4'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):	
		channelsToDigitize ='CHAN3'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):	
		channelsToDigitize ='CHAN3, CHAN4'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):	
		channelsToDigitize ='CHAN2'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):
		channelsToDigitize ='CHAN2, CHAN4'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):
		channelsToDigitize ='CHAN2, CHAN3'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):
		channelsToDigitize ='CHAN2, CHAN3, CHAN4'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):
		channelsToDigitize ='CHAN1'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):
		channelsToDigitize ='CHAN1, CHAN4'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):
		channelsToDigitize ='CHAN1, CHAN3'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):
		channelsToDigitize ='CHAN1, CHAN3, CHAN4'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):
		channelsToDigitize ='CHAN1, CHAN2'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] == 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):
		channelsToDigitize ='CHAN1, CHAN2, CHAN4'
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] == 'OFF'):
		channelsToDigitize ='CHAN1, CHAN2, CHAN3' 
	elif (cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF' and cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):						
		channelsToDigitize ='CHAN1, CHAN2, CHAN3, CHAN4'
	if(channelsToDigitize != None):
		cmdString = ":DIGITIZE " + channelsToDigitize
		cfg.Oscilloscope.send(cmdString+ '\n')
		printFunctions.printToLog("Channels to Digitize -> " + channelsToDigitize)
	else:
		printFunctions.printToScreenAndLog("\tNo Channels selected to Digitize.")
	

def closeOscilloscopeConnection():
  cfg.Oscilloscope.close()