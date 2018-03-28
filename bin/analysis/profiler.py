#!/usr/bin/python
#This scripts takes t-values as a numpy array creates a plot.
#It can also plot a clock signal on top of the t-values. 
#Author: Bakry Abdulgadir
#Date : Jan 2018
##########GENERAL SETTINGS
start_ylim  = -40  #Plot ymlim range
end_ylim    = 40
##########END GENERAL SETTINGS
###########CLK GRAPH SETTINGS
display_clk = 'YES' #Enable/Disable clock plotting
num_of_clks = 10   #num of clocks to in trace
clk_high    = 5   #high clock voltage for plotting
clk_low     = -5  #low clock voltage for plotting
#state_file  = 'state_file.txt' #text file that includes states. One state in each line.
###END CLK GRAPH SETTINGS

import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
import argparse

def plotTValues(t_values_file, plot_file, state_file):

   t_values = np.load(t_values_file)
   print t_values.shape


   num_of_samples = t_values.shape[0]

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

   threshold = [4.5] * num_of_samples
   minus_threshold = [-4.5] * num_of_samples
   plt.plot(threshold, color='b')
   plt.plot(minus_threshold, color='b')

   plt.ylim(start_ylim, end_ylim)
   #plt.xlim(start_xlim, end_xlim)
   plt.xlabel("Sample No.")
   plt.ylabel("t-value")
   plt.title("T-Test Results")
   plt.plot(t_values, color='r')
   plt.savefig(plot_file)

   plt.show()


if __name__ == "__main__":
   
   parser = argparse.ArgumentParser()
   parser.add_argument("t_values", help="A .npy file that store traces as Nx1 Nupmy array that contains t-values.", type=str)
   parser.add_argument("plot_file", help="File name where the plot is saved", type=str)
   args = parser.parse_args()
   t_values_file = args.t_values
   plot_file = args.plot_file
   plotTValues(t_values_file, plot_file)
