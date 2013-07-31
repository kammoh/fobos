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



#Declare Control Board Here
DeviceName = 'Nexys3'


#Clearing Screen
clear_screen()  

#Printing Header
print_header(DeviceName)

#Prints debug messages if dbug=1/0 does not
dbg = 1

#Getting USB Handle
USBHandle = initialize_usbcomm(DeviceName)
#Send data - 0xA5 to register 0x00 -> which is connected to LEDs ..
status = putByte(USBHandle, 0x00, 0xA5, dbg)

#should read value 0x4B from register 0x01 (value is hardcoded into vhdl code
data = getByte(USBHandle, 0x01, dbg)


#Terminate USB handle
terminate_usbcomm(USBHandle)






