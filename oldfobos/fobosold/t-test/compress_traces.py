#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2016 Cryptographic Engineering Research Group (CERG)               #
#	George Mason University														 #	
#   http://cryptography.gmu.edu/fobos                                            #                            
#									                                             #                             	 
#	Licensed under the Apache License, Version 2.0 (the "License");         	 #
#	you may not use this file except in compliance with the License.        	 #
#	You may obtain a copy of the License at                                 	 #
#	                                                                        	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                          	 #
#	                                                                        	 #
#	Unless required by applicable law or agreed to in writing, software     	 #
#	distributed under the License is distributed on an "AS IS" BASIS,       	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.	 #
#	See the License for the specific language governing permissions and     	 #
#	limitations under the License.                                          	 #
#                                                                           	 #
##################################################################################
import numpy
import argparse
	
####################################
def compress(a, compressionLen, compressionType):
	compressedData = numpy.zeros(0)
	totalSampleSize = len(a)
	if((totalSampleSize%compressionLen) == 0 and totalSampleSize > compressionLen):
		lowerBound = 0
		upperBound = compressionLen
		while (upperBound <= totalSampleSize):
			if(compressionType == 'MAX'):
				compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
			elif(compressionType == 'MIN'):
				compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
			elif(compressionType == 'MEAN'):
				compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
			lowerBound = upperBound
			upperBound = upperBound + compressionLen
	elif((totalSampleSize%compressionLen) != 0 and totalSampleSize > compressionLen):
		lowerBound = 0
		upperBound = compressionLen
		while (upperBound <= totalSampleSize):
			if(compressionType == 'MAX'):
				compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
			elif(compressionType == 'MIN'):
				compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
			elif(compressionType == 'MEAN'):
				compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
			lowerBound = upperBound
			upperBound = upperBound + compressionLen
		if(compressionType == 'MAX'):
			compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
		elif(compressionType == 'MIN'):
			compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
		elif(compressionType == 'MEAN'):
			compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
	elif(totalSampleSize == compressionLen):
		lowerBound = 0
		upperBound = totalSampleSize
		if(compressionType == 'MAX'):
			compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
		elif(compressionType == 'MIN'):
			compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
		elif(compressionType == 'MEAN'):
			compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
	elif(totalSampleSize < compressionLen):
		#sys.stdout.write("Compression window is greater than available samples.\n")
		#sys.stdout.write("Adjusting the compression window to total available samples.\n")
		lowerBound = 0
		upperBound = totalSampleSize
		if(compressionType == 'MAX'):
			compressedData = numpy.append(compressedData, numpy.amax(a[lowerBound:upperBound]))
		elif(compressionType == 'MIN'):
			compressedData = numpy.append(compressedData, numpy.amin(a[lowerBound:upperBound]))
		elif(compressionType == 'MEAN'):
			compressedData = numpy.append(compressedData, numpy.mean(a[lowerBound:upperBound]))
	return (compressedData)

	
parser = argparse.ArgumentParser()
parser.add_argument("uncompressed_file", help=".npy file that store traces as MxN Nupmy array", type=str)
parser.add_argument("compressed_file", help=".npy file that store compressed traces as MxN Nupmy array", type=str)
parser.add_argument("compression_length", help="Number of samples to be converted int one sample", type=int)
parser.add_argument("compression_type", help="Compression type: MEAN | MAX | MIN", type=str)
args = parser.parse_args()
uncompressed_file = args.uncompressed_file
compressed_file = args.compressed_file
compression_type = args.compression_type
compression_length = args.compression_length

traces = numpy.load(uncompressed_file)
compressed_traces =  numpy.apply_along_axis(compress, 1, traces,compression_length,compression_type)
numpy.save(compressed_file, compressed_traces)
	
