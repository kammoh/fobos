#!/usr/bin/python
##############################################################################
#                                                                            #
#	Copyright 2018 Cryptographic Engineering Research Group (CERG)           #
#	George Mason University							                         #	
#   http://cryptography.gmu.edu/fobos                                        #                            
#									                                         #
#	Licensed under the Apache License, Version 2.0 (the "License");        	 #
#	you may not use this file except in compliance with the License.       	 #
#	You may obtain a copy of the License at                                	 #
#	                                                                       	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                         	 #
#	                                                                       	 #
#	Unless required by applicable law or agreed to in writing, software    	 #
#	distributed under the License is distributed on an "AS IS" BASIS,      	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#	See the License for the specific language governing permissions and      #
#	limitations under the License.                                           #
#                                                                          	 #
##############################################################################
#This scripts takes raw power trace and calculates the t value for each traces sample wise
import math
import numpy
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse
start_ylim = -40
end_ylim = 40

start_xlim = 0
end_xlim = 15000


#load trace file
#use simple array first
#samples_per_trace = 25000
num_of_traces = 1929
#raw_traces0 = numpy.array([[1,2,3,4],[5,6,7,8],[9,10,11,12]])
#raw_traces1 = numpy.array([[13,24,35,45],[15,61,71,18],[19,110,131,12]])

	
def get_mean(raw_traces):
#Takes trace array (each row is a trace)
#returns a one dimention array with each elemen = the mean of a column of the input 
   samples_per_trace = raw_traces.shape[1]
   mean_array = []
   for sample_no in range(0, samples_per_trace):
      sum = 0
      for trace_no in range(0, num_of_traces):
         sum += raw_traces[trace_no,sample_no]
      mean_array.append(sum/num_of_traces)

   return mean_array


def get_variance(raw_traces, mean_array):
#Takes trace array (each row is a trace)
#returns a one dimention array wi`th each element = the variance of a column of the input 
   samples_per_trace = raw_traces.shape[1]
   var_array = []
   for sample_no in range(0, samples_per_trace):
      sum = 0
      for trace_no in range(0, num_of_traces):
         sum += (raw_traces[trace_no,sample_no] - mean_array[sample_no])**2
      var_array.append(float(sum)/num_of_traces)

   return var_array


def get_t_values(mean_array0, var_array0, mean_array1, var_array1, num_of_traces):
#funtion takes the mean and variance arays and
#calcualtes the t-values (one dimenional array)
   samples_per_trace = len(mean_array0)
   print "SAMPLES PER TRACE=" , samples_per_trace
   t_array = []
   n0 = num_of_traces
   n1 = num_of_traces
   for i in  range(0, samples_per_trace):
      m0 = mean_array0[i]
      m1 = mean_array1[i]
      s0 = var_array0[i]
      s1 = var_array1[i]
      t = (m0 - m1) / math.sqrt( (s0/n0) + (s1/n1))
      t_array.append(t)
   return t_array

def createTFile(traceFile0, traceFile1, plotFile, dstFile):
   
   
   raw_traces0 = numpy.load(traceFile0)
   raw_traces1 = numpy.load(traceFile1)
   #num_of_traces = raw_traces0.shape[0]
   samples_per_trace = raw_traces0.shape[1]
   #print "num_of_traces=", num_of_traces
   print "samples_per_trace=", samples_per_trace
   mean_array0 =  get_mean(raw_traces0)
   mean_array1 =  get_mean(raw_traces1)
   var_array0 = get_variance(raw_traces0, mean_array0)
   var_array1 = get_variance(raw_traces1, mean_array1)
   t_array = get_t_values(mean_array0,var_array0, mean_array1, var_array1, num_of_traces)
   #fig1 = plt.figure()
   #fig1.plot(mean_array0)
   #fig1.savefig('mean0.png')
   #plt.plot(mean_array1)
   #plt.plot(var_array0)
   #plt.plot(var_array1)
   threshold = [4.5] * samples_per_trace
   minus_threshold = [-4.5] * samples_per_trace
   plt.plot(threshold, color='b')
   plt.plot(minus_threshold, color='b')

   plt.ylim(start_ylim, end_ylim)
   plt.xlim(start_xlim, end_xlim)
   plt.xlabel("Sample No.")
   plt.ylabel("t-value")
   plt.plot(t_array, color='r')
   #plt.show()
   plt.savefig(plotFile)

   ###
   numpy.save(dstFile, numpy.array(t_array).transpose()) ##need to get one row array
   #
