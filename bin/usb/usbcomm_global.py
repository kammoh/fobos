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
from ctypes import *
import sys
import os
# Get DLL depending on OS
if (sys.platform == "linux2" ):
    cdll.LoadLibrary("libdpcutil.so")
    usbcomm = CDLL("libdpcutil.so")
elif (sys.platform == "win32" ):
	windll.LoadLibrary("depp.dll")
	usbcomm = WinDLL("depp.dll")	
	windll.LoadLibrary("dmgr.dll")
	usbcommdmgr = WinDLL("dmgr.dll")
    
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

usbcommdmgr.DmgrOpen.argtypes = [POINTER(c_uint), POINTER(c_char)]
usbcommdmgr.DmgrOpen.restypes = c_int

usbcommdmgr.DmgrClose.argtypes = [c_uint]
usbcommdmgr.DmgrClose.restypes = c_int

usbcomm.DeppGetVersion.argtypes = [POINTER(c_char)]

usbcomm.DeppEnableEx.argtypes = [c_uint, c_uint32]

usbcomm.DeppGetReg.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int]
usbcomm.DeppGetReg.restypes = c_int

usbcomm.DeppPutReg.argtypes = [c_uint, c_ubyte, c_ubyte, c_int]
usbcomm.DeppPutReg.restypes = c_int

usbcomm.DeppGetRegRepeat.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_ulong, c_int]
usbcomm.DeppGetRegRepeat.restypes = c_int

