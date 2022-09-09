import numpy 

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

def compressData(measuredData, compressionType, compressionLen):
   dataResize =  numpy.apply_along_axis(compress, 1, measuredData, compressionLen,compressionType)
   return dataResize