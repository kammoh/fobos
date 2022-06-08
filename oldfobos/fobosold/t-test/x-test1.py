#!/usr/bin/python
#This scripts takes raw power trace and calculates the t value for each traces sample wise
import math
import numpy
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse
import scipy.special

start_ylim = -40
end_ylim = 40

start_xlim = 0
end_xlim = 17080


#load trace file
#use simple array first
#samples_per_trace = 25000
num_of_traces = 997
#raw_traces0 = numpy.array([[1,2,3,4],[5,6,7,8],[9,10,11,12]])
#raw_traces1 = numpy.array([[13,24,35,45],[15,61,71,18],[19,110,131,12]])

	
#def get_mean(raw_traces):
#Takes trace array (each row is a trace)
#returns a one dimention array with each elemen = the mean of a column of the input 
#   mean_array = []
#   for sample_no in range(0, samples_per_trace):
#      sum = 0
#      for trace_no in range(0, num_of_traces):
#         sum += raw_traces[trace_no,sample_no]
#      mean_array.append(sum/num_of_traces)

#   return mean_array


#def get_variance(raw_traces, mean_array):
#Takes trace array (each row is a trace)
#returns a one dimention array with each element = the variance of a column of the input 
#   var_array = []
#   for sample_no in range(0, samples_per_trace):
#      sum = 0
#      for trace_no in range(0, num_of_traces):
#         sum += (raw_traces[trace_no,sample_no] - mean_array[sample_no])**2
#      var_array.append(float(sum)/num_of_traces)

#   return var_array


#def get_t_values(mean_array0, var_array0, mean_array1, var_array1, num_of_traces):
#funtion takes the mean and variance arays and
#calcualtes the t-values (one dimenional array)
#   t_array = []
#   n0 = num_of_traces
#   n1 = num_of_traces
#   for i in  range(0, samples_per_trace):
#      m0 = mean_array0[i]
#      m1 = mean_array1[i]
#      s0 = var_array0[i]
#      s1 = var_array1[i]
#      t = (m0 - m1) / math.sqrt( (s0/n0) + (s1/n1))
#      t_array.append(t)
#   return t_array

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
#num_of_traces = raw_traces0.shape[0]
samples_per_trace = raw_traces0.shape[1]
print "num_of_traces=", num_of_traces
print "samples_per_trace=", samples_per_trace

print raw_traces0.shape

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
  
  t0count = 0
  for i in range(0, num_of_traces):
      if (t0bins.count(raw_traces0[i, sample_num]) == 0):
          t0bins[t0count] = raw_traces0[i, sample_num]
          t0freqs[t0count]=1
          t0count = t0count + 1
      else:
          t0freqs [t0bins.index(raw_traces0[i, sample_num])]= t0freqs [t0bins.index(raw_traces0[i, sample_num])] + 1
      #print raw_traces0[i, 0]
  #print "Trace0 has ",t0count, " bins"

#binlength = len(bins)
#bins.sort()
#print bins
  #for i in range(0,t0count):
  #    print t0bins[i], t0freqs[i]
  #print "  "

  t1count = 0
  for i in range(0, num_of_traces):
      if (t1bins.count(raw_traces1[i, sample_num]) == 0):
          t1bins[t1count] = raw_traces1[i, sample_num]
          t1freqs[t1count] = 1
          t1count = t1count + 1
      else:
          t1freqs [t1bins.index(raw_traces1[i, sample_num])]= t1freqs [t1bins.index(raw_traces1[i, sample_num])] + 1
      #print raw_traces0[i, 0]
  #print "Trace1 has ", t1count, "bins"

#binlength = len(bins)
#bins.sort()
#print bins
  #for i in range(0,t1count):
  #    print t1bins[i], t1freqs[i]
  #print "  "

# merge lists
  if (t1count > t0count):
      mergebins = t1bins
      mergebinscount = t1count
      for i in range(0, t0count):
          if mergebins.count(t0bins[i]) == 0:
              mergebins[mergebinscount] = t0bins[i]
              mergebinscount = mergebinscount + 1
  else:
      mergebins = t0bins
      mergebinscount = t0count
      for i in range(0, t1count):
          if mergebins.count(t1bins[i]) == 0:
              mergebins[mergebinscount] = t1bins[i]
              mergebinscount = mergebinscount + 1
    
  #print "mergebinscount = ",mergebinscount
  #print mergebins
  # remove trailing zeroes
  for i in range(mergebinscount, max_freq):
      del mergebins[mergebinscount]
  #print mergebins
  mergebins.sort()
  #print "sorted mergebins"
  #print mergebins
  # restore trailing zeroes
  for i in range(mergebinscount, max_freq):
      mergebins.append(0)
  #print mergebins
        
#secondpass
  #print "second pass"

#initialize merge frequency lists

  for i in range(0, num_of_traces):
      #print mergebins.index(raw_traces0[i,0])
      #print mergebins.index(raw_traces1[i,0])
      t0mergefreq[mergebins.index(raw_traces0[i,sample_num])] = t0mergefreq[mergebins.index(raw_traces0[i,sample_num])] + 1 
      t1mergefreq[mergebins.index(raw_traces1[i,sample_num])] = t1mergefreq[mergebins.index(raw_traces1[i,sample_num])] + 1

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

  #print "expected values are:"
  #for i in range(0, mergebinscount):
  #    print mergebins[i], E0[i], E1[i]

  #print "chi squared values are:"    
#compute chi-squared values
  for i in range(0, mergebinscount):
      chi0[i] = (t0mergefreq[i]-E0[i])*(t0mergefreq[i]-E0[i])/E0[i]  
      chi1[i] = (t1mergefreq[i]-E1[i])*(t1mergefreq[i]-E1[i])/E1[i]

  #for i in range(0, mergebinscount):
  #    print mergebins[i], chi0[i], chi1[i]
    
  chisum = 0
  for i in range(0, mergebinscount):
      chisum = chi0[i]+chi1[i]+chisum
    
  #print "chisum=",chisum
  p = p_value(chisum,v)
  print "p = ", p
  p_array.append(p)
  if (sample_num % 100 == 0):
      print "sample_num = ",sample_num
  
  # clear lists and arrays
  
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
#mean_array0 =  get_mean(raw_traces0)
#mean_array1 =  get_mean(raw_traces1)
#var_array0 = get_variance(raw_traces0, mean_array0)
#var_array1 = get_variance(raw_traces1, mean_array1)
#t_array = get_t_values(mean_array0,var_array0, mean_array1, var_array1, num_of_traces)

#fig1.savefig('mean0.png')
#plt.plot(mean_array1)
#plt.plot(var_array0)
#plt.plot(var_array1)
threshold = [0.00001] * samples_per_trace
#minus_threshold = [-4.5] * samples_per_trace
plt.semilogy(threshold, color='b')
#plt.plot(minus_threshold, color='b')

#plt.ylim(start_ylim, end_ylim)
#plt.xlim(start_xlim, end_xlim)
#plt.xlabel("Sample No.")
#plt.ylabel("t-value")
plt.semilogy(p_array, color='r')
plt.show()
plt.savefig("result.png")
###
#numpy.save("t-values.npy", numpy.array(t_array).transpose()) ##need to get one row array
####
