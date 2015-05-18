#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2014 Cryptographic Engineering Research Group (CERG)               #
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
	if (os.path.isfile(cfg.TRACE_EXPUNGE_DATA_FILE) == True):
		kgExData = numpy.loadtxt(cfg.TRACE_EXPUNGE_DATA_FILE)
		keyGuess = numpy.delete(keyGuess, kgExData, globals.TRACE_WISE)
	keyGuess = keyGuess[:,:-1]
	return(keyGuess)
	
def adjustSampleSize(sampleLength, dataArray):
		printFunctions.printToAnalysisLog("\tAdjusting Sample Size to ->" + str(sampleLength))
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
			

def computeAlignedData(totalMeasuredPowerData, totalMeasuredTriggerData):
	if(cfg.analysisConfigAttributes['CAPTURE_MODE'] == "" or cfg.analysisConfigAttributes['TRIGGER_THRESHOLD'] == ""):
		sys.stdout.write("\tSignal Alignment parameters not found.\n\tPlease load the parameter values before calling Signal Alignment routine")
		sys.exit(1)
		
	if(cfg.analysisConfigAttributes['CAPTURE_MODE'] == 'MULTI'):
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
				if(measuredTriggerData[sampleNo] > cfg.analysisConfigAttributes['TRIGGER_THRESHOLD']):
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
					tempArray = numpy.append(tempArray, measuredPowerData[sampleNo])
				elif(measuredTriggerData[sampleNo] < cfg.analysisConfigAttributes['TRIGGER_THRESHOLD']  and firstTriggerHigh == True):
					firstTriggerSampleHigh = True
					tempArray = numpy.append(tempArray, measuredPowerData[sampleNo])
			alignedData = numpy.vstack((alignedData,adjustSampleSize(traceLength,tempArray)))	

		return (alignedData)	
	
	elif(cfg.analysisConfigAttributes['CAPTURE_MODE'] == 'SINGLE'):
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
			triggerCount = 0
			tempArray = numpy.zeros(0)
			sampleCount = 0
			sampleLength = 0
			triggerSampleCount = 0
			for sampleNo in range(0, len(measuredTriggerData)):
				if(measuredTriggerData[sampleNo] > cfg.analysisConfigAttributes['TRIGGER_THRESHOLD'] and firstTriggerHigh == False):
					firstTriggerHigh = True
					if (traceSet == 0):
						tempArray = measuredPowerData[sampleNo:]
						t = tempArray.shape
						traceLength = t[0]
						alignedData = tempArray
						tempArray = numpy.zeros(0)
						break;
					elif(traceSet > 0):
						tempArray = measuredPowerData[sampleNo:]
						tempArray = adjustSampleSize(traceLength, tempArray)
						alignedData = numpy.vstack((alignedData, tempArray))
						tempArray = numpy.zeros(0)
						break;
						
		return (alignedData)
		

def readRawTraces():
	cfg.RAW_POWER_DATA = numpy.loadtxt(cfg.RAW_UNALIGNED_POWER_FILE)
	cfg.RAW_TRIGGER_DATA = numpy.loadtxt(cfg.RAW_UNALIGNED_TRIGGER_FILE)
	
		
	
def getAlignedMeasuredPowerData():
	printFunctions.printToScreenAndAnalysisLog("Starting signal alignment routine")
	if (os.path.isfile(cfg.ALIGNED_DATA_FILE) == True):
		printFunctions.printToScreenAndAnalysisLog("\tFound aligned power signal data set. Loading the data set")
		printFunctions.printToAnalysisLog("\tDataSet - " +cfg.ALIGNED_DATA_FILE)
		alignedData = numpy.loadtxt(cfg.ALIGNED_DATA_FILE)
		return (alignedData)
	else:
		printFunctions.printToScreenAndAnalysisLog("\tNo aligned power signal data set found. Commencing power signal alignment process")
		alignedData = computeAlignedData(cfg.RAW_POWER_DATA, cfg.RAW_TRIGGER_DATA)
		numpy.savetxt(cfg.ALIGNED_DATA_FILE, alignedData)
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