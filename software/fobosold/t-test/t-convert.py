#!/usr/bin/python
import math
import numpy
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("t_array_file", help=".npy file that has traces stored as 1xN Nupmy array", type=str)
parser.add_argument("text_file", help="text file that will contain t values", type=str)
args = parser.parse_args()
t_array_file = args.t_array_file
text_file = args.text_file
writeFile = open(text_file,'w')

t_array = numpy.load(t_array_file)
#num_of_traces = raw_traces0.shape[0]

samples_per_trace = t_array.shape[0]
#print "num_of_traces=", num_of_traces
print "samples_per_trace=", samples_per_trace

for i in range (0, samples_per_trace):
  ostr = str(t_array[i]) + '\n'
  writeFile.write(ostr)
  
# end  
