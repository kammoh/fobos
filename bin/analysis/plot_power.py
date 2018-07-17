#!/usr/bin/python
#This scripts takes raw power trace plots a graph
#It can also plot a clock signal on top of the power signal and number the clocks
#if there is a state file, it can print the state on the graph

#Author: Bakry Abdulgadir
#Date : Jan 2018
##########GENERAL SETTINGS
start_ylim  = -1.5 #Plot ymlim range
end_ylim    = 1.5
##########END GENERAL SETTINGS
###########CLK GRAPH SETTINGS
display_clk = "YES"# 'YES' | 'NO' Enable/Disable clock plotting
num_of_clks = 2717   #num of clocks to in trace
clk_high    = 1.20   #high clock voltage for plotting
clk_low     = 1.00  #low clock voltage for plotting
state_file  = 'state_file.txt' #file_name | NONE #text file that includes states. One state in each line.
###END CLK GRAPH SETTINGS


import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import argparse


parser = argparse.ArgumentParser()
parser.add_argument("trace_file", help=".npy file that store traces as MxN Nupmy array", type=str)
parser.add_argument("plot_file", help="File name where the plot is stored", type=str)
args = parser.parse_args()
trace_file = args.trace_file
plot_file = args.plot_file

raw_traces = np.load(trace_file)
print raw_traces.shape
   
num_of_samples = raw_traces.shape[1]
#########################################################################CLOCK SIGNAL PLOTTING
if display_clk == "YES":
   states = []
   if state_file != "NONE" :
      f = open(state_file, 'r')
      states = f.readlines()
      f.close()

   period = num_of_samples / float(num_of_clks) #clock period
   d = 0 # Y offset of clock number obove clock signal
   l = []
   offset = 0
   x_offset = period/2
   print "period/2 =" + str(period/2)
   i = 0
   clk_is_high = True
   for n in range(0, num_of_clks * 2):
      if(n%2 ==0):
         plt.text(x_offset, clk_high + d, str(n/2 + 1))
         if n/2 < len(states):
            plt.text(x_offset, clk_high  , "S" + str(states[n/2]))  #print states on the plot
         x_offset = x_offset + period
      next_change = int((n + 1) * period/2)
      for j in range(i, next_change):
         if(clk_is_high== True):
            l.append(clk_high)
         else:
            l.append(clk_low)
      clk_is_high = not clk_is_high
      i = next_change
   print "clk list lenght: " + str(len(l))
   clk_list = np.array(l)
   plt.plot(clk_list, color= 'g')
##############################################################################PLOTTING

for trace in raw_traces:
    #print trace
    plt.plot(trace)
    #break
plt.title("Power Trace")
plt.xlabel("Sample No.")
plt.ylabel("")
plt.ylim(start_ylim, end_ylim)
#plt.savefig(plot_file)
print "before show"
plt.show()
print "after"



