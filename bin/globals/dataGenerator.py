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
import array
import os
import re
import binascii
import cfg
import printFunctions 
import globals
from Crypto import Random
from Crypto.Cipher import AES

plainText =  '00000000000000000000000000000000'
secretKey =  '00000000000000000000000000000000'

def convertToHex(hexString):
	hexString = ''.join( [ "%02X " % ord( val ) for val in hexString] ).strip()
	hexString = ''.join( hexString.split(" ") )
	hexBytes = []
	for dataByte in range(0, len(hexString), 2):
		hexBytes.append( hexString[dataByte:dataByte+2])		
	return hexBytes
	
def generateRandomData( ):
	randomBytes = []
	printFunctions.printToScreenAndLog("Number of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']))
	printFunctions.printToScreenAndLog("Block Size: " + str(cfg.config_attributes['BLOCK_SIZE']))	
	TOTAL_DATA = cfg.config_attributes['NUMBER_OF_ENCRYPTIONS'] * cfg.config_attributes['BLOCK_SIZE']
	printFunctions.printToScreenAndLog("Generating " + str(TOTAL_DATA) + " bytes of random data")
	randomBytes = convertToHex(Random.get_random_bytes(TOTAL_DATA))
	printFunctions.printToOutputFile(randomBytes, globals.DATA)
	return randomBytes
	
def generateRandomKey( ):
	randomKeyBytes = []
	printFunctions.printToScreenAndLog("Key Size: " + str(cfg.config_attributes['KEY_SIZE']))	
	TOTAL_DATA = cfg.config_attributes['KEY_SIZE']
	printFunctions.printToScreenAndLog("Generating " + str(TOTAL_DATA) + " bytes of random key")
	randomKeyBytes = convertToHex(Random.get_random_bytes(TOTAL_DATA))
	printFunctions.printToOutputFile(randomKeyBytes, globals.KEY)
	return randomKeyBytes	

def aesEncrypt(data,key):
	key = binascii.unhexlify(key) 
	data = binascii.unhexlify(data) 
	aes = AES.new(key, AES.MODE_ECB)
	cipherText = convertToHex(aes.encrypt(data))
	return cipherText

def aesDecrypt(ct,key):
	key = ''.join(key)
	ct = ''.join(ct)

	aes = AES.new(key, AES.MODE_ECB)
	plainText = convertToHex(aes.decrypt(ct))
	return plainText

def main():
	cipherText = aesEncrypt(plainText, secretKey)
	print plainText
	print secretKey
	print cipherText

			
		


if __name__ == "__main__":
    main()	