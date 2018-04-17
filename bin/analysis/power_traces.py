#!/usr/bin/python
#This script takes raw power traces and calculates the max and mean power for raw untruncated traces and sample-wise truncated traces
import math
import numpy as np
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse

# Get values from XXBX and FOBOS test bench
# set Vcc voltage of DUT
Vcc = 1.2
# set gain on XXBX chip
Gain = 25
# set resistor value (ohms)
R = 1

# compute power in watts = Vcc * Vs/Gain/R 
def computePower(Vs):
      return Vcc*(Vs/Gain/R)

# imported from read_traces()      
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

# imported from read_traces()			
def detectSampleSize(file_name):
	"""
	This function calcualates the number of sample per trace. This is needed to do any paddig/truncation to make all 
	traces the same size. We iterate through the first 10 traces and get the max number of traces
	"""
	print "DEBUG: Module: analysis, Function: detectSampleSize():"
	print "----Detecting samples per trace"
	maxNumOfSamples = 0
	for traceCount in range (0,10):
		try:
			trace = np.load(file_name)
		except:
			print "----You have less than 10 samples. It looks that the max number of samples is : " + str(maxNumOfSamples)
			return maxNumOfSamples
		numOfSamples = len(trace)
		if maxNumOfSamples < numOfSamples:
			maxNumOfSamples = numOfSamples
	print "----It looks that the max number of samples in the first 10 traces is: " + str(maxNumOfSamples)
	return maxNumOfSamples

# imported from read_traces()
def read_raw_traces(file_name):
        print "Loading rawtraces from file: " + file_name 
	measurementFile = open(file_name, 'r')
	#Get sample size to adjust all traces to the same number of samples. A better solution is to get the data cleaned up upon acquistion.
        global samples_per_trace
	samples_per_trace = detectSampleSize(measurementFile)
	#samples_per_trace = 4000
	#need to reset file handle since we used it 
	measurementFile.seek(0)
	for traceCount in range (0,num_of_traces):
		#print "traceCount= " + str(traceCount)
		tempArrayMeasurement = np.load(measurementFile)
		tempArrayMeasurement = adjustSampleSize(samples_per_trace, tempArrayMeasurement)
		if (traceCount == 0):
			raw_traces  = tempArrayMeasurement
			#print 'array length' + str(len(cfg.RAW_POWER_DATA))
			#print 'array length' + str(len(tempArrayMeasurement))
		elif (traceCount > 0):
			#print "DEBUG shape: " + str(tempArrayMeasurement.shape)
			#print 'array length cfg: ' + str(len(cfg.RAW_POWER_DATA)) 
			#print 'array length tmp: ' + str(len(tempArrayMeasurement)) + ' count= ' + str(traceCount)
			raw_traces  = np.vstack((raw_traces,tempArrayMeasurement))
	
	print "Loading done"
	return raw_traces

# start main program

parser = argparse.ArgumentParser()
parser.add_argument("source_file", help="Traces from FOBOS dataAcquisition", type=str)
parser.add_argument("destination_file", help="Mean and average power report", type=str)
parser.add_argument("num_of_traces", help="Total number of traces in this run", type=int)
parser.add_argument("start_sample", help="Sample on which power calculation starts for truncated traces", type=int)
parser.add_argument("end_sample", help="Sample on which power calculation ends for truncated traces", type=int)

args = parser.parse_args()
source_file = args.source_file
num_of_traces = args.num_of_traces
destination_file = args.destination_file
start_sample = args.start_sample
end_sample = args.end_sample

writeFile = open(destination_file, 'w') 
ostr = "Max and mean power computer"
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

raw_traces0 = read_raw_traces(source_file)

writeFile = open(destination_file, 'w') 
# established truncated numpy array [start_sample:end:sample]

raw_traces1 = np.zeros([num_of_traces-1,end_sample-start_sample])

# header

ostr = "Source File: " + source_file
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = "Number of Traces: " + str(num_of_traces)
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = "Start sample (for truncated traces): " + str(start_sample)
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = "End sample (for truncated traces): " + str(end_sample)
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = "Vcc (volts): " + str(Vcc)
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = "XBXX Gain" + str(Gain)
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = "XBXX resistance (ohms): " + str(R)
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

# truncate raw_traces0 to raw_traces1
for i in range (0,num_of_traces-1):
  raw_traces1[i,] = raw_traces0[i,start_sample:end_sample:1]
  
ostr =  "Maximum indices and power for untruncated traces:"
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

for i in range (0,num_of_traces-1):
  Vsa = np.argmax(raw_traces0[i,])
  ostr = 'Trace#: ' + str(i) + ' Sample#: ' + str(Vsa) + ' Measured Voltage: ' + str(raw_traces0[i,Vsa]) + 'V Computed Power: ' + str(computePower(raw_traces0[i,Vsa])) + 'W'
  print ostr
  ostr = ostr + '\n'
  writeFile.write(ostr)

ostr = 'Mean voltage for untruncated traces is: ' + str(np.mean(raw_traces0)) + 'V'
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = 'Mean power for untruncated traces is: ' + str(computePower(np.mean(raw_traces0))) + 'W'
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = "Maximum indices and power for truncated traces:"
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

for i in range (0,num_of_traces-1):
  Vsb = np.argmax(raw_traces1[i,])
  ostr = 'Trace#: ' + str(i) + ' Sample#: ' + str(Vsb) + ' Measured Voltage: ' + str(raw_traces1[i,Vsb]) + 'V Computed Power: ' + str(computePower(raw_traces1[i,Vsb])) + 'W' 
  print ostr
  ostr = ostr + '\n'
  writeFile.write(ostr)

ostr =   'Mean voltage for truncated traces is: ' + str(np.mean(raw_traces1)) + 'V'
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

ostr = 'Mean power for truncated traces is: ' + str(computePower(np.mean(raw_traces1))) + 'W'
print ostr
ostr = ostr + '\n'
writeFile.write(ostr)

writeFile.close()