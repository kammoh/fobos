#!/usr/bin/python
import os
import sys
import numpy
import cfg
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
	
def calculate_mean(measuredData, axis):
	if(cfg.analysisConfigAttributes['COMPUTE_MEAN'] == 'YES'):
		sys.stdout.write("Calculating Mean of Processed Data\n")
		measuredDataMean = numpy.mean(measuredData,axis)
		dataToPlot = numpy.transpose(measuredDataMean)
		plt.clf()
		plt.plot(dataToPlot)
		plt.ylabel('Mean')
		plt.xlabel('time')
		plt.title('Mean of Measured Data (Maximum Likelyhood)')
		plt.savefig("mean.png",dpi=72)
		return measuredDataMean
	else:
		pass
		
def calculate_std(measuredData,axis):
	if(cfg.analysisConfigAttributes['COMPUTE_STD'] == 'YES'):
		sys.stdout.write("Calculating Standard Deviation of Processed Data\n")
		measuredDataStd = numpy.std(measuredData,axis)
		dataToPlot =  numpy.transpose(measuredDataStd)
		plt.clf()
		plt.plot(dataToPlot)
		plt.ylabel('Standard Deviation')
		plt.xlabel('time')
		plt.title('Standard Deviation of Measured Data (Maximum Likelyhood)')
		plt.savefig("std.png",dpi=72)
		return measuredDataStd
	else:
		pass
		
def calculate_var(measuredData,axis):
	if(cfg.analysisConfigAttributes['COMPUTE_VAR'] == 'YES'):
		sys.stdout.write("Calculating Variance of Processed Data\n")
		measuredDataVar = numpy.var(measuredData,axis)
		dataToPlot = numpy.transpose(measuredDataVar)
		plt.clf()
		plt.plot(dataToPlot)
		plt.ylabel('Variance')
		plt.xlabel('time')
		plt.title('Variance of Measured Data (Maximum Likelyhood)')
		plt.savefig("var.png",dpi=72)
		return measuredDataVar
	else:
		pass
		
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
	elif(corrType == 'AUTOCORRELATION'):
		plt.plot(dataToPlot)
		plt.xlim(0, len(dataToPlot[0:]))
		plt.ylabel('Auto Correlation')
		plt.xlabel('time')
		plt.title('Autocorrelation Plot')
		plt.savefig("autocorrelation.png",dpi=72)
		
def correlation_pearson(measuredData, modeledData):
	if(cfg.analysisConfigAttributes['CORRELATION_PEARSONS'] == 'YES'):
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
	else:
		pass
		
def correlation_spearman(measuredData, modeledData):
	if(cfg.analysisConfigAttributes['CORRELATION_SPEARMAN'] == 'YES'):
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
	else:
		pass
		
def calculate_autocorrelation(measuredData):
	if(cfg.analysisConfigAttributes['COMPUTE_AUTOCORRELATION'] == 'YES'):
		sys.stdout.write("Calculating Autocorrelation for Measured data\n")
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
		plotCorr(corrMatrix, 'AUTOCORRELATION')
		return corrMatrix	
	else:
		pass
		
def main():
	os.system('cls')
	x = [[5,4,6,8,4],
		 [2,3,4,5,1]]
	y  = [[0],[1],[4],[6],[2]]
	print x
	z = numpy.zeros(0)
	z = numpy.append(z,2)
	z = numpy.append(z,4)
	t = numpy.delete(x,z,1)
	print t


	
	
if __name__ == "__main__":
    main()	