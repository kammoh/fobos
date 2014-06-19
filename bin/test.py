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
	

