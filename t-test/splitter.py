#!/usr/bin/python
import numpy
MAX_TRACE=2000
traces0 = numpy.zeros(0)
traces1 = numpy.zeros(0)
traceCount0 = 0
traceCount1 = 0
fullTraceIndex = 0

full_traces = numpy.load("cleanTraces.npy")
print full_traces.shape
i=0
with  open("fvrchoicefile.txt") as f:
   while i < MAX_TRACE:
      c = f.read(1)
      if not c:
         print "End of file"
         break
      print "index=",fullTraceIndex
      print c
      temp = full_traces[fullTraceIndex,:]
      fullTraceIndex += 1
      if c == '0':
         print "Q0"
         if (traceCount0 == 0):
            traces0  = temp
         elif (traceCount0 > 0):
            traces0  = numpy.vstack((traces0,temp))
         traceCount0 += 1

      else:
         print "Q1"
         if (traceCount1 == 0):
            traces1  = temp
         elif (traceCount1 > 0):
            traces1  = numpy.vstack((traces1,temp))
         traceCount1 += 1
      i +=1


print "Q0 shape:" , traces0.shape
print "Q1 shape:" , traces1.shape

numpy.save("traces0.npy", traces0)
numpy.save("traces1.npy", traces1)
