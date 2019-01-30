import binascii
import time
import os
import shutil
import fobos
#Constants################################################################################################
WORKSPACE = "/home/aabdulga/fobos_workspace"
PROJECT_NAME ="aes"
DIN_FILE_NAME = "dinFile.txt"
CIPHER_FILE = "ciphertext.txt"
DUT_BIT_FILE = "FOBOS_DUT.bit"
TRACE_NUM = 1000
OUT_LEN = 16
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
status = ctrl.writeConfig(0,10) #set OUT_LEN to 6
print binascii.hexlify(status)
print 'Sending config ...'
status = ctrl.writeConfig(7, 5) #set TIMEOUT
print binascii.hexlify(status)
print 'Sending config ...'
status = ctrl.writeConfig(1,8) #set OUT_LEN to 6
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
########
tvFileName = os.path.join(projDir, DIN_FILE_NAME)
tvFile = open(tvFileName, "r")
captureDir = pm.getCaptureDir()
cipherFileName = os.path.join(captureDir, CIPHER_FILE)
cipherFile = open(cipherFileName, "w")
shutil.copy(tvFileName, captureDir)
#Get traces####################################################################################################

print 'Sending data..'
t1 = time.time()
string = ''
j = 0
while j < TRACE_NUM:
   j+=1
   print '==================================%s' % j
   #data = dgen.randTestVector(16, 16, 0, 16)
   data = tvFile.readline()
   status, result = ctrl.processData(data, OUT_LEN)
   if status != bytearray([0,0,0,0]):
      print "TIMEOUT"
   print binascii.hexlify(result)
   cipherFile.write(binascii.hexlify(result) + "\n")
   
tvFile.close()
cipherFile.close()

t2 = time.time()
print "Time = " + str(t2 -t1)
