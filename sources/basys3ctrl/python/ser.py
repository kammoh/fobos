import time
import serial
import random
import string
import binascii

###configuration parameters
C_EXPECTED_OUT = 0xC001

VECTOR_LEN = 6
ACK_LEN = 4
EXPECTED_OUT_LEN = 6
TRACE_NUM = 10
def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

conf = bytearray([0xC0, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00, 0x06]) ### Set expectedOutLen to 6
vector = bytearray([0xD0, 0x01, 0x00, 0x07, 0x12, 0x34, 0x56, 0x78, 0xab, 0xcd, 0xef]) #Send 7 bytes of data
#ser = serial.Serial('/dev/ttyUSB1', 230400)
ser = serial.Serial('/dev/ttyUSB1', 115200)
#x = ser.read()
##send config
print 'Sending config ...'
c = ser.write(conf)
ser.flush()
ack = ser.read(ACK_LEN)
print 'Ack:'
print binascii.hexlify(ack)
print 'Sending data..'
t1 = time.time()
string = ''
j = 0
while j < TRACE_NUM:
   j+=1
   print '==================================%s' % j
   #s = id_generator(VECTOR_LEN)
   print 'Sending:'
   print binascii.hexlify(vector)
   c = ser.write(vector)
   ser.flush()
   #print 'Sent %s bytes' %(c)
   #for i in range(0,N):
      #print c
   #   x = ser.read(1)
   #   print x
   x = ser.read(EXPECTED_OUT_LEN)
   print binascii.hexlify(x)
   #raw_input('Press Enter...')
#ser.write(b'B')
#print str(x)
t2 = time.time()
#print str(x)

print "Time = " + str(t2 -t1)
#print x

