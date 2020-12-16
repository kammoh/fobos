#!/usr/bin/python
#############################################################################
#                                                                           #
#	Copyright 2016 CERG                                                     #
#	                                                                        #
#	Licensed under the Apache License, Version 2.0 (the "License");         #
#	you may not use this file except in compliance with the License.        #
#	You may obtain a copy of the License at                                 #
#	                                                                        #
#	    http://www.apache.org/licenses/LICENSE-2.0                          #
#	                                                                        #
#	Unless required by applicable law or agreed to in writing, software     #
#	distributed under the License is distributed on an "AS IS" BASIS,       #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#	See the License for the specific language governing permissions and     #
#	limitations under the License.                                          #
#                                                                           #
#############################################################################


import os
import sys
import numpy
import matplotlib.pyplot as plt

########################################################################
######## SUB MACROS ####################################################
########################################################################

PLOT_TEXT_FILE_NAME = "power_text.txt"
sample_length = 16007

def clearScreen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )


def plotRawTrace(power_array, traceLowerBound, traceUpperBound):
		dataToPlot = power_array
		plotName = "Power Array"
		figs = plt.figure()	
		figs.suptitle(plotName, fontsize=14, fontweight='bold')
		toPlot = numpy.zeros(0)
		toPlot = numpy.transpose(dataToPlot)
		plt.hold(False)
		plt.clf()
		plt.plot(toPlot[traceLowerBound:traceUpperBound])
		plt.ylabel('mW')
		plt.xlabel('time')
		plt.title(plotName)
		plt.grid(b=True, which='Major', color = 'b', linestyle = '--')
		plt.show()

def main():	
	clearScreen()
	print "Plotting Trace Sets"
##########################################################################
##########  USER DEFINED VARIABLES. EDIT ONLY THESE VARIABLES ############
##########################################################################
	traceStartPoint = 0
	traceEndPoint = 16007
##########################################################################
	#plotRawTrace(CHANNEL1_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
  
        power_array = numpy.zeros(traceEndPoint)
        readfile = open(PLOT_TEXT_FILE_NAME,'r')
	for i in range (0, traceEndPoint):
	    readline = readfile.readline()
	    power_array[i] = float(readline[0:len(readline)-1])*1000
	    
	plotRawTrace(power_array, traceStartPoint, traceEndPoint)
	
if __name__ == "__main__":
    main()	