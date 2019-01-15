import binascii
import time
from basys3ctrl import Basys3Ctrl
from datagen import DataGenerator


########################################################################################################
TRACE_NUM = 1000
OUT_LEN = 16

ctrl = Basys3Ctrl('/dev/ttyUSB1', 115200, True)
dgen = DataGenerator()

data = "00C0001077446B609E646B7C9EDC1E9A070DFFB800C1001000112233445566778899AABBCCDDEEFF0081001000800001"

print 'Sending config ...'
ack = ctrl.writeConfig(0,6) #set OUT_LEN to 6
print binascii.hexlify(ack)

print 'Sending config ...'
ack = ctrl.writeConfig(1,8) #set OUT_LEN to 6
print binascii.hexlify(ack)


####read config
param = ctrl.readConfig(0)

print 'parameter value:'
print binascii.hexlify(param)

param = ctrl.readConfig(1)

print 'parameter value:'
print binascii.hexlify(param)
##exit()
print 'Sending data..'
t1 = time.time()
string = ''
j = 0
while j < TRACE_NUM:
   j+=1
   print '==================================%s' % j
   data = dgen.randTestVector(16, 16, 0, 16)
   result = ctrl.processData(data, OUT_LEN)
   print binascii.hexlify(result)
   
t2 = time.time()
#print str(x)

print "Time = " + str(t2 -t1)
#print x
