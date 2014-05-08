#!/usr/bin/python
import cfg
import os
import os.path
import sys
import numpy


def acquireDataValues_old(rawDataFile):
	fid = open(rawDataFile, "r")
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
	fid = open(preambleFile , "r")
	preamble = numpy.fromfile(fid, dtype = numpy.float64, count= 10, sep = ",")
	fid.close()
	fid = open(rawDataFile, "r")
	rawImg = numpy.array(numpy.fromfile(fid, dtype = numpy.ubyte, count = int(preamble[2]), sep = ""))
	fid.close()
	imgX1 = numpy.arange(1,int(preamble[2]))
	numpy.transpose(imgX1)
	imgX1 = (imgX1 - preamble[6]) * preamble[4] + preamble[5]
	imgY1 = (img - preamble[9]) * preamble[7] + preamble[8]
	measuredData = numpy.array(imgY1, dtype = numpy.float64)
	return (measuredData)
	
def acquireHypotheticalValues():
	keyGuess = numpy.loadtxt(cfg.POWER_MODEL_FILE)
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
		alignedData = numpy.vstack((alignedData,adjustSampleSize(sampleLength,tempArray)))	
		return (alignedData)		
				
def getAlignedMeasuredPowerData():
	sys.stdout.write("Starting signal alignment routine\n")
	if (os.path.isfile(cfg.ALIGNED_DATA_FILE) == True):
		sys.stdout.write("\tFound aligned power signal data set. Leading the data set\n")
		alignedData = numpy.loadtxt(cfg.ALIGNED_DATA_FILE)
		return (alignedData)
	else:
		sys.stdout.write("\tNo aligned power signal data set found. Commencing power signal alignment process\n")
		measuredPowerData = acquireDataValues_old(cfg.RAW_UNALIGNED_POWER_FILE)
		measuredTriggerData = acquireDataValues_old(cfg.RAW_UNALIGNED_TRIGGER_FILE)
		alignedData = computeAlignedData(measuredPowerData, measuredTriggerData)
		numpy.savetxt(cfg.ALIGNED_DATA_FILE, alignedData)
		return(alignedData)