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
DeviceName = 'Nexys2'
stressnos = 50
streamBytesnos = 200
debug = 3
dataStreamFile = 'dataStream.txt'
snapShotFile = 'snapShot.png'
dataToStream = OPENADC #COUNTER/OPENADC

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
  status = putRegByte(USBHandle, 0x30, 0x01, debug)
  status = putRegByte(USBHandle, 0x30, 0x00, debug)
  goToSleep(1)
  status = putRegByte(USBHandle, 0x61, 0x00, debug) ## Amp Hi ->01 Lo -> 00
  status = putRegByte(USBHandle, 0x60, 0x00, debug) ## Gain Values - 00 - 4D (4D -> 30.3% max duty cycle -> 2.5V at gain pin)
  


sys.stdout.write("\t\tStreaming %d values\n" % streamBytesnos)
startTime = time()
dataFromFPGA = streamDataFromBRAM(USBHandle, streamBytesnos, dataStreamFile, dataToStream, debug)
endTime = time()
totalTime = endTime - startTime
sys.stdout.write("\t\tWrote to %s\n " % dataStreamFile
+ "\t\tTime Taken - %.3f sec\n" % totalTime 
+ "\t\tSpeed - %.3f Mbytes/Sec\n" % ((streamBytesnos *0.002)/totalTime) )

plt.plot(dataFromFPGA)
plt.ylabel('Data')
plt.xlabel('# of traces')
plt.savefig(snapShotFile,dpi=72)
plt.show()
	
#Terminate USB handle
terminate_usbcomm(USBHandle)






