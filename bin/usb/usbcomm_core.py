#!/usr/bin/python
import array
import time
import sys
import argparse
from ctypes import *
import os
from usbcomm_global import * 
import traceback

    
def clear_screen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )
  
def print_header():
    sys.stdout.write("-----------------------------------------------\n")
    sys.stdout.write("Starting PC-FPGA Communication via USB\n")
    sys.stdout.write("\tControl Board -> %s\n" % DeviceName)
    sys.stdout.write("\tVersion -> %s\n" % VERSION)
    sys.stdout.write("-----------------------------------------------\n") 

def initialize_usbcomm():
    status = usbcomm.DmgrOpen(handle, DeviceName)
    if (status == SUCCESS):
      sys.stdout.write("Initializing USB - FPGA Communication... \n")
      status = usbcomm.DeppEnableEx(handle[0], 0)
      if (status == SUCCESS):
	sys.stdout.write("\tDepp protocol enabled at Port 0\n")
	usbcomm.DeppGetVersion(ResultString)
	sys.stdout.write("\tDepp protocol version -> %s\n"% ResultString[0:10])
	sys.stdout.write("-----------------------------------------------\n") 
	return handle
      else:
	sys.stdout.write("\tDepp protocol not enabled. Exiting Program\n")
	sys.exit(0)
    else:
      sys.stdout.write("\tUSB Communication Failure. Exiting Program \n")
      sys.exit(0)

      
def getRegByte(USBHandle, regByte):
  if (usbcomm.DeppGetReg(USBHandle[0], regByte, dataBYTEP, 0)) :
    sys.stdout.write("\tRead Data from Reg -> %X " %regByte)
    sys.stdout.write("Data -> %X\n" % dataBYTEP[0])
    return (dataBYTEP)
  else :
    sys.stdout.write("\tCould not read register -> %X\n" % regByte)
    return (0)
    
def putRegByte(USBHandle, regByte, dataBYTE):
    if (usbcomm.DeppPutReg(USBHandle[0], regByte, dataBYTE, 0)) :
      sys.stdout.write("\tRead Data from Reg -> %X " %regByte)
      sys.stdout.write("Data -> %X\n" % dataBYTE)
      #sys.stdout.write("\tPut Data -> %x to Reg -> %x\n" % dataBYTE % regByte)
      return (1)
    else :
      sys.stdout.write("\tCould not write to register -> %X\n" % regByte)
      return (0)
  
    
def terminate_usbcomm(USBHandle):
    usbcomm.DeppDisable(USBHandle[0])
    usbcomm.DmgrClose(USBHandle[0])


 
#def getReg(regVal):

#Declare Control Board Here
DeviceName = 'Nexys3'


#Clearing Screen
clear_screen()  

#Printing Header

print_header()

USBHandle = initialize_usbcomm()
  
status = getRegByte(USBHandle, 0x01)
status = putRegByte(USBHandle, 0x00, 0xA0)
terminate_usbcomm(USBHandle)







