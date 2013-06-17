#!/usr/bin/python

import os
import re
from sys import argv
from socket import *
import sys
from oscilloscope_agilent import *
from oscilloscope_global import *
#import visa
from numpy import *
 
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
        print "Acquiring Attributes"
        for object in data_list :
            if re.match('^OSCILLOSCOPE\W', object) :
		value = re.split("=", object)
		osc_attributes['OSCILLOSCOPE'] = value[1].strip(" ")
            elif re.match('^OSCILLOSCOPE_IP\W', object) :
		value = re.split("=", object)
		osc_attributes['OSCILLOSCOPE_IP'] = value[1].strip(" ")
            elif re.match('^OSCILLOSCOPE_PORT\W', object) :
		value = re.split("=", object)
		osc_attributes['OSCILLOSCOPE_PORT'] = value[1].strip(" ")	  
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
		
def set_osc_attrib(osc_attributes, osc_socket) :
  if re.match('AGILENT', osc_attributes['OSCILLOSCOPE']) :
    osc_attributes = parse_attrib_agilent(osc_attributes)
    for key, value in osc_attributes.items() :
	osc.socket.send(value)
  return(osc_attributes)
  
def get_waveform_power(oscilloscope_socket) :
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

def oscilloscope_connect(osc_ipaddress, osc_portnos):
	osc_socket = socket( AF_INET, SOCK_STREAM )
	osc_socket.connect((osc_ipaddress, osc_portnos))#have to put in error checks dummy
	osc_socket.send("*IDN?"+'\n')
	osc_id = osc_socket.recv(200)
	print "\tConnected to Oscilloscope ID :"+ osc_id+'\n'
	return (osc_socket)
