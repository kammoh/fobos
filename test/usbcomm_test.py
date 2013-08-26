#!/usr/bin/python
import array
import time
import sys
import argparse
from ctypes import *
import os
from usbcomm_global import * 
from usbcomm_core import *
import traceback
import time


#Declare Control Board Here
DeviceName = 'Nexys3'


#Clearing Screen
clear_screen()  

#Printing Header
print_header(DeviceName)
getVersion()

#Prints debug messages if dbug=1/0 does not
dbg = 1

#Getting USB Handle
#USBHandle = initialize_usbcomm(DeviceName)
#Send data - 0xA5 to register 0x00 -> which is connected to LEDs ..
setTime(1000000, DeviceName)
i = 0
while (i<50):
	sys.stdout.write("\t Test Id : %d " % i)
	status = putByteToReg(DeviceName, 0x00, 0xA0, dbg)
	time.sleep(0.1)
	status = putByteToReg(DeviceName, 0x00, 0x5A, dbg)
	time.sleep(0.1)
	status = getByteFromReg(DeviceName, 0x01, dbg)
	time.sleep(0.1)	
	i = i+1
	sys.stdout.write("\n")
	
#should read value 0x4B from register 0x01 (value is hardcoded into vhdl code
#data = getByte(USBHandle, 0x01, dbg)


#Terminate USB handle
#terminate_usbcomm(USBHandle)






