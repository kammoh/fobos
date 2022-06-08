#!/usr/bin/python
#This scripts reads the raw traces provided by FOBOS and saves them as an NxM numpy array
#Author : Bakry Abdulgadir
#####################################################################################
import math
import numpy as np
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse


#load trace file
#use simple array first
#samples_per_trace = 4
#num_of_traces = 1000
#raw_traces0 = np.array([[1,2,3,4],[5,6,7,8],[9,10,11,12]])
#raw_traces1 = np.array([[1,2,3,4],[5,6,7,8],[9,10,11,12]])

#print raw_traces


def adjustSampleSize(sampleLength, dataArray):
		#print "\tAdjusting Sample Size to ->" + str(sampleLength)
		temp = dataArray.shape
		newDataArray = dataArray
		arrLen = temp[0]
		#print "Array Length --> " + str(arrLen)
		if (arrLen == sampleLength):
			
			return dataArray
			
		elif (arrLen > sampleLength):
			
			diff = arrLen-sampleLength
			for count in range(0,diff):
				newDataArray = np.delete(newDataArray, -1, 0)
			return newDataArray	
			
		elif (arrLen < sampleLength):
			
			diff = sampleLength-arrLen
			for count in range (0,diff):
				newDataArray = np.append(newDataArray,0)
			return newDataArray	
			
def detectSampleSize(file_name):
	"""
	This function calcualates the number of sample per trace. This is needed to do any paddig/truncation to make all 
	traces the same size. We iterate through the first 10 traces and get the max number of traces
	"""
	#print "DEBUG: Module: analysis, Function: detectSampleSize():"
	#print "----Detecting samples per trace"
	maxNumOfSamples = 0
	for traceCount in range (0,10):
		try:
			trace = np.load(file_name)
		except:
			print "You have less than 10 samples. It looks that the max number of samples is : " + str(maxNumOfSamples)
			return maxNumOfSamples
		numOfSamples = len(trace)
		if maxNumOfSamples < numOfSamples:
			maxNumOfSamples = numOfSamples
	print "It looks that the max number of samples in the first 10 traces is: " + str(maxNumOfSamples)
	return maxNumOfSamples
	
def read_raw_traces(file_name):
        print "Loading raw traces from file: " + file_name  
        print "Please wait ..."
	measurementFile = open(file_name, 'r')
	#Get sample size to adjust all traces to the same number of samples. A better solution is to get the data cleaned up upon acquistion.
        global samples_per_trace
	samples_per_trace = detectSampleSize(measurementFile)
	##create the array
	raw_traces = np.empty((num_of_traces, samples_per_trace))
	#samples_per_trace = 4000
	#need to reset file handle since we used it 
	measurementFile.seek(0)
	for traceCount in range (0,num_of_traces):
		#print "traceCount= " + str(traceCount)
		tempArrayMeasurement = np.load(measurementFile)
		tempArrayMeasurement = adjustSampleSize(samples_per_trace, tempArrayMeasurement)
		raw_traces[traceCount,:] = tempArrayMeasurement
	
	print "Loading done."
	return raw_traces



print "###### readtraces.py script"	
parser = argparse.ArgumentParser()
parser.add_argument("source_file", help="Traces from FOBOS dataAcquisition", type=str)
parser.add_argument("destination_file", help=".npy file that store traces as MxN Nupmy array.", type=str)
parser.add_argument("num_of_traces", help=".npy file that store traces as MxN Nupmy array.", type=int)
   
args = parser.parse_args()
source_file = args.source_file
num_of_traces = args.num_of_traces
destination_file = args.destination_file

raw_traces0 = read_raw_traces(source_file)
print "Saving file. Please wait ..."
np.save(destination_file, raw_traces0)
print "Done"
