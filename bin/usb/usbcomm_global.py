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
from globals import cfg

# Get DLL depending on OS
if (sys.platform == "linux2" ):
 cdll.LoadLibrary("libdepp.so")
 depp = CDLL("libdepp.so")
 cdll.LoadLibrary("libdmgr.so")
 dmgr = CDLL("libdmgr.so")
elif (sys.platform == "win32" ):
 cdll.LoadLibrary("dmgr.dll")
 dmgr = CDLL("dmgr.dll")
 cdll.LoadLibrary("depp.dll")
 depp = CDLL("depp.dll")
   
VERSION = '0.2'
SUCCESS = True
FAILURE = False
COUNTER = 'counter'
OPENADC = 'openADC'
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
cfg.USB_HANDLE = cast(addressof(HIFbuf), HIFP)


#Device Name pointer Definition
DS = c_char
DSP = POINTER(RS)
DSbuf = c_int(128)
cfg.config_attributes['CONTROL_BOARD'] = cast(addressof(DSbuf), DSP)

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
dmgr.DmgrClose.restypes = None

depp.DeppGetVersion.argtypes = [POINTER(c_char)]

depp.DeppEnableEx.argtypes = [c_uint, c_uint32]

depp.DeppGetReg.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int]
depp.DeppGetReg.restypes = c_int

depp.DeppPutReg.argtypes = [c_uint, c_ubyte, c_ubyte, c_int]
depp.DeppPutReg.restype = c_int

depp.DeppGetRegRepeat.argtypes = [c_uint, c_ubyte, POINTER(c_ubyte), c_int, c_int]
depp.DeppGetRegRepeat.restype = c_int



