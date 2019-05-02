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

class TtestOnline():
   
   def __init__(self, numSamples, threshold = 4.5):
      self.k0 = np.zeros((1, numSamples))
      self.M0 = np.zeros((1, numSamples))
      self.S0 = np.zeros((1, numSamples))
      self.k1 = np.zeros((1, numSamples))
      self.M1 = np.zeros((1, numSamples))
      self.S1 = np.zeros((1, numSamples))
      self.threshold = threshold
      self.numSamples = numSamples

   def addTrace(self, x, setNum):
      #global k0
      #global M0
      #global S0
      if setNum == 0: 
         self.k0 += 1
         newM0 = self.M0 + (x - self.M0) * 1./ self.k0
         newS0 = self.S0 + (x - self.M0) * (x - newM0)
         self.M0, self.S0 = newM0, newS0
      else:
         self.k1 += 1
         newM1 = self.M1 + (x - self.M1) * 1./ self.k1
         newS1 = self.S1 + (x - self.M1) * (x - newM1)
         self.M1, self.S1 = newM1, newS1

   def calcTvalues(self):
      var0 = self.S0 / (self.k0 - 1)
      var1 = self.S1 / (self.k1 - 1)
      t_array = (self.M0 - self.M1)/ np.sqrt(var0/self.k0 + var1/self.k1)
      #print t_array.shape
      #print t_array
      ##check if test passed
      passed = (t_array > self.threshold).sum() == 0
      return t_array.reshape(t_array.shape[1]), passed

   def plot(self, fileName):
      plt.clf()
      t_array, passed = self.calcTvalues()
      threshold = [self.threshold] * self.numSamples
      minus_threshold = [-1 * self.threshold] * self.numSamples
      plt.plot(threshold, color='b')
      plt.plot(minus_threshold, color='b')
      plt.ylim(start_ylim, end_ylim)
      plt.xlim(start_xlim, end_xlim)
      plt.xlabel("Sample No.")
      plt.ylabel("t-value")
      plt.plot(t_array, color='r')
      plt.savefig(fileName)


def ttestOnline(traces0, traces1, numTraces):
   numSamples = traces0.shape[1]
   traces0 = traces0[0:numTraces,:]
   traces1 = traces1[0:numTraces,:]
   ttest = TtestOnline(numSamples)
   for i in range(numTraces):
      x0 = traces0[i, :]
      x1 = traces1[i, :]
      ttest.addTrace(x0, 0)
      ttest.addTrace(x1, 1)
      if i  % 500 == 0 and i > 1:
         print(i)
         #print(ttest.k0, ttest.k1)\
         ttest.plot("fig-{}.png".format(i))
   t_array, passed = ttest.calcTvalues()
   print("T-test passed= {}".format(passed))
   return t_array


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