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
import array
import time
import sys
import os
import traceback
import cfg , globals, support
import logging
from dataGenerator import *


			
# def initLogging():
	# logger = logging.getLogger('FOBOS')
	# if(cfg.config_attributes['LOGGING'] = 'DEBUG' or cfg.analysisConfigAttributes['LOGGING'] = 'DEBUG'):
		# logger = logging.setLevel(logging.DEBUG)
	
def printArray(array, num):
  i = 0
  while(i<num):
    sys.stdout.write("%02X\n" % array[i])
    i=i+1
def printArrayNorm(array, num):	
  #key = getKeyForAnalysis()
  key = cfg.EXPECTED_KEY
  i = 1
  output = ""
  bytesMissed = 0
  while(i<=num):
	if (array[i] == int(key[i-1], 16)):
		output += ("%02x " % array[i])
		i=i+1
	else:
		output += ("%02x" % array[i]) + str("("+key[i-1]+") ") 
		bytesMissed = bytesMissed+1
		i=i+1
  output += "\n"
  output += "Total of " + str(bytesMissed) + " bytes incorrect (correct values indicated in () above)" + "\n"
  return str(output)
  
def printKeyFound(array):
	printToScreenAndAnalysisLog("Key Found: " + printArrayNorm(array, cfg.config_attributes['KEY_SIZE']))
	
def printControlBoardHeaderToScreenAndLog():
    output = "\tStarting PC-FPGA Communication via USB\n";
    output += "\tControl Board -> " +  cfg.config_attributes['CONTROL_BOARD'] + "\n";
    output += "\tVersion -> " + globals.VERSION + "\n"
    print output
    printToLog(output)
    
def print_OpenADCheader(DeviceName):
	print_header(DeviceName)
	sys.stdout.write("\tStarting FOBOS- OpenADC Communication Script\n")
	
def printHeaderToScreenAndLog():
	output = "#" * 79;
	output += "#\n";
	output += "\tStarting FOBOS - Flexible Opensource workBench fOr Sidechannel Analysis\n";
	output += "#" * 79;
	output += "#\n";
	output += "\tData Acquisition Module Initialized\n"
	output += "\tConfiguring Workspace ..\n"
	print output
	printToLog(output)

def printToLog(data):
	with open(cfg.FOBOS_LOG_FILE, 'a') as file:
		file.write(data+"\n")

def printToAnalysisLog(data):
	with open(cfg.FOBOS_ANALYSIS_LOG_FILE, 'a') as file:
		file.write(data+"\n")		

def printToScreen(data):
	print data

def printToScreenAndLog(data):
	print data
	printToLog(data)
	
def printToScreenAndAnalysisLog(data):
	print data
	printToAnalysisLog(data)	

def printToScreenBold(data):
	if(sys.platform == 'linux2'):
		print support.color.BOLD + data + support.color.END
	else:
		print data
		
def printAnalysisHeaderToScreen():
	output = "#" * 79
	output += "#\n"
	output += "\tStarting -- FOBOS - Flexible Opensource workBench fOr Sidechannel Analysis\n"
	output += "#" * 79
	output += "#\n"
	output += "\tData Analysis Module Initialized\n"
	output += "\tConfiguring Workspace ..\n"
	print output

def printAnalysisHeaderToLog():
	output = "#" * 79
	output += "#\n"
	output += "\tStarting -- FOBOS - Flexible Opensource BOard for Sidechannel Analysis\n"
	output += "#" * 79
	output += "#\n"
	output += "\tData Analysis Module Initialized\n"
	output += "\tConfiguring Workspace ..\n"
	printToAnalysisLog(output)
	
def printToOutputFile(data, type):
	output = ""
	if(type == globals.DATA):
		TOTAL_DATA = cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		for count in range (0, TOTAL_DATA):
			
			output += str(data[count]) + " "
			if ((count+1) % cfg.config_attributes['BLOCK_SIZE']  == 0):
				output += "\n"
		with open(cfg.PLAIN_TEXT_FILE, 'a') as file:
			file.write(output)
	
	if(type == globals.CIPHERTEXT):
		#TOTAL_DATA = cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		f = open(cfg.CIPHER_TEXT_FILE, 'wb')
        	for line in cfg.dataFromControlBoard:
                	f.write("%s\n" % line)
        	f.close()
	
	if(type == globals.KEY):
                print "d=" + str(data)
		TOTAL_DATA = cfg.config_attributes['KEY_SIZE']
                print TOTAL_DATA
		for count in range (0, TOTAL_DATA):
                        print "c=" + str(count)
			output += str(data[count]) + " "
		output += "\n"	
		with open(cfg.KEY_FILE, 'a') as file:
			file.write(output)	
