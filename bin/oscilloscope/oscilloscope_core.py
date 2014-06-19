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
#import visa
from numpy import *
 

def get_attribs(data_list) :
    for object in data_list :
        if re.match('^OSCILLOSCOPE\W', object) :
	value = re.split("=", object)
	cfg.osc_attributes['OSCILLOSCOPE'] = value[1].strip(" ")
        elif re.match('^OSCILLOSCOPE_IP\W', object) :
	value = re.split("=", object)
	cfg.osc_attributes['OSCILLOSCOPE_IP'] = value[1].strip(" ")
        elif re.match('^OSCILLOSCOPE_PORT\W', object) :
	value = re.split("=", object)
	cfg.osc_attributes['OSCILLOSCOPE_PORT'] = value[1].strip(" ")	  
        elif re.match('^AUTOSCALE', object) :
	value = re.split("=", object)
	cfg.osc_attributes['AUTOSCALE'] = value[1].strip(" ")
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
        elif re.match('^CHANNEL1_DISPLAY', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL2_DISPLAY'] = value[1].strip(" ")
        elif re.match('^CHANNEL1_DISPLAY', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL2_DISPLAY'] = value[1].strip(" ")
        elif re.match('^CHANNEL3_DISPLAY', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL3_DISPLAY'] = value[1].strip(" ")
        elif re.match('^CHANNEL4_DISPLAY', object) :
            value = re.split("=", object)
            cfg.osc_attributes['CHANNEL4_DISPLAY'] = value[1].strip(" ")
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
  if osc_attributes['IMPEDANCE'] :
    cmd_string = ":CHANNEL1:IMPEDANCE "+osc_attributes['IMPEDANCE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['CHANNEL_RANGE1'] :
    cmd_string = ":CHANNEL1:RANGE "+osc_attributes['CHANNEL_RANGE1']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['CHANNEL_RANGE2'] :
    cmd_string = ":CHANNEL2:RANGE "+osc_attributes['CHANNEL_RANGE2']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['CHANNEL_RANGE3'] :	
    cmd_string = ":CHANNEL3:RANGE "+osc_attributes['CHANNEL_RANGE3']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['CHANNEL_RANGE4'] :
    cmd_string = ":CHANNEL4:RANGE "+osc_attributes['CHANNEL_RANGE4']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['TIME_RANGE'] :
    cmd_string = ":TIM:RANG "+osc_attributes['TIME_RANGE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['TIMEBASE_REF'] :
    cmd_string = ":TIMEBASE:REFERENCE "+osc_attributes['TIMEBASE_REF']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['TRIGGER_SOURCE'] :
    cmd_string = ":TRIGger:EDGE:SOURce "+osc_attributes['TRIGGER_SOURCE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['TRIGGER_MODE'] :
    cmd_string = ":TRIGGER:MODE "+osc_attributes['TRIGGER_MODE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['TRIGGER_SWEEP'] :
    cmd_string = ":TRIGGER:SWEEP "+osc_attributes['TRIGGER_SWEEP']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['TRIGGER_LEVEL'] :
    cmd_string = ":TRIGGER:EDGE:LEVEL "+osc_attributes['TRIGGER_LEVEL']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['TRIGGER_SLOPE'] :
    cmd_string = ":TRIGGER:EDGE:SLOPE "+osc_attributes['TRIGGER_SLOPE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['ACQUIRE_TYPE'] :
    cmd_string = ":ACQUIRE:TYPE "+osc_attributes['ACQUIRE_TYPE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['ACQUIRE_MODE'] :
    cmd_string = ":ACQUIRE:MODE "+osc_attributes['ACQUIRE_MODE']
    cfg.Oscilloscope.send(cmd_string+'\n')
  if osc_attributes['ACQUIRE_COMPLETE'] :
    cmd_string = ":ACQUIRE:COMPLETE "+osc_attributes['ACQUIRE_COMPLETE']
    cfg.Oscilloscope.send(cmd_string+'\n')
 
def extractOscilloscopeConfigAttributes():
  data_from_file = readFile(cfg.OSC_CONFIGFILE)
  data_list = removeComments(data_from_file)
  printToLog("Obtaining oscilloscope attributes")
  get_attribs(data_list)
	  
def get_waveform_power() :
  cfg.Oscilloscope.send(":WAVEFORM:FORMAT BYTE" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:SOURCE CHAN1" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS 8000000" + '\n')
  print "\tReading Preamble of Power Source"
  cfg.Oscilloscope.send(":WAVEFORM:PREAMBLE?" + '\n')
  preamble = cfg.Oscilloscope.recv(200)
  fpowerpreamble = open(cfg.POWER_CHANNEL_PREAMBLE_FILE, "wb")
  fpowerpreamble.write(preamble)
  fpowerpreamble.close()
  fid = open(cfg.POWER_CHANNEL_PREAMBLE_FILE, "rb")
  preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
  fid.close()
  print "\tTotal Number of Points to Receive: " + str(int(preamble[2]))
  print "\tReading Data of Power Source"
  cfg.Oscilloscope.send(":WAVEFORM:DATA?" + '\n') 
  tData = int(preamble[2])
  wavedata = ""
  count = 0
  temp = cfg.Oscilloscope.recv(tData)
  while(len(temp) > 0 and count < 20):
    wavedata = wavedata + temp
    temp = cfg.Oscilloscope.recv(tData)
    count += 1
  print "No. of Bytes transferred per turn: " + str(len(temp))
  print "\t\tWriting to file"
  #print wavedata
  fpower = open(cfg.POWER_MEASUREMENT_FILE, "wb")
  fpower.write(str(wavedata))
  fpower.close()

def get_waveform_trigger() :
  cfg.Oscilloscope.send(":WAVEFORM:FORMAT BYTE" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:SOURCE CHAN2" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
  cfg.Oscilloscope.send(":WAVEFORM:POINTS 8000000" + '\n')
  print "\tReading Preamble of Power Source"
  cfg.Oscilloscope.send(":WAVEFORM:PREAMBLE?" + '\n')
  preamble = cfg.Oscilloscope.recv(200)
  fpowerpreamble = open("preambleChannel2.dat", "wb")
  fpowerpreamble.write(preamble)
  fpowerpreamble.close()
  fid = open("preambleChannel2.dat", "rb")
  preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
  fid.close()
  print "\tTotal Number of Points to Receive: " + str(int(preamble[2]))
  print "\tReading Data of Power Source"
  cfg.Oscilloscope.send(":WAVEFORM:DATA?" + '\n') 
  tData = int(preamble[2])
  wavedata = ""
  count = 0
  temp = cfg.Oscilloscope.recv(tData)
  while(len(temp) > 0 and count < 20):
    wavedata = wavedata + temp
    temp = cfg.Oscilloscope.recv(tData)
    count += 1
  print "No. of Bytes transferred per turn: " + str(len(temp))
  print "\t\tWriting to file"
  #print wavedata
  fpower = open("channel2.dat", "wb")
  fpower.write(str(wavedata))
  fpower.close()

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
  printToScreenAndLog("\tConnected to Oscilloscope ID :"+ osc_id+'\n')

def armOscilloscope():
  cfg.Oscilloscope.send(":DIGITIZE CHAN1,CHAN2" + '\n')

def closeOscilloscopeConnection():
  cfg.Oscilloscope.close()  
