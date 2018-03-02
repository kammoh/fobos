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
from globals import support,cfg , printFunctions, globals, dataGenerator
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
    #printFunctions.printToLog("\tRead Data from Reg ->  " + str(regByte) + "Data -> " + str(dataBYTEP[0]))
    return (dataBYTEP[0])
  else :
    printFunctions.printToScreenAndLog("\tCould not read register -> " + regByte)
    return (0)
    
def putRegByte(regByte, dataBYTE):
    if (depp.DeppPutReg(cfg.USB_HANDLE[0], regByte, dataBYTE, 0)) :
      #printFunctions.printToLog("\tSending Data to Reg ->  " + str(regByte) + "Data -> " + str(dataBYTE))
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
  if (mainclkfreq_MHz == 0):
	printFunctions.printToScreenAndLog("\t\t Error!! Could not read main clock frequency of the board. Please reprogram FPGA")
	sys.exit(0)
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
  if (victimclkfreq_MHz == 0):
	status = getRegByte(0x31)
	if(status == 0):
		printFunctions.printToScreenAndLog("\t\t Error!! Victim Clock Generation DCM is not Locked. PLease re-start FOBOS. Problem persists please re-program FPGA")
  printFunctions.printToScreenAndLog("\t\t" + cfg.config_attributes['CONTROL_BOARD'] + " - Victim Clock Frequency ->" + str(float(int(arrayToString(victimclkfreq_hex), 16)/1000000)) + " - MHz" )  

	
def sendTriggerParamsToControlBoard():
  noOfTriggerWaitCycles = [((cfg.config_attributes['TRIGGER_WAIT_CYCLES'] - 1) >> i & 0xFF) for i in (24, 16, 8, 0)]
  noOfTriggerLengthCycles = [((cfg.config_attributes['TRIGGER_LENGTH_CYCLES'] - 1) >> i & 0xFF) for i in (24, 16, 8, 0)]  
  triggerType = cfg.config_attributes['TRIGGER_TYPE']
  print "Setting trigger type to: " , str(globals.TRIGGER_TYPE[triggerType])
  status = putRegByte(0x89, globals.TRIGGER_TYPE[triggerType])
  status = putRegByte(0x80, noOfTriggerWaitCycles[0])
  status = putRegByte(0x81, noOfTriggerWaitCycles[1])
  status = putRegByte(0x82, noOfTriggerWaitCycles[2])
  status = putRegByte(0x83, noOfTriggerWaitCycles[3])
  status = putRegByte(0x84, noOfTriggerLengthCycles[0])
  status = putRegByte(0x85, noOfTriggerLengthCycles[1])
  status = putRegByte(0x86, noOfTriggerLengthCycles[2])
  status = putRegByte(0x87, noOfTriggerLengthCycles[3])
  return status

def sendDataToControlBoard(traceCount):
	##read file
	data_to_send = cfg.dataToControlBoard[traceCount]
	status = putRegByte(0x30, 0x00)
	i = 0
	while i < len(data_to_send) -1:
		bytes_to_send = data_to_send[i:i+2]
		lsb = bytes_to_send[0:2]
		status = putRegByte(0x7A, int(lsb, 16))
		i += 2
	
def readOutput(traceCount):
	#read output (ciphertxt) from HW
	out_list = str()
	if (traceCount == 0):
		cfg.dataFromControlBoard = []
	support.goToSleep(0.1)
	print "Reading Output: "
	expected_output_size = cfg.config_attributes["EXPECTED_OUTPUT"]
	print "Expected output size in :" + str(expected_output_size) + " bytes"
	for i in range(0,int(expected_output_size)): #Configurable parameter
        	
                x = "%02X" % getRegByte(0x71)
	
			
		bytes_to_save = str(x)
		#print bytes_to_save
		out_list += bytes_to_save
		
        cfg.dataFromControlBoard.append(out_list)
	print out_list		
        status = putRegByte(0xDD, 0x00) ## deassert snd_to_dut signal

	
def populateControlBoardOutputDataStorage_old(traceCount):
	printFunctions.printToLog("\tGetting data from Control Board for Trace No ->" + str(traceCount+1))
	status = putRegByte(0x30, 0x00)
	status = putRegByte(0x30, 0x05)
	status = putRegByte(0x30, 0x07)
	tempArray = [0] * cfg.config_attributes['BLOCK_SIZE']
	for count in range(0, cfg.config_attributes['BLOCK_SIZE']):
		tempArray[count] = "%02X" % getRegByte(0x71)
	status = putRegByte(0x30, 0x00)
	if (traceCount == 0):
		cfg.dataFromControlBoard = tempArray
	else:
		for x in tempArray:
			#print x
			cfg.dataFromControlBoard.append(x)
	#printFunctions.printToOutputFile(cfg.dataFromControlBoard, globals.CIPHERTEXT)		
	return status
	
def runEncrytionOnControlBoard (traceCount):
	if (cfg.config_attributes['DUMMY_RUN'] == 'YES'):
		status = putRegByte(0x01, 0x02) # Initialize
		printFunctions.printToScreenAndLog("\tRunning Dummy Encryption - " + str(traceCount+1))	
		if (traceCount == 0):
			printFunctions.printToScreenAndLog("\t\tFirst Run - Setting the key for Encryption")
			sendKeyToControlBoard()
			
		sendBlockOfDataToControlBoard(traceCount)
		status = putRegByte(0x01, 0x00) # Initialize
		#support.goToSleep(1)		
		status = putRegByte(0x01, 0xFF) # Run
		#support.goToSleep(1)
		#status = putRegByte(0x01, 0x00) # End
		return status
	elif (cfg.config_attributes['DUMMY_RUN'] == 'NO'):
		
        	status = putRegByte(0xDD, 0x00) ## deassert snd_to_dut signal
		status = putRegByte(0xAA, 0xFF) # Initialize - system_reset
		support.goToSleep(0.1)
		status = putRegByte(0xAA, 0x00) # Initialize
		status = putRegByte(0xBB, 0xFF) # Initialize -- reset dut interfce and dut
		support.goToSleep(0.1)
		status = putRegByte(0xBB, 0x00) # Initialize
		status = putRegByte(0xCC, 0xFF) # Initialize -target_module_reset
		
		#support.goToSleep(0.1)
		status = putRegByte(0xCC, 0x00) # Initialize
		print "init done"
		#support.goToSleep(3)	
		printFunctions.printToScreenAndLog("\tStarted Encryption/Decryption No - " + str(traceCount+1))	
	        sendDataToControlBoard(traceCount)		
		status = putRegByte(0xDD, 0xFF) # Run
                print "start command sent"
		return status


def saveOutput():
	printFunctions.printToScreenAndLog("\tSaving the data from Control Board")
	f = open(globals.CIPHERTEXT, 'wb')
	for line in cfg.dataFromControlBoard:
		f.write("%s\n" % line)
	f.close()

	return True

def displayReg(regByte):
	status = putRegByte(0x40, regByte)
	return status

def resetControlBoard():
	status = putRegByte(0x30, 0x01)
	support.goToSleep(0.001)
	status = putRegByte(0x30, 0x00)

def setControlBoardConfigAttributes():
	status = sendTriggerParamsToControlBoard()
	cfg.dataToCtrlBrdByteNum = 0
	cfg.maskToCtrlBrdByteNum1 = 0
	cfg.maskToCtrlBrdByteNum2 = 0
	cfg.maskToCtrlBrdByteNum3 = 0
	cfg.maskToCtrlBrdByteNum4 = 0
	return status
	
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
	  
