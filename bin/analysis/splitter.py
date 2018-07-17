#!/usr/bin/python
##############################################################################
#                                                                            #
#	Copyright 2018 Cryptographic Engineering Research Group (CERG)           #
#	George Mason University							                         #	
#   http://cryptography.gmu.edu/fobos                                        #                            
#									                                         #
#	Licensed under the Apache License, Version 2.0 (the "License");        	 #
#	you may not use this file except in compliance with the License.       	 #
#	You may obtain a copy of the License at                                	 #
#	                                                                       	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                         	 #
#	                                                                       	 #
#	Unless required by applicable law or agreed to in writing, software    	 #
#	distributed under the License is distributed on an "AS IS" BASIS,      	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. #
#	See the License for the specific language governing permissions and      #
#	limitations under the License.                                           #
#                                                                          	 #
##############################################################################
#This script takes the full traces and partitions it into two sets Q0 and Q1 using the mapping file 'fvrchoice'
################################
import numpy
######CONSTANTS
#MAX_TRACE=20000
#traces0File = 'traces0.npy'
#traces1File = 'traces1.npy'
#fvrFile = 'fvrchoicefile.txt'
#cleanTraceFile = 'cleanTraces.npy'
##########################

def countZerosOnes(fileName):
   #calculate the number of ones in the fvrchoicefile.txt
   f = open(fileName, 'r')
   content = f.read()
   f.close()
   #print content
   numOnes = 0
   for i in range(0, len(content)):
      if content[i] == '1':
         numOnes+=1
   numZeros = len(content) - numOnes
   return numZeros,numOnes



def splitTrace(MAX_TRACE, traceFile0, traceFile1, fvrFile, cleanTraceFile):

   numZeros, numOnes =  countZerosOnes(fvrFile)

   print "#######Spliter script"
   #print numZeros, numOnes
   ##create arrays
   print "Reading traces file. Please wait ..."
   full_traces = numpy.load(cleanTraceFile)
   print "Reading trace file done."
   #print full_traces.shape
   samplesPerTrace = full_traces.shape[1]

   traces0 = numpy.empty((numZeros,samplesPerTrace))
   traces1 = numpy.empty((numOnes, samplesPerTrace))
   
   traceCount0 = 0
   traceCount1 = 0

   fullTraceIndex = 0
   i=0
   with  open(fvrFile) as f:
      while i < MAX_TRACE:
         c = f.read(1)
         if not c:
            print "End of file"
            break
         #print "index=",fullTraceIndex
         #print c
         temp = full_traces[fullTraceIndex,:]
         fullTraceIndex += 1
         if c == '0':
            #print "Q0"
            traces0[traceCount0,:] = temp
            traceCount0 += 1

         else:
            #print "Q1"
            traces1[traceCount1,:] = temp
            traceCount1 += 1
         i +=1

   print "Done splitting"
   print "   Q0 shape:" , traces0.shape
   print "   Q1 shape:" , traces1.shape
   print "Saving files. Please wait ..."
   numpy.save(traceFile0, traces0)
   numpy.save(traceFile1, traces1)
   print "Done"
