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

def get_mean(raw_traces, start_trace, end_trace, samples_per_trace):
#Takes trace array (each row is a trace)
#returns a one dimention array with each elemen = the mean of a column of the input 
   mean_array = []
   for sample_no in range(0, samples_per_trace):
      sum = 0
      for trace_no in range(start_trace, end_trace):
         sum += raw_traces[trace_no,sample_no]
      mean_array.append(sum/(end_trace - start_trace))
   return mean_array   

def get_variance(raw_traces, mean_array, start_trace, end_trace, samples_per_trace):
#Takes trace array (each row is a trace)
#returns a one dimention array with each element = the variance of a column of the input 
   var_array = []
   for sample_no in range(0, samples_per_trace):
      sum = 0
      for trace_no in range(start_trace, end_trace):
         sum += (raw_traces[trace_no,sample_no] - mean_array[sample_no])**2
      var_array.append(float(sum)/(end_trace - start_trace))

   return var_array


def get_t_values(mean_array0, var_array0, mean_array1, var_array1, num_of_traces, samples_per_trace):
#funtion takes the mean and variance arays and
#calcualtes the t-values (one dimenional array)
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


def main():
    start_ylim = -40
    end_ylim = 40

    start_xlim = 0
    end_xlim = 14500
    num_trace_estimates = 100
    estimate_periodicity = 5

    #load trace file
    #use simple array first
    #samples_per_trace = 25000
    num_of_traces = 996
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
    t_array = numpy.zeros((num_trace_estimates, samples_per_trace))

    #print "num_of_traces=", num_of_traces
    print "samples_per_trace=", samples_per_trace
    trace_vector = []
    for i in range(0, num_trace_estimates):

      upper_limit = num_of_traces - num_trace_estimates * estimate_periodicity + (i + 1) * estimate_periodicity
      print upper_limit
      trace_vector.append(upper_limit)
      mean_array0 =  get_mean(raw_traces0, 0, upper_limit, samples_per_trace)
      mean_array1 =  get_mean(raw_traces1, 0, upper_limit, samples_per_trace)
      var_array0 = get_variance(raw_traces0, mean_array0, 0, upper_limit, samples_per_trace)
      var_array1 = get_variance(raw_traces1, mean_array1, 0, upper_limit, samples_per_trace)
      t_array[i,] = get_t_values(mean_array0,var_array0, mean_array1, var_array1, upper_limit, samples_per_trace)

      
    #print t_array.ndim
    #print t_array.size
    tt_array = t_array.T
    #print tt_array.ndim
    #print tt_array.size

    plot_array = tt_array[9000,]
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