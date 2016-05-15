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
import re
from sys import argv
from socket import *
import sys
#from oscilloscope_agilent import *
#from oscilloscope_global import *
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
        elif re.match('^CHANNEL1_RANGE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL_RANGE1'] = value[1].strip(" ")
        elif re.match('^CHANNEL2_RANGE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL_RANGE2'] = value[1].strip(" ")
        elif re.match('^CHANNEL3_RANGE', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL_RANGE3'] = value[1].strip(" ")
        elif re.match('^CHANNEL4_RANGE', object) :
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
  printFunctions.printToLog("\tSetting Oscilloscope Attributes")  
  #cfg.Oscilloscope.send("*RST" + '\n')
  if cfg.osc_attributes['IMPEDANCE'] :
    cmd_string = ":CHANNEL1:IMPEDANCE "+cfg.osc_attributes['IMPEDANCE']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE1'] :
    cmd_string = ":CHANNEL1:RANGE "+cfg.osc_attributes['CHANNEL_RANGE1']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE2'] :
    cmd_string = ":CHANNEL2:RANGE "+cfg.osc_attributes['CHANNEL_RANGE2']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE3'] :	
    cmd_string = ":CHANNEL3:RANGE "+cfg.osc_attributes['CHANNEL_RANGE3']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['CHANNEL_RANGE4'] :
    cmd_string = ":CHANNEL4:RANGE "+cfg.osc_attributes['CHANNEL_RANGE4']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TIME_RANGE'] :
    cmd_string = ":TIM:RANG "+cfg.osc_attributes['TIME_RANGE']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TIMEBASE_REF'] :
    cmd_string = ":TIMEBASE:REFERENCE "+cfg.osc_attributes['TIMEBASE_REF']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_SOURCE'] :
    cmd_string = ":TRIGger:EDGE:SOURce "+cfg.osc_attributes['TRIGGER_SOURCE']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_MODE'] :
    cmd_string = ":TRIGGER:MODE "+cfg.osc_attributes['TRIGGER_MODE']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_SWEEP'] :
    cmd_string = ":TRIGGER:SWEEP "+cfg.osc_attributes['TRIGGER_SWEEP']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_LEVEL'] :
    cmd_string = ":TRIGGER:EDGE:LEVEL "+cfg.osc_attributes['TRIGGER_LEVEL']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['TRIGGER_SLOPE'] :
    cmd_string = ":TRIGGER:EDGE:SLOPE "+cfg.osc_attributes['TRIGGER_SLOPE']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['ACQUIRE_TYPE'] :
    cmd_string = ":ACQUIRE:TYPE "+cfg.osc_attributes['ACQUIRE_TYPE']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
  if cfg.osc_attributes['ACQUIRE_MODE'] :
    cmd_string = ":ACQUIRE:MODE "+cfg.osc_attributes['ACQUIRE_MODE']
    printFunctions.printToLog("\t"+ cmd_string)
    cfg.Oscilloscope.send(cmd_string+'\n')
	
  cmd_string = ":ACQUIRE:COMPLETE 100"
  printFunctions.printToLog("\t"+ cmd_string)
  cfg.Oscilloscope.send(cmd_string+'\n')
  cfg.Oscilloscope.send(":WAVEFORM:FORMAT BYTE" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS:MODE RAW" + '\n') #get more than 1000 points only then this line is on 2/26 JK

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
  preamble = cfg.Oscilloscope.recv(400)
  fpowerpreamble = open(cfg.POWER_CHANNEL_PREAMBLE_FILE, "wb")
  fpowerpreamble.write(preamble)
  fpowerpreamble.close()
  fid = open(cfg.POWER_CHANNEL_PREAMBLE_FILE, "rb")
  preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
  fid.close()
  printFunctions.printToLog("\tTotal Number of Points to Receive: " + str(int(preamble[2])))
  vdiv = 32 * preamble[7]
  off = preamble[8]
  sdiv = preamble[2] * preamble [4] / 10
  delay = (preamble[2] / 2) * preamble[4] + preamble[5]
  printFunctions.printToLog("Scope Settings for Channel 1:\n")
  printFunctions.printToLog("Volts per Division = %f\n" % vdiv)
  printFunctions.printToLog("Offset = %f\n" % off)
  printFunctions.printToLog("Seconds per Division = %f\n" % sdiv)
  printFunctions.printToLog("Delay = %f\n" % delay)
  printFunctions.printToScreenAndLog("\tReading Data of Power Source")
  cfg.Oscilloscope.send(":WAVEFORM:DATA?" + '\n') 
  tData = int(preamble[2])
  wavedata = ""
  count = 0
  temp = cfg.Oscilloscope.recv(tData, socket.MSG_WAITALL)
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
  cfg.SAMPLE_LENGTH_FROM_OSC = 20000
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
  if(channelName == 'CHANNEL1'):
	chanType = 'CHAN1'
  if(channelName == 'CHANNEL2'):
	chanType = 'CHAN2'
  if(channelName == 'CHANNEL3'):
	chanType = 'CHAN3'
  if(channelName == 'CHANNEL4'):
	chanType = 'CHAN4'	
  cfg.Oscilloscope.send(":WAVEFORM:SOURCE " + chanType + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:SOURCE?" + '\n')
  printFunctions.printToLog("\tOscilloscope Says .. Acquiring  ->" + cfg.Oscilloscope.recv(200))
  cfg.Oscilloscope.send(":WAVEFORM:POINTS:MODE BYTE" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS 16000" + '\n')#changed from 8,000,000 panci  
  cfg.Oscilloscope.send("WAVEFORM:POINTS?" + '\n')
  printFunctions.printToLog("\tOscillopscope Says .. Obtaining # point -> " + cfg.Oscilloscope.recv(200))

  #cmdString = ":WAVEFORM:POINTS " + str(cfg.osc_attributes['WAVE_DATA_SIZE'])
  #print cmdString
  #cfg.Oscilloscope.send(cmdString + '\n') 
  #printFunctions.printToLog("\t# of samples requested -> " + cfg.Oscilloscope.recv(200))    
  printFunctions.printToLog("\tReading Preamble of " + channelName)
  cfg.Oscilloscope.send(":WAVEFORM:PREAMBLE?" + '\n')
  preamble = cfg.Oscilloscope.recv(400)
  #print "first"
  print "\tpreamble as per oscilloscope - " + preamble
  fileId = open(cfg.TEMP_PREAMBLE_FILE, "wb")
  fileId.write(preamble)
  fileId.close()
  fid = open(cfg.TEMP_PREAMBLE_FILE, "rb")
  preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
  fid.close()
  #print "second"
  #print preamble
  #print str(int(preamble[2]))
  printFunctions.printToLog("\tTotal Number of Points to Receive: " + str(int(preamble[2])))
  #cfg.SAMPLE_LENGTH_FROM_OSC = int(preamble[2])
  vdiv = 32 * preamble[7]
  off = preamble[8]
  sdiv = preamble[2] * preamble[4] / 10
  delay = (preamble[2] / 2) * preamble[4] + preamble[5]
  printFunctions.printToLog("\t\tScope Settings for -> " + channelName)
  printFunctions.printToLog("\t\tVolts per Division = " + str(vdiv))
  printFunctions.printToLog("\t\tOffset = " + str(off))
  printFunctions.printToLog("\t\tSeconds per Division = " + str(sdiv))
  printFunctions.printToLog("\t\tDelay = " + str(delay))  
  printFunctions.printToLog("\tReading Data of " + channelName)
  cfg.Oscilloscope.send(":WAVEFORM:DATA?" + '\n') 
  tData = int(preamble[2])
  wavedata = ""
  temp = cfg.Oscilloscope.recv(11)
  print temp
  temp = cfg.Oscilloscope.recv(tData)
  #print len(temp)
  wavedata = wavedata+temp
  #support.goToSleep(2)
  while (len(wavedata) < tData):
  	temp = cfg.Oscilloscope.recv(tData)
  	#print len(temp)
        wavedata = wavedata + temp
  #print "\tLength of obtained data - " + str(len(wavedata))
  #lowerBound = tData - len(temp)
  #rData = lowerBound
  #temp = temp[10:]
  #while(count < lowerBound):
    #printFunctions.printToLog("\tNo. of Bytes transferred : " + str(count))
    #printFunctions.printToLog("\tNo. of Bytes to be transferred : " + str(rData))	
    #wavedata = wavedata + temp
    #temp = cfg.Oscilloscope.recv(rData)
    #count += len(temp)
    #rData = tData - count
  #print wavedata
  
  printFunctions.printToLog("Got the entire data. Moving on..!")
  fileId = open(cfg.TEMP_MEASUREMENT_FILE, "wb")
  fileId.write(str(wavedata))
  fileId.close()
  measuredChannelData = signalAnalysisModule.acquireDataValues(cfg.TEMP_PREAMBLE_FILE, cfg.TEMP_MEASUREMENT_FILE)
  support.removeFile(cfg.TEMP_PREAMBLE_FILE)
  support.removeFile(cfg.TEMP_MEASUREMENT_FILE)
  if (cfg.SAMPLE_LENGTH_FROM_OSC == None):
	#print "\t\tFirst run"
	cfg.SAMPLE_LENGTH_FROM_OSC = len(measuredChannelData)
  print "\tSAmple Length --> " + str(cfg.SAMPLE_LENGTH_FROM_OSC)
  return (measuredChannelData)

def initializeOscilloscopeDataStorage():
	cfg.channel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
	cfg.channel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
	cfg.channel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
	cfg.channel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None

def populateOscilloscopeDataStorage(traceCount):
	#sampleLength = 2000000
	#cfg.SAMPLE_LENGTH_FROM_OSC = 1000
	printFunctions.printToScreenAndLog("\tGetting data from Oscilloscope for Trace No ->" + str(traceCount+1))
	#print "Total array length " + len (cfg.SAMPLE_LENGTH_FROM_OSC)
	if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF'):
		dataFromOscilloscope = getDataFromOscilloscope('CHANNEL1')
		adjustedData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, dataFromOscilloscope)
		with open(cfg.CHANNEL1_MEASUREMENT_FILE, 'a+b') as fileHandle:
			numpy.save(fileHandle, adjustedData)
		
	if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF'):
		dataFromOscilloscope = getDataFromOscilloscope('CHANNEL2')
		adjustedData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, dataFromOscilloscope)
		with open(cfg.CHANNEL2_MEASUREMENT_FILE, 'a+b') as fileHandle:
			numpy.save(fileHandle, adjustedData)
		
	if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF'):
		dataFromOscilloscope = getDataFromOscilloscope('CHANNEL3')
		adjustedData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, dataFromOscilloscope)
		with open(cfg.CHANNEL3_MEASUREMENT_FILE, 'a+b') as fileHandle:
			numpy.save(fileHandle, adjustedData)
		
	if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):
		dataFromOscilloscope = getDataFromOscilloscope('CHANNEL4')
		adjustedData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, dataFromOscilloscope)
		with open(cfg.CHANNEL4_MEASUREMENT_FILE, 'a+b') as fileHandle:
			numpy.save(fileHandle, adjustedData)
				
def populateOscilloscopeDataStorageAndAlign(traceCount):
	#sampleLength = 2000000
	#cfg.SAMPLE_LENGTH_FROM_OSC = 1000
	printFunctions.printToScreenAndLog("\tGetting data from Oscilloscope for Trace No ->" + str(traceCount+1))
	#print "Total array length " + len (cfg.SAMPLE_LENGTH_FROM_OSC)
	if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF'):
		if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL1'):
		  triggerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL1')
		  adjustedTriggerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, triggerDataFromOscilloscope)
		else:
		  powerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL1')
		  adjustedPowerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, powerDataFromOscilloscope)

	if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF'):
		if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL2'):
		  triggerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL2')
		  adjustedTriggerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, triggerDataFromOscilloscope)
		else:
		  powerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL2')
		  adjustedPowerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, powerDataFromOscilloscope)		

	if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF'):
		if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL3'):
		  triggerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL3')
		  adjustedTriggerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, triggerDataFromOscilloscope)
		else:
		  powerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL3')
		  adjustedPowerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, powerDataFromOscilloscope)		

	if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF'):
		if(cfg.osc_attributes['TRIGGER_SOURCE'] == 'CHANNEL4'):
		  triggerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL4')
		  adjustedTriggerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, triggerDataFromOscilloscope)
		else:
		  powerDataFromOscilloscope = getDataFromOscilloscope('CHANNEL4')
		  adjustedPowerData = signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, powerDataFromOscilloscope)
		  
	rawAlignedData = computeAlignedData(adjustedPowerData, adjustedTriggerData)
	with open(cfg.ALIGNED_DATA_FILE, 'a+b') as fileHandle:
		numpy.save(fileHandle, rawAlignedData)

def oldpopulateOscilloscopeDataStorage(traceCount):
	#sampleLength = 2000000
	printFunctions.printToLog("\tGetting data from Oscilloscope for Trace No ->" + str(traceCount+1))		
	tempChannel1Data = getDataFromOscilloscope('CHANNEL1') if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
	tempChannel2Data = getDataFromOscilloscope('CHANNEL2') if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
	tempChannel3Data = getDataFromOscilloscope('CHANNEL3') if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
	tempChannel4Data = getDataFromOscilloscope('CHANNEL4') if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
	if (traceCount == 0):
		cfg.channel1Data =  signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel1Data)  if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		cfg.channel2Data =  signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel2Data)  if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		cfg.channel3Data =  signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel3Data)  if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		cfg.channel4Data =  signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel4Data)  if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
		tempChannel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		tempChannel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		tempChannel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		tempChannel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None								
	else:
		cfg.channel1Data = numpy.vstack((cfg.channel1Data, signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel1Data)))  if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		cfg.channel2Data = numpy.vstack((cfg.channel2Data, signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel2Data)))  if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		cfg.channel3Data = numpy.vstack((cfg.channel3Data, signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel3Data)))  if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		cfg.channel4Data = numpy.vstack((cfg.channel4Data, signalAnalysisModule.adjustSampleSize(cfg.SAMPLE_LENGTH_FROM_OSC, tempChannel4Data)))  if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
		tempChannel1Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE1'] != 'OFF') else None
		tempChannel2Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE2'] != 'OFF') else None
		tempChannel3Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE3'] != 'OFF') else None
		tempChannel4Data = numpy.zeros(0) if(cfg.osc_attributes['CHANNEL_RANGE4'] != 'OFF') else None
def saveOscilloscopeDataStorage():
	printFunctions.printToScreenAndLog("\tSaving the data from Oscilloscope")
	if (cfg.channel1Data != None):		
		numpy.save(cfg.CHANNEL1_MEASUREMENT_FILE, cfg.channel1Data)#, fmt = '%5.4g')
	if (cfg.channel2Data != None):		
		numpy.save(cfg.CHANNEL2_MEASUREMENT_FILE, cfg.channel2Data)#, fmt = '%5.4g')
	if (cfg.channel3Data != None):		
		numpy.save(cfg.CHANNEL3_MEASUREMENT_FILE, cfg.channel3Data)#, fmt = '%5.4g')
	if (cfg.channel4Data != None):		
		numpy.save(cfg.CHANNEL4_MEASUREMENT_FILE, cfg.channel4Data)#, fmt = '%5.4g')
 
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
	
def openOscilloscopeConnectionOld():
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

def openOscilloscopeConnection():
  cfg.Oscilloscope = socket( AF_INET, SOCK_STREAM )
  cfg.Oscilloscope.connect((cfg.osc_attributes['OSCILLOSCOPE_IP'], cfg.osc_attributes['OSCILLOSCOPE_PORT']))#have to put in error checks dummy
  cfg.Oscilloscope.send("*IDN?"+'\n')
  osc_id = cfg.Oscilloscope.recv(200)
  printFunctions.printToScreenAndLog("\tConnected to Oscilloscope ID :"+ osc_id+'\n')
  cfg.ALIGNED_DATA_FILE = os.path.join(cfg.MEASUREMENT_FOLDER, globals.ALIGNED_DATA_FILE_NAME)	
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
		support.goToSleep(0.1)
	else:
		printFunctions.printToScreenAndLog("\tNo Channels selected to Digitize.")
	

def closeOscilloscopeConnection():
  cfg.Oscilloscope.close()
