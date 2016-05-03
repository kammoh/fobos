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
import re
from sys import argv
import sys
from oscilloscope_core import *
import socket
from numpy import *

oscilloscope_ipaddress = "192.168.0.10"
oscilloscope_portno = 5025	
	
################################################################################
## Main Program
################################################################################
script, osc_config_file = argv

## Clear Screen
os.system('clear')
#clear_screen()

## Print Header on Konsole
print_header(osc_config_file)

## Read Oscilloscope Config File
data_from_file = read_file(osc_config_file)

## Remove Comments and empty lines
data_list = remove_comments(data_from_file)
#print data_list

## Get Attributes from file
inst_attrib = get_attribs(data_list)

## Connect to Oscilloscope
MyInstrument = oscilloscope_connect(oscilloscope_ipaddress, oscilloscope_portno)

## Reset Instrument
MyInstrument.send("*RST")

## Closing Oscilloscope socket
MyInstrument.close()


