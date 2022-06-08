#############################################################################
#                                                                           #
#   Copyright 2019 CERG                                                     #
#                                                                           #
#   Licensed under the Apache License, Version 2.0 (the "License");         #
#   you may not use this file except in compliance with the License.        #
#   You may obtain a copy of the License at                                 #
#                                                                           #
#       http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                           #
#   Unless required by applicable law or agreed to in writing, software     #
#   distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#   See the License for the specific language governing permissions and     #
#   limitations under the License.                                          #
#                                                                           #
#############################################################################
import math
import numpy
import matplotlib as mpl
mpl.use('Agg')
mpl.use( 'tkagg' )
import matplotlib
import matplotlib.pyplot as plt
import argparse
import scipy.special
import time


thresholdLineWidth = 2.0
labelFontSize = 23
axisFontSize = 23

font = {'family' : 'normal',
       # 'weight' : 'bold',
        'size'   : axisFontSize}

matplotlib.rc('font', **font)

start = time.time()

start_ylim = 10**-9
end_ylim = 1
xticks = [0, 10000, 20000, 30000, 40000]
start_xlim = 0
#end_xlim = 136500
end_xlim = 43000

num_of_traces = 969

def p_value(x, v):
    ulimit = x * 4 # = infinity
    i = float(x) #index
    istep = 0.5 
    p = 0.0 # initialize probability
    v2 = float(v/2)
    #print "v2 = ", v2
    v2m1 = float(v2 - 1)
    v22 = math.pow(2,v2)
    v2g = math.gamma(v2)
    gp = float(v22 * v2g)
    #icount = 0
    while (i < ulimit):
        p = p + (math.pow(i,v2m1)*math.exp(-i/2)/gp)*istep
        i = i + istep
        #i = i + math.log10(i)/100
        #icount = icount + 1
    #print "icount=", icount
    return p

parser = argparse.ArgumentParser()
parser.add_argument("trace_file0", help=".npy file that store traces as MxN Nupmy array", type=str)
parser.add_argument("trace_file1", help=".npy file that store traces as MxN Nupmy array", type=str)
parser.add_argument("plot_file", help="File name to store the output figure", type=str)
args = parser.parse_args()
trace_file0 = args.trace_file0
trace_file1 = args.trace_file1
plot_file = args.plot_file
raw_traces0 = numpy.load(trace_file0)
raw_traces1 = numpy.load(trace_file1)   
   

samples_per_trace = raw_traces0.shape[1]
print ("num_of_traces=", num_of_traces)
print ("samples_per_trace=", samples_per_trace)

print (raw_traces0.shape)

# initializations
t0bins = []
t0freqs = []
t1bins = []
t1freqs = []
mergebins = []
t0mergefreq = []
t1mergefreq = []
E0 = []
E1 = []
chi0 = []
chi1 = []
p_array= [ ]

max_freq = 256 # for 8-bit ADC

for i in range(0, max_freq):
    t0bins.append(0)
    t1bins.append(0)
    t0freqs.append(0)
    t1freqs.append(0)
    mergebins.append(0)
    t0mergefreq.append(0)
    t1mergefreq.append(0)
    E0.append(0)
    E1.append(0)
    chi0.append(0)
    chi1.append(0)

#for sample_num in range(0, raw_traces0.shape[1]):
for sample_num in range(0, samples_per_trace):
  unique0, count0 = numpy.unique(raw_traces0[0: num_of_traces, sample_num], return_counts=True)
  unique0 = list(unique0)
  count0 = list(count0)
  if 0 in unique0:
      del count0[unique0.index(0)]
      unique0.remove(0)
  t0count = len(unique0)
  for i in range(0, t0count):
      t0bins[i] = unique0[i]
      t0freqs[i] = count0[i]
            
  unique1, count1 = numpy.unique(raw_traces1[0: num_of_traces, sample_num], return_counts=True)
  unique1 = list(unique1)
  count1 = list(count1)
  if 0 in unique1:
      del count1[unique1.index(0)]
      unique1.remove(0)
  t1count = len(unique1)
  for i in range(0, t1count):
      t1bins[i] = unique1[i]
      t1freqs[i] = count1[i]

 
  mergelist = list(set().union(t0bins, t1bins))
  if 0 in mergelist:
      mergelist.remove(0)
  mergebinscount = len(mergelist)
  for i in range(0, mergebinscount):
      mergebins[i] = mergelist[i]

  for i in range(mergebinscount, max_freq):
      del mergebins[mergebinscount]
  #print mergebins

  mergebins.sort()
  
  for i in range(mergebinscount, max_freq):
      mergebins.append(0)
      

#initialize merge frequency lists
  for i in range(0, num_of_traces):
      #print (mergebins.index(raw_traces0[i,0]))
      #print mergebins.index(raw_traces1[i,0])
      t0mergefreq[mergebins.index(raw_traces0[i,sample_num])] = t0mergefreq[mergebins.index(raw_traces0[i,sample_num])] + 1 
      t1mergefreq[mergebins.index(raw_traces1[i,sample_num])] = t1mergefreq[mergebins.index(raw_traces1[i,sample_num])] + 1
      
#  print(t0mergefreq)
#  print(t1mergefreq)  
   
  sumt0freq = 0
  sumt1freq = 0

  for i in range(0, mergebinscount):
      #print mergebins[i], t0mergefreq[i], t1mergefreq[i]
      sumt0freq = sumt0freq + t0mergefreq[i]
      sumt1freq = sumt1freq + t1mergefreq[i]

  #print "sum of t0 freqs=", sumt0freq
  #print "sum of t1 freqs=", sumt1freq

# compute degrees of freedom

  v = mergebinscount-1 # trace0 and trace1
  #print "degrees of freedom"
  #print v
  #print "  "

#compute expected
  for i in range(0, mergebinscount):
      E0[i] = (t0mergefreq[i] + t1mergefreq[i])/2.0
      E1[i] = (t0mergefreq[i] + t1mergefreq[i])/2.0
    # the same for now...

#compute chi-squared values
  for i in range(0, mergebinscount):
      chi0[i] = (t0mergefreq[i]-E0[i])*(t0mergefreq[i]-E0[i])/E0[i]  
      chi1[i] = (t1mergefreq[i]-E1[i])*(t1mergefreq[i]-E1[i])/E1[i]
    
  chisum = 0
  for i in range(0, mergebinscount):
      chisum = chi0[i]+chi1[i]+chisum
    
  #print "chisum=",chisum
  p = p_value(chisum,v)
  #print ("p = ", p)
  p_array.append(p)
  
  for i in range(0, max_freq):
      t0bins[i] = 0
      t1bins[i] = 0
      t0freqs[i] = 0
      t1freqs[i] = 0
      mergebins[i] = 0
      t0mergefreq[i] = 0
      t1mergefreq[i] = 0
      E0[i] = 0
      E1[i] = 0
      chi0[i] = 0
      chi1[i] = 0

plt.semilogy(p_array, color='r')

plt.ylim(start_ylim, end_ylim)
plt.xlim(start_xlim, end_xlim)
plt.xticks(xticks)
#plt.set_yticks(yticks)
threshold = [0.00001] * samples_per_trace
#minus_threshold = [-4.5] * samples_per_trace
plt.semilogy(threshold, color='b', linewidth = thresholdLineWidth)

plt.xlabel("Sample No.", fontsize = labelFontSize)
plt.ylabel("p-value", fontsize = labelFontSize)

plt.show()
numpy.save("p-values.npy", numpy.array(p_array).transpose()) ##need to get one row array

end = time.time()
print("total time = %.3f s" % (end - start))
