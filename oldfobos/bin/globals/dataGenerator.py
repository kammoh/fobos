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
	printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE']* cfg.config_attributes['NUMBER_OF_TRACES']))
	printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))	
	TOTAL_DATA = cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
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
	print len(randomKeyBytes)
	print randomKeyBytes[0]
	print randomKeyBytes[1]
	print randomKeyBytes[2]
	print randomKeyBytes[3]
	print randomKeyBytes[4]
	print randomKeyBytes[5]
	print randomKeyBytes[6]
	print randomKeyBytes[7]
	print randomKeyBytes[8]
	print randomKeyBytes[9]
	print randomKeyBytes[10]
	print randomKeyBytes[11]
	print randomKeyBytes[12]
	print randomKeyBytes[13]
	print randomKeyBytes[14]	
	print randomKeyBytes[15]	
	printFunctions.printToOutputFile(randomKeyBytes, globals.KEY)
	return randomKeyBytes	
	
def getPlainText():
	dataToEncrypt = []
	if(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.RANDOM):
		dataToEncrypt = generateRandomData()
	elif(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.USER):
		printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['NUMBER_OF_TRACES']))
		printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = support.readFile(cfg.config_attributes['DATA_FILE'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					dataToEncrypt.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		printFunctions.printToScreenAndLog("\tReading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['DATA_FILE'] +" file")
		printFunctions.printToOutputFile(dataToEncrypt, globals.DATA)
	return dataToEncrypt	
	dataToEncrypt = []
	if(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.RANDOM):
		dataToEncrypt = generateRandomData()
	elif(cfg.config_attributes['PLAINTEXT_GENERATION'] == globals.USER):
		printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['NUMBER_OF_TRACES']))
		printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = support.readFile(cfg.config_attributes['DATA_FILE'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					dataToEncrypt.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		printFunctions.printToScreenAndLog("\tReading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['DATA_FILE'] +" file")
		printFunctions.printToOutputFile(dataToEncrypt, globals.DATA)
	return dataToEncrypt	
		
def getData():
        data = []
        printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['NUMBER_OF_TRACES']))
        f = open(cfg.config_attributes['DATA_FILE'])
        data = f.readlines()
	f.close()   
        printFunctions.printToScreenAndLog("\tReading data from "+ cfg.config_attributes['DATA_FILE'] +" file")
        return data


def getMask1():
	maskToEncrypt1 = []
	if(cfg.config_attributes['MASK_GENERATION1'] == globals.RANDOM):
		maskToEncrypt1 = generateRandomData()
	elif(cfg.config_attributes['MASK_GENERATION1'] == globals.USER):
		printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['NUMBER_OF_TRACES']))
		printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = support.readFile(cfg.config_attributes['MASK_FILE1'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					maskToEncrypt1.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		printFunctions.printToScreenAndLog("\tReading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['MASK_FILE1'] +" file")
		printFunctions.printToOutputFile(maskToEncrypt1, globals.MASK1)
	return maskToEncrypt1	

def getMask2():
	maskToEncrypt2 = []
	if(cfg.config_attributes['MASK_GENERATION2'] == globals.RANDOM):
		maskToEncrypt2 = generateRandomData()
	elif(cfg.config_attributes['MASK_GENERATION2'] == globals.USER):
		printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['NUMBER_OF_TRACES']))
		printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = support.readFile(cfg.config_attributes['MASK_FILE2'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					maskToEncrypt2.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		printFunctions.printToScreenAndLog("\tReading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['MASK_FILE2'] +" file")
		printFunctions.printToOutputFile(maskToEncrypt2, globals.MASK2)
	return maskToEncrypt2	

def getMask3():
	maskToEncrypt3 = []
	if(cfg.config_attributes['MASK_GENERATION3'] == globals.RANDOM):
		maskToEncrypt3 = generateRandomData()
	elif(cfg.config_attributes['MASK_GENERATION3'] == globals.USER):
		printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['NUMBER_OF_TRACES']))
		printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = support.readFile(cfg.config_attributes['MASK_FILE3'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					maskToEncrypt3.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		printFunctions.printToScreenAndLog("\tReading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['MASK_FILE3'] +" file")
		printFunctions.printToOutputFile(maskToEncrypt3, globals.MASK3)
	return maskToEncrypt3	

def getMask4():
	maskToEncrypt4 = []
	if(cfg.config_attributes['MASK_GENERATION4'] == globals.RANDOM):
		maskToEncrypt = generateRandomData()
	elif(cfg.config_attributes['MASK_GENERATION4'] == globals.USER):
		printFunctions.printToScreenAndLog("\tNumber of Encryption: " + str(cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['NUMBER_OF_TRACES']))
		printFunctions.printToScreenAndLog("\tBlock Size: " + str(cfg.config_attributes['BLOCK_SIZE']))
		rawData = support.readFile(cfg.config_attributes['MASK_FILE4'])
		for count in range(0, len(rawData)):
			temp = support.convertToByteArray(rawData[count])
			for x in temp: 
				if (x!='\n'): 
					maskToEncrypt4.append(x)
		TOTAL_DATA = 	cfg.config_attributes['NUMBER_OF_ENCRYPTIONS_PER_TRACE'] * cfg.config_attributes['BLOCK_SIZE'] * cfg.config_attributes['NUMBER_OF_TRACES']
		printFunctions.printToScreenAndLog("\tReading " + str(TOTAL_DATA) + " bytes from "+ cfg.config_attributes['MASK_FILE4'] +" file")
		printFunctions.printToOutputFile(maskToEncrypt4, globals.MASK4)
	return maskToEncrypt4	
def getKey():		
	keyToEncrypt = []
	if(cfg.config_attributes['KEY_GENERATION'] == globals.USER):
		if (cfg.PROGRAM_CALL == "ANALYSIS"):
			printFunctions.printToScreenAndAnalysisLog("\tKey Size :" + str(cfg.config_attributes['KEY_SIZE']))
			printFunctions.printToScreenAndAnalysisLog("\tReading Key from "+ cfg.config_attributes['KEY_FILE'] +" file")		
		else:
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
	
def getKeyForAnalysis():		
	keyToEncrypt = []
	rawData = support.readFile(cfg.KEY_FILE)
	for count in range(0, len(rawData)):
		temp = support.convertToByteArray(rawData[count])
		for x in temp: keyToEncrypt.append(x)
	return keyToEncrypt		

	
def main():
	print plainText
	print secretKey
	print cipherText

			
		


if __name__ == "__main__":
    main()	
