#!/usr/bin/python
##################################################################################
#                                                                           	 #
#	Copyright 2017 Cryptographic Engineering Research Group (CERG)           #
#	George Mason University							 #	
#   http://cryptography.gmu.edu/fobos                                            #                            
#				                                                 #                             	 
#	Licensed under the Apache License, Version 2.0 (the "License");       	 #
#	you may not use this file except in compliance with the License.       	 #
#	You may obtain a copy of the License at                                	 #
#	                                                                       	 #
#	    http://www.apache.org/licenses/LICENSE-2.0                         	 #
#	                                                                       	 #
#	Unless required by applicable law or agreed to in writing, software    	 #
#	distributed under the License is distributed on an "AS IS" BASIS,      	 #
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied	 #
#	See the License for the specific language governing permissions and    	 #
#	limitations under the License.                                         	 #
#                                                                           	 #
##################################################################################
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("start", help="Number of starting sample. All samples before this will be truncated.", type=int)
parser.add_argument("end", help="Number of last sample. Samples from this to the end of trace will be truncated.", type=int)
parser.add_argument("source_trace", help=".npy file that stores M x N array that store the trace to be processed.", type=str)
parser.add_argument("destination_trace", help=".npy file that stores M x N array to stor traces after processing.", type=str)

args = parser.parse_args()
start = args.start
end = args.end
source_trace = args.source_trace
destination_trace = args.destination_trace

print 'Loading trace'
traces = np.load(source_trace)
print 'Traces loaded'

processed_traces = traces[:,start:end] 
np.save(destination_trace, processed_traces)
