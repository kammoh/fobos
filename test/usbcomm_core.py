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
    if (sys.platform == "linux2" ):
      os.system('clear')
    elif (sys.platform == "win32" ):
      os.system('cls')

def arrayToString(array):
  r = ''
  for num in array:
    r += '%02X' % num
  return r
  
def print_header(DeviceName):
    sys.stdout.write("-----------------------------------------------\n")
    sys.stdout.write("Starting PC-FPGA Communication via USB\n")
    sys.stdout.write("\tControl Board -> %s\n" % DeviceName)
    sys.stdout.write("\tVersion -> %s\n" % VERSION)
    sys.stdout.write("-----------------------------------------------\n") 
	
def print_OpenADCheader(DeviceName):
	print_header(DeviceName)
	sys.stdout.write("\tStarting FOBOS- OpenADC Communication Script\n")

def initialize_usbcomm():
 ERC = c_int
 INTP  = POINTER(ERC)
 num = c_int(42)
 addr = addressof(num)
 ERCP = cast(addr, INTP) 
 status = usbcomm.DpcInit(ERCP)
 if(status == SUCCESS):
   sys.stdout.write("\tDPC Library Initialized. ERC - %d\n" % ERCP[0])
 else:
   sys.stdout.write("\tDPC Library is not Initialized. ERC - %d\n" % ERCP[0])

def terminate_usbcomm():
 usbcomm.DpcTerm(None)
 sys.stdout.write("\tDPC Library closed\n")

def getVersion():
  initialize_usbcomm()
  status = usbcomm.DpcGetDpcVersion(ResultString, ERCP)
  sys.stdout.write("\tDPCUTIL version -> %s"% ResultString[0:10])
  sys.stdout.write(" ERC - %d\n" % ERCP[0])
  terminate_usbcomm()
  
def getByte(DeviceName, regByte, debug):
  ERC = c_int
  INTP  = POINTER(ERC)
  num = c_int(42)
  addr = addressof(num)
  ERCP = cast(addr, INTP)
  HIF = c_uint
  HIFP = POINTER(HIF)
  HIFbuf = c_uint(8)
  handle = cast(addressof(HIFbuf), HIFP)
  dataBYTE = c_ubyte
  dataP = POINTER(dataBYTE)
  bufBYTE = c_ubyte(10)
  dataBYTEP = cast(addressof(bufBYTE), dataP)
  if(usbcomm.DpcOpenData(handle, DeviceName, ERCP, None)):
    if(debug == 1):
      sys.stdout.write("\tTransmission Channel Open.ERC - %d\n" % ERCP[0])
  else:
    sys.stdout.write("\tTransmission Channel Could Not be Opened. ERC - %d\n" % ERCP[0])
    return(0)  
  if(usbcomm.DpcGetReg(handle[0], regByte, dataBYTEP, ERCP, None)):
   if(debug == 1):
    sys.stdout.write("\tReading from Reg -> %02X " %regByte)
    sys.stdout.write(": Data -> %02X" % dataBYTEP[0])
    sys.stdout.write(" ERC - %d\n" % ERCP[0])
   dataVAL = dataBYTEP[0]
  else:
   sys.stdout.write("\tCould not read register -> %X" % regByte)
   sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(0)
  if(usbcomm.DpcCloseData(handle[0], ERCP)):
   if(debug == 1):
    sys.stdout.write("\tTransmission Channel Closed")
    sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return (dataVAL)
  else:
   sys.stdout.write("\tTransmission Channel Could Not be Closed")
   sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(0)   
  
    
def getByteFromReg(DeviceName, regByte, debug):
 initialize_usbcomm()
 ByteVal = getByte(DeviceName, regByte,debug)
 terminate_usbcomm()
 return (ByteVal)

def putByte(DeviceName, regByte, dataBYTE, debug):
  ERC = c_int
  INTP  = POINTER(ERC)
  num = c_int(42)
  addr = addressof(num)
  ERCP = cast(addr, INTP)
  HIF = c_uint
  HIFP = POINTER(HIF)
  HIFbuf = c_uint(8)
  handle = cast(addressof(HIFbuf), HIFP)
  if(usbcomm.DpcOpenData(handle, DeviceName, ERCP, None)):
   if(debug == 1): 
    sys.stdout.write("\tTransmission Channel Open")
    sys.stdout.write(" ERC - %d\n" % ERCP[0])
  else:
   sys.stdout.write("\tTransmission Channel Could Not be Opened")
   sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(0)  
  if(usbcomm.DpcPutReg(handle[0], regByte, dataBYTE, ERCP, None)):
   if(debug == 1):
    sys.stdout.write("\tSending Data -> %02X " %dataBYTE)
    sys.stdout.write("to Reg -> %02X" % regByte)
    sys.stdout.write(" ERC - %d\n" % ERCP[0])
  else:
   sys.stdout.write("\tCould not write to register -> %X" % regByte)
   sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(0)
  if(usbcomm.DpcCloseData(handle[0], ERCP)):
   if(debug == 1):
    sys.stdout.write("\tTransmission Channel Closed")
    sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(1)
  else:
   sys.stdout.write("\tTransmission Channel Could Not be Closed")
   sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(0)   
     
  
def putByteToReg(DeviceName,regByte, dataBYTE, debug):
 initialize_usbcomm()
 ResultValue = putByte (DeviceName, regByte, dataBYTE, debug)
 terminate_usbcomm()
 return (ResultValue)
 

def getDataStream(DeviceName, regByte,bytesNos, debug):
  dataSTREAM = c_ubyte
  dataSTP = POINTER(dataSTREAM)
  bufSTREAM = c_ubyte(bytesNos)
  dataSTREAMP = cast(addressof(bufSTREAM), dataSTP)
  if(usbcomm.DpcOpenData(handle, DeviceName, ERCP, None)):
   if(debug ==1): 
    sys.stdout.write("\tTransmission Channel Open.ERC - %d\n" % ERCP[0])
  else:
   sys.stdout.write("\tTransmission Channel Could Not be Opened. ERC - %d\n" % ERCP[0])
   return(0)  
  if(usbcomm.DpcGetRegRepeat(handle[0], regByte, dataSTREAMP, bytesNos, ERCP, None)):
   if(debug == 1):
    sys.stdout.write("Finished Stream the data to a Local Variable\n")
    sys.stdout.write(" ERC - %d\n" % ERCP[0])
   streamVAL = dataSTREAMP[0:bytesNos]
  else:
   sys.stdout.write("\tCould not read register -> %X" % regByte)
   sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(0)
  if(usbcomm.DpcCloseData(handle[0], ERCP)):
   if(debug == 1):
    sys.stdout.write("\tTransmission Channel Closed")
    sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return (streamVAL)
  else:
   sys.stdout.write("\tTransmission Channel Could Not be Closed")
   sys.stdout.write(" ERC - %d\n" % ERCP[0])
   return(0)   

def getDataStreamFromReg(DeviceName, regByte, bytesNos, debug):
 initialize_usbcomm()
 dataStream = getDataStream(DeviceName, regByte, bytesNos, debug)
 terminate_usbcomm()
 return(dataStream)
 
def setTime(TimeOutValue, DeviceName):
 cdll.LoadLibrary("libdepp.so")
 epp = CDLL("libdepp.so")
 epp.DeppSetTimeout.argtypes = [c_uint, c_ulong, POINTER(c_ulong)]
 epp.DeppSetTimeout.restypes = c_int
 
 epp.DmgrOpen.argtypes = [POINTER(c_uint), POINTER(c_char)]
 epp.DmgrOpen.restypes = c_int
 epp.DeppEnable.argtypes = [c_uint]
 
 dword = c_ulong
 dwordp = POINTER(c_ulong)
 dwordbuf = c_ulong(10)
 timeoutVAL = cast(addressof(dwordbuf), dwordp)
 
 HIF = c_uint
 HIFP = POINTER(HIF)
 HIFbuf = c_uint(8)
 handle = cast(addressof(HIFbuf), HIFP)
 
 epp.DmgrOpen(handle, DeviceName)
 epp.DeppEnable(handle[0])
 epp.DeppSetTimeout(handle[0], 1000000, timeoutVAL)
 sys.stdout.write("\tTimeoutvalue - %d" % timeoutVAL[0]) 
 