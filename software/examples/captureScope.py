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
# Constants###########################################################
WORKSPACE = "../workspace"
PROJECT_NAME = "dummyProject"
DIN_FILE_NAME = "dinFile.txt"
CIPHER_FILE = "ciphertext.txt"
TRACE_FILE = "powerTraces.npy"
DUT_BIT_FILE = "FOBOS_DUT_dummy1.bit"
SERIAL_PORT = '/dev/ttyUSB0'
TRACE_NUM = 100
DUT_CLk = 1
OUT_LEN = 7
TIMEOUT = 5
TRIG_WAIT = 1
TRIG_LENGTH = 1
TRIG_MODE_NORM = 0
TRIG_MODE_FULL = 1
TIME_TO_RST = 0
# Instantiate FOBOS objects###########################################
ctrl = fobos.Basys3Ctrl(SERIAL_PORT)
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
dut.program()

tvFileName = os.path.join(projDir, DIN_FILE_NAME)
tvFile = open(tvFileName, "r")
captureDir = pm.getCaptureDir()
cipherFileName = os.path.join(captureDir, CIPHER_FILE)
cipherFile = open(cipherFileName, "w")
traceFileName = os.path.join(captureDir, TRACE_FILE)
traceFile = open(traceFileName, "w")
shutil.copy(tvFileName, captureDir)
# Scope 
scope = fobos.picoscope.Picoscope(sampleResolution = 12, 
                     postTriggerSamples = 10000 #samples

scope.setChannel(channelName = 'CHANNEL_A', rangemv = '100mV')
scope.setSamplingInterval(samplingIntervalns = 2) #T=2 ns, Fs= 500MHz
scope.setTrigger(channelName ='EXTERNAL', direction = 'RISING_EDGE', 
               thresholdmv = 200)
scope.setDataBuffers()

# Get traces############################################################
print 'Sending data..'
traceNum = 0
while traceNum < TRACE_NUM:
    scope.arm()
    data = tvFile.readline()
    status, result = ctrl.processData(data, OUT_LEN)
    if status != fobos.OK:
        print "TIMEOUT"
    print(result)
    trace = scope.readTrace()
    numpy.save(traceFile, trace)
    cipherFile.write(result + "\n")
    traceNum += 1

traceFile.close()
tvFile.close()
cipherFile.close()
