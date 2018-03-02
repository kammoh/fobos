#!/usr/bin/python
#This scripts takes raw power trace and calculates the t value for each traces sample wise

num_of_clks = 100 #num of clocks to in trace

clk_high = 0.20 #high clock voltage for drawing
clk_low = -0.20 #low clock voltage for drawing

CLK_YLIM_HIGH = 0.30
CLK_YLIM_LOW =  -0.30

import numpy as np
import matplotlib as mpl

#mpl.use('Agg')
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

#########################################################################CLOCK SIGNAL

print "Creating clock signal"
num_of_samples = raw_traces.shape[1]
print "Num of samples =" + str(num_of_samples)

period = num_of_samples / num_of_clks #clock period
d = 0 # Y offset of clock number obove clock signal
l = []
offset = 0
x_offset = period/2

for n in range(0, num_of_clks):
   plt.text(x_offset, clk_high + d, str(n))
   x_offset = x_offset + period
   for i in range(0,period/2):
      l.append(clk_high)
   for i in range(period/2,period):
      l.append(clk_low)

print "clk list lenght: " + str(len(l))

clk_list = np.array(l)


for trace in raw_traces:
   #print trace
   plt.plot(trace)
   #break

plt.ylim(CLK_YLIM_LOW, CLK_YLIM_HIGH)
plt.plot(clk_list, 'g')
plt.savefig(plot_file)
plt.show()

