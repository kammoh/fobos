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

CHANNEL1_MEASUREMENT_FILE_NAME = "powerTraces.npy"
CHANNEL2_MEASUREMENT_FILE_NAME = "channel2Data.npy"
CHANNEL3_MEASUREMENT_FILE_NAME = "channel3Data.npy"
CHANNEL4_MEASUREMENT_FILE_NAME = "channel4Data.npy"

CHANNEL1_TRIGGER_MEASUREMENT_FILE_NAME = "channel1TriggerData.npy"
CHANNEL2_TRIGGER_MEASUREMENT_FILE_NAME = "channel2TriggerData.npy"
CHANNEL3_TRIGGER_MEASUREMENT_FILE_NAME = "channel3TriggerData.npy"
CHANNEL4_TRIGGER_MEASUREMENT_FILE_NAME = "channel4TriggerData.npy"

def clearScreen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )


def plotRawTrace(fileName, traceLowerBound, traceUpperBound):
	if os.path.exists(fileName):
		print("-> File Set - " + fileName)
		dataToPlot = numpy.load(fileName)
		plotName = str(fileName)
		figs = plt.figure()
		figs.suptitle(plotName, fontsize=14, fontweight='bold')
		toPlot = numpy.zeros(0)
		toPlot = numpy.transpose(dataToPlot)
		#plt.hold(False)
		plt.clf()
		plt.plot(toPlot[traceLowerBound:traceUpperBound])
		plt.ylabel('volts')
		plt.xlabel('time')
		plt.title(plotName)
		plt.grid(b=True, which='Major', color = 'b', linestyle = '--')
		#plt.show()
		plt.savefig('traces_one.png')

def plotRawTraceAverageOverTraces(fileName, traceLowerBound, traceUpperBound, numTraces):
	if os.path.exists(fileName):
		print("-> File Set - " + fileName)
		traceData = []
		file = open(fileName, "rb")
		#iters = numpy.load(fileName).shape[0]

		file.seek(0)
		for iter in range(0, numTraces):
			traceData.append(numpy.load(file))

		dataToPlot = numpy.mean(traceData, axis = 0)

		plotName = str(fileName + ": All Traces Averaged")
		figs = plt.figure()	
		figs.suptitle(plotName, fontsize=14, fontweight='bold')
		toPlot = numpy.zeros(0)
		toPlot = numpy.transpose(dataToPlot)
		#plt.hold(False)
		plt.clf()
		plt.plot(toPlot[traceLowerBound:traceUpperBound])
		plt.ylabel('volts')
		plt.xlabel('time')
		plt.title(plotName)
		plt.grid(b=True, which='Major', color = 'b', linestyle = '--')
		#plt.show()
		plt.savefig('traces_averaged.png')


def main():	
	clearScreen()
	print("Plotting Trace Sets")
##########################################################################
##########  USER DEFINED VARIABLES. EDIT ONLY THESE VARIABLES ############
##########################################################################
	traceStartPoint = 0
	traceEndPoint = 2000000
##########################################################################
	plotRawTrace(CHANNEL1_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTraceAverageOverTraces(CHANNEL1_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint, 2000)
	plotRawTrace(CHANNEL2_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL3_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL4_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL1_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL2_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL3_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)
	plotRawTrace(CHANNEL4_TRIGGER_MEASUREMENT_FILE_NAME, traceStartPoint, traceEndPoint)

if __name__ == "__main__":
    main()	
