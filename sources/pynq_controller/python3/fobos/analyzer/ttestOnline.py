#!/usr/bin/python
#This scripts takes raw power trace and calculates the t value for each traces sample wise
import math
import numpy as np
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse
start_ylim = -40
end_ylim = 40

start_xlim = 0
end_xlim = 1000

k0 = None
M0 = None
S0 = None
k1 = None
M1 = None
S1 = None

def update(x0, x1):
   global k0
   global M0
   global S0
   k0 += 1
   newM0 = M0 + (x0 - M0) * 1./ k0
   newS0 = S0 + (x0 - M0) * (x0 - newM0)
   M0, S0 = newM0, newS0
   global k1
   global M1
   global S1
   k1 += 1
   newM1 = M1 + (x1 - M1) * 1./ k1
   newS1 = S1 + (x1 - M1) * (x1 - newM1)
   M1, S1 = newM1, newS1

   #print(M0)
   #print(M1)

def ttestOnline(traces0, traces1, numTraces):
   numSamples = traces0.shape[1]
   from scipy import stats
   traces0 = traces0[0:numTraces,:]
   traces1 = traces1[0:numTraces,:]
   for i in range(numTraces):
      x0 = traces0[i, :]
      x1 = traces1[i, :]
      update(x0, x1)
   var0 = S0 / (k0 - 1)
   var1 = S1 / (k1 - 1)
   n = traces0.shape[0]
   t_array = (M0 - M1)/ np.sqrt(var0/n + var1/n)
   print t_array.shape
   print t_array
   return t_array.reshape(numSamples)

def ttest(traces0, traces1, numTraces):
   from scipy import stats
   traces0 = traces0[0:numTraces,:]
   traces1 = traces1[0:numTraces,:]
   numSamples = traces0.shape[1]
   t = np.empty((numSamples))
   for i in range(numSamples):
      t[i] = stats.ttest_ind(traces0[:,i], traces1[:,i])[0]
   return t

def main():

   parser = argparse.ArgumentParser()
   parser.add_argument("trace_file0", help=".npy file that store traces as MxN Nupmy array", type=str)
   parser.add_argument("trace_file1", help=".npy file that store traces as MxN Nupmy array", type=str)
   parser.add_argument("plot_file", help="File name to store the output figure", type=str)
   args = parser.parse_args()
   trace_file0 = args.trace_file0
   trace_file1 = args.trace_file1
   plot_file = args.plot_file
   
   raw_traces0 = np.load(trace_file0)
   raw_traces1 = np.load(trace_file1)
   #raw_traces0 = np.array([[1,2,3,4], [5,6,7,8], [9, 10, 11, 12]])
   #num_of_traces = raw_traces0.shape[0]
   samples_per_trace = raw_traces0.shape[1]
   print "samples_per_trace=", samples_per_trace
   global k0
   global M0
   global S0
   global k1
   global M1
   global S1
   k0 = np.zeros((1, samples_per_trace))
   M0 = np.zeros((1, samples_per_trace))
   S0 = np.zeros((1, samples_per_trace))
   
   k1 = np.zeros((1, samples_per_trace))
   M1 = np.zeros((1, samples_per_trace))
   S1 = np.zeros((1, samples_per_trace))
   
   t_array = ttestOnline(raw_traces0, raw_traces1, 4000)
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
   plt.savefig(plot_file)

if __name__ == '__main__':
   main()