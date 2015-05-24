#!/usr/bin/python
#############################################################################
#                                                                           #
#	Copyright 2015 CERG                                                     #
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

CHANNEL1_MEASUREMENT_FILE_NAME = "channel1Data.dat"
CHANNEL2_MEASUREMENT_FILE_NAME = "channel2Data.dat"
CHANNEL3_MEASUREMENT_FILE_NAME = "channel3Data.dat"
CHANNEL4_MEASUREMENT_FILE_NAME = "channel4Data.dat"

CHANNEL1_TRIGGER_MEASUREMENT_FILE_NAME = "channel1TriggerData.dat"
CHANNEL2_TRIGGER_MEASUREMENT_FILE_NAME = "channel2TriggerData.dat"
CHANNEL3_TRIGGER_MEASUREMENT_FILE_NAME = "channel3TriggerData.dat"
CHANNEL4_TRIGGER_MEASUREMENT_FILE_NAME = "channel4TriggerData.dat"

def clearScreen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )


def plotRawTrace(fileName, traceLowerBound, traceUpperBound):
	if os.path.exists(fileName):
		print "-> File Set - " + fileName
		dataToPlot = numpy.loadtxt(fileName)
		plotName = str(fileName)
		figs = plt.figure()	
		figs.suptitle(plotName, fontsize=14, fontweight='bold')
		toPlot = numpy.zeros(0)
		toPlot = numpy.transpose(dataToPlot)
		plt.hold(False)
		plt.clf()
		plt.plot(toPlot[traceLowerBound:traceUpperBound])
		plt.ylabel('volts')
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
	traceEndPoint = 2000000
##########################################################################
	plotRawTrace(CHANNEL1_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL2_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL3_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL4_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL1_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL2_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL3_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL4_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)

if __name__ == "__main__":
    main()	