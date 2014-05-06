import os
import sys
import numpy
import matplotlib.pyplot as plt
import cfg
from configExtract import *

def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.TESTDIR = os.path.join(cfg.ROOTDIR, cfg.TESTDIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.TESTDIR, cfg.CONFIGFILENAME)
	
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
	
def processData(measuredData, triggerData, triggerThreshold, sampleWindow, captureMode):
	if(captureMode == 'MULTI'):
		count = 0
		sampleSize = 1
		triggerCount = 0
		peakCheckFlag = True
		processedData = numpy.zeros(0)
		temp = numpy.zeros(0)
		sys.stdout.write("Processing Data\n")
		for count in range(0, len(triggerData)):
			if(triggerData[count] > triggerThreshold and sampleSize < sampleWindow and peakCheckFlag == True):
				temp = numpy.append(temp,measuredData[count])
				sampleSize += 1
				if(sampleSize == sampleWindow):
					peakCheckFlag = False
			elif (triggerData[count] < 0 and sampleSize != 1 and peakCheckFlag == False):
				if (triggerCount == 0):
					processedData = temp
					temp = numpy.zeros(0)
				else:
					processedData = numpy.vstack((processedData,temp))
					temp = numpy.zeros(0)
				sampleSize = 1	
				triggerCount +=1
				peakCheckFlag = True
		fid = open("processedData.dat", "wb")
		fid.write(",".join(map(str, processedData)))
		fid.close()	
	return (processedData)
	
def compress(a, compressionLen, compressionType):
	compressedData = numpy.zeros(0)
	totalSampleSize = len(a)
	if((totalSampleSize%compressionLen) == 0 and totalSampleSize > compressionLen):
		lowerBound = 0
		upperBound = compressionLen
		while (upperBound <= totalSampleSize):
			if(compressionType == 'MAX'):
				compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
			elif(compressionType == 'MIN'):
				compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
			elif(compressionType == 'MEAN'):
				compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
			lowerBound = upperBound
			upperBound = upperBound + compressionLen
	elif((totalSampleSize%compressionLen) != 0 and totalSampleSize > compressionLen):
		lowerBound = 0
		upperBound = compressionLen
		while (upperBound <= totalSampleSize):
			if(compressionType == 'MAX'):
				compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
			elif(compressionType == 'MIN'):
				compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
			elif(compressionType == 'MEAN'):
				compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
			lowerBound = upperBound
			upperBound = upperBound + compressionLen
		if(compressionType == 'MAX'):
			compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
		elif(compressionType == 'MIN'):
			compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
		elif(compressionType == 'MEAN'):
			compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
	elif(totalSampleSize == compressionLen):
		lowerBound = 0
		upperBound = totalSampleSize
		if(compressionType == 'MAX'):
			compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
		elif(compressionType == 'MIN'):
			compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
		elif(compressionType == 'MEAN'):
			compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
	elif(totalSampleSize < compressionLen):
		sys.stdout.write("Compression window is greater than available samples.\n")
		sys.stdout.write("Adjusting the compression window to total available samples.\n")
		lowerBound = 0
		upperBound = totalSampleSize
		if(compressionType == 'MAX'):
			compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
		elif(compressionType == 'MIN'):
			compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
		elif(compressionType == 'MEAN'):
			compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
	return (compressedData)
	
def compressData(measuredData, compressionLen, compressionType):
	dataResize =  numpy.apply_along_axis(compress, 1, measuredData,compressionLen, compressionType)
	fid = open("compressedData.dat", "wb")
	fid.write(str(dataResize))
	fid.close()	
	return (dataResize)

def main():	
	clear_screen()
	init()
	script, channel1Data, channel2Data = sys.argv
	measuredPowerData = acquireDataValues_old(channel1Data)
	measuredTriggerData = acquireDataValues_old(channel2Data)
	extractConfigAttributes()
	processedPowerData = processData(measuredPowerData, measuredTriggerData, 
							cfg.analysisConfigAttributes['TRIGGER_THRESHOLD'], 
							cfg.analysisConfigAttributes['SAMPLE_WINDOW'], 
							cfg.analysisConfigAttributes['CAPTURE_MODE'])
	#processedAndCompressedData = compressData(processedPowerData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'], cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
	#b = numpy.array([[1,2,3,10,11,12], [4,5,6,13,14,15], [7,8,9,16,17,18]])
	#temp = numpy.apply_along_axis(compress, 1, b,10,cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
	#print b
	#print temp
	plt.plot(processedPowerData)
	plt.ylabel('Volts')
	plt.xlabel('Time')
	plt.show() 
		
if __name__ == "__main__":
    main()		
	
	