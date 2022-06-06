#############################################################################
#                                                                           #
#   Copyright 2019 CERG                                                     #
#                                                                           #
#   Licensed under the Apache License, Version 2.0 (the "License");         #
#   you may not use this file except in compliance with the License.        #
#   You may obtain a copy of the License at                                 #
#                                                                           #
#       http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                           #
#   Unless required by applicable law or agreed to in writing, software     #
#   distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#   See the License for the specific language governing permissions and     #
#   limitations under the License.                                          #
#                                                                           #
#############################################################################
import os
import shutil
import fobos
import fobos.picoscope
import numpy
# Constants###########################################################
WORKSPACE = "/home/aabdulga/fobosworkspace"
PROJECT_NAME = "sha3Core"
DIN_FILE_NAME = "dinFile.txt"
CIPHER_FILE = "doutFile.txt"
TRACE_FILE = "powerTraces.npy"
DUT_BIT_FILE = "FOBOS_DUT_aes.bit"
SERIAL_PORT = '/dev/ttyUSB1'
TRACE_NUM = 1000000
DUT_CLk = 1
OUT_LEN = 128
TIMEOUT = 5
TRIG_WAIT = 1
TRIG_LENGTH = 1
TRIG_MODE_NORM = 0
TRIG_MODE_FULL = 1
TIME_TO_RST = 0
GLITCH_WAIT = 1
GLITCH_PATTERN = "0000000000000000"
GLITCH_ENABLE = 1
# Instantiate FOBOS objects###########################################
ctrl = fobos.Basys3Ctrl(port = SERIAL_PORT)
ctrl.setDUTClk(DUT_CLk)
ctrl.disableTestMode()
ctrl.setTimeToReset(TIME_TO_RST)
ctrl.setOutLen(OUT_LEN)
ctrl.setTimeout(TIMEOUT)
ctrl.setTriggerWait(TRIG_WAIT)
ctrl.setTriggerLen(TRIG_LENGTH)
ctrl.setTriggerMode(TRIG_MODE_FULL)
# Set glitch circuit
ctrl.setPowerGlitchWait(GLITCH_WAIT)
ctrl.setPowerGlitchPattern(GLITCH_PATTERN)
ctrl.setPowerGlitchEnable(GLITCH_ENABLE)
# Configure project directories#########################################
pm = fobos.ProjectManager()
pm.setWorkSpaceDir(WORKSPACE)
pm.setProjName(PROJECT_NAME)
projDir = pm.getProjDir()
# program DUT ##########################################################
dut = fobos.Nexys3DUT()
bitFile = os.path.join(projDir, DUT_BIT_FILE)
dut.setBitFile(bitFile)
#dut.program()
# prepare i/o files ####################################################
tvFileName = os.path.join(projDir, DIN_FILE_NAME)
tvFile = open(tvFileName, "r")
captureDir = pm.getCaptureDir()
cipherFileName = os.path.join(captureDir, CIPHER_FILE)
cipherFile = open(cipherFileName, "w")
traceFileName = os.path.join(captureDir, TRACE_FILE)
traceFile = open(traceFileName, "w")
shutil.copy(tvFileName, captureDir)
# Get traces############################################################

################Configure Picoscope
scope = fobos.picoscope.Picoscope(sampleResolution = 8, 
                     postTriggerSamples = 16250 #collecting int(64 clk) + first round(65 clk) => 130 clks
                     )
scope.setChannel(channelName = 'CHANNEL_A', rangemv = '100mV')
#scope.setChannel(channelName = 'CHANNEL_B', rangemv = '5V')
#scope.setTrigger(channelName ='CHANNEL_B', direction = 'RISING_EDGE', thresholdmv = 200)
scope.setSamplingInterval(samplingIntervalns = 8) #T=8 ns, Fs= 125MHz
scope.setTrigger(channelName ='EXTERNAL', direction = 'RISING_EDGE', 
               thresholdmv = 200)
scope.setDataBuffers()
print('Sending data..')
traceNum = 0
while traceNum < TRACE_NUM:
    scope.arm()
    data = tvFile.readline()
    status, result = ctrl.processData(data, OUT_LEN)
    if status != fobos.OK:
        print("TIMEOUT")
    print(result)
    cipherFile.write(result + "\n")
    trace = scope.readTrace()
    numpy.save(traceFile, trace)
    traceNum += 1

tvFile.close()
cipherFile.close()
traceFile.close() 
