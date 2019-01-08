import time
import serial
import random
import string
import binascii

###configuration parameters
C_EXPECTED_OUT = 0xC001


ACK_LEN = 4
PARAM_LEN = 2
OUT_LEN = 16
TRACE_NUM = 10

def writeConfig(param, value):
    """
    Writes config to the fobos  control board
    param: the number of the config, 
    value: a 16 bit value for the config parameter
    returs: ack code
    """
    #               WR_CONFIG       4 byte message   config number    config value 
    cmd = bytearray([0xF0, 0x03] + [0x00, 0x04] +  [0x00, param] + [ value / 256 , value % 256])
    print binascii.hexlify(cmd)
    c = ser.write(cmd)
    ack = ser.read(ACK_LEN)
    return ack

def readConfig(param):
    """
    Reads config from the fobos  control board
    param: the number of the config, 
    returns: a 16 bit value for the config parameter
    """
    #               RD_CONFIG       2 byte message   config number    
    cmd = bytearray([0xF0, 0x02] + [0x00, 0x02] +  [0x00, param] )
    print binascii.hexlify(cmd)
    c = ser.write(cmd)
    value = ser.read(PARAM_LEN)
    return value

def processData(data, outLen):
    """
    Sends data to FOBOS hardware for processing, e.g. encryption
    data: The data to be processes. This is a hexadecimal string.
    returns: the result of processing, e.g. ciphertext
    """
    vectorLen = len(data) / 2 #hex: two characters = 1 byte 
    lenLsb = vectorLen % 256
    lenMsb = vectorLen / 256
    #               PROCESS_DATA    message len         data
    cmd = bytearray([0xF0, 0x01] + [lenMsb, lenLsb]) +  bytearray.fromhex(data)
    #cmd = bytearray([0xF0, 0x01] + [lenMsb, lenLsb]) + data
    print binascii.hexlify(cmd)
    c = ser.write(cmd)
    result = ser.read(outLen)
    return result
    
#data = bytearray([0x12, 0x34, 0x56, 0x78, 0xab, 0xcd, 0xef])
#data = "12345678abcdef"
data = "00C0001077446B609E646B7C9EDC1E9A070DFFB800C1001000112233445566778899AABBCCDDEEFF0081001000800001"

ser = serial.Serial('/dev/ttyUSB1', 115200)

print 'Sending config ...'
ack = writeConfig(0,6) #set OUT_LEN to 6
print binascii.hexlify(ack)

print 'Sending config ...'
ack = writeConfig(1,8) #set OUT_LEN to 6
print binascii.hexlify(ack)


####read config
param = readConfig(0)
ser.flush()
print 'parameter value:'
print binascii.hexlify(param)

param = readConfig(1)
ser.flush()
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
   result = processData(data, OUT_LEN)
   print binascii.hexlify(result)
   
t2 = time.time()
#print str(x)

print "Time = " + str(t2 -t1)
#print x

