#!/usr/bin/python
import array
import time
import sys
import argparse
from ctypes import *
import os
from usbcomm_global import * 
import traceback

def clear_screen() :
  os.system("clear")

def arrayToString(array):
  r = ''
  for num in array:
    r += '%02X' % num
  return r
  
def print_header():
    sys.stdout.write("-----------------------------------------------\n")
    sys.stdout.write("Starting PC-FPGA Communication via USB\n")
    sys.stdout.write("\tControl Board -> %s\n" % DeviceName)
    sys.stdout.write("\tVersion -> %s\n" % VERSION)
    sys.stdout.write("-----------------------------------------------\n") 
	
def print_OpenADCheader():
	print_header()
	sys.stdout.write("\tStarting FOBOS- OpenADC Communication Script\n")

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
        status = usbcomm.DmgrClose(handle[0])
        sys.exit(0)
    else:
      sys.stdout.write("\tUSB Communication Failure. Exiting Program \n")
      sys.exit(0)

      
def getByte(USBHandle, regByte, debug):
  dataBYTE = c_ubyte
  dataP = POINTER(dataBYTE)
  bufBYTE = c_ubyte(10)
  dataBYTEP = cast(addressof(bufBYTE), dataP)
  if (usbcomm.DeppGetReg(USBHandle[0], regByte, dataBYTEP, 0)) :
    if (debug == 1):
      sys.stdout.write("\tReading from Reg -> %02X " %regByte)
      sys.stdout.write(": Data -> %02X\n" % dataBYTEP[0])
    dataVAL = dataBYTEP[0]
    return (dataVAL)
  else :
    sys.stdout.write("\tCould not read register -> %X\n" % regByte)
    return (0)
    
def putByte(USBHandle, regByte, dataBYTE, debug):
    if (usbcomm.DeppPutReg(USBHandle[0], regByte, dataBYTE, 0)) :
      if (debug == 1):
        sys.stdout.write("\tSending Data -> %X " %dataBYTE)
        sys.stdout.write("to Reg -> %X\n" % regByte)
	#sys.stdout.write("\tPut Data -> %x to Reg -> %x\n" % dataBYTE % regByte)
      return (1)
    else :
      sys.stdout.write("\tCould not write to register -> %X\n" % regByte)
      return (0)
  
def streamBytes(USBHandle, regByte) :
	streamdataBYTE = c_ubyte
	streamdataP = POINTER(c_ubyte)
	streambufBYTE = c_ubyte(20000)
	streamdataBYTEP = cast(addressof(streambufBYTE), streamdataP)
  
	if (usbcomm.DeppGetRegRepeat(USBHandle[0], regByte, streamdataBYTEP, 20000, 0)) :
		sys.stdout.write("\tStream Data from Reg -> %X " %regByte)
		return (streamdataBYTEP)
	else :
		sys.stdout.write("\tCould not stream from register -> %X\n" % regByte)
		return (0)

def pollRegforValue(USBHandle, debug):
	Val = getByte(USBHandle, 0x0E, debug)
	i = 1
	sys.stdout.write("\tPolling Status Reg")
	while(1):
		if ((Val == 0xE0)):
			sys.stdout.write("\n\t\tBoard Ready for sending data\n")
			time.sleep(0.4)
			break
		else:
			dots = ' #'*i
			sys.stdout.write(dots)
			i = i+1
		if (i == 4):
			i = 0
			time.sleep(1)
			Val = getByte(USBHandle, 0x0E, debug)

      
    
def readMainClockFreq(USBHandle, debug) :
  mainclkfreq_hex = [0,0,0,0]
  mainclkfreq_hex[0] = getByte(USBHandle, 0x01, debug)
  mainclkfreq_hex[1] = getByte(USBHandle, 0x02, debug)
  mainclkfreq_hex[2] = getByte(USBHandle, 0x03, debug)
  mainclkfreq_hex[3] = getByte(USBHandle, 0x04, debug)
  mainclkfreq_MHz = int(arrayToString(mainclkfreq_hex), 16)/1000000
  #sys.stdout.write("\tMain Clock Frequency - %s \n" % arrayToString(clkfreq_hex))
  sys.stdout.write("\tMain Clock Frequency - %d MHz\n" % mainclkfreq_MHz)

def readDCMClockFreq(USBHandle, debug) :
  dcmclkfreq_hex = [0,0,0,0]
  dcmclkfreq_hex[0] = getByte(USBHandle, 0x07, debug)
  dcmclkfreq_hex[1] = getByte(USBHandle, 0x08, debug)
  dcmclkfreq_hex[2] = getByte(USBHandle, 0x09, debug)
  dcmclkfreq_hex[3] = getByte(USBHandle, 0x0A, debug)
  dcmclkfreq_MHz = int(arrayToString(dcmclkfreq_hex), 16)/1000000
  sys.stdout.write("\tDCM Clock Frequency - %d MHz\n" % dcmclkfreq_MHz)

def readBrdClockFreq(USBHandle, debug) :
  brdclkfreq_hex = [0,0,0,0]
  brdclkfreq_hex[0] = getByte(USBHandle, 0x09, debug)
  brdclkfreq_hex[1] = getByte(USBHandle, 0x0A, debug)
  brdclkfreq_hex[2] = getByte(USBHandle, 0x0B, debug)
  brdclkfreq_hex[3] = getByte(USBHandle, 0x0C, debug)
  brdclkfreq_MHz = int(arrayToString(brdclkfreq_hex), 16)/1000000
  sys.stdout.write("\tBoard (in-coming) Clock Frequency - %d MHz\n" % brdclkfreq_MHz)
  
  
def terminate_usbcomm(USBHandle):
    usbcomm.DeppDisable(USBHandle[0])
    status = usbcomm.DmgrClose(handle[0])








