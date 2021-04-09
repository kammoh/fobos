#!/usr/bin/python
#This scripts takes raw power trace and calculates the t value for each traces sample wise
import math
import numpy
#import matplotlib as mpl
#mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse
import os
import sys



def clearScreen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )

def append_mean(raw_traces, in_array, index, samples_per_trace):
#Takes trace array (each row is a trace)
#returns a one dimention array with each elemen = the mean of a column of the input 
   current_trace = index + 1
   out_array = []
   for sample_no in range(0, samples_per_trace):
       
      if (current_trace == 1): 
	  out_array.append(raw_traces[index, sample_no])
      else:
	 sum = ( in_array[sample_no] * (current_trace - 1) / current_trace ) + ( raw_traces[index, sample_no] / current_trace ) # weighted average
	 out_array.append(float(sum))
         #if (sample_no == 9000):
	 #   print index, current_trace, raw_traces[index, sample_no], in_array[sample_no], sum 
   return out_array   

def append_variance(raw_traces, mean_array, in_array, index, samples_per_trace):
#Takes trace array (each row is a trace)
#returns a one dimention array with each element = the variance of a column of the input
   current_trace = index + 1
   out_array = []
   for sample_no in range(0, samples_per_trace):
      if (current_trace == 1):
          sum = (raw_traces[index, sample_no] - mean_array[sample_no]) ** 2
          out_array.append(float(sum))
      else: 
	  sum = (in_array[sample_no] * (current_trace - 1) / current_trace ) + ((raw_traces[index, sample_no] - mean_array[sample_no]) ** 2)/current_trace 
	  out_array.append(float(sum))
   return out_array

def append_t_values(mean_array0, var_array0, mean_array1, var_array1, index, samples_per_trace):
#funtion takes the mean and variance arays and
#calcualtes the t-values (one dimenional array)
   current_trace = index + 1
   t_array = []
   n0 = current_trace
   n1 = current_trace
   for i in  range(0, samples_per_trace):
      m0 = mean_array0[i]
      m1 = mean_array1[i]
      s0 = var_array0[i]
      s1 = var_array1[i]
      if ((s0 == 0) and (s1 == 0)):
	t = 0  # prevent divide by zero
      else:	
	t = (m0 - m1) / math.sqrt( (s0/n0) + (s1/n1))
      t_array.append(t)
   return t_array


def main():
    start_ylim = -40
    end_ylim = 40

    start_xlim = 0
    end_xlim = 15000
    num_trace_estimates = 100
    estimate_periodicity = 5

    #load trace file
    #use simple array first
    #samples_per_trace = 25000
    num_of_traces = 9968
    #raw_traces0 = numpy.array([[1,2,3,4],[5,6,7,8],[9,10,11,12]])
    #raw_traces1 = numpy.array([[13,24,35,45],[15,61,71,18],[19,110,131,12]])
    parser = argparse.ArgumentParser()
    parser.add_argument("trace_file0", help=".npy file that store traces as MxN Nupmy array", type=str)
    parser.add_argument("trace_file1", help=".npy file that store traces as MxN Nupmy array", type=str)
    parser.add_argument("plot_file", help="File name to store the output figure", type=str)
    args = parser.parse_args()
    trace_file0 = args.trace_file0
    trace_file1 = args.trace_file1
    plot_file = args.plot_file
      
      
    raw_traces0 = numpy.load(trace_file0)
    raw_traces1 = numpy.load(trace_file1)
    #num_of_traces = raw_traces0.shape[0]
    samples_per_trace = raw_traces0.shape[1]
    t_array = numpy.zeros((num_of_traces, samples_per_trace))

    #print "num_of_traces=", num_of_traces
    print "samples_per_trace=", samples_per_trace
    trace_vector = []
    mean_array0 = []
    mean_array1 = []
    var_array0 = []
    var_array1 = []
    
    for i in range(0, num_of_traces):
      trace_vector.append(i)
      mean_array0 = append_mean(raw_traces0, mean_array0, i, samples_per_trace)
      mean_array1 = append_mean(raw_traces1, mean_array1, i, samples_per_trace)
      var_array0 = append_variance(raw_traces0, mean_array0, var_array0, i, samples_per_trace)
      var_array1 = append_variance(raw_traces1, mean_array1, var_array1, i, samples_per_trace)
      t_array[i,] = append_t_values(mean_array0, var_array0, mean_array1, var_array1, i, samples_per_trace)
      print i, mean_array0[7900], mean_array1[7900], var_array0[7900], var_array1[7900], t_array[i,7900]
      
      
    #print t_array.ndim
    #print t_array.size
    tt_array = t_array.T
    #print tt_array.ndim
    #print tt_array.size

    plot_array = tt_array[7900,]
    print plot_array

    plotName = 'Test Plot'
    #clearScreen()
    figs = plt.figure()

    figs.suptitle(plotName, fontsize=14, fontweight='bold')
    plt.hold(False)
    plt.clf()
    plt.title(plotName)
    plt.grid(b=True, which='Major', color = 'b', linestyle = '--')
    plt.plot(trace_vector, plot_array, color='r')
    plt.xlabel("# of traces")
    plt.ylabel("t-value")
    #plt.ylim(2.2, 2.3)
    plt.show()
    #fig1.savefig('mean0.png')
    #plt.plot(plot_array)
    #plt.show()

    #plt.plot(var_array0)
    #plt.plot(var_array1)
    #threshold = [4.5] * samples_per_trace
    #minus_threshold = [-4.5] * samples_per_trace
    #plt.plot(threshold, color='b')
    #plt.plot(minus_threshold, color='b')

    #plt.ylim(start_ylim, end_ylim)
    #plt.xlim(start_xlim, end_xlim)
    #plt.xlabel("Sample No.")
    #plt.ylabel("t-value")
    #plt.plot(t_array[num_trace_estimates-1,], color='r')
    #plt.savefig(plot_file)

if __name__ == "__main__":
    main()	