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
import fobos
# Constants###########################################################
TRACE_NUM = 5
OUT_LEN = 7
# Instantiate FOBOS objects###########################################
print("Sending configuration...")
ctrl = fobos.Basys3Ctrl()
ctrl.enableTestMode()
ctrl.setOutLen(OUT_LEN)
# Run DUT operations
testVectors = ['00c0000761996dc996d4ac00c100070f7821507a22a00081000700800001',
               '00c00007fd8771fe717de400c100073e1fe5b4aa357c0081000700800001',
               '00c0000782051f5484702200c10007980d05d4ea25bc0081000700800001',
               '00c0000767881b702afe5200c10007b08a5e036de72b0081000700800001',
               '00c0000726a1d601ccdf7a00c1000773539e52672d5d0081000700800001']

print 'Sending data..'
traceNum = 0
while traceNum < TRACE_NUM:
    data = testVectors[traceNum]
    status, result = ctrl.processData(data, OUT_LEN)
    if status != fobos.OK:
        print "TIMEOUT"
    print(result)
    traceNum += 1
