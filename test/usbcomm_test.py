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

COMMAND_REGISTER = 0x00
PWM_REGISTER = 0x02

def reset_OpenADCTest(debug):
 sys.stdout.write("\tSending Reset Command ...")
 putByteToReg(DeviceName,COMMAND_REGISTER, 0xC0, debug)
 sys.stdout.write("..[DONE]\n")
 sys.stdout.write("\tSending Start Command ...")
 putByteToReg(DeviceName,COMMAND_REGISTER, 0xC0, debug)
 sys.stdout.write("..[DONE]\n")		


def setpwmValue(pwmValue, debug):
 sys.stdout.write("\tSending PWM Register Value to %d ..." %pwmValue)
 putByteToReg(DeviceName,PWM_REGISTER, pwmValue, debug)
 sys.stdout.write("..[DONE]\n")

def readDCMClockFreq(debug) :
  dcmclkfreq_hex = [0,0,0,0]
  dcmclkfreq_hex[0] = getByteFromReg(DeviceName, 0x07, debug)
  dcmclkfreq_hex[1] = getByteFromReg(DeviceName, 0x08, debug)
  dcmclkfreq_hex[2] = getByteFromReg(DeviceName, 0x09, debug)
  dcmclkfreq_hex[3] = getByteFromReg(DeviceName, 0x0A, debug)
  dcmclkfreq_MHz = int(arrayToString(dcmclkfreq_hex), 16)/1000000
  sys.stdout.write("\tDCM Clock Frequency - %d MHz\n" % dcmclkfreq_MHz)
  

#Declare Control Board Here
DeviceName = 'Nexys2'


#Clearing Screen
clear_screen()  

#Printing Header
print_header(DeviceName)
getVersion()

#Prints debug messages if dbug=1/0 does not
dbg = 1

#Main Program
reset_OpenADCTest(dbg)
setpwmValue(0x27, dbg)
readDCMClockFreq(dbg)




