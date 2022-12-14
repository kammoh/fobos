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
			printFunctions.printToScreen("File:  " + file_name + " not found. Expected to be found in the folder\n->"+ cfg.CONFIGDIR)
			exitProgram()
		else:
			printFunctions.printToScreen("Error -> " + str(ErrorNumber) +".")
			printFunctions.printToScreen(ErrorMessage)
	indata = file_pt.readlines()
	#temp =  "Number of Lines read : %d" % len(indata)
	#support.printToLog(temp)
	return (indata)
def removeFile(fileName):
	os.remove(fileName)
	
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
	printFunctions.printToScreen("\tListing Project directories under Workspace folder @\n\t" +
	os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME']))		
	directoryList = os.listdir(os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME']))
	directoryCount = 1
	for item in directoryList:
		printFunctions.printToScreen("\t"+ str(directoryCount)+": "+item)
		directoryCount += 1	
	while True:
		try:
			t = int(raw_input("\tPlease select the Project folder from the above list by entering correspond directory number:"))
		except ValueError:
			printFunctions.printToScreen("\t\tSorry! Wrong Choice please try again. Enter the values between 1 to " + str(directoryCount-1))
			continue
		if (t > (directoryCount-1)):
			printFunctions.printToScreen("\t\tSorry! Wrong Choice please try again. Enter the values between 1 to " + str(directoryCount-1))
			continue
		if (t == 0):
			printFunctions.printToScreen("\t\tSorry! Wrong Choice please try again. Enter the values between 1 to " + str(directoryCount-1))
			continue				
		else:
			break
		
	projectPath = os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME'], directoryList[t-1])
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
