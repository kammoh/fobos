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

# This .py file parses the #values from the oscilloscope global attrib file and 
# produces Agilent specific keywords

def parse_attrib_agilent(inst_attrib) :
  inst_attrib1 = {}
  print "\tParsing  Oscilloscope Attributes to Agilent Specific Value\n"
  if inst_attrib['IMPEDANCE'] :
    inst_attrib1['IMPEDANCE'] = ":CHANNEL1:IMPEDANCE "+inst_attrib['IMPEDANCE']+'\n'
  if inst_attrib['CHANNEL_RANGE1'] :
    inst_attrib1['CHANNEL_RANGE1'] = ":CHANNEL1:RANGE "+inst_attrib['CHANNEL_RANGE1']+'\n'
  if inst_attrib['CHANNEL_RANGE2'] :
    inst_attrib1['CHANNEL_RANGE2'] = ":CHANNEL2:RANGE "+inst_attrib['CHANNEL_RANGE2']+'\n'
  if inst_attrib['CHANNEL_RANGE3'] :
    inst_attrib1['CHANNEL_RANGE3'] = ":CHANNEL3:RANGE "+inst_attrib['CHANNEL_RANGE3']+'\n'	    
  if inst_attrib['CHANNEL_RANGE4'] :
    inst_attrib1['CHANNEL_RANGE4']= ":CHANNEL4:RANGE "+inst_attrib['CHANNEL_RANGE4']+'\n'
  if inst_attrib['TIME_RANGE'] :
    inst_attrib1['TIME_RANGE'] = ":TIM:RANG "+inst_attrib['TIME_RANGE']+'\n'
  if inst_attrib['TIMEBASE_REF'] :
    inst_attrib1['TIMEBASE_REF']= ":TIMEBASE:REFERENCE "+inst_attrib['TIMEBASE_REF']+'\n'
  if inst_attrib['TRIGGER_SOURCE'] :
    inst_attrib1['TRIGGER_SOURCE']= ":TRIGger:EDGE:SOURce "+inst_attrib['TRIGGER_SOURCE']+'\n'
  if inst_attrib['TRIGGER_MODE'] :
    inst_attrib1['TRIGGER_MODE']= ":TRIGGER:MODE "+inst_attrib['TRIGGER_MODE']+'\n'
  if inst_attrib['TRIGGER_SWEEP'] :
    inst_attrib1['TRIGGER_SWEEP']= ":TRIGGER:SWEEP "+inst_attrib['TRIGGER_SWEEP']+'\n'
  if inst_attrib['TRIGGER_LEVEL'] :
    inst_attrib1['TRIGGER_LEVEL']= ":TRIGGER:EDGE:LEVEL "+inst_attrib['TRIGGER_LEVEL']+'\n'
  if inst_attrib['TRIGGER_SLOPE'] :
    inst_attrib1['TRIGGER_SLOPE'] = ":TRIGGER:EDGE:SLOPE "+inst_attrib['TRIGGER_SLOPE']+'\n'
  if inst_attrib['ACQUIRE_TYPE'] :
    inst_attrib1['ACQUIRE_TYPE'] = ":ACQUIRE:TYPE "+inst_attrib['ACQUIRE_TYPE']+'\n'
  if inst_attrib['ACQUIRE_MODE'] :
    inst_attrib1['ACQUIRE_MODE']= ":ACQUIRE:MODE "+inst_attrib['ACQUIRE_MODE']+'\n'
  if inst_attrib['ACQUIRE_COMPLETE'] :
   inst_attrib1['ACQUIRE_COMPLETE'] = ":ACQUIRE:COMPLETE "+inst_attrib['ACQUIRE_COMPLETE']+'\n'

  return (inst_attrib1)

