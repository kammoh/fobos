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
import array
import time
import sys
sys.path.insert(0, 'usb/')
import argparse
from ctypes import *
import os
from usbcomm_global import * 
from usbcomm_core import * 
import traceback


#Declare Control Board Here
DeviceName = 'Nexys3'


#Clearing Screen
clear_screen()  

#Printing Header
print_OpenADCheader(DeviceName)

dbg = 0 	#1 -> Prints Debug Messages

gainval = 0 #Integer value from 0-256


USBHandle = initialize_usbcomm(DeviceName)
sys.stdout.write("\tSending Global Reset to FPGA\n")
status = putByte(USBHandle, 0x00, 0xC0, dbg)
#time.sleep(3)
sys.stdout.write("\tSending Start signal to FPGA\n")
status = putByte(USBHandle, 0x00, 0x00, dbg)
sys.stdout.write("\tSetting the Gain Value of Open ADC Amplifier to %d\n" % gainval)
status = putByte(USBHandle, 0x02, gainval, dbg)
sys.stdout.write("\tStarting Phase shift routine\n")
status = putByte(USBHandle, 0x00, 0x20, dbg)
sys.stdout.write("\tStarting Clock Counters\n")
status = putByte(USBHandle, 0x00, 0x00, dbg)
#pollRegforValue(USBHandle, dbg)
readMainClockFreq(USBHandle, dbg)
readDCMClockFreq(USBHandle, dbg)
#readBrdClockFreq(USBHandle, dbg)
#dataflag = getByte(USBHandle, 0x01, dbg)
#bytestream_LB = streamBytes(USBHandle, 0x04)
#bytestream_UB = streamBytes(USBHandle, 0x05)
terminate_usbcomm(USBHandle)
