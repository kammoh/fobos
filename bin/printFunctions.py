#!/usr/bin/python
import array
import time
import sys
import os
import traceback
import cfg
from globals import *

def printArray(array, num):
  i = 0
  while(i<num):
    sys.stdout.write("%02X\n" % array[i])
    i=i+1

def print_header(DeviceName):
    sys.stdout.write("-----------------------------------------------\n")
    sys.stdout.write("Starting PC-FPGA Communication via USB\n")
    sys.stdout.write("\tControl Board -> %s\n" % DeviceName)
    sys.stdout.write("\tVersion -> %s\n" % VERSION)
    sys.stdout.write("-----------------------------------------------\n") 
    
def print_OpenADCheader(DeviceName):
	print_header(DeviceName)
	sys.stdout.write("\tStarting FOBOS- OpenADC Communication Script\n")
	
def printHeaderToScreenAndLog():
	output = "#" * 79;
	output += "#\n";
	output += "\tStarting FOBOS - Flexible Opensource BOard for Sidechannel Analysis\n";
	output += "#" * 79;
	output += "#\n";
	print output
	printToLog(output)

def printToLog(data):
	with open(cfg.FOBOS_LOG_FILE, 'a') as file:
		file.write(data)

def printToScreen(data):
	print data

def printToScreenAndLog(data):
	print data
	printToLog(data)
	
def printToOutputFile(data, type):
	output = ""
	if(type == DATA):
		TOTAL_DATA = cfg.config_attributes['NUMBER_OF_ENCRYPTIONS'] * cfg.config_attributes['BLOCK_SIZE']
		for count in range (0, TOTAL_DATA):
			
			output += str(data[count]) + " "
			if ((count+1) % cfg.config_attributes['BLOCK_SIZE']  == 0):
				output += "\n"
		with open(cfg.PLAIN_TEXT_FILE, 'a') as file:
			file.write(output)
	
	if(type == CIPHERTEXT):
		TOTAL_DATA = cfg.config_attributes['NUMBER_OF_ENCRYPTIONS'] * cfg.config_attributes['BLOCK_SIZE']
		for count in range (0, TOTAL_DATA):
			output += str(data[count]) + " "
			if ((count+1) % cfg.config_attributes['BLOCK_SIZE']  == 0):
				output += "\n"	
		with open(cfg.CIPHER_TEXT_FILE, 'a') as file:
			file.write(output)
			
	if(type == KEY):
		TOTAL_DATA = cfg.config_attributes['KEY_SIZE']-1
		for count in range (0, TOTAL_DATA):
			output += str(data[count]) + " "
		output += "\n"	
		with open(cfg.KEY_FILE, 'a') as file:
			file.write(output)	
