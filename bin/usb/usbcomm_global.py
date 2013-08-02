#!/usr/bin/python
from ctypes import *
import sys
import os
# Get DLL depending on OS
if (sys.platform == "linux2" ):
    cdll.LoadLibrary("libdpcutil.so")
    usbcomm = CDLL("libdpcutil.so")
	usbcommDMGR = usbcomm
elif (sys.platform == "win32" ):
	windll.LoadLibrary("dpcutil.dll")
	usbcomm = WinDLL("dpcutil.dll")
	windll.LoadLibrary("dmgr.dll")
	usbcommDMGR = WinDLL("dmgr.dll")	
    
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
HIF = c_uint
HIFP = POINTER(HIF)
HIFbuf = c_uint(8)
handle = cast(addressof(HIFbuf), HIFP)


#Device Name pointer Definition
DS = c_char
DSP = POINTER(RS)
DSbuf = c_int(128)
DeviceName = cast(addressof(DSbuf), DSP)

#General Definitions
regBYTE = c_ubyte
VOIDP = c_void_p

#DPC Call functions

usbcommDMGR.DmgrOpen.argtypes = [POINTER(c_uint), POINTER(c_char)]
usbcommDMGR.DmgrOpen.restypes = c_int

usbcommDMGR.DmgrClose.argtypes = [c_uint]
usbcommDMGR.DmgrClose.restypes = c_int

usbcomm.DeppGetVersion.argtypes = [POINTER(c_char)]

usbcomm.DeppEnableEx.argtypes = [c_uint, c_uint32]

usbcomm.DeppGetReg.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int]
usbcomm.DeppGetReg.restypes = c_int

usbcomm.DeppPutReg.argtypes = [c_uint, c_ubyte, c_ubyte, c_int]
usbcomm.DeppPutReg.restypes = c_int

usbcomm.DeppGetRegRepeat.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_ulong, c_int]
usbcomm.DeppGetRegRepeat.restypes = c_int

