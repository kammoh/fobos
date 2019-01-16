##FOBOS control board class
##GMU
##Author: Abubakr Abdulgadir
##Aug 7 2018
##This class hides the Control Board hardware and provides easy to use 
##methods to configure and run operations on the DUT
##This class will interface to Digilent Basys3 board
##The board includes a Microblaze softcore 
##This uses a protocol to talk to Basys3
##The connection used is a UART/USB
import serial
import binascii
from fobosctrl import FOBOSCtrl
from dummyserial import DummySerial

class Basys3Ctrl(FOBOSCtrl):

    def __init__(self, port, baudRate = 115200, dummy=False):
        self.model = "Basys3"
        if dummy == True:
            self.ser = DummySerial()
        else:
            self.ser = serial.Serial(port, baudRate)
        self.outLen = 0
    
    def writeConfig(self, param, value):
        """
        Writes config to the fobos  control board
        param: the number of the config, 
        value: a 16 bit value for the config parameter
        returs: ack code
        """
        #               WR_CONFIG       4 byte message   config number    config value 
        cmd = bytearray([0xF0, 0x03] + [0x00, 0x04] +  [0x00, param] + [ value / 256 , value % 256])
        print binascii.hexlify(cmd)
        c = self.ser.write(cmd)
        ack = self.ser.read(FOBOSCtrl.ACK_LEN)
        return ack
    
    def readConfig(self, param):
        """
        Reads config from the fobos  control board
        param: the number of the config, 
        returns: a 16 bit value for the config parameter
        """
        #               RD_CONFIG       2 byte message   config number    
        cmd = bytearray([0xF0, 0x02] + [0x00, 0x02] +  [0x00, param] )
        print binascii.hexlify(cmd)
        c = self.ser.write(cmd)
        value = self.ser.read(FOBOSCtrl. PARAM_LEN)
        return value
    
    def processData(self, data, outLen):
        """
        Sends data to FOBOS hardware for processing, e.g. encryption
        data: The data to be processes. This is a hexadecimal string.
        returns: the result of processing, e.g. ciphertext
        """
        vectorLen = len(data) / 2 #hex: two characters = 1 byte 
        lenLsb = vectorLen % 256
        lenMsb = vectorLen / 256
        #               PROCESS_DATA    message len         data
        cmd = bytearray([0xF0, 0x01] + [lenMsb, lenLsb]) +  bytearray.fromhex(data.strip())
        #cmd = bytearray([0xF0, 0x01] + [lenMsb, lenLsb]) + data
        print binascii.hexlify(cmd)
        c = self.ser.write(cmd)
        result = self.ser.read(outLen)
        return result

    def getModel(self):
        return self.model
    
    def setOutLen(self, outLen):
        """
        set Expected Output Length (outLen)
        """
        self.outLen = outLen
        return self.writeConfig(FOBOSCtrl.OUT_LEN, outLen)
    
    def setTrigWait(self, trigWait):
        """
        set number of trigger wait cycles
        """
        return self.writeConfig(FOBOSCtrl.TRIG_WAIT, trigWait)
        
    def setTrigLen(self, trigLen):
        """
        set number of trigger length in cycles
        """
        return self.writeConfig(FOBOSCtrl.TRG_LEN, trigLen)    
    
    def setTrigType(self, trigType):
        """
        set trigger type
        """
        return self.writeConfig(FOBOSCtrl.TRG_TYPE, trigType)
    

