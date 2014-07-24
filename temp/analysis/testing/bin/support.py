#!/usr/bin/python
import os
import time
import re
import sys
import array
import sys
import re
import cfg
import globals

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
  
  
def clear_screen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )
 
def exitProgram():
	print "Exiting FOBOS Analysis!"
	sys.exit(1)
	
def wait():
    raw_input("\tPlease type Enter to Continue")
    
def readFile(file_name) :
	#temp = "Reading File : %s" % file_name
	#support.printToLog(temp)
	try:
		file_pt = open(file_name, "r")
	except IOError, (ErrorNumber, ErrorMessage):
		if(ErrorNumber == 2):
			printToScreen("\n\nWhoa! File -> " + file_name + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.CONFIGDIR)
			exitProgram()
		else:
			printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			printToScreen(ErrorMessage)
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

def currentDateTime():
	datetimeString = time.strftime("%d%m%Y-%H-%M-%S")
	return datetimeString
	
def printHeaderToScreen():
	output = "#" * 79
	output += "#\n"
	output += "\tStarting -- FOBOS - Flexible Opensource BOard for Sidechannel Analysis\n"
	output += "#" * 79
	output += "#\n"
	output += "\tData Analysis Module Initialized\n"
	output += "\tConfiguring Workspace ..\n"
	print output

def printHeaderToLog():
	output = "#" * 79
	output += "#\n"
	output += "\tStarting -- FOBOS - Flexible Opensource BOard for Sidechannel Analysis\n"
	output += "#" * 79
	output += "#\n"
	output += "\tData Analysis Module Initialized\n"
	output += "\tConfiguring Workspace ..\n"
	printToLog(output)

def printToLog(data):
	with open(cfg.FOBOS_ANALYSIS_LOG_FILE, 'a') as file:
		file.write(data+"\n")

def printToScreen(data):
	print data

def printToScreenBold(data):
	if(sys.platform == 'linux2'):
		print color.BOLD + data + color.END
	else:
		print data
def printToScreenAndLog(data):
	print data
	printToLog(data)
	
def createDirectory(directory):
	if not os.path.exists(directory):
		os.makedirs(directory)	

def getProjectPath():
	cfg.MEASUREMENT_PROJECT_PATH_FILE = os.path.join(cfg.ANALYSISCONFIGDIR, globals.PROJECTPATH_FILENAME)
	if os.path.isfile(cfg.MEASUREMENT_PROJECT_PATH_FILE) == False :
		printFunctions.printToScreen("\tListing Project directories under Workspace folder @\n\t" +
		os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME']))		
		directoryList = os.listdir(os.path.join(cfg.ROOTDIR, cfg.analysisConfigAttributes['WORK_DIR'], cfg.analysisConfigAttributes['PROJECT_NAME'])
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