#!/usr/bin/python
import os
import cfg
from globals import *
from printFunctions import *
from support import *
from configExtract import *
import dataGenerator
from oscilloscopeFunctions import *

	
def init():
	(cfg.ROOTDIR, temp) = os.path.split(os.getcwd())
	cfg.BINDIR = os.path.join(cfg.ROOTDIR,BIN_DIRNAME)
	cfg.CONFIGDIR = os.path.join(cfg.ROOTDIR,CONFIG_DIRNAME)
	cfg.CONFIGFILE = os.path.join(cfg.CONFIGDIR, CONFIG_FILENAME)
	cfg.OSC_CONFIGFILE = os.path.join(cfg.CONFIGDIR, OSC_CONFIGFILENAME)


def main():	
	clear_screen()
	init()
	extractConfigAttributes()
	configureWorkspace()	
	printHeaderToScreenAndLog()
	extractOscilloscopeConfigAttributes()
	dataToEncrypt = getPlainText()
	keyToEncrypt = getKey()
	#controlboardCommunicationcheck()
	#oscilloscopeCommunicationcheck()
	

if __name__ == "__main__":
    main()
	

