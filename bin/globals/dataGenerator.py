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
import globals, support
from Crypto import Random


def convertToHex(hexString):
	hexString = ''.join( [ "%02X " % ord( val ) for val in hexString] ).strip()
	hexString = ''.join( hexString.split(" ") )
	hexBytes = []
	for dataByte in range(0, len(hexString), 2):
		hexBytes.append( hexString[dataByte:dataByte+2])		
	return hexBytes
	
def generateRandomData( ):
	randomBytes = []
	printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']))
	printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))	
	TOTAL_DATA = cfg.config_attributes['NUMBER_OF_ENCRYPTIONS'] * cfg.config_attributes['BLOCK_SIZE']
	printFunctions.printToScreenAndLog("\tGenerating " + str(TOTAL_DATA) + " bytes of random data")
	randomBytes = convertToHex(Random.get_random_bytes(TOTAL_DATA))
	printFunctions.printToOutputFile(randomBytes, globals.DATA)
	return randomBytes
	
def generateRandomKey( ):
	randomKeyBytes = []
	printFunctions.printToScreenAndLog("\tKey Size: " + str(cfg.config_attributes['KEY_SIZE']))	
	TOTAL_DATA = cfg.config_attributes['KEY_SIZE']
	printFunctions.printToScreenAndLog("\tGenerating " + str(TOTAL_DATA) + " bytes of random key")
	randomKeyBytes = convertToHex(Random.get_random_bytes(TOTAL_DATA))
	printFunctions.printToOutputFile(randomKeyBytes, globals.KEY)
	return randomKeyBytes	
	
def getPlainText():
	dataToEncrypt = []
	if(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.RANDOM):
		dataToEncrypt = generateRandomData()
	elif(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.USER):
		printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS']))
		printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = support.readFile(cfg.config_attributes['DATA_FILE'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					dataToEncrypt.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS'] * cfg.config_attributes['BLOCK_SIZE']
		printFunctions.printToScreenAndLog("\tReading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['DATA_FILE'] +" file")
		printFunctions.printToOutputFile(dataToEncrypt, globals.DATA)
	return dataToEncrypt	
		
def getKey():		
	keyToEncrypt = []
	if(cfg.config_attributes['KEY_GENERATION'] == globals.USER):
		printFunctions.printToScreenAndLog("\tKey Size :" + str(cfg.config_attributes['KEY_SIZE']))
		printFunctions.printToScreenAndLog("\tReading Key from "+ cfg.config_attributes['KEY_FILE'] +" file")
		rawData = support.readFile(cfg.config_attributes['KEY_FILE'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: keyToEncrypt.append(x)
		printFunctions.printToOutputFile(keyToEncrypt, globals.KEY)	
	elif(cfg.config_attributes['KEY_GENERATION'] == globals.RANDOM):
		keyToEncrypt = generateRandomKey()
	return keyToEncrypt	

	
def main():
	print plainText
	print secretKey
	print cipherText

			
		


if __name__ == "__main__":
    main()	