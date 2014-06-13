#!/usr/bin/python

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
	  