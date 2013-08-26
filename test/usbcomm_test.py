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
import pickle

COMMAND_REGISTER = 0x00
PWM_REGISTER = 0x02

def reset_OpenADCTest(debug):
 sys.stdout.write("\tSending Reset Command ...")
 putByteToReg(DeviceName,COMMAND_REGISTER, 0xC0, debug)
 sys.stdout.write("..[DONE]\n")
 sys.stdout.write("\tSending Start Command ...")
 putByteToReg(DeviceName,COMMAND_REGISTER, 0x00, debug)
 sys.stdout.write("..[DONE]\n")		


def setpwmValue(pwmValue, debug):
 sys.stdout.write("\tSending PWM Register Value to %d ..." %pwmValue)
 putByteToReg(DeviceName,PWM_REGISTER, pwmValue, debug)
 sys.stdout.write("..[DONE]\n")

def readDCMClockFreq(debug) :
  dcmclkfreq_hex = [0,0,0,0]
  dcmclkfreq_hex[0] = getByteFromReg(DeviceName, 7, debug)
  dcmclkfreq_hex[1] = getByteFromReg(DeviceName, 8, debug)
  dcmclkfreq_hex[2] = getByteFromReg(DeviceName, 9, debug)
  dcmclkfreq_hex[3] = getByteFromReg(DeviceName, 10, debug)
  dcmclkfreq_MHz = int(arrayToString(dcmclkfreq_hex), 16)/1000000
  sys.stdout.write("\tDCM Clock Frequency - %d MHz\n" % dcmclkfreq_MHz)
 
def writeToFile(data, outfile):
 f = open(outfile, "w+b")
 pickle.dump(data, f)
 f.close()
		
def getDataFromBRAMs(nosval, debug):
 lowernibble = [0] * nosval
 highernibble = [0] * nosval
 adcHighnibble = 0b000000
 dataArrayFile = "data_BRAM_binary.txt"
 dataADCFile = "data_adc_voltages.txt" 
 lowernibble = getDataStreamFromReg(DeviceName, 11, nosval, debug)
 highernibble = getDataStreamFromReg(DeviceName, 12, nosval, debug)
 i=0
 while(i < len(lowernibble)):
  dataArray[i] = (lowernibble[i] <<8) |  highernibble[i]
  temp = (lowernibble[i] <<8) |  highernibble[i]
  adcBinary[i] =  highernibble<<6 | temp[6:15]
  adcVoltageValues[i] = int(arrayToString(adcBinary[i]), 2) *(3.3/1023)
 writeToFile(adcBinary, dataArrayFile)
 writeToFile(adcVoltageValues, dataADCFile)
  

#Declare Control Board Here
DeviceName = 'Nexys2'


#Clearing Screen
clear_screen()  

#Printing Header
print_header(DeviceName)
getVersion()

#Prints debug messages if dbug=1/0 does not
dbg = 0

#Main Program
reset_OpenADCTest(dbg)
setpwmValue(0x27, dbg)
readDCMClockFreq(dbg)




