#!/usr/bin/python
from ctypes import *
import sys
import os
# Get DLL depending on OS
if (sys.platform == "linux2" ):
 cdll.LoadLibrary("libdpcutil.so")
 usbcomm = CDLL("libdpcutil.so")

elif (sys.platform == "win32" ):
 windll.LoadLibrary("dpcutil.dll")
 usbcomm = WinDLL("dpcutil.dll")
   
VERSION = '0.2'
SUCCESS = True
# Defining types to ctypes

#Error Pointer Definition
ERC = c_int
INTP  = POINTER(ERC)
num = c_int(42)
addr = addressof(num)
ERCP = cast(addr, INTP)

#Result String pointer Definition
RS = c_char
CHP = POINTER(RS)
buf = c_int(128)
ResultString = cast(addressof(buf), CHP)

#Handle pointer definition
#HIF = c_uint
#HIFP = POINTER(HIF)
#HIFbuf = c_uint(8)
#handle = cast(addressof(HIFbuf), HIFP)


#Device Name pointer Definition
DS = c_char
DSP = POINTER(RS)
DSbuf = c_int(128)
DeviceName = cast(addressof(DSbuf), DSP)

#General Definitions
regBYTE = c_ubyte
VOIDP = c_void_p

#DPC Call functions

usbcomm.DpcInit.argtypes = [POINTER(c_int)]
usbcomm.DpcInit.restype = c_int

usbcomm.DpcTerm.argtypes = [c_void_p]
usbcomm.DpcTerm.restype = None

usbcomm.DpcGetDpcVersion.argtypes = [POINTER(c_char), POINTER(c_int)]
usbcomm.DpcGetDpcVersion.restype = c_int

usbcomm.DpcOpenData.argtypes = [POINTER(c_uint), POINTER(c_char), POINTER(c_int), POINTER(c_int)]
usbcomm.DpcOpenData.restype = c_int

usbcomm.DpcCloseData.argtypes = [c_uint, POINTER(c_int)]
usbcomm.DpcCloseData.restype = c_int

usbcomm.DpcGetReg.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), POINTER(c_int), POINTER(c_int)]
usbcomm.DpcGetReg.restype = c_int

usbcomm.DpcPutReg.argtypes = [c_uint, c_ubyte, c_ubyte, POINTER(c_int), POINTER(c_int)]
usbcomm.DpcPutReg.restype = c_int

usbcomm.DpcGetRegRepeat.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int, POINTER(c_int), POINTER(c_int)]
usbcomm.DpcGetRegRepeat.restype = c_int



