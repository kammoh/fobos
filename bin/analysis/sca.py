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
import os
import sys,re
import numpy
import cfg,globals, printFunctions
import support
import matplotlib.pyplot as plt
import scipy.stats.stats as statModule
import configExtract

def findMaxValuesCorr(correlationMatrix, corrType):
	runNo = 1
	cfg.CORR_PEARSON_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.CORR_PEARSON_RESULT_FILE_NAME)
	cfg.CORR_SPEARMAN_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE,str(runNo) + "-" +globals.CORR_SPEARMAN_RESULT_FILE_NAME)

	while os.path.exists(cfg.CORR_PEARSON_RESULT_FILE):
		runNo += 1
		cfg.CORR_PEARSON_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.CORR_PEARSON_RESULT_FILE_NAME)
	
	while os.path.exists(cfg.CORR_SPEARMAN_RESULT_FILE):
		runNo += 1
		cfg.CORR_SPEARMAN_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.CORR_SPEARMAN_RESULT_FILE_NAME)
	
	
	corrMat = numpy.transpose(correlationMatrix)
	maxValue = numpy.zeros(0)
	maxIndex = numpy.zeros(0)
	maxValue = numpy.append(maxValue, numpy.amax(corrMat, 0))
	maxIndex = numpy.append(maxIndex, numpy.argmax(corrMat, 0))
	if (corrType == 'PEARSON'):
		fid = open(cfg.CORR_PEARSON_RESULT_FILE, "w")
		printFunctions.printToAnalysisLog("Writing Pearson's r Correlation Results to - " + cfg.CORR_PEARSON_RESULT_FILE)
	elif(corrType == 'SPEARMAN'):
		fid = open(cfg.CORR_SPEARMAN_RESULT_FILE, "w")
		printFunctions.printToAnalysisLog("Writing Spearman RHO Correlation Results to - " + cfg.CORR_SPEARMAN_RESULT_FILE)
	count = 0
	string = ""
	while(count < len(maxIndex)):
		string += "Window[" +str(int(count))+ "] Key Byte- " + str(hex(int(maxIndex[count]))) + " [" + str(int(maxIndex[count])) + "] Correlation- "+ str(maxValue[count])+ "\n"
		count += 1
	fid.write(string)
	fid.close()
	
def calculate_mean(measuredData, axis):
	figs = plt.figure()	
	figs.suptitle('Measured Traces', fontsize=14, fontweight='bold')
	if(axis == globals.SAMPLE_WISE):
		printFunctions.printToScreenAndAnalysisLog("Calculating Mean of Measured Data - Sample Wise")
		runNo = 1
		cfg.MEAN_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-SampleWise-" +globals.MEAN_OF_DATA_FILE_NAME)
		while os.path.exists(cfg.MEAN_OF_DATA_FILE):
			runNo += 1
			cfg.MEAN_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-SampleWise-" +globals.MEAN_OF_DATA_FILE_NAME)	
	elif(axis == globals.TRACE_WISE):
		printFunctions.printToScreenAndAnalysisLog("Calculating Mean of Measured Data - Trace Wise")
		runNo = 1
		cfg.MEAN_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-TraceWise-" +globals.MEAN_OF_DATA_FILE_NAME)
		while os.path.exists(cfg.MEAN_OF_DATA_FILE):
			runNo += 1
			cfg.MEAN_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-TraceWise-" +globals.MEAN_OF_DATA_FILE_NAME)
	measuredDataMean = numpy.mean(measuredData,axis)
	dataToPlot = numpy.transpose(measuredDataMean)
	plt.clf()
	plt.plot(dataToPlot)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 1):
		meanLine  = numpy.mean(measuredDataMean)
		stdVal = numpy.std(measuredDataMean)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.2)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 2):
		meanLine  = numpy.mean(measuredDataMean)
		stdVal = numpy.std(measuredDataMean)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		twoSigmaPLine = meanLine+(2*stdVal)
		twoSigmaNline = meanLine-(2*stdVal)
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.25)
		plt.axhspan(twoSigmaNline, twoSigmaPLine, facecolor='g', alpha=0.2)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 3):
		meanLine  = numpy.mean(measuredDataMean)
		stdVal = numpy.std(measuredDataMean)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		twoSigmaPLine = meanLine+(2*stdVal)
		twoSigmaNline = meanLine-(2*stdVal)
		threeSigmaPLine = meanLine+(3*stdVal)
		threeSigmaNline = meanLine-(3*stdVal)
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.25)
		plt.axhspan(twoSigmaNline, twoSigmaPLine, facecolor='g', alpha=0.2)		
		plt.axhspan(threeSigmaNline, threeSigmaPLine, facecolor='g', alpha=0.15)		
	if(axis == globals.SAMPLE_WISE):	
		plt.ylabel('Mean')
		plt.xlabel('Time')
	elif(axis == globals.TRACE_WISE):	
		plt.ylabel('Mean')
		plt.xlabel('Traces')	
	plt.title('Mean of Measured Data (Maximum Likelyhood)')
	printFunctions.printToAnalysisLog("Saving Mean of measured Data PNG file to - " + cfg.MEAN_OF_DATA_FILE)
	plt.savefig(cfg.MEAN_OF_DATA_FILE,dpi=100)
	if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
		plt.savefig(support.shiftPathToGraphFolder(cfg.MEAN_OF_DATA_FILE.replace("png","pdf")),dpi=100)
		plt.savefig(support.shiftPathToGraphFolder(cfg.MEAN_OF_DATA_FILE.replace("png","eps")),dpi=100)
	return measuredDataMean

def calculate_std(measuredData,axis):
	figs = plt.figure()	
	figs.suptitle('Measured Traces', fontsize=14, fontweight='bold')
	if(axis == globals.SAMPLE_WISE):
		printFunctions.printToScreenAndAnalysisLog("Calculating Standard Deviation of Measured Data - Sample Wise")
		runNo = 1
		cfg.STD_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-SampleWise-" +globals.STD_OF_DATA_FILE_NAME)
		while os.path.exists(cfg.STD_OF_DATA_FILE):
			runNo += 1
			cfg.STD_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-SampleWise-" +globals.STD_OF_DATA_FILE_NAME)
	elif(axis == globals.TRACE_WISE):
		printFunctions.printToScreenAndAnalysisLog("Calculating Standard Deviation of Measured Data - Trace Wise")
		runNo = 1
		cfg.STD_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-TraceWise-" +globals.STD_OF_DATA_FILE_NAME)
		while os.path.exists(cfg.STD_OF_DATA_FILE):
			runNo += 1
			cfg.STD_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-TraceWise" +globals.STD_OF_DATA_FILE_NAME)
	measuredDataStd = numpy.std(measuredData,axis)
	dataToPlot =  numpy.transpose(measuredDataStd)
	plt.clf()
	plt.plot(dataToPlot)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 1):
		meanLine  = numpy.mean(measuredDataStd)
		stdVal = numpy.std(measuredDataStd)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.2)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 2):
		meanLine  = numpy.mean(measuredDataStd)
		stdVal = numpy.std(measuredDataStd)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		twoSigmaPLine = meanLine+(2*stdVal)
		twoSigmaNline = meanLine-(2*stdVal)
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.25)
		plt.axhspan(twoSigmaNline, twoSigmaPLine, facecolor='g', alpha=0.2)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 3):
		meanLine  = numpy.mean(measuredDataStd)
		stdVal = numpy.std(measuredDataStd)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		twoSigmaPLine = meanLine+(2*stdVal)
		twoSigmaNline = meanLine-(2*stdVal)
		threeSigmaPLine = meanLine+(3*stdVal)
		threeSigmaNline = meanLine-(3*stdVal)
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.25)
		plt.axhspan(twoSigmaNline, twoSigmaPLine, facecolor='g', alpha=0.2)		
		plt.axhspan(threeSigmaNline, threeSigmaPLine, facecolor='g', alpha=0.15)		
	if(axis == globals.SAMPLE_WISE):	
		plt.ylabel('Standard Deviation')
		plt.xlabel('Time')
	elif(axis == globals.TRACE_WISE):	
		plt.ylabel('Standard Deviation')
		plt.xlabel('Traces')	
	plt.title('Standard Deviation of Measured Data (Maximum Likelyhood)')
	printFunctions.printToAnalysisLog("Saving STD of measured Data PNG file to - " + cfg.STD_OF_DATA_FILE)
	plt.savefig(cfg.STD_OF_DATA_FILE,dpi=100)
	if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
		plt.savefig(support.shiftPathToGraphFolder(cfg.STD_OF_DATA_FILE.replace("png","pdf")),dpi=100)
		plt.savefig(support.shiftPathToGraphFolder(cfg.STD_OF_DATA_FILE.replace("png","eps")),dpi=100)	
	return measuredDataStd
		
def calculate_var(measuredData,axis):
	figs = plt.figure()	
	figs.suptitle('Measured Traces', fontsize=14, fontweight='bold')
	if(axis == globals.SAMPLE_WISE):
		printFunctions.printToScreenAndAnalysisLog("Calculating Variance of Measured Data - Sample Wise")
		runNo = 1
		cfg.VAR_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-SampleWise-" +globals.VAR_OF_DATA_FILE_NAME)
		while os.path.exists(cfg.VAR_OF_DATA_FILE):
			runNo += 1
			cfg.VAR_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-SampleWise-" +globals.VAR_OF_DATA_FILE_NAME)
	elif(axis == globals.TRACE_WISE):
		printFunctions.printToScreenAndAnalysisLog("Calculating Variance of Measured Data - Trace Wise")
		runNo = 1
		cfg.VAR_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-TraceWise-" +globals.VAR_OF_DATA_FILE_NAME)
		while os.path.exists(cfg.VAR_OF_DATA_FILE):
			runNo += 1
			cfg.VAR_OF_DATA_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-TraceWise-" +globals.VAR_OF_DATA_FILE_NAME)

	measuredDataVar = numpy.var(measuredData,axis)
	dataToPlot = numpy.transpose(measuredDataVar)
	plt.clf()
	plt.plot(dataToPlot)	
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 1):
		meanLine  = numpy.mean(measuredDataVar)
		stdVal = numpy.std(measuredDataVar)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.2)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 2):
		meanLine  = numpy.mean(measuredDataVar)
		stdVal = numpy.std(measuredDataVar)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		twoSigmaPLine = meanLine+(2*stdVal)
		twoSigmaNline = meanLine-(2*stdVal)
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.25)
		plt.axhspan(twoSigmaNline, twoSigmaPLine, facecolor='g', alpha=0.2)
	if(cfg.analysisConfigAttributes['DISPLAY_THREE_SIGMAS'] == 3):
		meanLine  = numpy.mean(measuredDataVar)
		stdVal = numpy.std(measuredDataVar)
		oneSigmaPLine = meanLine+stdVal
		oneSigmaNline = meanLine-stdVal
		twoSigmaPLine = meanLine+(2*stdVal)
		twoSigmaNline = meanLine-(2*stdVal)
		threeSigmaPLine = meanLine+(3*stdVal)
		threeSigmaNline = meanLine-(3*stdVal)
		plt.axhline(y=meanLine, color='r')
		plt.axhspan(oneSigmaNline, oneSigmaPLine, facecolor='g', alpha=0.25)
		plt.axhspan(twoSigmaNline, twoSigmaPLine, facecolor='g', alpha=0.2)		
		plt.axhspan(threeSigmaNline, threeSigmaPLine, facecolor='g', alpha=0.15)				
	#if(axis == globals.SAMPLE_WISE):	
		#plt.ylabel('Variance')
		#plt.xlabel('Time')
	#elif(axis == globals.TRACE_WISE):	
		#plt.ylabel('Variance')
		#plt.xlabel('Traces')
	#plt.title('Variance of Measured Data (Maximum Likelyhood)')
	printFunctions.printToAnalysisLog("Saving VAR of measured Data PNG file to - " + cfg.VAR_OF_DATA_FILE)
	plt.savefig(cfg.VAR_OF_DATA_FILE,dpi=100)
	if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
		plt.savefig(support.shiftPathToGraphFolder(cfg.VAR_OF_DATA_FILE.replace("png","pdf")),dpi=100)
		plt.savefig(support.shiftPathToGraphFolder(cfg.VAR_OF_DATA_FILE.replace("png","eps")),dpi=100)		
	return measuredDataVar
		
def correlation_pearson(measuredData, modeledData):
	printFunctions.printToScreenAndAnalysisLog("Calculating Pearson's r between Measured and Modelled Data")
	measuredData = numpy.transpose(measuredData)
	corrMatrix = numpy.zeros(0)
	corrArray =  numpy.zeros(0)
	firstRun = True
	for rowM in measuredData:
		for rowH in modeledData :
			c, p = statModule.pearsonr(rowH, rowM)
			corrArray = numpy.append(corrArray, c)
		if(firstRun == True):
			corrMatrix = corrArray
			corrArray = numpy.zeros(0)
			firstRun = False
		else:
			corrMatrix = numpy.vstack((corrMatrix, corrArray))
			corrArray = numpy.zeros(0)
	findMaxValuesCorr(corrMatrix, 'PEARSON')		
	return corrMatrix
		
def correlation_spearman(measuredData, modeledData):
	printFunctions.printToScreenAndAnalysisLog("Calculating Spearman's RHO between Measured and Modelled Data")
	measuredData = numpy.transpose(measuredData)
	corrMatrix = numpy.zeros(0)
	corrArray =  numpy.zeros(0)
	firstRun = True	
	for rowM in measuredData:
		for rowH in modeledData :
			c, p = statModule.spearmanr(rowH, rowM)
			corrArray = numpy.append(corrArray, c)
		if(firstRun == True):
			corrMatrix = corrArray
			corrArray = numpy.zeros(0)
			firstRun = False
		else:
			corrMatrix = numpy.vstack((corrMatrix, corrArray))	
			corrArray = numpy.zeros(0)			
	findMaxValuesCorr(corrMatrix, 'SPEARMAN')
	return corrMatrix	
	
def calculate_autocorrelation(measuredData):
	printFunctions.printToScreenAndAnalysisLog("Calculating Autocorrelation for Measured data")
	mData = numpy.transpose(measuredData)
	corrMatrix = numpy.zeros(0)
	corrArray =  numpy.zeros(0)
	firstRun = True	
	for rowM in mData:
		ac = numpy.correlate(rowM, rowM, mode = 'full')[-len(rowM):]
		ac = ac/(rowM.var() *(numpy.arange(len(rowM),0,-1)))
		corrArray = numpy.append(corrArray, ac)
		if(firstRun == True):
			corrMatrix = corrArray
			corrArray = numpy.zeros(0)
			firstRun = False
		else:
			corrMatrix = numpy.vstack((corrMatrix, corrArray))	
			corrArray = numpy.zeros(0)			
	return corrMatrix	
		
def main():
	os.system('cls')
	configExtract.configureWorkspace()
	#x = [[5,4,6,8,4],
	#	[2,3,4,5,1]]
	# y  = [[0],[1],[4],[6],[2]]
	#test = numpy.array([[1, 2], [3, 4], [5, 6]])
	#print test[0,:]
	# z = numpy.zeros(0)
	# z = numpy.append(z,2)
	# z = numpy.append(z,4)
	# t = numpy.delete(x,z,1)
	# print t
	#t = "VAR:0.0000025:0.0000035"
	#temp = re.split(":", t)
	#print temp[0]
	#print temp[1]
	#print temp[2]
	directoryList = os.listdir(cfg.analysisConfigAttributes['MEASUREMENT_WORK_DIR'])
	
	for item in directoryList:
		print item


	
	
if __name__ == "__main__":
    main()	
