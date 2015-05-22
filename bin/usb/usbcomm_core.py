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
from __future__ import division
import array
import time
import sys
import argparse
from ctypes import *
import os
from usbcomm_global import *
from globals import support,cfg , printFunctions, globals
import struct
#import traceback


def arrayToString(array):
  r = ''
  for num in array:
    r += '%02X' % num
  return r
  

def initializeControlBoardConnection():
    status = dmgr.DmgrOpen(cfg.USB_HANDLE, cfg.config_attributes['CONTROL_BOARD'])
    if (status == SUCCESS):
      printFunctions.printToScreenAndLog("\tInitializing USB - FPGA Communication...")
      status = depp.DeppEnableEx(cfg.USB_HANDLE[0], 0)
      if (status == SUCCESS):
        printFunctions.printToScreenAndLog("\t\tDepp protocol enabled at Port 0")
      else:
        printFunctions.printToScreenAndLog("\tDepp protocol not enabled. Exiting Program")
        dmgr.DmgrClose(cfg.USB_HANDLE[0])
        sys.exit(0)
    else:
      printFunctions.printToScreenAndLog("\tUSB Communication Failure. Exiting Program")
      sys.exit(0)

      
def getRegByte(regByte):
  if (depp.DeppGetReg(cfg.USB_HANDLE[0], regByte, dataBYTEP, 0)) :
    printFunctions.printToLog("\tRead Data from Reg ->  " + str(regByte) + "Data -> " + str(dataBYTEP[0]))
    return (dataBYTEP[0])
  else :
    printFunctins.printToScreenAndLog("\tCould not read register -> " + regByte)
    return (0)
    
def putRegByte(regByte, dataBYTE):
    if (depp.DeppPutReg(cfg.USB_HANDLE[0], regByte, dataBYTE, 0)) :
      printFunctions.printToLog("\tSending Data to Reg ->  " + str(regByte) + "Data -> " + str(dataBYTE))
      return (1)
    else :
      printFunctions.printToScreenAndLog("\tCould not write to register -> " + str(regByte))
      return (0)
      
def streamBytes(nosBytes, regByte) :
	streambufBYTE = (c_ubyte*(nosBytes+10))()
	streamdataBYTEP = cast(streambufBYTE, POINTER(c_ubyte))
	nosBytesD = c_ulong
	nosBytesD = nosBytes
	if (depp.DeppGetRegRepeat(cfg.USB_HANDLE[0], regByte, streamdataBYTEP, nosBytes, 0)) :
	  printFunctions.printToLog("\tStream Data from Reg -> " + str(regByte))
	  return (streamdataBYTEP)
	else :
	  printFunctions.printToLog("\tCould not stream from register -> " + str(regByte))
	  return (0)  

def readMainClockFreq() :
  mainclkfreq_hex = [0,0,0,0]
  status = putRegByte(0x30, 0x02)
  status = putRegByte(0x30, 0x00)
  support.goToSleep(1)
  mainclkfreq_hex[0] = getRegByte(0x20)
  mainclkfreq_hex[1] = getRegByte(0x21)
  mainclkfreq_hex[2] = getRegByte(0x22)
  mainclkfreq_hex[3] = getRegByte(0x23)
  mainclkfreq_MHz = int(arrayToString(mainclkfreq_hex), 16)/1000000
  printFunctions.printToScreenAndLog("\t\t" + cfg.config_attributes['CONTROL_BOARD'] + " - Main Clock Frequency ->" + str(mainclkfreq_MHz) + " - MHz")

def readVictimClockFreq() :
  victimclkfreq_hex = [0,0,0,0]
  status = putRegByte(0x30, 0x02)
  status = putRegByte(0x30, 0x00)
  support.goToSleep(1)
  victimclkfreq_hex[0] = getRegByte(0x24)
  victimclkfreq_hex[1] = getRegByte(0x25)
  victimclkfreq_hex[2] = getRegByte(0x26)
  victimclkfreq_hex[3] = getRegByte(0x27)
  victimclkfreq_MHz = struct.unpack('f', struct.pack('i', (int(arrayToString(victimclkfreq_hex), 16)/1000000)))
  printFunctions.printToScreenAndLog("\t\t" + cfg.config_attributes['CONTROL_BOARD'] + " - Victim Clock Frequency ->" + str(float(int(arrayToString(victimclkfreq_hex), 16)/1000000)) + " - MHz" )  
 
def sendTraceCountToControlBoard():
  noOfTracesArray = [((cfg.config_attributes['NUMBER_OF_TRACES'] - 1) >> i & 0xFF) for i in (24, 16, 8, 0)]
  status = putRegByte(0x80, noOfTracesArray[0])
  status = putRegByte(0x81, noOfTracesArray[1])
  status = putRegByte(0x82, noOfTracesArray[2])
  status = putRegByte(0x83, noOfTracesArray[3])
  return status
 
def runDummyEncrytionOncControlBoard (traceCount):
	printFunctions.printToScreenAndLog("\tRunning Dummy Encryption - " + str(traceCount+1))
	status = putRegByte(0x01, 0x00)
	status = putRegByte(0x01, 0x04)
	support.goToSleep(0.00002)
	status = putRegByte(0x01, 0x00)
	status = putRegByte(0x01, 0x00)
	return status

def displayReg(regByte):
	status = putRegByte(0x40, 0x0C)
	return status
# def streamDataFromBRAM(cfg.USB_HANDLE, nosBytes, logfile, dataToStream, debug):

  
  # lbyteValue = [0]*(nosBytes)
  # hbyteValue = [0]*(nosBytes)
  # streamdataV = [0]*(nosBytes)
  # if(debug == 2):
    # i = 0
    # log = open(logfile, 'w')
    # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x01, debug) # Reset High
    # if (dataToStream == COUNTER):
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x00, debug) # Reset Low|Counter input
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x80, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x40, debug)
      # while(i<nosBytes):
        # hbyteValue[i] = getRegByte(cfg.USB_HANDLE, 0x10, debug)
        # i = i+1
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x80, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x40, debug)
      # i =0
      # while(i<nosBytes):
        # lbyteValue[i] = getRegByte(cfg.USB_HANDLE, 0x11, debug)
        # i = i+1
      # i=0
      # while(i<nosBytes):
        # streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        # log.write(str(streamdataV[i]))
        # log.write('\n')
        # i = i+1
    # if (dataToStream == OPENADC):
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x20, debug) # Reset Low|Counter input
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0xA0, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x60, debug)
      # while(i<nosBytes):
        # hbyteValue[i] = getRegByte(cfg.USB_HANDLE, 0x10, debug)
        # i = i+1
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0xA0, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x60, debug)  
      # i =0
      # while(i<nosBytes):
        # lbyteValue[i] = getRegByte(cfg.USB_HANDLE, 0x11, debug)
        # i = i+1
      # i=0 
      # while(i<nosBytes):
        # streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        # log.write(str(streamdataV[i]))
        # log.write('\n')
        # i = i+1
    # log.close() 
    
  # if(debug == 3):
    # i=0
    # log = open(logfile, 'w')
    # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x01, debug) # Reset High
    # if (dataToStream == COUNTER):
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x00, debug) # Reset Low|Counter input
      # time.sleep(1)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x80, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x40, debug)
      # hbyteValue = streamBytes(cfg.USB_HANDLE, nosBytes, 0x10, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x80, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x40, debug)
      # lbyteValue = streamBytes(cfg.USB_HANDLE, nosBytes, 0x11, debug)
      # while(i<nosBytes):
        # streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        # log.write(str(streamdataV[i]))
        # log.write('\n')
        # i = i+1
      # log.close()
    # elif(dataToStream == OPENADC):
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x20, debug) # Reset Low|Counter input
      # time.sleep(1)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0xA0, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x60, debug)
      # hbyteValue = streamBytes(cfg.USB_HANDLE, nosBytes, 0x10, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0xA0, debug)
      # status = putRegByte(cfg.USB_HANDLE, 0x00, 0x60, debug)
      # lbyteValue = streamBytes(cfg.USB_HANDLE, nosBytes, 0x11, debug)
      # while(i<nosBytes):
        # streamdataV[i] = getIntValue(hbyteValue[i], lbyteValue[i])
        # log.write(str(streamdataV[i]))
        # log.write('\n')
        # i = i+1
      # log.close()    
  # return streamdataV

def resetControlBoard():
	status = putRegByte(0x30, 0x01)
	status = putRegByte(0x30, 0x00)

def openControlBoardConnection():
	printFunctions.printControlBoardHeaderToScreenAndLog()
	initializeControlBoardConnection()
	resetControlBoard()
	readMainClockFreq()
	readVictimClockFreq()
	
def closeControlBoardConnection():
    depp.DeppDisable(cfg.USB_HANDLE[0])
    if (sys.platform == "linux2" ):
      depp.DmgrClose(cfg.USB_HANDLE[0])
	  
