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
from __future__ import division

import array
import time
import sys
import argparse
from ctypes import *
import os
from usbcomm_global import * 
import traceback
import struct

def goToSleep(value):
	time.sleep(value)
    
def clear_screen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )
  
def arrayToString(array):
  r = ''
  for num in array:
    r += '%02X' % num
  return r
  
def getIntValue(val1, val2):
  Value = int(val1 << 8 | val2)
  return Value
  
def printArray(array, num):
  i = 0
  while(i<num):
    sys.stdout.write("%02X\n" % array[i])
    i=i+1
  
def print_header(DeviceName):
    sys.stdout.write("-----------------------------------------------\n")
    sys.stdout.write("Starting PC-FPGA Communication via USB\n")
    sys.stdout.write("\tControl Board -> %s\n" % DeviceName)
    sys.stdout.write("\tVersion -> %s\n" % VERSION)
    sys.stdout.write("-----------------------------------------------\n") 
    
def print_OpenADCheader(DeviceName):
	print_header(DeviceName)
	sys.stdout.write("\tStarting FOBOS- OpenADC Communication Script\n")
	
def initialize_usbcomm(DeviceName):
    status = dmgr.DmgrOpen(handle, DeviceName)
    if (status == SUCCESS):
      sys.stdout.write("Initializing USB - FPGA Communication... \n")
      status = depp.DeppEnableEx(handle[0], 0)
      if (status == SUCCESS):
        sys.stdout.write("\tDepp protocol enabled at Port 0\n")
        #depp.DeppGetVersion(ResultString)
        #sys.stdout.write("\tDepp protocol version -> %s\n"% ResultString[0:10])
        sys.stdout.write("-----------------------------------------------\n")
        return handle
      else:
        sys.stdout.write("\tDepp protocol not enabled. Exiting Program\n")
        dmgr.DmgrClose(handle[0])
        sys.exit(0)
    else:
      sys.stdout.write("\tUSB Communication Failure. Exiting Program \n")
      sys.exit(0)

      
def getRegByte(USBHandle, regByte, debug):
  if (depp.DeppGetReg(USBHandle[0], regByte, dataBYTEP, 0)) :
    if(debug == 1):
     sys.stdout.write("\tRead Data from Reg -> %X " %regByte)
     sys.stdout.write("Data -> %X\n" % dataBYTEP[0])
    return (dataBYTEP[0])
  else :
    sys.stdout.write("\tCould not read register -> %X\n" % regByte)
    return (0)
    
def putRegByte(USBHandle, regByte, dataBYTE, debug):
    if (depp.DeppPutReg(USBHandle[0], regByte, dataBYTE, 0)) :
      if(debug == 1):
       sys.stdout.write("\tSending Data to Reg -> %X " %regByte)
       sys.stdout.write("Data -> %X\n" % dataBYTE)
      #sys.stdout.write("\tPut Data -> %x to Reg -> %x\n" % dataBYTE % regByte)
      return (1)
    else :
      sys.stdout.write("\tCould not write to register -> %X\n" % regByte)
      return (0)
      
def streamBytes(USBHandle, nosBytes, regByte, debug) :
	streambufBYTE = (c_ubyte*(nosBytes+10))()
	streamdataBYTEP = cast(streambufBYTE, POINTER(c_ubyte))
	nosBytesD = c_ulong
	nosBytesD = nosBytes
	if (depp.DeppGetRegRepeat(USBHandle[0], regByte, streamdataBYTEP, nosBytes, 0)) :
	  if(debug == 1):
	    sys.stdout.write("\tStream Data from Reg -> %X \n" %regByte)
	  return (streamdataBYTEP)
	else :
	  sys.stdout.write("\tCould not stream from register -> %X\n" % regByte)
	  return (0)  

def readMainClockFreq(USBHandle, DeviceName, debug) :
  mainclkfreq_hex = [0,0,0,0]
  status = putRegByte(USBHandle, 0x30, 0x02, debug)
  status = putRegByte(USBHandle, 0x30, 0x00, debug)
  goToSleep(1)
  mainclkfreq_hex[0] = getRegByte(USBHandle, 0x20, debug)
  mainclkfreq_hex[1] = getRegByte(USBHandle, 0x21, debug)
  mainclkfreq_hex[2] = getRegByte(USBHandle, 0x22, debug)
  mainclkfreq_hex[3] = getRegByte(USBHandle, 0x23, debug)
  mainclkfreq_MHz = int(arrayToString(mainclkfreq_hex), 16)/1000000
  #sys.stdout.write("\tMain Clock Frequency - %s \n" % arrayToString(clkfreq_hex))
  sys.stdout.write("\t\t%s - Main Clock Frequency" % DeviceName + " - %d MHz\n" % mainclkfreq_MHz)

def readVictimClockFreq(USBHandle, DeviceName, debug) :
  victimclkfreq_hex = [0,0,0,0]
  status = putRegByte(USBHandle, 0x30, 0x02, debug)
  status = putRegByte(USBHandle, 0x30, 0x00, debug)
  goToSleep(1)
  victimclkfreq_hex[0] = getRegByte(USBHandle, 0x24, debug)
  victimclkfreq_hex[1] = getRegByte(USBHandle, 0x25, debug)
  victimclkfreq_hex[2] = getRegByte(USBHandle, 0x26, debug)
  victimclkfreq_hex[3] = getRegByte(USBHandle, 0x27, debug)
  victimclkfreq_MHz = struct.unpack('f', struct.pack('i', (int(arrayToString(victimclkfreq_hex), 16)/1000000)))
  sys.stdout.write("\t\t%s - Victim Clock Frequency" % DeviceName + " - %f MHz\n" % float(int(arrayToString(victimclkfreq_hex), 16)/1000000))  
 
def sendEncryptionCycles(USBHandle, noOfTraces, debug):
  noOfTracesArray = [(noOfTraces >> i & 0xFF) for i in (24, 16, 8, 0)]
  status = putRegByte(USBHandle, 0x80, noOfTracesArray[0], debug)
  status = putRegByte(USBHandle, 0x81, noOfTracesArray[1], debug)
  status = putRegByte(USBHandle, 0x82, noOfTracesArray[2], debug)
  status = putRegByte(USBHandle, 0x83, noOfTracesArray[3], debug)
  return status
 
def runDummyencrytion (USBHandle, debug):
	status = putRegByte(USBHandle, 0x01, 0x04, debug)
	goToSleep(0.5)
	status = putRegByte(USBHandle, 0x01, 0x08, debug)
	return status
  
def streamDataFromBRAM(USBHandle, nosBytes, logfile, dataToStream, debug):

  
  lbyteValue = [0]*(nosBytes)
  hbyteValue = [0]*(nosBytes)
  streamdataV = [0]*(nosBytes)
  if(debug == 2):
    i = 0
    log = open(logfile, 'w')
    status = putRegByte(USBHandle, 0x00, 0x01, debug) # Reset High
    if (dataToStream == COUNTER):
      status = putRegByte(USBHandle, 0x00, 0x00, debug) # Reset Low|Counter input
      status = putRegByte(USBHandle, 0x00, 0x80, debug)
      status = putRegByte(USBHandle, 0x00, 0x40, debug)
      while(i<nosBytes):
        hbyteValue[i] = getRegByte(USBHandle, 0x10, debug)
        i = i+1
      status = putRegByte(USBHandle, 0x00, 0x80, debug)
      status = putRegByte(USBHandle, 0x00, 0x40, debug)
      i =0
      while(i<nosBytes):
        lbyteValue[i] = getRegByte(USBHandle, 0x11, debug)
        i = i+1
      i=0
      while(i<nosBytes):
        streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        log.write(str(streamdataV[i]))
        log.write('\n')
        i = i+1
    if (dataToStream == OPENADC):
      status = putRegByte(USBHandle, 0x00, 0x20, debug) # Reset Low|Counter input
      status = putRegByte(USBHandle, 0x00, 0xA0, debug)
      status = putRegByte(USBHandle, 0x00, 0x60, debug)
      while(i<nosBytes):
        hbyteValue[i] = getRegByte(USBHandle, 0x10, debug)
        i = i+1
      status = putRegByte(USBHandle, 0x00, 0xA0, debug)
      status = putRegByte(USBHandle, 0x00, 0x60, debug)  
      i =0
      while(i<nosBytes):
        lbyteValue[i] = getRegByte(USBHandle, 0x11, debug)
        i = i+1
      i=0 
      while(i<nosBytes):
        streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        log.write(str(streamdataV[i]))
        log.write('\n')
        i = i+1
    log.close() 
    
  if(debug == 3):
    i=0
    log = open(logfile, 'w')
    status = putRegByte(USBHandle, 0x00, 0x01, debug) # Reset High
    if (dataToStream == COUNTER):
      status = putRegByte(USBHandle, 0x00, 0x00, debug) # Reset Low|Counter input
      time.sleep(1)
      status = putRegByte(USBHandle, 0x00, 0x80, debug)
      status = putRegByte(USBHandle, 0x00, 0x40, debug)
      hbyteValue = streamBytes(USBHandle, nosBytes, 0x10, debug)
      status = putRegByte(USBHandle, 0x00, 0x80, debug)
      status = putRegByte(USBHandle, 0x00, 0x40, debug)
      lbyteValue = streamBytes(USBHandle, nosBytes, 0x11, debug)
      while(i<nosBytes):
        streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        log.write(str(streamdataV[i]))
        log.write('\n')
        i = i+1
      log.close()
    elif(dataToStream == OPENADC):
      status = putRegByte(USBHandle, 0x00, 0x20, debug) # Reset Low|Counter input
      time.sleep(1)
      status = putRegByte(USBHandle, 0x00, 0xA0, debug)
      status = putRegByte(USBHandle, 0x00, 0x60, debug)
      hbyteValue = streamBytes(USBHandle, nosBytes, 0x10, debug)
      status = putRegByte(USBHandle, 0x00, 0xA0, debug)
      status = putRegByte(USBHandle, 0x00, 0x60, debug)
      lbyteValue = streamBytes(USBHandle, nosBytes, 0x11, debug)
      while(i<nosBytes):
        streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        log.write(str(streamdataV[i]))
        log.write('\n')
        i = i+1
      log.close()    
  return streamdataV

def controlBoardReset(USBHandle, debug):
	status = putRegByte(USBHandle, 0x30, 0x01, debug)
	status = putRegByte(USBHandle, 0x30, 0x00, debug)
	
def terminate_usbcomm(USBHandle):
    depp.DeppDisable(USBHandle[0])
    if (sys.platform == "linux2" ):
      depp.DmgrClose(USBHandle[0])








