import binascii
import time
from basys3ctrl import Basys3Ctrl

TRACE_NUM = 10

ctrl = Basys3Ctrl('/dev/ttyUSB2', 115200)

data = "12345678abcdef"

ctrl.setOutLen(4)

t1 = time.time()
string = ''
j = 0
while j < TRACE_NUM:
   j+=1
   print '==================================%s' % j
   result = ctrl.processData(data)
   print binascii.hexlify(result)
   
t2 = time.time()


print "Time = " + str(t2 -t1)
