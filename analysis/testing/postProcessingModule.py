#!/usr/bin/python
import cfg
import os
import os.path
import sys
import numpy


	
def processData(alignedData):	
	processedData = alignedData[:,cfg.analysisConfigAttributes['WINDOW_START_POINT'] : cfg.analysisConfigAttributes['WINDOW_START_POINT']+cfg.analysisConfigAttributes['SAMPLE_WINDOW']] 
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
	dataResize =  numpy.apply_along_axis(compress, 1, measuredData,compressionLen, compressionType)
	fid = open("compressedData.dat", "wb")
	fid.write(str(dataResize))
	fid.close()	
	return (dataResize)
	
	
def postProcessing(alignedData):
	sys.stdout.write("Starting post processing routine\n")
	if(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == 'YES' and cfg.analysisConfigAttributes['COMPRESS_DATA'] == 'YES'):
		sys.stdout.write("\tCommencing SAMPLE SPACE DISPOSITION routine\n")
		processedData = processData(alignedData)
		sys.stdout.write("\t\t->Commencing COMPRESS SAMPLE WINDOW routine\n")
		processedAndCompressedData = compressData(processedData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
		return(processedAndCompressedData)
	elif(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == 'YES' and cfg.analysisConfigAttributes['COMPRESS_DATA'] == 'NO'):
		sys.stdout.write("\tCommencing SAMPLE SPACE DISPOSITION routine\n")
		processedData = processData(alignedData)
		return(processedData)
	elif(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == 'NO' and cfg.analysisConfigAttributes['COMPRESS_DATA'] == 'YES'):
		sys.stdout.write("\tCommencing COMPRESS SAMPLE WINDOW routine\n")
		compressedData = compressData(alignedData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
		return(compressedData)	
	elif(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == 'NO' and cfg.analysisConfigAttributes['COMPRESS_DATA'] == 'NO'):
		sys.stdout.write("\tCaution!! No post processing process is selected. Sample size will be the entire data set\n")
		return(alignedData)			