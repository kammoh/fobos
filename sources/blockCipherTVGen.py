###FOBOS TV generator
###Generates random test vector for block ciphers 
##Author : Abubakr Abdulgadir
###June 2018

import array
import os
import re
import binascii
from Crypto import Random

############user defined settings
TRACE_NUM = 50000            #Number of traces
PDI_LENGTH = 16            #In byets
SDI_LENGTH = 16           #In bytes
EXPECTED_OUT = 16          #expected output in bytes
DIN_FILE = 'dinFile.txt'  #desitination file name
PLAINTEXT_FILE = 'plaintext.txt'  #desitination file name
FIXED_KEY = 'yes'          #Fixed key = yes | no
#KEY =  '00112233445566778899AABBCCDDEEFF' # Fixed key (if needed)
KEY = '123456789009876ABCDFE12456789ABF'

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


def main():
   fDin = open(DIN_FILE,'w')
   fPlain = open(PLAINTEXT_FILE,'w')
   for pdi in range(0,TRACE_NUM):
      pdi = getRandData(PDI_LENGTH)
      if (FIXED_KEY == 'yes'):
         sdi = KEY
      else:
         sdi =  getRandData(SDI_LENGTH)
      data = PDI_HEADER + pdiLength + pdi + SDI_HEADER + sdiLength + sdi  + EXPECTED_OUT_CMD + expectedOut + CMD + START + '\n'
      fDin.write(data)
      fPlain.write(pdi + '\n')

   fDin.close()
   fPlain.close()

if __name__ == '__main__':
    main()
