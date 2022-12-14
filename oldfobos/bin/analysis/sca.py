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
import os
import sys,re
import numpy
from globals import cfg,globals, printFunctions
from globals import support
import matplotlib.pyplot as plt
import scipy.stats.stats as statModule
from globals import configExtract
from pylab import *
import plottingModule



	
	
def findKeyByteLocation(keyByte,corrMatrix):
	tcorrMatrix = numpy.transpose(corrMatrix)
	keyValue = tcorrMatrix[keyByte]
	array = sorted(tcorrMatrix, reverse=True)
	try:
		index_element=array.index(keyValue)
		if (index_element == -1):
			index_element = 255
		return index_element
	except ValueError:
		return -1
	
def findMaxValuesCorr(correlationMatrix, corrType):
	runNo = 1
	cfg.CORR_PEARSON_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.CORR_PEARSON_RESULT_FILE_NAME)
	cfg.CORR_SPEARMAN_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE,str(runNo) + "-" +globals.CORR_SPEARMAN_RESULT_FILE_NAME)
	cfg.ANOVA_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE,str(runNo) + "-" +globals.ANOVA_RESULT_FILE_NAME)
	
	while os.path.exists(cfg.CORR_PEARSON_RESULT_FILE):
		runNo += 1
		cfg.CORR_PEARSON_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.CORR_PEARSON_RESULT_FILE_NAME)
	
	while os.path.exists(cfg.CORR_SPEARMAN_RESULT_FILE):
		runNo += 1
		cfg.CORR_SPEARMAN_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.CORR_SPEARMAN_RESULT_FILE_NAME)

	while os.path.exists(cfg.ANOVA_RESULT_FILE):
		runNo += 1
		cfg.ANOVA_RESULT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.ANOVA_RESULT_FILE_NAME)		
	
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
	elif(corrType == 'ANOVA'):
		fid = open(cfg.ANOVA_RESULT_FILE, "w")
		printFunctions.printToAnalysisLog("Writing 1-way ANOVA Results to - " + cfg.ANOVA_RESULT_FILE)		
	count = 0
	string = ""
	while(count < len(maxIndex)):
		string += "Window[" +str(int(count))+ "] Key Byte- " + str(hex(int(maxIndex[count]))) + " [" + str(int(maxIndex[count])) + "] 1-way ANOVA p_val - "+ str(maxValue[count])+ "\n"
		if (cfg.KEY_BYTE_MAX_CORR == None):
			cfg.KEY_BYTE_MAX_CORR = maxValue[count]
			cfg.KEY_BYTE_CORR = int(maxIndex[count])
		elif(cfg.KEY_BYTE_MAX_CORR < maxValue[count]):
			cfg.KEY_BYTE_MAX_CORR = maxValue[count]
			cfg.KEY_BYTE_CORR = int(maxIndex[count])
		count += 1	
	fid.write(string)
	fid.close()

def correlation_pearson(measuredData, modeledData):
	printFunctions.printToScreenAndAnalysisLog("Calculating Pearson's r between Measured and Modelled Data")
	measuredData = numpy.transpose(measuredData)
	corrMatrix = numpy.zeros(0)
	corrArray =  numpy.zeros(0)
	firstRun = True
	for rowM in measuredData:
		for rowH in modeledData :
			#print len(rowH)
			#print len(rowM)
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

def cpaPearson(measuredData, modeledData):
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

def findMinimumGuessingEntropy(measuredData, modeledData, correlationType, stepSize, knownKey):
	printFunctions.printToScreenAndAnalysisLog("Calculating Minimum Guessing Entropy for an Known Key Byte")
	totalTraces = len(measuredData)
	mgeArray = numpy.zeros(0)
	mgeMatrix = numpy.zeros(0)
	firstRun = True	
	for step in range(10,totalTraces, stepSize):
		pwrData = measuredData[1:step,:]
		hypData = modeledData[:,1:step]
		crrMat = cpaPearson(pwrData, hypData)
		totalPoints = len(crrMat)
		for eachPoint in range(0, totalPoints, 1):
			tempCrrMat = crrMat[eachPoint,:]
			keyLoc = findKeyByteLocation(knownKey,tempCrrMat)
			mgeArray = numpy.append(mgeArray, keyLoc)
		if(firstRun == True):
			mgeMatrix = mgeArray
			mgeArray = numpy.zeros(0)
			firstRun = False
		else:
			mgeMatrix = numpy.vstack((mgeMatrix, mgeArray))
			mgeArray = numpy.zeros(0)
			
	plottingModule.plotMGE(mgeMatrix, stepSize, knownKey)		
	return mgeArray
	
def anova(measuredData, modeledData):
	printFunctions.printToScreenAndAnalysisLog("Calculating ANOVA between Measured and Modelled Data")
	measuredData = numpy.transpose(measuredData)
	corrMatrix = numpy.zeros(0)
	corrArray =  numpy.zeros(0)
	firstRun = True	
	for rowM in measuredData:
		for rowH in modeledData :
			data = numpy.hstack((rowH, rowM))
			c, p = statModule.f_oneway(*[d[1] for d in data.iterrows()])
			corrArray = numpy.append(corrArray, p)
		if(firstRun == True):
			corrMatrix = corrArray
			corrArray = numpy.zeros(0)
			firstRun = False
		else:
			corrMatrix = numpy.vstack((corrMatrix, corrArray))	
			corrArray = numpy.zeros(0)			
	findMaxValuesCorr(corrMatrix, 'ANOVA')
	return corrMatrix	
	
def calculate_autocorrelation(measuredData):
	printFunctions.printToScreenAndAnalysisLog("Calculating Autocorrelation for Measured data")
	mData = measuredData#numpy.transpose(measuredData)
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
def calculate_var(data, axis):
	printFunctions.printToScreenAndAnalysisLog("Calculating Variance")
	data = numpy.var(data , axis = axis)
	plt.plot(data)
	plt.show()

def testArrayLoading():
	i=0
	b = numpy.zeros(0)
	a = numpy.zeros(0)
	temp = numpy.zeros(0)
	while (i<10):
		b = i
		print b
		with open("testfile.npy", 'a+b') as fileHandle:
			numpy.save(fileHandle, b)
		i = i+1
	i=0
	fi = open("testfile.npy", 'r')
	while(i<10):
		temp = numpy.load(fi)
		print temp
		if (i == 0):
			a = temp
			print a
		else:
			a = numpy.vstack((a,temp))
			print a
		i=i+1
	print a
		
def main():
	os.system('cls')
	testArrayLoading()


	
	
if __name__ == "__main__":
    main()	
