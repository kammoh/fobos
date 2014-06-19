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
import os
import sys
import numpy
import matplotlib.pyplot as plt
os.system('clear')
script, rawDataFile, preambleFile = sys.argv
fid = open(preambleFile , "r")
#Read Preamble
preamble = numpy.fromfile(fid, dtype = numpy.float64, count= 10, sep = ",")
fid.close()

i=0
while(i<len(preamble)):
#	print preamble[i]
	i+=1

vdiv = 32 * preamble[7]
off = preamble[8]
sdiv = preamble[2] * preamble [4] / 10
delay = (preamble[2] / 2) * preamble[4] + preamble[5]
sys.stdout.write("Scope Settings for Channel 1:\n")
sys.stdout.write("Volts per Division = %f\n" % vdiv)
sys.stdout.write("Offset = %f\n" % off)
sys.stdout.write("Seconds per Division = %f\n" % sdiv)
sys.stdout.write("Delay = %f\n" % delay)
sys.stdout.write("No. of Bytes = %d\n" % int(preamble[2]))

fid = open(rawDataFile, "r")
img = numpy.array(numpy.fromfile(fid, dtype = numpy.ubyte, count = int(preamble[2]), sep = ""))
sys.stdout.write("No. of Img Bytes = %d\n" % len(img))
fid.close()

i= 0
while(i<len(img)):
#	print img[i]
	i+=1
imgX1 = numpy.arange(1,int(preamble[2]))
numpy.transpose(imgX1)
imgX1 = (imgX1 - preamble[6]) * preamble[4] + preamble[5]
imgY1 = (img - preamble[9]) * preamble[7] + preamble[8]
#raw_trace = imgY1;
plt.plot(imgY1)
plt.ylabel('Volts')
plt.xlabel('Time')
plt.show()

