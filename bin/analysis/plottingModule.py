#!/usr/bin/python
#############################################################################
#                                                                           #
#	Copyright 2014 CERG                                                     #
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
import cfg,globals, printFunctions
import re
import configExtract
import matplotlib.pyplot as plt
import support


	
def plotCorr(corrMatrix, corrType):
	dataToPlot = numpy.transpose(corrMatrix)
	figs = plt.figure()	
	figs.suptitle('Measured Traces', fontsize=14, fontweight='bold')
	plt.hold(False)
	plt.clf()
	if(corrType == globals.PEARSON):
		printFunctions.printToScreenAndAnalysisLog("Plotting Pearson's Correlation Values vs Key guess")
		runNo = 1
		cfg.PEARSON_GRAPH_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.PEARSON_GRAPH_FILE_NAME)
		while os.path.exists(cfg.PEARSON_GRAPH_FILE):
			runNo += 1
			cfg.PEARSON_GRAPH_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.PEARSON_GRAPH_FILE_NAME)		
		
		printFunctions.printToAnalysisLog("Plotting Correlation Values (Pearson's r) to PNG file - " + cfg.PEARSON_GRAPH_FILE) 
		plt.plot(dataToPlot)
		plt.xlim(0,255)
		plt.ylabel('Pearson r value')
		plt.xlabel('Key Byte')
		plt.title('Correlation vs Key Guess (BYTE)')
		plt.savefig(cfg.PEARSON_GRAPH_FILE,dpi=100)
		if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
			plt.savefig(support.shiftPathToGraphFolder(cfg.PEARSON_GRAPH_FILE.replace("png", "pdf")),dpi=100)
			plt.savefig(support.shiftPathToGraphFolder(cfg.PEARSON_GRAPH_FILE.replace("png", "eps")),dpi=100)
	elif(corrType == globals.SPEARMAN):
		printFunctions.printToScreenAndAnalysisLog("Plotting Spearman's Correlation Values vs Key guess")
		runNo = 1
		cfg.SPEARMAN_GRAPH_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.SPEARMAN_GRAPH_FILE_NAME)
		while os.path.exists(cfg.SPEARMAN_GRAPH_FILE):
			runNo += 1
			cfg.SPEARMAN_GRAPH_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.SPEARMAN_GRAPH_FILE_NAME)		
		printFunctions.printToAnalysisLog("Plotting Correlation Values (Spearman's RHO) to PNG file - " + cfg.SPEARMAN_GRAPH_FILE)
		plt.plot(dataToPlot)
		plt.xlim(0,255)
		plt.ylabel('Spearman RHO value')
		plt.xlabel('Key Byte')
		plt.title('Correlation vs Key Guess (BYTE)')
		plt.savefig(cfg.SPEARMAN_GRAPH_FILE,dpi=100)
		if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
			plt.savefig(support.shiftPathToGraphFolder(cfg.SPEARMAN_GRAPH_FILE.replace("png","pdf")),dpi=100)
			plt.savefig(support.shiftPathToGraphFolder(cfg.SPEARMAN_GRAPH_FILE.replace("png","eps")),dpi=100)
	elif(corrType == 'AUTOCORRELATION'):	
		printFunctions.printToScreenAndAnalysisLog("Plotting AutoCorrelation Values of data")
		runNo = 1
		cfg.AUTOCORR_GRAPH_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.AUTOCORR_GRAPH_FILE_NAME)
		while os.path.exists(cfg.AUTOCORR_GRAPH_FILE):
			runNo += 1
			cfg.AUTOCORR_GRAPH_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.AUTOCORR_GRAPH_FILE_NAME)		
		printFunctions.printToAnalysisLog("Plotting Auto-Correlation Values to PNG file - " + cfg.AUTOCORR_GRAPH_FILE)
		plt.plot(dataToPlot)
		plt.xlim(0, len(dataToPlot[0:]))
		plt.ylabel('Auto Correlation')
		plt.xlabel('time')
		plt.title('Autocorrelation Plot')
		plt.savefig(cfg.AUTOCORR_GRAPH_FILE,dpi=100)
		if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
			plt.savefig(support.shiftPathToGraphFolder(cfg.AUTOCORR_GRAPH_FILE.replace("png","pdf")),dpi=100)
			plt.savefig(support.shiftPathToGraphFolder(cfg.AUTOCORR_GRAPH_FILE.replace("png","eps")),dpi=100)
	
def traceNoStringParser(tString):
	if(tString == "ALL"):
		tracesToPrint = numpy.zeros(0)
	else:	
		tracesToPrint = numpy.zeros(0)
		tStringSplit = re.split(",", tString)
		for item in tStringSplit:
			ranCheck = re.match("(\d+)\W(\d+)", item)
			if ranCheck:
				lb = int(ranCheck.group(1))
				ub = int(ranCheck.group(2))
				if(lb > ub):
					toAppend = range(ub, lb+1)
				elif(lb < ub):
					toAppend = range(lb, ub+1)			
			else:
				toAppend = int (item)
			tracesToPrint = numpy.append(tracesToPrint, toAppend)
	return tracesToPrint

def plotTrace(dataToPlot, traceNos, plotType):
	figs = plt.figure()	
	figs.suptitle('Measured Traces', fontsize=14, fontweight='bold')
	toPlot = numpy.zeros(0)
	runNo = 1
	cfg.SNAPSHOT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.SNAPSHOT_FILE_NAME)
	while os.path.exists(cfg.SNAPSHOT_FILE):
		runNo += 1
		cfg.SNAPSHOT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.SNAPSHOT_FILE_NAME)	
	tracesToPrint = traceNoStringParser(traceNos)
	firstRun = True
	if len(tracesToPrint) > 0:
		for trceNo in tracesToPrint:
			if(firstRun == True):
				toPlot = dataToPlot[int(trceNo),:]
				firstRun = False
			else:	
				toPlot = numpy.vstack((toPlot, dataToPlot[int(trceNo),:]))
		toPlot = numpy.transpose(toPlot)	
	else:
		toPlot = numpy.transpose(dataToPlot)
		
	plt.hold(False)
	plt.clf()
	tiledPlotCounter = 0
	if(plotType == 'OVERLAY'):
		printFunctions.printToScreenAndAnalysisLog("Plotting traces - Overlayed Format")	
		plt.plot(toPlot)
		plt.ylabel('volts')
		plt.xlabel('time')
		plt.title('Processed Data')
		plt.grid(b=True, which='Major', color = 'b', linestyle = '--')
	elif(plotType == 'TILED'):
		printFunctions.printToScreenAndAnalysisLog("Plotting traces - Tiled Format")
		fig,axes = plt.subplots(len(tracesToPrint), 1, sharex= True, sharey = True)
		fig.text(0.54, 0.02, 'Time', ha='center', va='center', fontsize=14)
		fig.text(0.02, 0.53, 'Volts', ha='center', va='center', rotation='vertical', fontsize=14)
		plt.tight_layout()

		if (len(tracesToPrint) == 1):
			axes.plot(toPlot)
		else:	
			for traceNo in range(0, len(tracesToPrint)):
				axes[tiledPlotCounter].plot(toPlot[:,int(traceNo)])
				plt.setp(axes[tiledPlotCounter].get_xticklabels(), visible=False)
				plt.setp(axes[tiledPlotCounter].get_yticklabels(), visible=False)				
				tiledPlotCounter += 1
			tiledPlotCounter -= 1
			plt.setp(axes[tiledPlotCounter].get_xticklabels(), visible=True)
			
		#plt.ylabel('volts')
		#plt.xlabel('time')
		#plt.title('Processed Data')
		#plt.grid(b=True, which='Major', color = 'b', linestyle = '--')	
	printFunctions.printToAnalysisLog("Saving " + cfg.SNAPSHOT_FILE)
	plt.savefig(cfg.SNAPSHOT_FILE,dpi=100)
	#plt.show()
	if (cfg.analysisConfigAttributes['GENERATE_EPS_PDF_GRAPHS'] == 'YES'):
		plt.savefig(support.shiftPathToGraphFolder(cfg.SNAPSHOT_FILE.replace("png","pdf")),dpi=100)
		plt.savefig(support.shiftPathToGraphFolder(cfg.SNAPSHOT_FILE.replace("png","eps")),dpi=100)

def plotRawTrace(dataToPlot, traceLowerBound, traceUpperBound):
	figs = plt.figure()	
	figs.suptitle('Measured Traces', fontsize=14, fontweight='bold')
	toPlot = numpy.zeros(0)
	runNo = 1
	cfg.SNAPSHOT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.SNAPSHOT_FILE_NAME)
	while os.path.exists(cfg.SNAPSHOT_FILE):
		runNo += 1
		cfg.SNAPSHOT_FILE = os.path.join(cfg.ANALYSIS_WORKSPACE, str(runNo) + "-" +globals.SNAPSHOT_FILE_NAME)	
	toPlot = numpy.transpose(dataToPlot)
	plt.hold(False)
	plt.clf()
	plt.plot(toPlot[traceLowerBound:traceUpperBound])
	plt.ylabel('volts')
	plt.xlabel('time')
	plt.title('Processed Data')
	plt.grid(b=True, which='Major', color = 'b', linestyle = '--')
	printFunctions.printToAnalysisLog("Saving " + cfg.SNAPSHOT_FILE)
	plt.savefig(cfg.SNAPSHOT_FILE,dpi=100)
	
	
def main():
	support.clear_screen()
	#print "Checking values"
	#strA = "1,2,100-10"
	#tracesToPrint = traceNoStringParser(strA)
	#print tracesToPrint
	str1 = "traces.png"
	print str1
	str1.replace("png","pdf")
	print str1
	
	
	
	
if __name__ == "__main__":
	main()