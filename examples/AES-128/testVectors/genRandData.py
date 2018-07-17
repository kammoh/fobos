#!/usr/bin/python
#############################################################################
#                                                                           #
#	Copyright 2016 CERG                                                     #
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
import array
import os
import re
import binascii
from Crypto import Random

numBlocks = 2000
blockSize = 16

def convertToHex(hexString):
	hexString = ''.join( [ "%02X " % ord( val ) for val in hexString] ).strip()
	hexString = ''.join( hexString.split(" ") )
	hexBytes = []
	for dataByte in range(0, len(hexString), 2):
		hexBytes.append( hexString[dataByte:dataByte+2])		
	return hexBytes
	
def generateRandomData(TOTAL_DATA ):
	randomBytes = []
	
	randomBytes = convertToHex(Random.get_random_bytes(TOTAL_DATA))
	
	return randomBytes
	

	
def getPlainText(TOTAL_DATA):
	dataToEncrypt = []
	dataToEncrypt = generateRandomData(TOTAL_DATA)
	return dataToEncrypt
	
		



	
def main():
	plaintext = str()
        for i in range(0, numBlocks):
	    randList = getPlainText(blockSize)
	    block = ''.join(randList) + '\n'
	    plaintext  += block
	f = open('random_plaintext.txt' , 'w')
	f.write(plaintext)
	f.close()
	

			
		


if __name__ == "__main__":
    main()	
