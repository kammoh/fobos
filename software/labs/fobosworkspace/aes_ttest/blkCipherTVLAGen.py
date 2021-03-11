
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
# FOBOS TV generator
# Generates random test vector for block ciphers 
# Author : Abubakr Abdulgadir
# June 2018

import array
import os
import re
import binascii
from Crypto import Random
import random

############user defined settings
TRACE_NUM = 10000                           # Number of traces
PDI_LENGTH = 16                            # In byets
SDI_LENGTH = 16                            # In bytes
EXPECTED_OUT = 16                          # Expected output in bytes
DIN_FILE = 'dinFile.txt'                   # Desitination file name
PLAINTEXT_FILE = 'plaintext.txt'           # Desitination file name
FVR_FILE = 'fvrchoicefile.txt'
FIXED_KEY = 'yes'                          # Fixed key = yes | no
KEY =       '123456789009876ABCDFE12456789ABF'   # Fixed key
FIXED_PDI = '1FF935C7C513EC441EB6D73EE4925FA5'
FIXED_TV = '00C00010' + FIXED_PDI + '00C10010123456789009876ABCDFE12456789ABF0081001000800001' + '\n'
####header data - See Fobos protocol
PDI_HEADER = '00C0'
SDI_HEADER = '00C1'
CMD = '0080'
START = '0001'
EXPECTED_OUT_CMD = '0081'
###########################################################

pdiLength = format(PDI_LENGTH, '04x').upper() ##format into 4 hex digits
sdiLength = format(SDI_LENGTH, '04x').upper()
expectedOut = format(EXPECTED_OUT, '04x').upper()



def convertToHex(hexString):
    hexString = ''.join( [ "%02X " % ord( val ) for val in hexString] ).strip()
    hexString = ''.join( hexString.split(" ") )
    hexBytes = []
    for dataByte in range(0, len(hexString), 2):
        hexBytes.append( hexString[dataByte:dataByte+2])		
    return hexBytes

def generateRandomData(blockSize):
    randomBytes = []
    randomBytes = convertToHex(Random.get_random_bytes(blockSize))
    return randomBytes

def getRandData(blockSize):
    data = []
    data = generateRandomData(blockSize)
    return  ''.join(data)

def genRndTV():
    pdi = getRandData(PDI_LENGTH)
    if (FIXED_KEY == 'yes'):
        sdi = KEY
    else:
        sdi =  getRandData(SDI_LENGTH)
    data = PDI_HEADER + pdiLength + pdi + SDI_HEADER + sdiLength + sdi  + EXPECTED_OUT_CMD + expectedOut + CMD + START + '\n'
    res = ' '.join(pdi[i:i+2] for i in range(0, len(pdi), 2))
    return data, res

def main():
    fDin = open(DIN_FILE,'w')
    fPlain = open(PLAINTEXT_FILE,'w')
    fvrChoiceFile = open(FVR_FILE, 'w')
    for i in range(0,TRACE_NUM):
        r = random.randint(0,1)
        fvrChoiceFile.write(str(r))
        if r == 1:
            data , res = genRndTV()
        else:
            data, res = FIXED_TV, FIXED_PDI
        fDin.write(data)
        fPlain.write(res + '\n')

    fvrChoiceFile.close()
    fDin.close()
    fPlain.close()

if __name__ == '__main__':
    main()
