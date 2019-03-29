##FOBOS control board class
##GMU
##Author: Abubakr Abdulgadir
##March 2019

from .fobosctrl import FOBOSCtrl
import pynq.lib.dma
from pynq import Xlnk
import numpy as np
from pynq import Overlay
from .clkwizard import ClockWizard
from .openadc import OpenADC


class PYNQCtrl(FOBOSCtrl):
    #status codes
    OK                  = 0x00
    ERROR               = 0x01
    TIMEOUT             = 0x02
    #dutcomm register offsets
    dutcomm_START       = 0x00
    dutcomm_STATUS      = 0x04
    dutcomm_EXP_OUT_LEN = 0x0c
    ##########################
    #dutctrl register offsets
    dutctrl_TRGLEN      = 0x00
    dutctrl_TRGWIAT     = 0x04
    dutctrl_TRGMODE     = 0x08
    ###trigger modes
    TRG_NORM            = 0X00
    TRG_FULL            = 0x01
    TRG_NORM_CLK        = 0x02
    TRG_FULL_CLK        = 0x03
    ##########################
    #constants
    MAX_IN_BUFF         = 12 #max input buffer size in bytes
    MAX_OUT_BUFF        = 4 #max output buffer size in bytes
     
    def __init__(self, overlay):
        self.model = "FOBOS-CTRL-PYNQ-Z1"
        self.outLen = 0
        self.STATUS_LEN = 4
        self.dma = overlay.axi_dma_0
        self.dutcomm = overlay.dutcomm_0
        self.dutctrl = overlay.dut_controller_0
        self.dutClkWizard =overlay.clk_wiz
        #io buffers
        xlnk = Xlnk()
        self.input_buffer = xlnk.cma_array(shape=(PYNQCtrl.MAX_IN_BUFF,), dtype=np.uint32)
        self.output_buffer = xlnk.cma_array(shape=(PYNQCtrl.MAX_OUT_BUFF,), dtype=np.uint32)

    def setDUTClk(self, clkFreq):
        self.dutClkWizard.setClock0Freq(clkFreq)       
        #self.dutClkWizard.write(0x200, 0x00000102)
        #self.dutClkWizard.write(0x208, 0x00000064)
        #self.dutClkWizard.write(0x25c, 0x00000003)

    def __del__(self):
        #not sure if necessay
        self.input_buffer.freebuffer()
        self.output_buffer.freebuffer()
        
    def processData(self, data):
        """
        Sends data to FOBOS hardware for processing, e.g. encryption
        data: The data to be processed. This is a hexadecimal string.
        returns: the result of processing, e.g. ciphertext
        """
        #put data in the buffer as 32bit integers
        data = data.strip()
        testVector = [int(data[i:i+8],16) for i in range(0, len(data), 8)]
        for i in range(0, len(testVector)):
            self.input_buffer[i] = testVector[i]
        #send via DMA
        self.dma.recvchannel.transfer(self.output_buffer) #configure dma to receive
        self.dma.sendchannel.transfer(self.input_buffer)  #configure dma to send 
        self.dma.sendchannel.wait()
        self.dma.recvchannel.wait()
        result = ''.join(['{:08x}'.format(self.output_buffer[i]) for i in range(0, 4)])
        return result

    def getModel(self):
        return self.model
    
    def setOutLen(self, outLen):
        """
        set Expected Output Length (outLen)
        """
        self.outLen = outLen
        self.dutcomm.write(PYNQCtrl.dutcomm_EXP_OUT_LEN, outLen)

    def getOutLen(self):
        """
        get Expected Output Length (outLen)
        """
        return self.dutcomm.read(PYNQCtrl.dutcomm_EXP_OUT_LEN)
    
    def setTriggerWait(self, trigWait):
        """
        set number of trigger wait cycles
        """
        self.dutctrl.write(PYNQCtrl.dutctrl_TRGWIAT, trigWait)

    def getTriggerWait(self):
        """
        get number of trigger wait cycles
        """
        return self.dutctrl.read(PYNQCtrl.dutctrl_TRGWIAT)
        
    def setTriggerLen(self, trigLen):
        """
        set number of trigger length in cycles
        """
        self.dutctrl.write(PYNQCtrl.dutctrl_TRGLEN, trigLen)

    def getTriggerLen(self):
        """
        get number of trigger length in cycles
        """
        return self.dutctrl.read(PYNQCtrl.dutctrl_TRGLEN)
    
    
    def setTriggerMode(self, trigMode):
        """
        set trigger type
        """
        self.dutctrl.write(PYNQCtrl.dutctrl_TRGMODE, trigMode)

    def getTriggerMode(self):
        """
        get trigger type
        """
        return self.dutctrl.read(PYNQCtrl.dutctrl_TRGMODE)
    
   