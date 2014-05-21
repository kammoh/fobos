#!/usr/bin/python
import cfg,globals
import os
import sys
import numpy
import support


def acquireDataValues_old(rawDataFile):
	support.printToLog("Reading " + rawDataFile+"\n")
	try:
		fid = open(rawDataFile, "r")
	except IOError, (ErrorNumber, ErrorMessage):
		if(ErrorNumber == 2):
			support.printToScreen("\n\nWhoa! File -> " + rawDataFile + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.MEASUREMENTDIR)
			os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
			support.exitProgram()
		else:
			support.printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			support.printToScreen(ErrorMessage)
			os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
			support.exitProgram()
	preamble = numpy.fromfile(fid, dtype = numpy.float64, count=10, sep = "")
	rawImg = numpy.fromfile(fid, dtype = numpy.ubyte, count = int(preamble[2]), sep = "")
	fid.close()
	imgX1 = numpy.arange(1,int(preamble[2]))
	numpy.transpose(imgX1)
	imgX1 = (imgX1 - preamble[6]) * preamble[4] + preamble[5]
	imgY1 = (rawImg - preamble[9]) * preamble[7] + preamble[8]
	measuredData = imgY1
	return (measuredData)

def acquireDataValues(preambleFile, rawDataFile):
	try:
		fid = open(preambleFile , "r")
	except IOError, (ErrorNumber, ErrorMessage):
		if(ErrorNumber == 2):
			support.printToScreen("\n\nWhoa! File -> " + preambleFile + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.MEASUREMENTDIR)
			os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
			support.exitProgram()
		else:
			support.printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			support.printToScreen(ErrorMessage)
			os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
			support.exitProgram()
	
	preamble = numpy.fromfile(fid, dtype = numpy.float64, count= 10, sep = ",")
	fid.close()
	try:
		fid = open(rawDataFile, "r")
	except IOError, (ErrorNumber, ErrorMessage):
		if(ErrorNumber == 2):
			support.printToScreen("\n\nWhoa! File -> " + rawDataFile + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.MEASUREMENTDIR)
			support.exitProgram()
		else:
			support.printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			support.printToScreen(ErrorMessage)
			support.exitProgram()
	
	rawImg = numpy.array(numpy.fromfile(fid, dtype = numpy.ubyte, count = int(preamble[2]), sep = ""))
	fid.close()
	imgX1 = numpy.arange(1,int(preamble[2]))
	numpy.transpose(imgX1)
	imgX1 = (imgX1 - preamble[6]) * preamble[4] + preamble[5]
	imgY1 = (img - preamble[9]) * preamble[7] + preamble[8]
	measuredData = numpy.array(imgY1, dtype = numpy.float64)
	return (measuredData)
	
def acquireHypotheticalValues(POWER_MODEL_FILE):
	fileToLoad = os.path.join(cfg.POWERMODELDIR, POWER_MODEL_FILE)
	support.printToScreenAndLog("Acquiring Power Model File")
	support.printToLog("\tReading " + fileToLoad +"\n") 
	keyGuess = numpy.loadtxt(fileToLoad)
	if (os.path.isfile(cfg.TRACE_EXPUNGE_DATA_FILE) == True):
		kgExData = numpy.loadtxt(cfg.TRACE_EXPUNGE_DATA_FILE)
		keyGuess = numpy.delete(keyGuess, kgExData, globals.TRACE_WISE)
	keyGuess = keyGuess[:,:-1]
	return(keyGuess)
	
def adjustSampleSize(sampleLength, dataArray):
		temp = dataArray.shape
		newDataArray = dataArray
		arrLen = temp[0]
		if (arrLen == sampleLength):
			return dataArray
		elif (arrLen > sampleLength):
			diff = arrLen-sampleLength
			for count in range(0,diff):
				newDataArray = numpy.delete(newDataArray, -1, 0)
			return newDataArray	
		elif (arrLen < sampleLength):
			diff = sampleLength-arrLen
			for count in range (0,diff):
				newDataArray = numpy.append(newDataArray,0)
			return newDataArray	
			

def computeAlignedData(measuredPowerData, measuredTriggerData):
	if(cfg.analysisConfigAttributes['CAPTURE_MODE'] == "" or cfg.analysisConfigAttributes['TRIGGER_THRESHOLD'] == ""):
		support.printToScreenAndLog("\tSignal Alignment parameters not found.\n\tPlease load the parameter values before calling Signal Alignment routine")
		support.exitProgram()
		
	if(cfg.analysisConfigAttributes['CAPTURE_MODE'] == 'MULTI'):
		sampleNo = 0
		firstTriggerHigh = False
		firstTriggerSampleHigh = True
		triggerCount = 0
		tempArray = numpy.zeros(0)
		alignedData = numpy.zeros(0)
		sampleCount = 0
		sampleLength = 0
		for sampleNo in range(0, len(measuredTriggerData)):
			if(measuredTriggerData[sampleNo] > cfg.analysisConfigAttributes['TRIGGER_THRESHOLD']):
				firstTriggerHigh = True
				if(firstTriggerSampleHigh == True):
					if (triggerCount == 0):
						tempArray = numpy.zeros(0)
					elif(triggerCount == 1):
						t = tempArray.shape
						sampleLength = t[0]
						alignedData = tempArray
						tempArray = numpy.zeros(0)	
					elif(triggerCount > 1):
						tempArray = adjustSampleSize(sampleLength, tempArray)
						alignedData = numpy.vstack((alignedData,tempArray))
						tempArray = numpy.zeros(0)
					firstTriggerSampleHigh = False
					triggerCount += 1
				tempArray = numpy.append(tempArray, measuredPowerData[sampleNo])
	
			elif(measuredTriggerData[sampleNo] < cfg.analysisConfigAttributes['TRIGGER_THRESHOLD']  and firstTriggerHigh == True):
				firstTriggerSampleHigh = True
				tempArray = numpy.append(tempArray, measuredPowerData[sampleNo])
			#print "\t\tProcessed - ",sampleNo,"/",len(measuredTriggerData),"\r",
		alignedData = numpy.vstack((alignedData,adjustSampleSize(sampleLength,tempArray)))	
		return (alignedData)		

def readRawTraces():
	cfg.RAW_POWER_DATA = acquireDataValues_old(cfg.RAW_UNALIGNED_POWER_FILE)
	cfg.RAW_TRIGGER_DATA = acquireDataValues_old(cfg.RAW_UNALIGNED_TRIGGER_FILE)
		
	
def getAlignedMeasuredPowerData():
	support.printToScreenAndLog("Starting signal alignment routine")
	if (os.path.isfile(cfg.ALIGNED_DATA_FILE) == True):
		support.printToScreenAndLog("\tFound aligned power signal data set. Loading the data set")
		support.printToLog("\tDataSet - " +cfg.ALIGNED_DATA_FILE)
		alignedData = numpy.loadtxt(cfg.ALIGNED_DATA_FILE)
		return (alignedData)
	else:
		support.printToScreenAndLog("\tNo aligned power signal data set found. Commencing power signal alignment process")
		alignedData = computeAlignedData(cfg.RAW_POWER_DATA, cfg.RAW_TRIGGER_DATA)
		numpy.savetxt(cfg.ALIGNED_DATA_FILE, alignedData)
		return(alignedData)