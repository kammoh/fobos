#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2016 Cryptographic Engineering Research Group (CERG)               #
#	George Mason University														 #	
#   http://cryptography.gmu.edu/fobos                                            #                            
#									                                             #                             	 
#	Licensed under the Apache License, Version 2.0 (the "License");         	 #
#	you may not use this file except in compliance with the License.        	 #
#	You may obtain a copy of the License at                                 	 #
#	                                                                        	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                          	 #
#	                                                                        	 #
#	Unless required by applicable law or agreed to in writing, software     	 #
#	distributed under the License is distributed on an "AS IS" BASIS,       	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.	 #
#	See the License for the specific language governing permissions and     	 #
#	limitations under the License.                                          	 #
#                                                                           	 #
##################################################################################

from globals import cfg,globals, printFunctions
import os
import sys
import numpy
from globals import support
import pylab
import matplotlib.pyplot as plt

def updatePowerModelUsingBCPA(myArray1, myArray2, rowA):
	myArray1 += myArray2[rowA,:].copy() # create a temporary variable
	return myArray1

def acquireDataValues_old(rawDataFile):
	printFunctions.printToAnalysisLog("Reading " + rawDataFile+"\n")
	try:
		fid = open(rawDataFile, "r")
	except IOError, (ErrorNumber, ErrorMessage):
		if(ErrorNumber == 2):
			printFunctions.printToScreen("\n\nWhoa! File -> " + rawDataFile + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.MEASUREMENTDIR)
			os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
			support.exitProgram()
		else:
			printFunctions.printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			printFunctions.printToScreen(ErrorMessage)
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
			printFunctions.printToScreen("\n\nWhoa! File -> " + preambleFile + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.MEASUREMENTDIR)
			os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
			support.exitProgram()
		else:
			printFunctions.printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			printFunctions.printToScreen(ErrorMessage)
			os.remove(cfg.MEASUREMENT_PROJECT_PATH_FILE)
			support.exitProgram()
	
	preamble = numpy.fromfile(fid, dtype = numpy.float64, count= 10, sep = ",")
	fid.close()
	try:
		fid = open(rawDataFile, "r")
	except IOError, (ErrorNumber, ErrorMessage):
		if(ErrorNumber == 2):
			printFunctions.printToScreen("\n\nWhoa! File -> " + rawDataFile + "\n joined FOBOS Analysis invisible. As FOBOS Analysis does not have X-Ray Vision, Please make it visible (present) in the folder\n->"+ cfg.MEASUREMENTDIR)
			support.exitProgram()
		else:
			printFunctions.printToScreen("Hmmm!! You have managed to trigger -> " + str(ErrorNumber) +" Error Number")
			printFunctions.printToScreen(ErrorMessage)
			support.exitProgram()
	
	rawImg = numpy.array(numpy.fromfile(fid, dtype = numpy.ubyte, count = int(preamble[2]), sep = ""))
	fid.close()
	imgX1 = numpy.arange(1,int(preamble[2]))
	numpy.transpose(imgX1)
	imgX1 = (imgX1 - preamble[6]) * preamble[4] + preamble[5]
	imgY1 = (rawImg - preamble[9]) * preamble[7] + preamble[8]
	measuredData = numpy.array(imgY1, dtype = numpy.float64)
	return (measuredData)
	
def acquireHypotheticalValues(POWER_MODEL_FILE):
	fileToLoad = os.path.join(cfg.POWERMODELDIR, POWER_MODEL_FILE)
	printFunctions.printToScreenAndAnalysisLog("Acquiring Power Model File")
	printFunctions.printToAnalysisLog("\tReading " + fileToLoad +"\n") 
	keyGuess = numpy.loadtxt(fileToLoad)
	#if (os.path.isfile(cfg.TRACE_EXPUNGE_DATA_FILE) == True):
		#kgExData = numpy.load(cfg.TRACE_EXPUNGE_DATA_FILE)
		#keyGuess = numpy.delete(keyGuess, kgExData, globals.TRACE_WISE)	
	##print len(keyGuess[0])
	return(keyGuess)
	
def acquirePowerModel(POWER_MODEL_FILE, CPATYPE):
	fileToLoad = os.path.join(cfg.POWERMODELDIR, POWER_MODEL_FILE)
	printFunctions.printToScreenAndAnalysisLog("Acquiring Power Model File for Key Byte - " + str(cfg.KEY_INDEX))
	printFunctions.printToAnalysisLog("\tReading " + fileToLoad +"\n") 
	keyGuess = numpy.loadtxt(fileToLoad)
	if (os.path.isfile(cfg.TRACE_EXPUNGE_DATA_FILE) == True):
		kgExData = numpy.load(cfg.TRACE_EXPUNGE_DATA_FILE)
		keyGuess = numpy.delete(keyGuess, kgExData, globals.TRACE_WISE)
	if (CPATYPE == globals.ADAPTIVE_CPA):
		if (cfg.LAST_POWER_MODEL != None and cfg.KEYARRAY != None):
			keyGuess = updatePowerModelUsingBCPA(keyGuess, cfg.LAST_POWER_MODEL, cfg.KEYARRAY[cfg.KEY_INDEX])
	cfg.LAST_POWER_MODEL = keyGuess
	cfg.KEY_INDEX = cfg.KEY_INDEX + 1
	##print len(keyGuess[0])
	return(keyGuess)
	
def adjustSampleSize(sampleLength, dataArray):
		
		
		if(cfg.PROGRAM_CALL == "ANALYSIS"):
			printFunctions.printToAnalysisLog("\tAdjusting Sample Size to ->" + str(sampleLength))
			print 'analysis'
		else:
			printFunctions.printToLog("\tAdjusting Sample Size to ->" + str(sampleLength))
		temp = dataArray.shape
		newDataArray = dataArray
		arrLen = temp[0]
		print "Array Length --> " + str(arrLen)
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
			

def computeAlignedData(totalMeasuredPowerData, totalMeasuredTriggerData):
	if(cfg.config_attributes['CAPTURE_MODE'] == "" or cfg.config_attributes['TRIGGER_THRESHOLD'] == ""):
		sys.stdout.write("\tSignal Alignment parameters not found.\n\tPlease load the parameter values before calling Signal Alignment routine")
		sys.exit(1)
		
	if(cfg.config_attributes['CAPTURE_MODE'] == 'MULTI'):
		alignedData = numpy.zeros(0)
		singleTraceFlag = False
		temp = totalMeasuredTriggerData.shape
		
		totalNumOfTraceSets = temp[0]
		
		if (totalNumOfTraceSets == totalMeasuredTriggerData.size):
			totalNumOfTraceSets = 1
			singleTraceFlag = True
		traceLength = 0
		for traceSet in range(0, totalNumOfTraceSets):
			if(singleTraceFlag == True):
				measuredPowerData = totalMeasuredPowerData
				measuredTriggerData = totalMeasuredTriggerData
			else:	
				measuredTriggerData = totalMeasuredTriggerData[traceSet,:]
				measuredPowerData = totalMeasuredPowerData[traceSet,:]
			sampleNo = 0
			firstTriggerHigh = False
			firstTriggerSampleHigh = True
			tempArray = numpy.zeros(0)
			triggerCount = 0
			for sampleNo in range(0, len(measuredTriggerData)):
				if(measuredTriggerData[sampleNo] > cfg.config_attributes['TRIGGER_THRESHOLD']):
					firstTriggerHigh = True
					if(firstTriggerSampleHigh == True):
						if (triggerCount == 0):
							tempArray = numpy.zeros(0)
							
						elif(triggerCount == 1 and traceSet == 0):
							t = tempArray.shape
							traceLength = t[0]
							alignedData = tempArray
							tempArray = numpy.zeros(0)
							
						elif(triggerCount > 1):
							tempArray = adjustSampleSize(traceLength, tempArray)
							alignedData = numpy.vstack((alignedData,tempArray))
							tempArray = numpy.zeros(0)
							
						firstTriggerSampleHigh = False
						triggerCount += 1
						#print triggerCount	
					tempArray = numpy.append(tempArray, measuredPowerData[sampleNo])
					
				elif(measuredTriggerData[sampleNo] < cfg.config_attributes['TRIGGER_THRESHOLD']  and firstTriggerHigh == True):
					
					firstTriggerSampleHigh = True
					tempArray = numpy.append(tempArray, measuredPowerData[sampleNo])
			alignedData = numpy.vstack((alignedData,adjustSampleSize(traceLength,tempArray)))
		return (alignedData)	
	
	elif(cfg.config_attributes['CAPTURE_MODE'] == 'SINGLE'):
		alignedData = numpy.zeros(0)
		singleTraceFlag = False
		temp = totalMeasuredTriggerData.shape
		totalNumOfTraceSets = temp[0]
		if (totalNumOfTraceSets == totalMeasuredTriggerData.size):
			totalNumOfTraceSets = 1
			singleTraceFlag = True
		traceLength = 0
		for traceSet in range(0, totalNumOfTraceSets):
			if(cfg.PROGRAM_CALL == "analysis"):
				printFunctions.printToScreenAndAnalysisLog("\n\nProcessing Trace Set number: " + str(traceSet))
			if(singleTraceFlag == True):
				measuredPowerData = totalMeasuredPowerData
				measuredTriggerData = totalMeasuredTriggerData
			else:	
				measuredTriggerData = totalMeasuredTriggerData[traceSet,:]
				measuredPowerData = totalMeasuredPowerData[traceSet,:]		
			sampleNo = 0
			firstTriggerHigh = False
			firstTriggerSampleHigh = True
			triggerCount = 0
			tempArray = numpy.zeros(0)
			sampleCount = 0
			sampleLength = 0
			triggerSampleCount = 0
                        cutMode = cfg.config_attributes['CUT_MODE'] 
                        print "Cut mode = " + cutMode
                        start = 0 
                        end = len(measuredTriggerData)
			for sampleNo in range(0, len(measuredTriggerData)):
				if(measuredTriggerData[sampleNo] > cfg.config_attributes['TRIGGER_THRESHOLD'] and firstTriggerHigh == False):
                                        ###
                                        start = sampleNo
                                        firstTriggerHigh = True
                                        if cutMode != "TRIG_HIGH":
                                           break
                                elif(measuredTriggerData[sampleNo] < cfg.config_attributes['TRIGGER_THRESHOLD']  and firstTriggerHigh == True):
                                        end = sampleNo
					break
			
                        print "Cutting trace : start= " + str(start) + " end=" + str(end)

 
			if (traceSet == 0):
				tempArray = measuredPowerData[start:end]
				t = tempArray.shape
				traceLength = t[0]
				alignedData = tempArray
				tempArray = numpy.zeros(0)
				#break;
			elif(traceSet > 0):
				tempArray = measuredPowerData[start:end]
				tempArray = adjustSampleSize(traceLength, tempArray)
				alignedData = numpy.vstack((alignedData, tempArray))
				tempArray = numpy.zeros(0)
				#break;
						
		return (alignedData)
		

def readRawTraces():
	printFunctions.printToScreenAndAnalysisLog("Loading Power and Trigger Data ..")
	if (os.path.isfile(cfg.RAW_UNALIGNED_POWER_FILE) != True):
		printFunctions.printToScreenAndAnalysisLog("Power measurement file does not exist ..")
		sys.exit(1)
	if (os.path.isfile(cfg.RAW_UNALIGNED_TRIGGER_FILE) != True):
		printFunctions.printToScreenAndAnalysisLog("Trigger measurement file does not exist ..")
		sys.exit(1)
	measurementFile = open(cfg.RAW_UNALIGNED_POWER_FILE, 'r')
	triggerFile = open(cfg.RAW_UNALIGNED_TRIGGER_FILE, 'r')
	for traceCount in range (0, cfg.config_attributes['NUMBER_OF_TRACES']):
		tempArrayMeasurement = numpy.load(measurementFile)
		tempArrayTrigger = numpy.load(triggerFile)
		if (traceCount == 0):
			cfg.RAW_POWER_DATA  = tempArrayMeasurement
			cfg.RAW_TRIGGER_DATA  = tempArrayTrigger
		elif (traceCount > 0):
			cfg.RAW_POWER_DATA  = numpy.vstack((cfg.RAW_POWER_DATA,tempArrayMeasurement))
			cfg.RAW_TRIGGER_DATA  = numpy.vstack((cfg.RAW_TRIGGER_DATA,tempArrayTrigger))
	printFunctions.printToScreenAndAnalysisLog("..DONE")		

def readAlignedDataFromFile():
	printFunctions.printToScreenAndAnalysisLog("Loading Aligned Data ..(%d traces)" %cfg.config_attributes['NUMBER_OF_TRACES'])
	measurementFile = open(cfg.ALIGNED_DATA_FILE, 'r')
        
	print 'File = ' + cfg.ALIGNED_DATA_FILE
	#Get sample size to adjust all traces to the same number of samples. A better solution is to get the data cleaned up upon acquistion.
	sampleSize = detectSampleSize(measurementFile)
	#need to reset file handle since we used it 
	measurementFile.seek(0)
        print "Number of samples=" + str(int(cfg.config_attributes['NUMBER_OF_TRACES']))
        cfg.RAW_POWER_DATA = numpy.zeros([int(cfg.config_attributes['NUMBER_OF_TRACES']), sampleSize])
        print "DEBUUUG"
        print cfg.config_attributes['NUMBER_OF_TRACES']
	print  sampleSize
	print type(cfg.RAW_POWER_DATA)
	for traceCount in range (0,cfg.config_attributes['NUMBER_OF_TRACES']):
		#print "traceCount= " + str(traceCount)
		tempArrayMeasurement = numpy.load(measurementFile)
		tempArrayMeasurement = adjustSampleSize(sampleSize, tempArrayMeasurement)
		#if (traceCount == 0):
		#	cfg.RAW_POWER_DATA  = tempArrayMeasurement
		#	print 'array length' + str(len(cfg.RAW_POWER_DATA))
		#	print 'array length' + str(len(tempArrayMeasurement))
		#elif (traceCount > 0):
		#	print "DEBUG shape: " + str(tempArrayMeasurement.shape)
		#	#print 'array length cfg: ' + str(len(cfg.RAW_POWER_DATA)) 
		#	#print 'array length tmp: ' + str(len(tempArrayMeasurement)) + ' count= ' + str(traceCount)
		#	cfg.RAW_POWER_DATA  = numpy.vstack((cfg.RAW_POWER_DATA,tempArrayMeasurement))
	        cfg.RAW_POWER_DATA[traceCount, :] = tempArrayMeasurement

	printFunctions.printToScreenAndAnalysisLog("..DONE")	
	return (cfg.RAW_POWER_DATA)

def detectSampleSize(measurementFile):
	"""
	This function calcualates the number of sample per trace. This is needed to do any paddig/truncation to make all 
	traces the same size. We iterate through the first 10 traces and get the max number of traces
	"""
	print "DEBUG: Module: analysis, Function: detectSampleSize():"
	print "----Detecting samples per trace"
	maxNumOfSamples = 0
	for traceCount in range (0,10):
		try:
			trace = numpy.load(measurementFile)
		except:
			print "----You have less than 10 samples. It looks that the max number of samples is : " + str(maxNumOfSamples)
			return maxNumOfSamples
		numOfSamples = len(trace)
		if maxNumOfSamples < numOfSamples:
			maxNumOfSamples = numOfSamples
	print "----It looks that the max number of samples in the first 10 traces is: " + str(maxNumOfSamples)
	return maxNumOfSamples
	


#def readAlignedDataFromFile():
#	printFunctions.printToScreenAndAnalysisLog("Loading Aligned Data ..")
#	measurementFile = open(cfg.ALIGNED_DATA_FILE, 'r')
#	for traceCount in range (0, cfg.config_attributes['NUMBER_OF_TRACES']):
#		tempArrayMeasurement = numpy.load(measurementFile)
#		if (traceCount == 0):
#			cfg.RAW_POWER_DATA  = tempArrayMeasurement
#		elif (traceCount > 0):
#			cfg.RAW_POWER_DATA  = numpy.vstack((cfg.RAW_POWER_DATA,tempArrayMeasurement))
#	printFunctions.printToScreenAndAnalysisLog("..DONE")	
#	return (cfg.RAW_POWER_DATA)
	
def getAlignedMeasuredPowerData():
	printFunctions.printToScreenAndAnalysisLog("Starting signal alignment routine")
	if (os.path.isfile(cfg.ALIGNED_DATA_FILE) == True):
		printFunctions.printToScreenAndAnalysisLog("\tFound  raw aligned power signal data set. Loading the data set")
		printFunctions.printToAnalysisLog("\tDataSet - " +cfg.ALIGNED_DATA_FILE)
		#alignedData = numpy.load(cfg.ALIGNED_DATA_FILE)
		alignedData = readAlignedDataFromFile()
		return (alignedData)
	else:
		printFunctions.printToScreenAndAnalysisLog("\tNo aligned power signal data set found. Commencing power signal alignment process")
		readRawTraces()
		alignedData = computeAlignedData(cfg.RAW_POWER_DATA, cfg.RAW_TRIGGER_DATA)
		numpy.save(cfg.ALIGNED_DATA_FILE, alignedData)
		return(alignedData)


def spectogram(dataToPlot):
	dataToPlot = numpy.transpose(dataToPlot)
	runNo = 1
	cfg.SPECTOGRAM_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo)+globals.SPECTOGRAM_FILE_NAME)
	while os.path.exists(cfg.MEAN_OF_DATA_FILE):
		runNo += 1
		cfg.SPECTOGRAM_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) +globals.SPECTOGRAM_FILE_NAME)	
	printFunctions.printToScreenAndAnalysisLog("Plotting Spectrogram of Measured Data")
	#figs = plt.figure()	
	#figs.suptitle('Spectrogram of Measured Traces', fontsize=14, fontweight='bold')
	#plt.hold(False)
	plt.clf()
	plt.subplot(211)
	plt.plot(range(len(dataToPlot)), dataToPlot)
	plt.subplot(212)
	dt = 2e-6
	NFFT = 128
	Fs = int(1.0/dt)
	printFunctions.printToAnalysisLog("Plotting Spectrogram to PNG file - " + cfg.SPECTOGRAM_FILE)
	Pxx, freqs, bins, im = pylab.specgram(dataToPlot, NFFT=NFFT, Fs=Fs, noverlap=0)
	plt.savefig(cfg.SPECTOGRAM_FILE,dpi=100)
	if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
		plt.savefig(support.shiftPathToGraphFolder(cfg.SPECTOGRAM_FILE.replace("png", "pdf")),dpi=100)
		plt.savefig(support.shiftPathToGraphFolder(cfg.SPECTOGRAM_FILE.replace("png", "eps")),dpi=100)
