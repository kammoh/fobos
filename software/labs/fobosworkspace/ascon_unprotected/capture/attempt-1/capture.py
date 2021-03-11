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
PROJECT_NAME = "fobos_dut_4_0_ascon_lw_large_unprotected_vivado"
DIN_FILE_NAME = "dinFile.txt"
CIPHER_FILE = "ciphertext.txt"
TRACE_FILE = "powerTraces.npy"
DUT_BIT_FILE = "FOBOS_DUT_aes.bit"
SERIAL_PORT = '/dev/ttyUSB2'
TRACE_NUM = 2000
DUT_CLk = 1
OUT_LEN = 160
TIMEOUT = 5
TRIG_WAIT = 1
TRIG_LENGTH = 1
TRIG_MODE_NORM = 0
TRIG_MODE_FULL = 1
TIME_TO_RST = 0
# Instantiate FOBOS objects###########################################
ctrl = fobos.Basys3Ctrl()
ctrl.setDUTClk(DUT_CLk)
ctrl.disableTestMode()
ctrl.setTimeToReset(TIME_TO_RST)
ctrl.setOutLen(OUT_LEN)
ctrl.setTimeout(TIMEOUT)
ctrl.setTriggerWait(TRIG_WAIT)
ctrl.setTriggerLen(TRIG_LENGTH)
ctrl.setTriggerMode(TRIG_MODE_FULL)

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
                     postTriggerSamples = 68250 #samples #ascon-large needes 546 clk cycles
                     )
scope.setChannel(channelName = 'CHANNEL_A', rangemv = '100mV')
#scope.setChannel(channelName = 'CHANNEL_B', rangemv = '5V')
#scope.setTrigger(channelName ='CHANNEL_B', direction = 'RISING_EDGE', thresholdmv = 200)
scope.setSamplingInterval(samplingIntervalns = 8) #T=8 ns, Fs= 125MHz
scope.setTrigger(channelName ='EXTERNAL', direction = 'RISING_EDGE', 
               thresholdmv = 200)
scope.setDataBuffers()
print 'Sending data..'
traceNum = 0
while traceNum < TRACE_NUM:
    scope.arm()
    data = tvFile.readline()
    status, result = ctrl.processData(data, OUT_LEN)
    if status != fobos.OK:
        print "TIMEOUT"
    print(result)
    cipherFile.write(result + "\n")
    trace = scope.readTracev()
    numpy.save(traceFile, trace)
    traceNum += 1

tvFile.close()
cipherFile.close()
traceFile.close()
 
