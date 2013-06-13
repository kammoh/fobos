#!/usr/bin/python

import os
import re
#from sys import argv
import sys
import oscilloscope_core
import socket
from numpy import *

oscilloscope_ipaddress = "134.40.174.43"
oscilloscope_portno = 5025	
	
################################################################################
## Main Program
################################################################################
script, osc_config_file = argv

## Clear Screen
#os.system('clear')
clear_screen()

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


