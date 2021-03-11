import sys
def getByteHW(a):
   return (a&1) + ((a&2)>>1) + ((a&4)>>2) + ((a&8)>>3) + ((a&16)>>4) + ((a&32)>>5) + ((a&64)>>6) + ((a&128)>>7)
 
for i in range(256): 
   if i % 20 == 0 : 
        print"\n"
   sys.stdout.write( str(getByteHW(i)) +  ", ")

