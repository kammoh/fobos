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
import time
from sys import argv
import sys
from oscilloscope_core import *
import socket
from numpy import *
import matplotlib.pyplot as plt


#oscilloscope_ipaddress = "192.168.0.10"
#oscilloscope_portno = 5025	
	
################################################################################
## Main Program
################################################################################
script, osc_config_file = argv

## Clear Screen
os.system('clear')
#clear_screen()

## Print Header on Konsole
print_header(osc_config_file)

## Read Oscilloscope Config File
data_from_file = read_file(osc_config_file)

## Remove Comments and empty lines
data_list = remove_comments(data_from_file)
#print data_list

## Get Attributes from file
inst_attrib = get_attribs(data_list)

## Connect to Oscilloscope
MyInstrument = oscilloscope_connect(inst_attrib['OSCILLOSCOPE_IP'],inst_attrib['OSCILLOSCOPE_PORT'])


## Reset Instrument
#MyInstrumentSend(MyInstrument,"*RST")
#time.sleep(8)
	
print "\tSetting Oscilloscope Attributes"
if inst_attrib['CHANNEL1_IMPEDANCE'] :
	cmd_string = ":CHANNEL1:IMPEDANCE "+inst_attrib['CHANNEL1_IMPEDANCE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL2_IMPEDANCE'] :
	cmd_string = ":CHANNEL2:IMPEDANCE "+inst_attrib['CHANNEL2_IMPEDANCE']
	MyInstrumentSend(MyInstrument,cmd_string)
	
if inst_attrib['CHANNEL3_IMPEDANCE'] :
	cmd_string = ":CHANNEL3:IMPEDANCE "+inst_attrib['CHANNEL3_IMPEDANCE']
	MyInstrumentSend(MyInstrument,cmd_string)
	
if inst_attrib['CHANNEL4_IMPEDANCE'] :
	cmd_string = ":CHANNEL4:IMPEDANCE "+inst_attrib['CHANNEL4_IMPEDANCE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL1_DISPLAY'] :
	cmd_string = ":CHANNEL1:DISPLAY "+inst_attrib['CHANNEL1_DISPLAY']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL2_DISPLAY'] :
	cmd_string = ":CHANNEL2:DISPLAY "+inst_attrib['CHANNEL2_DISPLAY']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL3_DISPLAY'] :
	cmd_string = ":CHANNEL3:DISPLAY "+inst_attrib['CHANNEL3_DISPLAY']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL4_DISPLAY'] :
	cmd_string = ":CHANNEL4:DISPLAY "+inst_attrib['CHANNEL4_DISPLAY']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL1_RANGE'] :
	cmd_string = ":CHANNEL1:RANGE "+inst_attrib['CHANNEL1_RANGE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL2_RANGE'] :
	cmd_string = ":CHANNEL2:RANGE "+inst_attrib['CHANNEL2_RANGE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL3_RANGE'] :
	cmd_string = ":CHANNEL3:RANGE "+inst_attrib['CHANNEL3_RANGE']
	MyInstrumentSend(MyInstrument,cmd_string)
	
if inst_attrib['CHANNEL4_RANGE'] :
	cmd_string = ":CHANNEL4:RANGE "+inst_attrib['CHANNEL4_RANGE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL1_SCALE'] :
	cmd_string = ":CHANNEL1:SCALE "+inst_attrib['CHANNEL1_SCALE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL2_SCALE'] :
	cmd_string = ":CHANNEL2:SCALE "+inst_attrib['CHANNEL2_SCALE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['CHANNEL3_SCALE'] :
	cmd_string = ":CHANNEL3:SCALE "+inst_attrib['CHANNEL3_SCALE']
	MyInstrumentSend(MyInstrument,cmd_string)
	
if inst_attrib['CHANNEL4_SCALE'] :
	cmd_string = ":CHANNEL4:SCALE "+inst_attrib['CHANNEL4_SCALE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['TIME_RANGE'] :
	cmd_string = ":TIME:RANGE "+inst_attrib['TIME_RANGE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['TIME_SCALE'] :
	cmd_string = ":TIME:SCALE "+inst_attrib['TIME_SCALE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['TIMEBASE_REF'] :
	cmd_string = ":TIMEBASE:REFERENCE "+inst_attrib['TIMEBASE_REF']
	MyInstrumentSend(MyInstrument,cmd_string)
	
if inst_attrib['TRIGGER_SOURCE'] :
	cmd_string = ":TRIGger:EDGE:SOURce "+inst_attrib['TRIGGER_SOURCE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['TRIGGER_MODE'] :
	cmd_string = ":TRIGGER:MODE "+inst_attrib['TRIGGER_MODE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['TRIGGER_SWEEP'] :
	cmd_string = ":TRIGGER:SWEEP "+inst_attrib['TRIGGER_SWEEP']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['TRIGGER_LEVEL'] :
	cmd_string = ":TRIGGER:EDGE:LEVEL "+inst_attrib['TRIGGER_LEVEL']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['TRIGGER_SLOPE'] :
	cmd_string = ":TRIGGER:EDGE:SLOPE "+inst_attrib['TRIGGER_SLOPE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['ACQUIRE_TYPE'] :
	cmd_string = ":ACQUIRE:TYPE "+inst_attrib['ACQUIRE_TYPE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['ACQUIRE_MDEPTH'] :
	cmd_string = ":ACQUIRE:MDEPTH "+inst_attrib['ACQUIRE_MDEPTH']
	MyInstrumentSend(MyInstrument,cmd_string)
	
if inst_attrib['ACQUIRE_MODE'] :
	cmd_string = ":ACQUIRE:MODE "+inst_attrib['ACQUIRE_MODE']
	MyInstrumentSend(MyInstrument,cmd_string)

if inst_attrib['ACQUIRE_COMPLETE'] :
	cmd_string = ":ACQUIRE:COMPLETE "+inst_attrib['ACQUIRE_COMPLETE']
	MyInstrumentSend(MyInstrument,cmd_string)	

### Digitize

i = 0
while (i < 10):
	print "run No" + str(i)
	MyInstrumentSend(MyInstrument,":SINGLE")
	done = "WAIT\n"
	while (done != "STOP\n"):
	  	MyInstrumentSend(MyInstrument,":TRIGGER:STATUS?")
	  	done=MyInstrument.recv(5)
	  	print done
	print done
## Read Power consumption of the targe
	get_waveform_power(MyInstrument)
#get_snapshot(MyInstrument)

## Read Trigger information of the target
	get_waveform_trigger(MyInstrument)
	i = i +1
## Closing Oscilloscope socket
MyInstrument.close()


