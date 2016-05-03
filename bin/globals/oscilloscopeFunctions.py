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
import cfg,globals
from support import *
from oscilloscope.oscilloscope_core import *
from printFunctions import *

def init():
  (cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
  cfg.BINDIR = os.path.join(cfg.ROOTDIR,globals.BIN_DIRNAME)
  cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,globals.CONFIG_DIRNAME)
  cfg.CONFIG_FILE = os.path.join(cfg.CONFIGDIR, globals.CONFIG_FILENAME)
  cfg.OSC_CONFIGFILE = os.path.join(cfg.CONFIGDIR, globals.OSC_CONFIGFILENAME)
  
#####################################################################################
########### MAIN CODE ###############################################################
#####################################################################################

def main():
  init()
  extractConfigAttributes()
  clearScreen()
  extractOscilloscopeConfigAttributes()
  openOscilloscopeConnection()
  setOscilloscopeConfigAttributes()
  armOscilloscope()
  get_waveform_power()
  get_waveform_trigger()
  closeOscilloscopeConnection()

if __name__ == "__main__":
    main()		
	  