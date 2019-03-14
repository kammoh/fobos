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
import pynq.lib.dma
from pynq import Xlnk
import numpy as np
from pynq import Overlay


class PYNQCtrl(FOBOSCtrl):
    #status codes
    OK      = 0x00
    ERROR   = 0x01
    TIMEOUT = 0x02
    #dutcomm register offsets
    dutcomm_START       = 0x00
    dutcomm_STATUS      = 0x04
    dutcomm_EXP_OUT_LEN = 0x0c
    ##########################
    #dutctrl register offsets
    dutctrl_TRGLEN      = 0x00
    dutctrl_TRGWIAT     = 0x04
    dutctrl_TRGMODE     = 0x08
    ##########################
    #constants
    MAX_IN_BUFF         = 2048 #max input buffer size in bytes
    MAX_OUT_BUFF        = 2048 #max output buffer size in bytes
     
    def __init__(self, port, baudRate = 115200, dummy=False):
        self.model = "PYNQ-Z1"
        self.outLen = 0
        self.STATUS_LEN = 4
        self.overlay = Overlay("../ctrl_top_wrapper.bit")
        self.dma = self.overlay.dma_0
        self.dutcomm = self.overlay.dutcomm_0
        self.dutctrl = self.overlay.dutctrl_0
        #io buffers
        self.input_buffer = xlnk.cma_array(shape=(MAX_IN_BUFF,), dtype=np.uint32)
        self.output_buffer = xlnk.cma_array(shape=(MAX_OUT_BUFF,), dtype=np.uint32)

        
    def processData(self, data):
        """
        Sends data to FOBOS hardware for processing, e.g. encryption
        data: The data to be processed. This is a hexadecimal string.
        returns: the result of processing, e.g. ciphertext
        """
        
        
        

    def getModel(self):
        return self.model
    
    def setOutLen(self, outLen):
        """
        set Expected Output Length (outLen)
        """
        self.outLen = outLen
        self.dutcomm.write(dutcomm_EXP_OUT_LEN, outLen)

    def getOutLen(self):
        """
        get Expected Output Length (outLen)
        """
        return self.dutcomm.read(dutcomm_EXP_OUT_LEN)
    
    def setTrigWait(self, trigWait):
        """
        set number of trigger wait cycles
        """
        self.dutcomm.write(dutctrl_TRGWIAT, trigWait)

    def getTrigWait(self):
        """
        get number of trigger wait cycles
        """
        return self.dutcomm.read(dutctrl_TRGWIAT)
        
    def setTrigLen(self, trigLen):
        """
        set number of trigger length in cycles
        """
        self.dutcomm.write(dutctrl_TRGLEN, trigLen)

    def getTrigLen(self):
        """
        get number of trigger length in cycles
        """
        return self.dutcomm.read(dutctrl_TRGLEN)
    
    
    def setTrigMode(self, trigMode):
        """
        set trigger type
        """
        self.dutcomm.write(dutctrl_TRGMODE, trigMode)

    def getTrigMode(self):
        """
        get trigger type
        """
        return self.dutcomm.read(dutctrl_TRGMODE)
        