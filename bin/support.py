#!/usr/bin/python
import array
import time
import sys
import os
import traceback
import re
import cfg
import dataGenerator
import globals
import printFunctions

def goToSleep(value):
	time.sleep(value)
    
def clear_screen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )
  
def arrayToString(array):
  r = ''
  for num in array:
    r += '%02X' % num
  return r
 
def convertToByteArray(hexString):
	hexString = ''.join( hexString.split(" ") )
	hexBytes = []
	for dataByte in range(0, len(hexString), 2):
		hexBytes.append( hexString[dataByte:dataByte+2])		
	return hexBytes
	
def getIntValue(val1, val2):
  Value = int(val1 << 8 | val2)
  return Value
  
def createDirectory(directory):
	if not os.path.exists(directory):
		os.makedirs(directory)

def currentDateTime():
	datetimeString = time.strftime("%d%m%Y-%H-%M-%S")
	return datetimeString
	
def readFile(file_name) :
	#print "Reading File : %s" % file_name
	file_pt = open(file_name, "r")
	indata = file_pt.readlines()
	#print "Number of Lines read : %d" % len(indata)
	return (indata)

def removeComments(data_list) :
	#print "Removing Comments from the Data list"
	newdata_list = []
	for object in data_list:
		item = re.sub(r'#.*$', "", object)
		item = item.rstrip()
		item = item.rstrip('\n')
		if item :
			newdata_list.append(item)
	return(newdata_list)

def getPlainText():
	dataToEncrypt = []
	if(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.RANDOM):
		dataToEncrypt = dataGenerator.generateRandomData()
	elif(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.USER):
		printFunctions.printToScreenAndLog("Number of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']))
		printFunctions.printToScreenAndLog("Block Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = readFile(cfg.config_attributes['DATA_FILE'])
		for count in range(0, len(rawData)):
			temp = convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					dataToEncrypt.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS'] * cfg.config_attributes['BLOCK_SIZE']
		printFunctions.printToScreenAndLog("Reading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['DATA_FILE'] +" file")
		printFunctions.printToOutputFile(dataToEncrypt, globals.DATA)
	return dataToEncrypt	
		
def getKey():		
	keyToEncrypt = []
	if(cfg.config_attributes['KEY_GENERATION'] == globals.USER):
		printFunctions.printToScreenAndLog("Key Size :" + str(cfg.config_attributes['KEY_SIZE']))
		printFunctions.printToScreenAndLog("Reading Key from "+ cfg.config_attributes['KEY_FILE'] +" file")
		rawData = readFile(cfg.config_attributes['KEY_FILE'])
		for count in range(0, len(rawData)):
			temp = convertToByteArray(rawData[count])
			for x in temp: keyToEncrypt.append(x)
		printFunctions.printToOutputFile(keyToEncrypt, globals.KEY)	
	elif(cfg.config_attributes['KEY_GENERATION'] == globals.RANDOM):
		keyToEncrypt = dataGenerator.generateRandomKey()
	return keyToEncrypt	