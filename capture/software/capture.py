import binascii
import time
import os
import shutil
import numpy
import fobos
import fobos.picoscope
#Constants################################################################################################
WORKSPACE = "/home/aabdulga/fobosworkspace"
PROJECT_NAME ="aes"
DIN_FILE_NAME = "dinFile.txt"
CIPHER_FILE = "ciphertext.txt"
TRACE_FILE = "powerTraces.npy"
DUT_BIT_FILE = "FOBOS_DUT.bit"
TRACE_NUM = 10
OUT_LEN = 16
TIMEOUT = 10000
TRIG_WAIT = 1
TRIG_LENGTH = 1
TRIG_MODE_NORM = 0
TRIG_MODE_FULL = 1 
#Instantiate FOBOS objects#################################################################################
ctrl = fobos.Basys3Ctrl('/dev/ttyUSB1', 115200, False)
dgen = fobos.DataGenerator()

#Configuration controller##################################################################################
print 'Sending config ...'
status = ctrl.writeConfig(5, 0) #FORCE RESET
print binascii.hexlify(status)
print 'Sending config ...'
status = ctrl.writeConfig(6, 0) #RLEASE RESET
print binascii.hexlify(status)
print 'Sending config ...'
#status = ctrl.writeConfig(0,16) #set OUT_LEN to 6
status = ctrl.setOutLen(OUT_LEN)
print binascii.hexlify(status)
print 'Sending config ...'
status = ctrl.writeConfig(7, TIMEOUT) #set TIMEOUT
print binascii.hexlify(status)
print 'Sending config ...'
status = ctrl.writeConfig(1,TRIG_WAIT) #set OUT_LEN to 6
print binascii.hexlify(status)
status = ctrl.writeConfig(2,TRIG_LENGTH) #set OUT_LEN to 6
print binascii.hexlify(status)
print 'Sending config ...'
status = ctrl.writeConfig(3,TRIG_MODE_FULL) #set Trigger mode to FULL
print binascii.hexlify(status)

####read config
status, param = ctrl.readConfig(100)
print 'parameter value:'
print binascii.hexlify(param)
status, param = ctrl.readConfig(1)
print 'parameter value:'
print binascii.hexlify(param)

#Configure project directories################################################################################
pm = fobos.ProjectManager()
pm.setWorkSpaceDir(WORKSPACE)
pm.setProjName(PROJECT_NAME)
projDir = pm.getProjDir()
#program DUT
dut = fobos.Nexys3DUT()
bitFile = os.path.join(projDir, DUT_BIT_FILE)
dut.setBitFile(bitFile)
#dut.program()
#exit()
########
tvFileName = os.path.join(projDir, DIN_FILE_NAME)
tvFile = open(tvFileName, "r")
captureDir = pm.getCaptureDir()
cipherFileName = os.path.join(captureDir, CIPHER_FILE)
cipherFile = open(cipherFileName, "w")
traceFileName = os.path.join(captureDir, TRACE_FILE)
traceFile = open(traceFileName, "w")
shutil.copy(tvFileName, captureDir)

# #Scope ########################################################################################################
# scopConfig = {
#          'OSCILLOSCOPE'       : 'AGILENT', #AGILENT|OPENADC
#          'OSCILLOSCOPE_IP'    : '192.168.10.10',
#          'OSCILLOSCOPE_PORT'  : '5025',
#          'AUTOSCALE'          : 'NO',   # YES|NO    
#          'IMPEDANCE'          : 'ONEMEG', #FIFTY|ONEMEG
#          # VOLTAGE AND TIME RANGE OPTIONS        
#          'CHANNEL1_RANGE'     : '0.100V',
#          'CHANNEL2_RANGE'     : '6V',
#          'CHANNEL3_RANGE'     : 'OFF', # ON|OFF|voltage range
#          'CHANNEL4_RANGE'     : 'OFF', # ON|OFF|voltage range
#          'TIME_RANGE'         :  '0.000040',
#          'TIMEBASE_REF'       : 'LEFT',    
#          # TRIGGER OPTIONS
#          'TRIGGER_SOURCE'     : 'CHANNEL2',
#          'TRIGGER_MODE'       : 'EDGE',   
#          'TRIGGER_SWEEP'      : 'NORM',
#          'TRIGGER_LEVEL'      : '1',
#          'TRIGGER_SLOPE'      : 'POSITIVE',
#          # ACQUIRE OPTIONS
#          'ACQUIRE_TYPE'       : 'NORM', # NORM|PEAK|HRES|AVER
#          'ACQUIRE_MODE'       : 'RTIM'   # RTIM | ETIM| SEG
# }
# scope = fobos.Scope()
# scope.setConfig(scopConfig)
# print scope.getConfig()
# scope.openConnection()
# scope.applyConfig()
################Configure Picoscope
# scope = fobos.picoscope.Picoscope(sampleResolution = 16, 
#                      postTriggerSamples = 250 #samples
#                      )
# scope.setChannel(channelName = 'CHANNEL_A', rangemv = '100mV')
# #scope.setChannel(channelName = 'CHANNEL_B', rangemv = '5V')
# #scope.setTrigger(channelName ='CHANNEL_B', direction = 'RISING_EDGE', thresholdmv = 200)
# scope.setSamplingInterval(samplingIntervalns = 16) #T=1 ns, Fs= 1000MHz
# scope.setTrigger(channelName ='EXTERNAL', direction = 'RISING_EDGE', thresholdmv = 200)
# scope.setDataBuffers()

#Get traces####################################################################################################
print 'Sending data..'
t1 = time.time()
string = ''
j = 0
while j < TRACE_NUM:
   tc1 = time.time()
   # scope.arm()
   tc2 = time.time()
   if j==0: ##need to sleep. The arm function needs some time before getting trigger
            ##but only on the first command
      time.sleep(0.1)
   j+=1
   print '==================================%s' % j
   #data = dgen.randTestVector(16, 16, 0, 16)
   data = tvFile.readline()
   status, result = ctrl.processData(data, OUT_LEN)
   if status != bytearray([0,0,0,0]):
      print "TIMEOUT"
   print(result)
   cipherFile.write(result + "\n")
   
   tc3 = time.time()
   # trace = scope.readTrace()
   #trace = scope.readChannel('CHAN1')
   #scope.readChannel('CHAN2')
   #trace = scope.getAlignedTrace()
   tc4 =time.time()
   # numpy.save(traceFile, trace)

tvFile.close()
cipherFile.close()
traceFile.close()
#scope.closeConnection()
t2 = time.time()
print "Time = " + str(t2 -t1)
print "Arm time" + str(tc2-tc1)
print "Enc   time" + str(tc3-tc2)
print "Scope time" + str(tc4-tc3)
print "Total time" + str(tc4-tc1)