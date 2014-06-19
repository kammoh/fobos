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
#from sys import argv
import sys
import visa
from numpy import *

osc_attributes = {
 'RESOURCE' : "",        'AUTOSCALE' : "",        'IMPEDANCE' : "",        'CHANNEL_RANGE1' : "",
 'CHANNEL_RANGE2' : "",   'CHANNEL_RANGE3' : "",   'CHANNEL_RANGE4' : "",   'CHANNEL1_DISPLAY' : "",
 'CHANNEL2_DISPLAY' : "", 'CHANNEL3_DISPLAY' : "", 'CHANNEL4_DISPLAY' : "", 'TIME_RANGE' : "",
 'TIMEBASE_REF' : "",     'TRIGGER_SOURCE' : "",   'TRIGGER_MODE' : "",     'TRIGGER_SWEEP' : "",
 'TRIGGER_LEVEL' : "",    'TRIGGER_SLOPE' : "",    'SAMPLE_INPUT' : "",     'ACQUIRE_TYPE' : "",
 'ACQUIRE_MODE' : "",     'ACQUIRE_COMPLETE' : "", 'WAVE_DATA_SIZE' : "",   'NUM_PWR_TRACE' : "",
 'SCREEN_CAP' : "",       'SCREEN_FORMAT' : "",    'SCREEN_NAME' : "",      'OUTPUT_DIR' : "",
 }
 
def clear_screen():
    if (sys.platform == "linux2" ):
      os.system('clear')
    elif (sys.platform == "win32" ):
      os.system('cls')
 
def print_header(file_name) :
    print "--------------------------------------------"
    print "Starting Oscilloscope Data Collection Script"
    print "Using the options from File: %s" % file_name
		
		
def read_file(file_name) :
	print "Reading File : %s" % file_name
	file_pt = open(file_name, "r")
	indata = file_pt.readlines()
	print "Number of Lines read : %d" % len(indata)
	return (indata)

def remove_comments(data_list) :
	print "Removing Comments from the Data list"
	newdata_list = []
	for object in data_list:
		item = re.sub(r'#.*$', "", object)
		item = item.rstrip()
		if item :
			newdata_list.append(item)
	return(newdata_list)		

def get_attribs(data_list) :
#count = 0
        print "Assigning Attributes"
        for object in data_list :
            if re.match('^RESOURCE', object) :
				value = re.split("=", object)
				osc_attributes['RESOURCE'] = value[1].strip(" ")			
            elif re.match('^AUTOSCALE', object) :
				value = re.split("=", object)
				osc_attributes['AUTOSCALE'] = value[1].strip(" ")
            elif re.match('^IMPEDANCE', object) :
                value = re.split("=", object)
                osc_attributes['IMPEDANCE'] = value[1].strip(" ")
            elif re.match('^CHANNEL_RANGE1', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL_RANGE1'] = value[1].strip(" ")
            elif re.match('^CHANNEL_RANGE2', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL_RANGE2'] = value[1].strip(" ")
            elif re.match('^CHANNEL_RANGE3', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL_RANGE3'] = value[1].strip(" ")
            elif re.match('^CHANNEL_RANGE4', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL_RANGE4'] = value[1].strip(" ")
            elif re.match('^CHANNEL1_DISPLAY', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL2_DISPLAY'] = value[1].strip(" ")
            elif re.match('^CHANNEL1_DISPLAY', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL2_DISPLAY'] = value[1].strip(" ")
            elif re.match('^CHANNEL3_DISPLAY', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL3_DISPLAY'] = value[1].strip(" ")
            elif re.match('^CHANNEL4_DISPLAY', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL4_DISPLAY'] = value[1].strip(" ")
            elif re.match('^TIME_RANGE', object) :
                value = re.split("=", object)
                osc_attributes['TIME_RANGE'] = value[1].strip(" ")
            elif re.match('^TIMEBASE_REF', object) :
                value = re.split("=", object)
                osc_attributes['TIMEBASE_REF'] = value[1].strip(" ")
            elif re.match('^TRIGGER_SOURCE', object) :
                value = re.split("=", object)
                osc_attributes['TRIGGER_SOURCE'] = value[1].strip(" ")
            elif re.match('^TRIGGER_MODE', object) :
                value = re.split("=", object)
                osc_attributes['TRIGGER_MODE'] = value[1].strip(" ")
            elif re.match('^TRIGGER_SWEEP', object) :
                value = re.split("=", object)
                osc_attributes['TRIGGER_SWEEP'] = value[1].strip(" ")
            elif re.match('^TRIGGER_LEVEL', object) :
                value = re.split("=", object)
                osc_attributes['TRIGGER_LEVEL'] = value[1].strip(" ")
            elif re.match('^TRIGGER_SLOPE', object) :
                value = re.split("=", object)
                osc_attributes['TRIGGER_SLOPE'] = value[1].strip(" ")
            elif re.match('^SAMPLE_INPUT', object) :
                value = re.split("=", object)
                osc_attributes['SAMPLE_INPUT'] = value[1].strip(" ")
            elif re.match('^ACQUIRE_TYPE', object) :
                value = re.split("=", object)
                osc_attributes['ACQUIRE_TYPE'] = value[1].strip(" ")
            elif re.match('^ACQUIRE_MODE', object) :
                value = re.split("=", object)
                osc_attributes['ACQUIRE_MODE'] = value[1].strip(" ")
            elif re.match('^ACQUIRE_COMPLETE', object) :
                value = re.split("=", object)
                osc_attributes['ACQUIRE_COMPLETE'] = value[1].strip(" ")
            elif re.match('^WAVE_DATA_SIZE', object) :
                value = re.split("=", object)
                osc_attributes['WAVE_DATA_SIZE'] = value[1].strip(" ")
            elif re.match('^NUM_PWR_TRACE', object) :
                value = re.split("=", object)
                osc_attributes['NUM_PWR_TRACE'] = value[1].strip(" ")
            elif re.match('^SCREEN_CAP', object) :
                value = re.split("=", object)
                osc_attributes['SCREEN_CAP'] = value[1].strip(" ")
            elif re.match('^SCREEN_FORMAT', object) :
                value = re.split("=", object)
                osc_attributes['SCREEN_FORMAT'] = value[1].strip(" ")
            elif re.match('^SCREEN_NAME', object) :
                value = re.split("=", object)
                osc_attributes['SCREEN_NAME'] = value[1].strip(" ")
            elif re.match('^OUTPUT_DIR', object) :
                value = re.split("=", object)
                osc_attributes['OUTPUT_DIR'] = value[1].strip(" ")                        
		return(osc_attributes) 

def get_waveform_power() :
	MyInstrument.write(":WAVEFORM:FORMAT BYTE")
	cmd_string = ":WAVEFORM:SOURCE CHAN1"
	MyInstrument.write(cmd_string)
	MyInstrument.write(":WAVEFORM:POINTS:MODE RAW")
	MyInstrument.write(":WAVEFORM:POINTS 8000000")
	print "\tReading Preamble of Power Source"
	preamble = MyInstrument.ask(":WAVEFORM:PREAMBLE?")
	print "\tReading Data of Power Source"
	wavedata = MyInstrument.ask(":WAVEFORM:DATA?") 
	print "\t\tWriting to file"
	totalpower = preamble +wavedata
	fpower = open("power.dat", "w")
	fpower.writelines(totalpower)
	fpower.close()

def get_waveform_trigger() :
	MyInstrument.write(":WAVEFORM:FORMAT BYTE")
	cmd_string = ":WAVEFORM:SOURCE CHAN2"
	MyInstrument.write(cmd_string)
	MyInstrument.write(":WAVEFORM:POINTS:MODE RAW")
	MyInstrument.write(":WAVEFORM:POINTS 8000000")
	print "Reading Preamble of Trigger Source"
	preamble = MyInstrument.ask(":WAVEFORM:PREAMBLE?")
	print "Reading Data of Trigger Source"
	wavedata = MyInstrument.ask(":WAVEFORM:DATA?") 
	print "\t\tWriting to file"
	totaltrigger = preamble +wavedata
	ftrigger = open("trigger.dat", "w")
	ftrigger.writelines(totaltrigger)
	ftrigger.close()

	
	
################################################################################
## Main Program
################################################################################
script, osc_config_file = argv

## Clear Screen
#os.system('clear')
clear_screen()

## Print Header on Konsole
print_header(osc_config_file)

## Read Oscilloscope Config File
data_from_file = read_file(osc_config_file)

## Remove Comments and empty lines
data_list = remove_comments(data_from_file)
#print data_list

## Get Attributes from file
inst_attrib = get_attribs(data_list)

## Get Instrument VISA address
visa_add = visa.get_instruments_list()
MyInstrument = visa.instrument(visa_add[0])

## Set VISA Timeout Value
MyInstrument.timeout = 20 #Timeout Set to 20sec 

## Get Instrument ID
MyInstrumentID = MyInstrument.ask("*IDN?")
print "\tInstrument ID = "+ MyInstrumentID
## Reset Instrument
MyInstrument.write("*RST")

## Setting Oscilloscope Attributes

print "\tSetting Oscilloscope Attributes"
if inst_attrib['IMPEDANCE'] :
	cmd_string = ":CHANNEL1:IMPEDANCE "+inst_attrib['IMPEDANCE']
	MyInstrument.write(cmd_string)
	
if inst_attrib['CHANNEL_RANGE1'] :
	cmd_string = ":CHANNEL1:RANGE "+inst_attrib['CHANNEL_RANGE1']
	MyInstrument.write(cmd_string)

if inst_attrib['CHANNEL_RANGE2'] :
	cmd_string = ":CHANNEL2:RANGE "+inst_attrib['CHANNEL_RANGE2']
	MyInstrument.write(cmd_string)

if inst_attrib['CHANNEL_RANGE3'] :
	cmd_string = ":CHANNEL3:RANGE "+inst_attrib['CHANNEL_RANGE3']
	MyInstrument.write(cmd_string)
	
if inst_attrib['CHANNEL_RANGE4'] :
	cmd_string = ":CHANNEL4:RANGE "+inst_attrib['CHANNEL_RANGE4']
	MyInstrument.write(cmd_string)

if inst_attrib['TIME_RANGE'] :
	cmd_string = ":TIM:RANG "+inst_attrib['TIME_RANGE']
	MyInstrument.write(cmd_string)

if inst_attrib['TIMEBASE_REF'] :
	cmd_string = ":TIMEBASE:REFERENCE "+inst_attrib['TIMEBASE_REF']
	MyInstrument.write(cmd_string)

if inst_attrib['TRIGGER_SOURCE'] :
	cmd_string = ":TRIGger:EDGE:SOURce "+inst_attrib['TRIGGER_SOURCE']
	MyInstrument.write(cmd_string)

if inst_attrib['TRIGGER_MODE'] :
	cmd_string = ":TRIGGER:MODE "+inst_attrib['TRIGGER_MODE']
	MyInstrument.write(cmd_string)

if inst_attrib['TRIGGER_SWEEP'] :
	cmd_string = ":TRIGGER:SWEEP "+inst_attrib['TRIGGER_SWEEP']
	MyInstrument.write(cmd_string)

if inst_attrib['TRIGGER_LEVEL'] :
	cmd_string = ":TRIGGER:EDGE:LEVEL "+inst_attrib['TRIGGER_LEVEL']
	MyInstrument.write(cmd_string)

if inst_attrib['TRIGGER_SLOPE'] :
	cmd_string = ":TRIGGER:EDGE:SLOPE "+inst_attrib['TRIGGER_SLOPE']
	MyInstrument.write(cmd_string)

if inst_attrib['ACQUIRE_TYPE'] :
	cmd_string = ":ACQUIRE:TYPE "+inst_attrib['ACQUIRE_TYPE']
	MyInstrument.write(cmd_string)

if inst_attrib['ACQUIRE_MODE'] :
	cmd_string = ":ACQUIRE:MODE "+inst_attrib['ACQUIRE_MODE']
	MyInstrument.write(cmd_string)

if inst_attrib['ACQUIRE_COMPLETE'] :
	cmd_string = ":ACQUIRE:COMPLETE "+inst_attrib['ACQUIRE_COMPLETE']
	MyInstrument.write(cmd_string)	

	
print "\tGetting System Setup Information"	
## Get System Setup Information	
systemsetup_info = MyInstrument.ask(":SYSTEM:SETUP?")
print "\t\tWriting to file"
fsetup = open("setup.dat", "w")
fsetup.writelines(systemsetup_info)
fsetup.close()
	
if inst_attrib['SAMPLE_INPUT'] :
	cmd_string = ":DIGITIZE "+inst_attrib['SAMPLE_INPUT']
	MyInstrument.write(cmd_string)	
	
print "\tGetting Power Waveform"
get_waveform_power()
print "\tGetting Trigger Waveform"
get_waveform_trigger()	
## Get Preamble Information	
#preamble = MyInstrument.ask(":WAVEFORM:PREAMBLE?")

#print preamble

