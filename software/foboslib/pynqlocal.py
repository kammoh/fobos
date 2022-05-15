##FOBOS control board class
##GMU
##Author: Abubakr Abdulgadir
##March 2019

from .fobosctrl import FOBOSCtrl
import pynq.lib.dma
#from pynq import Xlnk
from pynq import allocate
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
    dutcomm_INTERFACE   = 0x08
    dutcomm_EXP_OUT_LEN = 0x0c
    ##########################
    #dutctrl register offsets
    dutctrl_TRGLEN      = 0x00
    dutctrl_TRGWAIT     = 0x04
    dutctrl_TRGMODE     = 0x08
    dutctrl_FORCE_RST   = 0x1c
    dutctrl_DUT         = 0x38
    ###trigger modes
    TRG_NORM            = 0X00
    TRG_FULL            = 0x01
    TRG_NORM_CLK        = 0x02
    TRG_FULL_CLK        = 0x03
    ###interface types - 4bit interface is default
    INTERFACE_4BIT      = 0x00
    INTERFACE_8BIT      = 0x01
    ##########################
    
    #constants
    
    def __init__(self, overlay):
        self.model = "FOBOS-CTRL-PYNQ-Z1"
        self.STATUS_LEN = 4
        self.outLen = 0
        self.dma = overlay.axi_dma_0
        self.dutcomm = overlay.dutcomm_0
        self.dutctrl = overlay.dut_controller_0
        self.dutClkWizard =overlay.clk_wiz
        #io buffers
        #self.xlnk = Xlnk()
        # self.input_buffer = xlnk.cma_array(shape=(int(inputSize / 4),), dtype=np.uint32)
        # self.output_buffer = xlnk.cma_array(shape=(int(outputSize / 4),), dtype=np.uint32)
        # self.setOutLen(int(outputSize/4))
        self.input_buffer = None
        self.output_buffer = None
        self.inputSize = 0

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
        inputSize = int(len(data)/2)
        #print(f'inputSize={inputSize}')
        if self.inputSize != inputSize:
            if self.input_buffer is not None:
                #print('free buffer')
                self.input_buffer.freebuffer()
            #print('allocate buffer')
            self.input_buffer = allocate(shape=(int(inputSize / 4),), dtype=np.uint32)
            self.inputSize = inputSize

        #put data in the buffer as 32bit integers
        data = data.strip()
        testVector = [int(data[i:i+8],16) for i in range(0, len(data), 8)]
        for i in range(0, len(testVector)):
            self.input_buffer[i] = testVector[i]
        #send via DMA
        #print(self.output_buffer.shape)
        #print(self.output_buffer.nbytes)
        #print(self.input_buffer.shape)
        #print(f'outLen={self.outLen}')
        #print(self.getOutLen())
        #self.dma.recvchannel.transfer(self.output_buffer,0,self.output_buffer.nbytes) #configure dma to receive
        self.dma.recvchannel.transfer(self.output_buffer) #configure dma to receive
        self.dma.sendchannel.transfer(self.input_buffer)  #configure dma to send 
        #print(f'in buf = {self.input_buffer}')
        self.dma.sendchannel.wait()
        self.dma.recvchannel.wait()
        result = ''.join(['{:08x}'.format(self.output_buffer[i]) for i in range(0, int(self.outLen / 4))])
        ##get result in correct format
        result2 = ''
        for i in range(len(result)):
            if (i % 2 == 0 and i != 0):
                result2 += ' '
            result2 += result[i]       
        return result2

    def sendDUTConf(self, data):
        """
        Sends data to FOBOS hardware for configuration, e.g. encryption
        data: The config parameters and command. This is a hexadecimal string.
        """
        print(f'Sending conf : {data}')
        inputSize = int(len(data)/2)
        input_buffer = allocate(shape=(int(inputSize / 4),), dtype=np.uint32)
        output_buffer = allocate(shape=(1,), dtype=np.uint32) # 32 bit ack
        #put data in the buffer as 32-bit integers
        data = data.strip()
        data_list = [int(data[i:i+8],16) for i in range(0, len(data), 8)]
        for i in range(0, len(data_list)):
            input_buffer[i] = data_list[i]
        
        prevOutLen = self.outLen #save outlen
        self.setOutLen(4) # ack size is 32 bits
        #send via DMA
        print('DUT config sent')
        ##
        self.dma.recvchannel.transfer(output_buffer) #configure dma to receive
        self.dma.sendchannel.transfer(input_buffer)  #configure dma to send
        print(f'out buf = {self.output_buffer}')
        self.dma.sendchannel.wait()
        self.dma.recvchannel.wait()
        input_buffer.freebuffer()
        output_buffer.freebuffer()
        self.setOutLen(prevOutLen)
        result = ''.join(['{:08x}'.format(output_buffer[i]) for i in range(0,1)])
        ##get result in correct format
        result2 = ''
        for i in range(len(result)):
            if (i % 2 == 0 and i != 0):
                result2 += ' '
            result2 += result[i]
        return result2

    def getModel(self):
        return self.model
    
    def setOutLen(self, outLen):
        """
        set Expected Output Length (outLen)
        """
        self.outLen = outLen
        print('outlen')
        print(outLen)
        print(type(outLen))
        self.dutcomm.write(PYNQCtrl.dutcomm_EXP_OUT_LEN, int(outLen * 2))
        if self.output_buffer is not None:
            self.output_buffer.freebuffer()
        if outLen > 0:
            self.output_buffer = allocate(shape=(int(outLen / 4),), dtype=np.uint32)
        #print(self.output_buffer.shape)

    def getOutLen(self):
        """
        get Expected Output Length (outLen)
        """
        return self.dutcomm.read(PYNQCtrl.dutcomm_EXP_OUT_LEN)
    
    def setTriggerWait(self, trigWait):
        """
        set number of trigger wait cycles
        """
        self.dutctrl.write(PYNQCtrl.dutctrl_TRGWAIT, trigWait)

    def getTriggerWait(self):
        """
        get number of trigger wait cycles
        """
        return self.dutctrl.read(PYNQCtrl.dutctrl_TRGWAIT)
        
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
        
    def forceReset(self):
        """
        set reset ctrl and DUT
        """
        self.dutctrl.write(PYNQCtrl.dutctrl_FORCE_RST, 1)
    
    def releaseReset(self):
        """
        set reset ctrl and DUT
        """
        self.dutctrl.write(PYNQCtrl.dutctrl_FORCE_RST, 0)

    def getTriggerMode(self):
        """
        get trigger type
        """
        return self.dutctrl.read(PYNQCtrl.dutctrl_TRGMODE)
    
    def setDUTInterface(self, interfaceType):
        self.dutcomm.write(PYNQCtrl.dutcomm_INTERFACE, interfaceType)
    
   
    def setDUT(self, dut):
        """
        set trigger type
        """
        self.dutctrl.write(PYNQCtrl.dutctrl_DUT, dut)

