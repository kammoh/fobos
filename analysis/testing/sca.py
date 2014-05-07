#!/usr/bin/python
import os
import sys
import numpy
import matplotlib.pyplot as plt
import scipy.stats.stats as statModule

def findMaxValuesCorr(correlationMatrix, corrType):
	corrMat = numpy.transpose(correlationMatrix)
	maxValue = numpy.zeros(0)
	maxIndex = numpy.zeros(0)
	maxValue = numpy.append(maxValue, numpy.amax(corrMat, 0))
	maxIndex = numpy.append(maxIndex, numpy.argmax(corrMat, 0))
	if (corrType == 'PEARSON'):
		fid = open("correlation_pearson.txt", "w")
	elif(corrType == 'SPEARMAN'):
		fid = open("correlation_spearman.txt", "w")
	count = 0
	string = ""
	while(count < len(maxIndex)):
		string += "Window[" +str(int(count))+ "] Key Byte- " + str(hex(int(maxIndex[count]))) + " [" + str(int(maxIndex[count])) + "] Correlation- "+ str(maxValue[count])+ "\n"
		count += 1
	fid.write(string)
	fid.close()
	
def calculate_mean(measuredData):
	sys.stdout.write("Calculating Mean of Processed Data\n")
	measuredDataMean = numpy.mean(measuredData,0)
	dataToPlot = numpy.transpose(measuredDataMean)
	plt.clf()
	plt.plot(dataToPlot)
	plt.ylabel('Mean')
	plt.xlabel('time')
	plt.title('Mean of Measured Data (Maximum Likelyhood)')
	plt.savefig("mean.png",dpi=72)
	return measuredDataMean

def calculate_std(measuredData):
	sys.stdout.write("Calculating Standard Deviation of Processed Data\n")
	measuredDataStd = numpy.std(measuredData,0)
	dataToPlot =  numpy.transpose(measuredDataStd)
	plt.clf()
	plt.plot(dataToPlot)
	plt.ylabel('Standard Deviation')
	plt.xlabel('time')
	plt.title('Standard Deviation of Measured Data (Maximum Likelyhood)')
	plt.savefig("std.png",dpi=72)
	return measuredDataStd
	
def calculate_var(measuredData):
	sys.stdout.write("Calculating Variance of Processed Data\n")
	measuredDataVar = numpy.var(measuredData,0)
	dataToPlot = numpy.transpose(measuredDataVar)
	plt.clf()
	plt.plot(dataToPlot)
	plt.ylabel('Variance')
	plt.xlabel('time')
	plt.title('Variance of Measured Data (Maximum Likelyhood)')
	plt.savefig("var.png",dpi=72)
	return measuredDataVar

def plotCorr(corrMatrix, corrType):
	dataToPlot = numpy.transpose(corrMatrix)
	plt.hold(False)
	if(corrType == 'PEARSON'):
		plt.plot(dataToPlot)
		plt.xlim(0,255)
		plt.ylabel('Pearson r value')
		plt.xlabel('Key Byte')
		plt.title('Correlation vs Key Guess (BYTE)')
		plt.savefig("pearson.png",dpi=72)
	elif(corrType == 'SPEARMAN'):
		plt.plot(dataToPlot)
		plt.xlim(0,255)
		plt.ylabel('Spearman RHO value')
		plt.xlabel('Key Byte')
		plt.title('Correlation vs Key Guess (BYTE)')
		plt.savefig("spearman.png",dpi=72)
		
def correlation_pearson(measuredData, modeledData):
	sys.stdout.write("Calculating Pearson's r between Measured and Modelled Data\n")
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
	plotCorr(corrMatrix, 'PEARSON')	
	findMaxValuesCorr(corrMatrix, 'PEARSON')
	return corrMatrix
	
def correlation_spearman(measuredData, modeledData):
	sys.stdout.write("Calculating Spearman's RHO between Measured and Modelled Data\n")
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
	plotCorr(corrMatrix, 'SPEARMAN')
	findMaxValuesCorr(corrMatrix, 'SPEARMAN')
	return corrMatrix	
	
def main():
	os.system('cls')
	x = [[5,4,6,8,4],
		 [2,3,4,5,1]]
	y  = [[0],[1],[4],[6],[2]]
	print x
	m = calculate_mean(x)
	s = calculate_std(x)
	v = calculate_var(x)
	print m
	print s
	print v

	
	
if __name__ == "__main__":
    main()	