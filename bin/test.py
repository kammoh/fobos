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
	#init()
	#extractConfigAttributes()
	#configureWorkspace()	
	#printHeaderToScreenAndLog()
	#extractOscilloscopeConfigAttributes()
	#dataToEncrypt = getPlainText()
	#keyToEncrypt = getKey()
	#controlboardCommunicationcheck()
	#oscilloscopeCommunicationcheck()
	(branch1, branch2) = os.path.split(os.getcwd())
	path2 = os.path.join(branch1, "newpath", branch2)
	print os.getcwd()
	print branch1
	print branch2
	print path2
	
if __name__ == "__main__":
    main()
	

