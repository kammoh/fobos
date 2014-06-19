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
import cfg,globals,support, printFunctions
import os
import os.path
import re
import sys
import numpy
	
def sampleSpaceDisp(alignedData):
	runNo = 1
	cfg.SAMPLE_SPACE_DISP_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE,str(runNo) + "-" +globals.SAMPLE_SPACE_DISP_FILE_NAME)
	while os.path.exists(cfg.SAMPLE_SPACE_DISP_FILE):
		runNo += 1
		cfg.SAMPLE_SPACE_DISP_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.SAMPLE_SPACE_DISP_FILE_NAME)
	if (cfg.analysisConfigAttributes['WINDOW_START_POINT'] == "" or cfg.analysisConfigAttributes['SAMPLE_WINDOW'] == ""):
		printFunctions.printToScreenAndAnalysisLog("\tSample Space Disposition parameters not found.\n\tPlease load the parameter values before calling SAMPLE SPACE DISPOSITION routine")
		support.exitProgram()
			
	printFunctions.printToScreenAndAnalysisLog("Commencing SAMPLE SPACE DISPOSITION routine")
	printFunctions.printToAnalysisLog("\tWindow Start Point - " + str(cfg.analysisConfigAttributes['WINDOW_START_POINT']))
	printFunctions.printToAnalysisLog("\tSample Window Size - " +str(cfg.analysisConfigAttributes['SAMPLE_WINDOW']))
	processedData = alignedData[:,cfg.analysisConfigAttributes['WINDOW_START_POINT'] : cfg.analysisConfigAttributes['WINDOW_START_POINT']+cfg.analysisConfigAttributes['SAMPLE_WINDOW']] 
	numpy.savetxt(cfg.SAMPLE_SPACE_DISP_FILE, processedData)
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

def compressData(measuredData):
	runNo = 1
	cfg.COMPRESSED_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.COMPRESSED_DATA_FILE_NAME)
	while os.path.exists(cfg.COMPRESSED_DATA_FILE):
		runNo += 1
		cfg.COMPRESSED_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.COMPRESSED_DATA_FILE_NAME)
	
	printFunctions.printToScreenAndAnalysisLog("Commencing COMPRESS SAMPLE WINDOW routine")
	if (cfg.analysisConfigAttributes['COMPRESSION_LENGTH'] == "" or cfg.analysisConfigAttributes['COMPRESSION_TYPE'] == ""):
		printFunctions.printToScreenAndAnalysisLog("\tCompress sample window parameters not found.\n\tPlease load the parameter values before calling COMPRESS DATA routine")
		support.exitProgram()
	printFunctions.printToAnalysisLog("\tCompression Length - " + str(cfg.analysisConfigAttributes['COMPRESSION_LENGTH']))
	printFunctions.printToAnalysisLog("\tCompression Type - " + str(cfg.analysisConfigAttributes['COMPRESSION_TYPE']))
	dataResize =  numpy.apply_along_axis(compress, 1, measuredData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
	numpy.savetxt(cfg.COMPRESSED_DATA_FILE, dataResize)
	return (dataResize)
	
def traceExpunge(measuredData): 
	cfg.TRACE_EXPUNGE_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE,globals.TRACE_EXPUNGE_DATA_FILE_NAME)
	while os.path.exists(cfg.TRACE_EXPUNGE_DATA_FILE):
		os.remove(cfg.TRACE_EXPUNGE_DATA_FILE)
	printFunctions.printToScreenAndAnalysisLog("Commencing TRACE EXPUNGE routine")
	newMeasuredData = numpy.zeros(0)
	teFlag = numpy.zeros(0)
	thLimit = numpy.zeros(0)
	if(cfg.analysisConfigAttributes['TRACE_EXPUNGE_PARAMS'] == ""):
		printFunctions.printToScreenAndAnalysisLog("\tTrace Expunge parameters are not found. \n\tPlease load the parameter values before calling TRACE EXPUNGE routine")
		support.exitProgram()
	val = re.split(":", cfg.analysisConfigAttributes['TRACE_EXPUNGE_PARAMS'])
	traceCount = 0
	thBelow = float(val[1])
	thAbove = float(val[2])
	printFunctions.printToAnalysisLog("\tExpunge Criteria - " + str(val[0]))
	printFunctions.printToAnalysisLog("\tThreshold Limits - " + str(thBelow)+" (below) to "+str(thAbove)+ " (above)") 
	if(val[0] == 'VAR'):
		thLimit = numpy.var(measuredData, globals.TRACE_WISE)
	elif(val[0] == 'STD'):
		thLimit = numpy.var(measuredData, globals.TRACE_WISE)
	else:
		printFunctions.printToScreenAndAnalysisLog("Incorrect selection - "+str(val[0])+". No traces expunged")
		return measuredData
	while(traceCount < len(thLimit)):
		if((thLimit[traceCount] > thBelow) and (thLimit[traceCount] < thAbove)):
			if(traceCount == 0):
				newMeasuredData = numpy.append(newMeasuredData, measuredData[traceCount,:])
			else:
				newMeasuredData = numpy.vstack((newMeasuredData, measuredData[traceCount,:]))
			traceCount += 1
			#bar = "Processed Trace - ", traceCount,"/", len(thLimit), "\r",
			#printFunctions.printToScreen(bar)
		else:
			printFunctions.printToAnalysisLog("Expunged Trace - " + str(traceCount) +"/"+str(len(thLimit)))
			teFlag = numpy.append(teFlag, traceCount)
			traceCount += 1
		numpy.savetxt(cfg.TRACE_EXPUNGE_DATA_FILE, teFlag)
	return newMeasuredData

	
def postProcessing(alignedData):
	sys.stdout.write("Starting post processing routine\n")
	if(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == '1'):
		sys.stdout.write("\tCommencing SAMPLE SPACE DISPOSITION routine\n")
		processedData = processData(alignedData)
		if(cfg.analysisConfigAttributes['COMPRESS_DATA'] == '2'):
			sys.stdout.write("\t\t->Commencing COMPRESS SAMPLE WINDOW routine\n")
			processedAndCompressedData = compressData(processedData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
			if(cfg.analysisConfigAttributes['TRACE_EXPUNGE'] == '3'):
				sys.stdout.write("\t\t->Commencing TRACE EXPUNGE routine\n")
				processedCompressedAndExpungedData = trace_expunge(processedAndCompressedData)
				return (processedCompressedAndExpungedData)
			else:
				return(processedAndCompressedData)
		elif(cfg.analysisConfigAttributes['TRACE_EXPUNGE'] == '2'):
			sys.stdout.write("\t\t->Commencing TRACE EXPUNGE routine\n")
			processedAndExpungedData = trace_expunge(processedData)
			if(cfg.analysisConfigAttributes['COMPRESS_DATA'] == '3'):
				sys.stdout.write("\t\t->Commencing COMPRESS SAMPLE WINDOW routine\n")
				processedExpungedAndCompressedData = compressData(processedAndExpungedData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
				return(processedExpungedAndCompressedData)
			else:
				return(processedAndExpungedData)
		else:
			return(processedData)
		
	elif(cfg.analysisConfigAttributes['COMPRESS_DATA'] == '1'):
		sys.stdout.write("\tCommencing COMPRESS SAMPLE WINDOW routine\n")
		compressedData = compressData(alignedData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
		if(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == '2'):
			sys.stdout.write("\t\t->Commencing SAMPLE SPACE DISPOSITION routine\n")
			compressedAndProcessedData = processData(compressedData)
			if(cfg.analysisConfigAttributes['TRACE_EXPUNGE'] == '3'):
				sys.stdout.write("\t\t->Commencing TRACE EXPUNGE routine\n")
				compressedProcessedAndExpungedData = trace_expunge(compressedAndProcessedData)
				return (compressedProcessedAndExpungedData)
			else:
				return(compressedAndProcessedData)
		elif(cfg.analysisConfigAttributes['TRACE_EXPUNGE'] == '2'):
			sys.stdout.write("\t\t->Commencing TRACE EXPUNGE routine\n")
			compressedAndExpungedData = trace_expunge(compressedData)
			if(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == '3'):
				sys.stdout.write("\t\t->Commencing SAMPLE SPACE DISPOSITION routine\n")
				compressedExpungedAndProcessedData = processData(compressedAndExpungedData)
				return(compressedExpungedAndProcessedData)
			else:
				return(compressedAndExpungedData)
		else:
			return(compressedData)

	elif(cfg.analysisConfigAttributes['TRACE_EXPUNGE'] == '1'):
		sys.stdout.write("\tCommencing TRACE EXPUNGE routine\n")
		expungedData = trace_expunge(alignedData)
		if(cfg.analysisConfigAttributes['COMPRESS_DATA'] == '2'):
			sys.stdout.write("\t\t->Commencing COMPRESS SAMPLE WINDOW routine\n")
			expungedAndCompressedData = compressData(expungedData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
			if(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == '3'):
				sys.stdout.write("\t\t->Commencing SAMPLE SPACE DISPOSITION routine\n")
				expungedCompressedAndProcessedData = processData(expungedAndCompressedData)
				return (expungedCompressedAndProcessedData)
			else:
				return(expungedAndCompressedData)
		elif(cfg.analysisConfigAttributes['SAMPLE_SPACE_DISPOSITION'] == '2'):
			sys.stdout.write("\t\t->Commencing SAMPLE SPACE DISPOSITION routine\n")
			expungedAndProcessedData = processeData(expungedData)
			if(cfg.analysisConfigAttributes['COMPRESS_DATA'] == '3'):
				sys.stdout.write("\t\t->Commencing COMPRESS SAMPLE WINDOW routine\n")
				expungedProcessedAndCompressedData = compressData(expungedAndProcessedData,cfg.analysisConfigAttributes['COMPRESSION_LENGTH'],cfg.analysisConfigAttributes['COMPRESSION_TYPE'])
				return(expungedProcessedAndCompressedData)
			else:
				return(expungedAndProcessedData)
		else:
			return(expungedData)			
		
	