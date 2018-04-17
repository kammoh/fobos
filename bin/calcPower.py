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
import subprocess

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
        print config.sections()	
	configExtract.extractConfigAttributes()
        configExtract.configureAnalysisWorkspace()
        #print support.getProjectPath()
	measurDir = cfg.MEASUREMENT_FOLDER
	analysisDir =  cfg.ANALYSIS_WORKSPACE
	alignedTraceFile = cfg.ALIGNED_DATA_FILE
        #Run power_traces.py
	srcFile =  os.path.join(measurDir, config['power']['srcFile'])
	dstFile =  os.path.join(analysisDir, config['power']['dstFile'])
	numTraces =  config['power']['numTraces']
	startSample =  config['power']['startSample']
	endSample =  config['power']['endSample']
        subprocess.call(['python', 'analysis/power_traces.py', srcFile, dstFile, numTraces, startSample, endSample]) 

if __name__ == "__main__": 
	start_time=time.time()
        main()		
	print("\tTotal Execution Time=%s seconds" %(time.time() - start_time))
	
