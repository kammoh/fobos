#!/usr/bin/python
#This scripts takes raw power trace and calculates the t value for each traces sample wise
import numpy as np
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse


#load trace file
#use simple array first
#samples_per_trace = 4
#num_of_traces = 1000
#raw_traces0 = np.array([[2,2,2,2],[3,3,3,3],[4,4,4,4]])
#raw_traces1 = np.array([[1,2,3,4],[5,6,7,8],[9,10,11,12]])

#print raw_traces
parser = argparse.ArgumentParser()
parser.add_argument("trace_file", help=".npy file that store traces as MxN Nupmy array", type=str)
parser.add_argument("plot_file", help="File name where the plot is stored", type=str)
args = parser.parse_args()
trace_file = args.trace_file
plot_file = args.plot_file

raw_traces = np.load(trace_file)
print raw_traces.shape
   
#raw_traces0 = read_raw_traces("rawDataAligned0.npy")
#raw_traces1 = read_raw_traces("rawDataAligned1.npy")
#print t_array
for trace in raw_traces:
   #print trace
   plt.plot(trace)
plt.savefig(plot_file)
