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
import array
import time
import sys
import os
import traceback
import re
import cfg
#import dataGenerator
import globals
import printFunctions
import matplotlib
import matplotlib.pyplot as plt

class color:
   PURPLE = '\033[95m'
   CYAN = '\033[96m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[94m'
   GREEN = '\033[92m'
   YELLOW = '\033[93m'
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m' 
   
   
def goToSleep(value):
	time.sleep(value)
  
def exitProgram():
	print "Exiting FOBOS !!"
	sys.exit(1)

def wait():
    raw_input("\tPlease type Enter to Continue")
	
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
	#temp = "Reading File : %s" % file_name
	#support.printToLog(temp)
	try:
		file_pt = open(file_name, "r")
	except IOError, (ErrorNumber, ErrorMessage):
		if(ErrorNumber == 2):
			printFunctions.printToScreen("\n\nWhoa! File -> " + file_name + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.CONFIGDIR)
			support.exitProgram()
		else:
			printFunctions.printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			printFunctions.printToScreen(ErrorMessage)
	indata = file_pt.readlines()
	#temp =  "Number of Lines read : %d" % len(indata)
	#support.printToLog(temp)
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

def getProjectPath():
	cfg.MEASUREMENT_PROJECT_PATH_FILE = os.path.join(cfg.ANALYSISCONFIGDIR, globals.PROJECTPATH_FILENAME)
	if os.path.isfile(cfg.MEASUREMENT_PROJECT_PATH_FILE) == False :
		printFunctions.printToScreen("\tListing Project directories under Workspace folder @\n\t" +
		os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME']))		
		directoryList = os.listdir(os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME']))
		directoryCount = 1
		for item in directoryList:
			printFunctions.printToScreen("\t"+ str(directoryCount)+": "+item)
			directoryCount += 1
		t = raw_input("\tPlease select the Project folder from the above list:")
		projectPath = os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME'], directoryList[int(t)-1])
		fileName = os.path.join(cfg.ANALYSISCONFIGDIR, "projectPath.txt")
		fid = open(cfg.MEASUREMENT_PROJECT_PATH_FILE, "w")
		fid.write(projectPath)
		fid.close()
	else:
		temp = readFile(cfg.MEASUREMENT_PROJECT_PATH_FILE)
		projectPath = temp[0]
		printFunctions.printToScreenBold("\tNote: Current Analysis is scheduled to run on traces located @\n\t"
		+ projectPath +"\n\tIf you want to change the trace set/project directory,  Please delete the file @\n\t"+
		cfg.MEASUREMENT_PROJECT_PATH_FILE +"\n\tand re-run the FOBOS Analysis again\n")
	return projectPath

def shiftPathToGraphFolder(path):
	(branch1, branch2) = os.path.split(path)
	newPath = os.path.join(branch1, globals.GRAPHS_FOLDERNAME, branch2)
	return newPath

def setPlotAttributes():
	font = {'family' : cfg.analysisConfigAttributes['PLOT_LABELS_FONT_FAMILY'],
        'weight' :cfg.analysisConfigAttributes['PLOT_LABELS_FONT_WEIGHT'],
        'size'   : cfg.analysisConfigAttributes['PLOT_LABELS_FONT_SIZE']}
	matplotlib.rc('font', **font)
	figs = plt.figure()	
	figs.set_size_inches(cfg.analysisConfigAttributes['PLOT_SIZE_LENGTH'],cfg.analysisConfigAttributes['PLOT_SIZE_BREADTH']) 
	
	
	
	
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