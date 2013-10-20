#!/usr/bin/python
from ctypes import *
import sys
import os
# Get DLL depending on OS
if (sys.platform == "linux2" ):
 cdll.LoadLibrary("libdepp.so")
 depp = CDLL("libdepp.so")
 cdll.LoadLibrary("libdmgr.so")
 dmgr = CDLL("libdmgr.so")
elif (sys.platform == "win32" ):
 windll.LoadLibrary("dmgr.dll")
 dmgr = WinDLL("dmgr.dll")
 windll.LoadLibrary("depp.dll")
   
VERSION = '0.2'
SUCCESS = True
FAILURE = False
COUNTER = 0
OPENADC = 1
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

dataBYTE = c_ubyte
dataP = POINTER(dataBYTE)
bufBYTE = c_ubyte(10)
dataBYTEP = cast(addressof(bufBYTE), dataP)

#DPC Call functions

dmgr.DmgrOpen.argtypes = [POINTER(c_uint), POINTER(c_char)]
dmgr.DmgrOpen.restypes = c_int

dmgr.DmgrClose.argtypes = [c_uint]

depp.DeppGetVersion.argtypes = [POINTER(c_char)]

depp.DeppEnableEx.argtypes = [c_uint, c_uint32]

depp.DeppGetReg.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int]
depp.DeppGetReg.restypes = c_int

depp.DeppPutReg.argtypes = [c_uint, c_ubyte, c_ubyte, c_int]
depp.DeppPutReg.restype = c_int

depp.DeppGetRegRepeat.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int, c_int]
depp.DeppGetRegRepeat.restype = c_int



