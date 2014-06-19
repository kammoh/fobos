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
MyInstrument.send("*RST" + '\n')

print "\tSetting Oscilloscope Attributes"
if inst_attrib['IMPEDANCE'] :
	cmd_string = ":CHANNEL1:IMPEDANCE "+inst_attrib['IMPEDANCE']
	MyInstrument.send(cmd_string+'\n')
	
if inst_attrib['CHANNEL_RANGE1'] :
	cmd_string = ":CHANNEL1:RANGE "+inst_attrib['CHANNEL_RANGE1']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['CHANNEL_RANGE2'] :
	cmd_string = ":CHANNEL2:RANGE "+inst_attrib['CHANNEL_RANGE2']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['CHANNEL_RANGE3'] :
	cmd_string = ":CHANNEL3:RANGE "+inst_attrib['CHANNEL_RANGE3']
	MyInstrument.send(cmd_string+'\n')
	
if inst_attrib['CHANNEL_RANGE4'] :
	cmd_string = ":CHANNEL4:RANGE "+inst_attrib['CHANNEL_RANGE4']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['TIME_RANGE'] :
	cmd_string = ":TIM:RANG "+inst_attrib['TIME_RANGE']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['TIMEBASE_REF'] :
	cmd_string = ":TIMEBASE:REFERENCE "+inst_attrib['TIMEBASE_REF']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['TRIGGER_SOURCE'] :
	cmd_string = ":TRIGger:EDGE:SOURce "+inst_attrib['TRIGGER_SOURCE']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['TRIGGER_MODE'] :
	cmd_string = ":TRIGGER:MODE "+inst_attrib['TRIGGER_MODE']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['TRIGGER_SWEEP'] :
	cmd_string = ":TRIGGER:SWEEP "+inst_attrib['TRIGGER_SWEEP']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['TRIGGER_LEVEL'] :
	cmd_string = ":TRIGGER:EDGE:LEVEL "+inst_attrib['TRIGGER_LEVEL']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['TRIGGER_SLOPE'] :
	cmd_string = ":TRIGGER:EDGE:SLOPE "+inst_attrib['TRIGGER_SLOPE']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['ACQUIRE_TYPE'] :
	cmd_string = ":ACQUIRE:TYPE "+inst_attrib['ACQUIRE_TYPE']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['ACQUIRE_MODE'] :
	cmd_string = ":ACQUIRE:MODE "+inst_attrib['ACQUIRE_MODE']
	MyInstrument.send(cmd_string+'\n')

if inst_attrib['ACQUIRE_COMPLETE'] :
	cmd_string = ":ACQUIRE:COMPLETE "+inst_attrib['ACQUIRE_COMPLETE']
	MyInstrument.send(cmd_string+'\n')	

## Digitize

MyInstrument.send(":DIGITIZE CHAN1" + '\n')
## Read Power consumption of the target

#get_waveform_power(MyInstrument)
#get_snapshot(MyInstrument)

## Read Trigger information of the target
#get_waveform_trigger(MyInstrument)

## Closing Oscilloscope socket
MyInstrument.close()


