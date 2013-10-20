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
from time import time
import matplotlib.pyplot as plt


def stressTest(USBHandle, stress_count, debug):
  i = 0
  pass_count = 0
  while(i<stress_count):
    if(debug == 1):
     sys.stdout.write("\tTest ID : %d\n" % i)
    status = getRegByte(USBHandle, 0x50, debug)
    if (status == 0x4B):
      status = putRegByte(USBHandle, 0x40, 0xAA, debug)
      status = putRegByte(USBHandle, 0x40, 0x55, debug)
      if (status == 1): 
       pass_count = pass_count +1
    i = i+1
  if(pass_count == stress_count):
    sys.stdout.write("\t\tCompleted Stress Test. Pass/Stressed = %d" % pass_count +
    "/ %d\n" % stress_count)
  else:
    sys.stdout.write("\t\tSTRESS TEST FAILED!!\n")
      
    
#Declare Control Board Here
DeviceName = 'Nexys3'
stressnos = 50
streamBytesnos = 20000
debug = 3
dataStreamFile = 'dataStream.txt'
dataToStream = COUNTER #COUNTER/OPENADC

#Clearing Screen
clear_screen()  

#Printing Header
print_header(DeviceName)

#Getting USB Handle
USBHandle = initialize_usbcomm(DeviceName)
sys.stdout.write("\tTesting Read Operation")
status = getRegByte(USBHandle, 0x50, debug)
if (status == 0):
  sys.stdout.write("\tRead Operation Failure\n")
else:
  sys.stdout.write("..Pass.\n")
  
sys.stdout.write("\tTesting Write Operation")
status = putRegByte(USBHandle, 0x40, 0xFF, debug)
if (status == 0):
  sys.stdout.write("\tWrite Operation Failure\n")
else:
  sys.stdout.write("..Pass.\n")
  
  
sys.stdout.write("\tPerforming Stress Test..\n")
stressTest(USBHandle, stressnos, debug)

sys.stdout.write("\tPolling On-Board Frequency Counters\n")
readMainClockFreq(USBHandle, DeviceName, debug)

sys.stdout.write("\tTesting Data Streaming %s values..\n" % dataToStream)
if(dataToStream == OPENADC):
  status = putRegByte(USBHandle, 0x61, 0x00, debug)
  status = putRegByte(USBHandle, 0x60, 0x00, debug)

startTime = time()
sys.stdout.write("\t\tStreaming %d values\n" % streamBytesnos)
dataFromFPGA = streamDataFromBRAM(USBHandle, streamBytesnos, dataStreamFile, dataToStream, debug)
sys.stdout.write("\t\tWrote to %s\n " % dataStreamFile
+ "\t\tTime Taken - %s sec\n" % str(time() - startTime) 
+ "\t\tSpeed - %s Mbytes/Sec\n" % str(int((streamBytesnos/1000)/(time() - startTime))))

plt.plot(dataFromFPGA)
plt.ylabel('Data')
plt.xlabel('# of traces')
plt.show()
	
#Terminate USB handle
terminate_usbcomm(USBHandle)






