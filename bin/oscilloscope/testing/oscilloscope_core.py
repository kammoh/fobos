#!/usr/bin/python

import os
import re
from sys import argv
from socket import *
import sys
#import visa
import numpy

osc_attributes = {
 'RESOURCE' : "",        'AUTOSCALE' : "",        'IMPEDANCE' : "",        'CHANNEL_RANGE1' : "",
 'CHANNEL_RANGE2' : "",   'CHANNEL_RANGE3' : "",   'CHANNEL_RANGE4' : "",   'CHANNEL1_DISPLAY' : "",
 'CHANNEL2_DISPLAY' : "", 'CHANNEL3_DISPLAY' : "", 'CHANNEL4_DISPLAY' : "", 'TIME_RANGE' : "",
 'TIMEBASE_REF' : "",     'TRIGGER_SOURCE' : "",   'TRIGGER_MODE' : "",     'TRIGGER_SWEEP' : "",
 'TRIGGER_LEVEL' : "",    'TRIGGER_SLOPE' : "",    'SAMPLE_INPUT' : "",     'ACQUIRE_TYPE' : "",
 'ACQUIRE_MODE' : "",     'ACQUIRE_COMPLETE' : "", 'WAVE_DATA_SIZE' : "",   'NUM_PWR_TRACE' : "",
 'SCREEN_CAP' : "",       'SCREEN_FORMAT' : "",    'SCREEN_NAME' : "",      'OUTPUT_DIR' : "",
 'OSCILLOSCOPE_IP' : "",  'OSCILLOSCOPE_PORT' : "",
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
	    elif re.match('^OSCILLOSCOPE_IP', object) :
				value = re.split("=", object)
				osc_attributes['OSCILLOSCOPE_IP'] = value[1].strip(" ")
	    elif re.match('^OSCILLOSCOPE_PORT', object) :
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

def get_waveform_power(MyInstrument) :
	MyInstrument.send(":WAVEFORM:FORMAT BYTE" + '\n')
	MyInstrument.send(":WAVEFORM:SOURCE CHAN1" + '\n')
	MyInstrument.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
	MyInstrument.send(":WAVEFORM:POINTS 8000000" + '\n')
	print "\tReading Preamble of Power Source"
	MyInstrument.send(":WAVEFORM:PREAMBLE?" + '\n')
	preamble = MyInstrument.recv(200)
	fpowerpreamble = open("preambleChannel1.dat", "wb")
	fpowerpreamble.write(preamble)
	fpowerpreamble.close()
	fid = open("preambleChannel1.dat", "rb")
	preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
	fid.close()
	print "\tTotal Number of Points to Receive: " + str(int(preamble[2]))
	print "\tReading Data of Power Source"
	MyInstrument.send(":WAVEFORM:DATA?" + '\n') 
	tData = int(preamble[2])
	wavedata = ""
	count = 0
	temp = MyInstrument.recv(tData)
	while(len(temp) > 0 and count < 20):
		wavedata = wavedata + temp
		temp = MyInstrument.recv(tData)
		count += 1
	print "No. of Bytes transferred per turn: " + str(len(temp))
	print "\t\tWriting to file"
	#print wavedata
	fpower = open("channel1.dat", "wb")
	fpower.write(str(wavedata))
	fpower.close()

def get_waveform_trigger(MyInstrument) :
	MyInstrument.send(":WAVEFORM:FORMAT BYTE" + '\n')
	cmd_string = ":WAVEFORM:SOURCE CHAN2"
	MyInstrument.send(cmd_string + '\n')
	MyInstrument.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
	MyInstrument.send(":WAVEFORM:POINTS 8000000" + '\n')
	print "Reading Preamble of Trigger Source"
	MyInstrument.send(":WAVEFORM:PREAMBLE?" + '\n')
	preamble = MyInstrument.recv(5)
	print "Total Number of Data to Receive: "+ str(int(preamble[2]))
	print "Reading Data of Trigger Source"
	MyInstrument.send(":WAVEFORM:DATA?" + '\n') 
	wavedata = MyInstrument.recv(8000000)
	print "\t\tWriting to file"
	totaltrigger = preamble +wavedata
	ftrigger = open("trigger.dat", "w")
	ftrigger.writelines(totaltrigger)
	ftrigger.close()
	
def get_snapshot(MyInstrument):
	print "Capturing Snapshot of the Scope"
	MyInstrument.send(":DISPlay?\n")
	disp_source = MyInstrument.recv(200)
	#print "\t\t Display Source - " + disp_source
	MyInstrument.send(":DISPlay:DATA? PNG, SCReen, COLor\n")
	rawpic = MyInstrument.recv(30000)
	fsnapshot = open("channel1.png", "wb")
	fsnapshot.write(rawpic)
	fsnapshot.close()

def oscilloscope_connect(osc_ipaddress, osc_portnos):
	osc_socket = socket( AF_INET, SOCK_STREAM )
	#osc_socket.setblocking(False)
	osc_socket.connect(("192.168.0.10", 5025))#have to put in error checks dummy
	osc_socket.send("*IDN?"+"\n")
	osc_id = osc_socket.recv(200)
	print "\tConnected to Oscilloscope ID :"+ osc_id
	print "\n"
	return (osc_socket)
