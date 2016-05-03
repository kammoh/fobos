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
#from oscilloscope_sockets import MyInstrumentSend
import sys
#import visa
import numpy
import time

osc_attributes = {
 'RESOURCE' : "",        'AUTOSCALE' : "",        'CHANNEL1_IMPEDANCE' : "",        'CHANNEL1_RANGE' : "",
 'CHANNEL2_RANGE' : "",   'CHANNEL3_RANGE' : "",   'CHANNEL4_RANGE' : "",   'CHANNEL1_DISPLAY' : "",
 'CHANNEL2_DISPLAY' : "", 'CHANNEL3_DISPLAY' : "", 'CHANNEL4_DISPLAY' : "", 'TIME_RANGE' : "",
 'TIMEBASE_REF' : "",     'TRIGGER_SOURCE' : "",   'TRIGGER_MODE' : "",     'TRIGGER_SWEEP' : "",
 'TRIGGER_LEVEL' : "",    'TRIGGER_SLOPE' : "",    'SAMPLE_INPUT' : "",     'ACQUIRE_TYPE' : "",
 'ACQUIRE_MODE' : "",     'ACQUIRE_COMPLETE' : "", 'WAVE_DATA_SIZE' : "",   'NUM_PWR_TRACE' : "",
 'SCREEN_CAP' : "",       'SCREEN_FORMAT' : "",    'SCREEN_NAME' : "",      'OUTPUT_DIR' : "",
 'OSCILLOSCOPE_IP' : "",  'OSCILLOSCOPE_PORT' : "", 'TIME_SCALE' : "", 'CHANNEL1_SCALE' : "",
 'CHANNEL2_SCALE' : "",   'CHANNEL3_SCALE' : "",    'CHANNEL4_SCALE' : "", 'CHANNEL2_IMPEDANCE' : "",
 'CHANNEL3_IMPEDANCE' : "", 'CHANNEL4_IMPEDANCE' : "",
 }
 
# Oscilloscope can get confused if too many commands arrive too fast
def MyInstrumentSend(instr,str):
    instr.send(str+'\n')
    print "\t"+str
    time.sleep(.5)
 
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
            elif re.match('^CHANNEL1_IMPEDANCE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL1_IMPEDANCE'] = value[1].strip(" ")
            elif re.match('^CHANNEL2_IMPEDANCE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL2_IMPEDANCE'] = value[1].strip(" ")
            elif re.match('^CHANNEL3_IMPEDANCE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL3_IMPEDANCE'] = value[1].strip(" ")
            elif re.match('^CHANNEL4_IMPEDANCE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL4_IMPEDANCE'] = value[1].strip(" ")
            elif re.match('^CHANNEL1_RANGE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL1_RANGE'] = value[1].strip(" ")
            elif re.match('^CHANNEL2_RANGE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL2_RANGE'] = value[1].strip(" ")
            elif re.match('^CHANNEL3_RANGE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL3_RANGE'] = value[1].strip(" ")
            elif re.match('^CHANNEL4_RANGE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL4_RANGE'] = value[1].strip(" ")
            elif re.match('^CHANNEL1_SCALE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL1_SCALE'] = value[1].strip(" ")
            elif re.match('^CHANNEL2_SCALE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL2_SCALE'] = value[1].strip(" ")
            elif re.match('^CHANNEL3_SCALE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL3_SCALE'] = value[1].strip(" ")
            elif re.match('^CHANNEL4_SCALE', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL4_SCALE'] = value[1].strip(" ")
            elif re.match('^CHANNEL1_DISPLAY', object) :
                value = re.split("=", object)
                osc_attributes['CHANNEL1_DISPLAY'] = value[1].strip(" ")
            elif re.match('^CHANNEL2_DISPLAY', object) :
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
            elif re.match('^TIME_SCALE', object) :
                value = re.split("=", object)
                osc_attributes['TIME_SCALE'] = value[1].strip(" ")
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
            elif re.match('^ACQUIRE_MDEPTH', object) :
                value = re.split("=", object)
                osc_attributes['ACQUIRE_MDEPTH'] = value[1].strip(" ")
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
	MyInstrumentSend(MyInstrument,":WAVEFORM:FORMAT BYTE")
	MyInstrumentSend(MyInstrument,":WAVEFORM:SOURCE CHAN1")
	MyInstrumentSend(MyInstrument,":WAVEFORM:MODE RAW")
	print "\tReading Preamble of Power Source"
	MyInstrumentSend(MyInstrument,":WAVEFORM:PREAMBLE?")
	preamble = MyInstrument.recv(200)
	fpowerpreamble = open("preambleChannel1.dat", "wb")
	fpowerpreamble.write(preamble)
	fpowerpreamble.close()
	fid = open("preambleChannel1.dat", "rb")
	preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
	fid.close()
	print "\tTotal Number of Points to Receive: " + str(int(preamble[2]))
	print "\tReading Data of Power Source"
	MyInstrumentSend(MyInstrument,":WAVEFORM:START 1")
	MyInstrumentSend(MyInstrument,":WAVEFORM:STOP 250000") 
	MyInstrumentSend(MyInstrument,":WAVEFORM:DATA?") 
	tData = int(preamble[2])
	wavedata = ""
	count = 0
	temp = MyInstrument.recv(tData)
	lowerBound = tData - len(temp)
	print str(len(temp)) + "\n"
	rData = lowerBound
	temp = temp[10:]
	while(count < lowerBound):
		print count,rData
		wavedata = wavedata + temp
		temp = MyInstrument.recv(rData)
		count += len(temp)
		rData = tData-count
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
	MyInstrument.send(":WAVEFORM:POINTS:MODE BYTE" + '\n')
	MyInstrument.send(":WAVEFORM:POINTS 8000000" + '\n')
	print "\tReading Preamble of Power Source"
	MyInstrument.send(":WAVEFORM:PREAMBLE?" + '\n')
	preamble = MyInstrument.recv(200)
	fpowerpreamble = open("preambleChannel2.dat", "wb")
	fpowerpreamble.write(preamble)
	fpowerpreamble.close()
	fid = open("preambleChannel2.dat", "rb")
	preamble = numpy.fromfile(fid, dtype= numpy.float64, count = 10, sep = ",")
	fid.close()
	print "\tTotal Number of Points to Receive: " + str(int(preamble[2]))
	print "\tReading Data of Power Source"
	MyInstrument.send(":WAVEFORM:DATA?" + '\n') 
	tData = int(preamble[2])
	wavedata = ""
	count = 0
	temp = MyInstrument.recv(tData)
	lowerBound = tData - len(temp)
	rData = lowerBound
	temp = temp[10:]
	while(count < lowerBound):
		#print count,rData
		wavedata = wavedata + temp
		temp = MyInstrument.recv(rData)
		count += len(temp)
		rData = tData-count
	print "No. of Bytes transferred per turn: " + str(len(temp))
	print "\t\tWriting to file"
	#print wavedata
	fpower = open("channel2.dat", "wb")
	fpower.write(str(wavedata))
	fpower.close()
	
def get_snapshot(MyInstrument):
	print "Capturing Snapshot of the Scope"
	#print "\t\t Display Source - " + disp_source
	MyInstrument.send(":DISPlay:DATA? PNG, SCReen, COLor\n")
	rawpic = ""
	count = 0
	temp = MyInstrument.recv(30000)
	tData = (int(temp[2:10]))
	lowerBound = tData - len(temp)
	temp = temp[10:]
	rData = lowerBound
	while(count < lowerBound):
		print count,rData
		rawpic = rawpic + temp
		temp = MyInstrument.recv(rData)
		count += len(temp)
		rData = tData-count
	rawpic = rawpic + MyInstrument.recv(10)	
	print "No. of Bytes transferred per turn: " + str(len(temp))	
	fsnapshot = open("channel1.png", "wb")
	fsnapshot.write(rawpic)
	fsnapshot.close()

def oscilloscope_connect(osc_ipaddress, osc_portnos):
	osc_socket = socket( AF_INET, SOCK_STREAM )
	osc_socket.setsockopt(IPPROTO_TCP, TCP_NODELAY, 1)
	#osc_socket.setblocking(False)
	osc_socket.connect(("192.168.10.54", 5555))#have to put in error checks dummy
	osc_socket.send("*IDN?"+"\n")
	osc_id = osc_socket.recv(200)
	print "\tConnected to Oscilloscope ID :"+ osc_id
	print "\n"
	return (osc_socket)
