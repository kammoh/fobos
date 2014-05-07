import os
import sys
import numpy
import matplotlib.pyplot as plt
import cfg
from configExtract import *
import sca
figFile = "snapshot.png"
sfigFile = "spearman.png"
pfigFile = "pearson.png"

def init():
	sys.stdout.write("Initializing Analysis Module ..\n")
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

def acquireHypotheticalValues(secretGuessFile):
	keyGuess = numpy.loadtxt(secretGuessFile)
	keyGuess = keyGuess[:,:-1]
	return(keyGuess)

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
		triggerCount = 0
		firstTrigger = True
		dataCapture = True
		processedData = numpy.zeros(0)
		temp = numpy.zeros(0)
		sys.stdout.write("Processing Data\n")
		windowSize = 0
		for count in range(0, len(triggerData)):
			if(triggerData[count] > triggerThreshold  and windowSize < sampleWindow):
				if(dataCapture == True):
					startPoint = count + cfg.analysisConfigAttributes['WINDOW_START_POINT']
					endPoint = startPoint + sampleWindow
					temp = numpy.append(temp,measuredData[startPoint:endPoint])
					dataCapture = False	
				windowSize += 1
			elif (triggerData[count] < 0 and windowSize != 0):
				if (firstTrigger == True):
					processedData = temp
					temp = numpy.zeros(0)
					firstTrigger = False
				else:
					processedData = numpy.vstack((processedData,temp))
					temp = numpy.zeros(0)
				triggerCount +=1
				dataCapture = True
				windowSize = 0
		#print triggerCount		
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
		#sys.stdout.write("Compression window is greater than available samples.\n")
		#sys.stdout.write("Adjusting the compression window to total available samples.\n")
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
	sys.stdout.write("Compressing Data\n")
	dataResize =  numpy.apply_along_axis(compress, 1, measuredData,compressionLen, compressionType)
	fid = open("compressedData.dat", "wb")
	fid.write(str(dataResize))
	fid.close()	
	return (dataResize)

def plotData(dataToPlot, figFile):
	plt.hold(False)
	dataToPlot = numpy.transpose(dataToPlot)
	plt.plot(dataToPlot)
	plt.ylabel('volts')
	plt.xlabel('time')
	plt.title('Processed Data')
	sys.stdout.write("->\tSaving %s fig file\n" % figFile)
	plt.savefig(figFile,dpi=72)
	plt.show()
	
def main():	
	clear_screen()
	init()
	script, channel1Data, channel2Data, powerModel = sys.argv
	measuredPowerData = acquireDataValues_old(channel1Data)
	measuredTriggerData = acquireDataValues_old(channel2Data)
	hypotheticalPowerData = acquireHypotheticalValues(powerModel)
	extractConfigAttributes()
	processedPowerData = processData(measuredPowerData, measuredTriggerData, 
							cfg.analysisConfigAttributes['TRIGGER_THRESHOLD'], 
							cfg.analysisConfigAttributes['SAMPLE_WINDOW'], 
							cfg.analysisConfigAttributes['CAPTURE_MODE'])
	processedAndCompressedData = compressData(processedPowerData,
							cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],
							cfg.analysisConfigAttributes['COMPRESSION_TYPE'])

	c = sca.correlation_pearson(processedAndCompressedData, hypotheticalPowerData) 
	sp = sca.correlation_spearman(processedAndCompressedData, hypotheticalPowerData)
	m = sca.calculate_mean(processedPowerData)
	s = sca.calculate_std(processedPowerData)
	v = sca.calculate_var(processedPowerData)

		
if __name__ == "__main__":
    main()		
	
	