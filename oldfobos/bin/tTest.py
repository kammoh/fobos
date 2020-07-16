#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2016 Cryptographic Engineering Research Group (CERG)           #
#	George Mason University							 #	
#   http://cryptography.gmu.edu/fobos                                            #                            
#									         #                             	 
#	Licensed under the Apache License, Version 2.0 (the "License");        	 #
#	you may not use this file except in compliance with the License.       	 #
#	You may obtain a copy of the License at                                	 #
#	                                                                       	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                         	 #
#	                                                                       	 #
#	Unless required by applicable law or agreed to in writing, software    	 #
#	distributed under the License is distributed on an "AS IS" BASIS,      	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#	See the License for the specific language governing permissions and      #
#	limitations under the License.                                           #
#                                                                           	 #
##################################################################################
from analysis import readtrace
from analysis import welch
from analysis import splitter
from analysis import profiler
import os
import time
from globals import cfg, globals,support, printFunctions, configExtract, dataGenerator
from analysis import signalAnalysisModule
from analysis import postProcessingModule
from analysis import plottingModule
from analysis import statisticsModule
from analysis import sca
import configparser

def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.BINDIR = os.path.join(cfg.ROOTDIR,globals.BIN_DIRNAME)
	cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,globals.CONFIG_DIRNAME)
	cfg.ANALYSISCONFIGDIR = os.path.join(cfg.ROOTDIR, globals.ANALYSIS_CONFIG_DIRNAME)
	cfg.CONFIG_FILE = os.path.join(cfg.CONFIGDIR, globals.CONFIG_FILENAME)
	cfg.OSC_CONFIGFILE = os.path.join(cfg.CONFIGDIR, globals.OSC_CONFIGFILENAME)
	cfg.ANALYSIS_SCRIPT_FILE = os.path.join(cfg.BINDIR, globals.ANALYSIS_SCRIPT_FILENAME)
	cfg.PROGRAM_CALL = "ANALYSIS"

def main():
	init()
	support.clear_screen()
        config = configparser.ConfigParser()
        config.read(os.path.join(cfg.ROOTDIR, globals.CONFIG_DIRNAME, 'analysis.ini'))
        print os.path.join(cfg.ROOTDIR, globals.CONFIG_DIRNAME, 'analysis.ini')
        #print config.sections()	
	configExtract.extractConfigAttributes()
        configExtract.configureAnalysisWorkspace()
        #print support.getProjectPath()
	measurDir = cfg.MEASUREMENT_FOLDER
	analysisDir =  cfg.ANALYSIS_WORKSPACE
	alignedTraceFile = cfg.ALIGNED_DATA_FILE
	cleanTraceFile =  os.path.join(analysisDir, 'cleanTrace.npy')
	traceCount = int(config['tTest']['traceCount'])
	readtrace.readTraces(alignedTraceFile, cleanTraceFile,traceCount)
        #####now split to Q0 and Q1
        #NEED TO GET THESE FROM CONFIG FILES
        traceFile0 = os.path.join(analysisDir, config['tTest']['Q0File'])
        traceFile1 = os.path.join(analysisDir, config['tTest']['Q1File'])
        fvrFile = os.path.join(cfg.ROOTDIR, 'sources' , config['tTest']['fvrFile'])
        
        splitter.splitTrace(traceCount, traceFile0, traceFile1, fvrFile, cleanTraceFile)

        ###calculate t values
        plotFile = os.path.join(analysisDir, config['tTest']['tValuesPlotFile'])
        dstFile = os.path.join(analysisDir, config['tTest']['tValuesFile'])
        welch.createTFile(traceFile0, traceFile1, plotFile, dstFile)
        ####Profiler
        display_clk = config['profiler']['display_clk']
        num_of_clks = int(config['profiler']['num_of_clks'])
        clk_high  = float(config['profiler']['clk_high'])
        clk_low = float(config['profiler']['clk_low'])
        profilerPlot = config['profiler']['profilerPlot']
        
        tValuesFile = os.path.join(analysisDir, config['profiler']['tValuesFile'])
        profilerPlotFile = os.path.join(analysisDir, profilerPlot)
        stateFile = os.path.join(cfg.ROOTDIR, 'sources' ,config['profiler']['stateFile'])
        profiler.plotTValues(tValuesFile, profilerPlotFile, stateFile, display_clk, num_of_clks, clk_high,clk_low)

if __name__ == "__main__": 
	start_time=time.time()
        main()		
	print("\tTotal Execution Time=%s seconds" %(time.time() - start_time))
	
