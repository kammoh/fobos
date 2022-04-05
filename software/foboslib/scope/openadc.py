
from pynq import DefaultIP

class OpenADC(DefaultIP):
    """
    OpenADC is the Python driver for the OpenADC Interface.
    """

    sr_offset = 0x0
    count_offset = 0x4
    divisor_offset = 0x8
    captured_offset = 0xC
    def __init__(self, description, *args, **kwargs):
        """
        Construct a new 'OpenADC' object.
        """
        super().__init__(description=description)        

    bindto = ['xilinx.com:user:openadc_interface_v1_0:1.0']
    
    def readSR(self):
        """
        Read the capture configuration system register.

        :return: returns 32-bit register value
        """
        return self.mmio.read(self.sr_offset)

    def writeEnable(self, enableBit):
        sr = self.mmio.read(self.sr_offset)
        sr = sr & 0x7fffffff
        sr = sr | ((enableBit << 31) & 0x80000000)
        self.mmio.write(self.sr_offset, sr)

    def writeBlockSize(self, blockSize):
        sr = self.mmio.read(self.sr_offset)
        sr = sr & 0xffff003f
        sr = sr | ((blockSize << 6) & 0x0000FFC0)
        self.mmio.write(self.sr_offset, sr)

    def readBlockSize(self):
        sr = self.mmio.read(self.sr_offset)
        return (sr & 0x0000FFC0) >> 6

    def resetTransmit(self):
        import time
        sr = self.mmio.read(self.sr_offset)
        sr = sr & 0xffffffef
        sr = sr | ((1 << 4) & 0x00000010)
        self.mmio.write(self.sr_offset, sr)
        # sleep for a millisecond to ensure reset completed
        time.sleep(0.001)
        r = self.mmio.read(self.sr_offset)
        sr = sr & 0xffffffef
        self.mmio.write(self.sr_offset, sr)
        
    def readOverRange(self):
        sr = self.mmio.read(self.sr_offset)
        return (sr & 0x00000001)

    def writeCaptureMode(self, mode):
        sr = self.mmio.read(self.sr_offset)
        sr = sr & 0xffffffdf
        sr = sr | ((mode << 5) & 0x00000020)
        self.mmio.write(self.sr_offset, sr)

    def readCaptureMode(self):
        sr = self.mmio.read(self.sr_offset)
        return ((sr >> 5) & 0x00000001)

    def writeCaptureCount(self, count):
        self.mmio.write(self.count_offset, count)

    def readCaptureCount(self):
        return self.mmio.read(self.count_offset)

    def readCountCaptured(self):
        return (self.mmio.read(self.captured_offset) & 0x7FFFFFFF)

    def readCaptureComplete(self):
        return ((self.mmio.read(self.captured_offset) >> 31) & 0x1)

    def writeDivisor(self, divisor):
        divisor = (self.mmio.read(self.divisor_offset) & 0xfffffff0) | divisor
        self.mmio.write(self.divisor_offset, divisor)

    def readDivisor(self, divisor):
        return self.mmio.read(self.divisor_offset)

    def writeMeanStatusBit(self, enable):
        sr = self.mmio.read(self.divisor_offset)
        sr = sr & 0x7fffffff
        sr = sr | ((enable << 31) & 0x80000000)
        self.mmio.write(self.divisor_offset, sr)

    def readMeanStatusBit(self, divisor):
        return ((self.mmio.read(self.divisor_offset) >> 31) & 0x1)

    def writeGain(self, gain):
        if (gain < 0) or (gain > 78):
            print("Invalid Gain, range 0-78 Only")
            return
        sr = self.mmio.read(self.sr_offset)
        sr = sr & 0xff00ffff
        sr = sr | ((gain << 16) & 0x00ff0000)
        self.mmio.write(self.sr_offset, sr)

    def readGain(self):
        return ((self.mmio.read(self.sr_offset) >> 16) & 0xff)

    def writeHiLo(self, hi_lo):
        sr = self.mmio.read(self.sr_offset)
        sr = sr & 0xfeffffff
        sr = sr | ((hi_lo << 24) & 0x01000000)
        self.mmio.write(self.sr_offset, sr)
        
    def readHiLo(self):
        return ((self.mmio.read(self.sr_offset) >> 24) & 0x1)



class OpenADCScope():
    """
    FobosAcquisition is the collection of utility functions for using the
    OpenADC board to capture on PYNQ
    """

    openADCInterface = None
    dma = None
    clockGen = None
    # MHz
    busClk = 100
    adcClk = None
    
    def __init__(self, overlay):
        self.openADCInterface = overlay.openadc_interface_v1_0_0
        self.dma = overlay.axi_dma_1
        self.adcClk = overlay.clk_wiz_adc

    def print_dma_status(self):   
        print("\n==== From FIFO to Memory ====")
        print("Stream to MM Control: " + 
              hex(self.dma.read(0x30)))
        print("             Binary : 0b" + 
              format(self.dma.read(0x30), '0b'))
        print("Stream to MM Status : " + 
              hex(self.dma.read(0x34)))
        print("             Binary : 0b" + 
              format(self.dma.read(0x34), '0b'))
    

    def dmaWaitWithTimeout(self, timeout):
        import time
        epoch_time = int(time.time())
        while not self.dma.recvchannel.idle:
            elapsed = int(time.time()) - epoch_time
            if (elapsed >= timeout):
                return True
        return False
        
    def dmaErrorReset(self):
        # if there is an error in the DMA, reset it
        if self.dma.read(0x34) & 0x10 != 0: 
        #if self.dma.read(0x34) & 0x01 != 0:
            self.dma.write(0x30, 0x4)
            while self.dma.read(0x30) & 0x4 != 0:
                pass
            self.dma.recvchannel.start()
        else:
            pass
            #print("DMA not started")

    # def endCapture(dma, blockSize):
        # import traceback
        # from pynq import Xlnk
        # import numpy as np
        # xlnk = Xlnk()
        # openadc.writeEnable(0)
        # readChannel = True
        # while readChannel is True:
            # output_buffer = xlnk.cma_array(shape=(blockSize,), dtype=np.uint64)
            # try:
                # dma.recvchannel.transfer(output_buffer)
            # except RuntimeError:
                # # done with memory, free it
                # output_buffer.freebuffer()
                # readChannel = False
        
    def captureFixedTraces(self, numTraces, blockSize=16): #block size in samples
        from pynq import Xlnk
        import numpy as np
        xlnk = Xlnk()
            
        readChannel = True
        listcapture = []
        count = 0
        #outputBuffer = xlnk.cma_array(shape=(blockSize,), dtype=np.uint64)
        outputBuffer = xlnk.cma_array(shape=(17,), dtype=np.uint64)
        
        # Prepare the openADCInterface for capture
        import math
        self.dmaErrorReset()
        self.openADCInterface.resetTransmit()
        self.openADCInterface.writeCaptureMode(0);
        self.openADCInterface.writeBlockSize(blockSize)
        # Each block is contains 4 samples per entry, so blockSize * 4 is number of samples per block
        captureBlocks = math.ceil(numTraces/(blockSize*4)) #in 4samle units
        self.openADCInterface.writeCaptureCount(captureBlocks)        
        self.openADCInterface.writeEnable(1)
        
        while readChannel is True:
            if (count*blockSize >= numTraces/4):
                self.openADCInterface.writeEnable(0)
                readChannel = False
                continue
                
            outputBuffer[0] = 0xdeadbeef
            try:
                self.dma.recvchannel.start()
                self.dma.recvchannel.transfer(outputBuffer)
                #import time
                #time.sleep(3)

                self.print_dma_status()
                self.print_dma_status()
                 # wait for dma to finalize transfer
                #timeout = self.dmaWaitWithTimeout(1)
                self.dma.recvchannel.wait()
                
                #if (timeout):
                 #   print('timeout waiting for DMA at count = %d' % (count))
                  #  readChannel = False
                
                if (outputBuffer[0] == 0xdeadbeef):
                    print('empty buffer read with count = %d' % (count))
                    readChannel = False
                    continue
                listcapture = listcapture + list(outputBuffer)
            except RuntimeError:
                import traceback
                print('Error in DMA read')
                traceback.print_exc()
                self.dmaErrorReset()
                outputBuffer.freebuffer()
                return
            count = count + 1
        # done with memory, free it
        outputBuffer.freebuffer()
        if not (self.openADCInterface.readCaptureComplete() and
                self.openADCInterface.readCountCaptured() == captureBlocks):
            print("Capture mechanism failed for some reason %d vs. %d" % (self.openADCInterface.readCountCaptured(), captureBlocks))
            return None
        
        finaltraces=[]
        for i in range (0, int(numTraces/4)):
            finaltraces.append(int((listcapture[i] >> np.uint64(54)) & np.uint64(0x3FF)))
            finaltraces.append(int((listcapture[i] >> np.uint64(38)) & np.uint64(0x3FF)))
            finaltraces.append(int((listcapture[i] >> np.uint64(22)) & np.uint64(0x3FF)))
            finaltraces.append(int((listcapture[i] >> np.uint64(6)) & np.uint64(0x3FF)))
        return finaltraces
    
    
    def plotTraces(self, tracelist, lineWidth=1.0, xlabelsize=30, ylabelsize=30):
        print("PLOT")
        import matplotlib.pyplot as plt
        xindex = 0
        xplot = []
        for i in tracelist:
            xplot.append(xindex)
            xindex = xindex + 1
        
        plt.style.use('seaborn')
        plt.figure(num=None, figsize=(48, 36), dpi=80, facecolor='w', edgecolor='k')
        plt.xticks(fontsize=xlabelsize)
        plt.yticks(fontsize=ylabelsize)
        plt.plot(xplot, tracelist, 'C2', label='',linewidth=lineWidth)
        plt.show()
        
    def verifyContinuous(self, tracelist, increment=1):
        for j in range(1, len(tracelist)):
            if ((tracelist[j-1] + increment)%1024 != tracelist[j]):
                print('did not capture all traces, %d vs. %d at position %d' %(tracelist[j-1],tracelist[j], j) )
                return False
                
        return True

    
    def captureContinuous(self, divisor, mean=True, numBlocksPerWindow=1, blockSize=900):
        #print("updated")
        from pynq import Xlnk
        import numpy as np
        xlnk = Xlnk()
            
        readChannel = True
        listcapture = []
        count = 0
        outputBuffer = xlnk.cma_array(shape=(1000,), dtype=np.uint64)
        
        # Prepare the openADCInterface for capture
        import math
        self.dmaErrorReset()
        self.openADCInterface.writeCaptureMode(0);
        self.openADCInterface.writeDivisor(divisor)
        self.openADCInterface.resetTransmit()
        self.openADCInterface.writeBlockSize(blockSize)
        self.openADCInterface.writeCaptureCount(1)
        if (mean):
            self.openADCInterface.writeMeanStatusBit(1)
        else:
            self.openADCInterface.writeMeanStatusBit(0)
        self.openADCInterface.writeEnable(1)
        
        while readChannel is True:
            if (count >= 1):
                #print('Received full samples')
                self.openADCInterface.writeEnable(0)
                readChannel = False
                continue
                
            outputBuffer[0] = 0xdeadbeef
            try:
                self.dma.recvchannel.transfer(outputBuffer)
                 # wait for dma to finalize transfer
                #timeout = self.dmaWaitWithTimeout(1)
                timeout = False
                self.dma.recvchannel.wait()
                #import time
                #time.sleep(3)
                #self.print_dma_status()
                #self.dma.recvchannel.wait()
                
                if (timeout):
                    print('timeout waiting for DMA at count = %d' % (count))
                    readChannel = False
                
                if (outputBuffer[0] == 0xdeadbeef):
                    print('empty buffer read with count = %d' % (count))
                    readChannel = False
                    continue
                listcapture = listcapture + list(outputBuffer)
            except RuntimeError:
                print('Error in DMA read1')
                readChannel = False
            count = count + 1
            
        # done with memory, free it
        outputBuffer.freebuffer()
        #print(count)
        #print(blockSize)
        tic = time.time()
        finaltraces=[]
        #for i in range (0, int(count * blockSize)):
         #   finaltraces.append(int((listcapture[i] >> np.uint64(54)) & np.uint64(0x3FF)))
          #  finaltraces.append(int((listcapture[i] >> np.uint64(38)) & np.uint64(0x3FF)))
           # finaltraces.append(int((listcapture[i] >> np.uint64(22)) & np.uint64(0x3FF)))
            #finaltraces.append(int((listcapture[i] >> np.uint64(6)) & np.uint64(0x3FF)))
        
        toc = time.time()
        #print("processing time = " + str(toc-tic))
        return finaltraces
    
    def waitForTrace(self):
        #wait for transfer to finish
        try:
            #self.dma.recvchannel.transfer(outputBuffer)
            self.dma.recvchannel.wait()
        except RuntimeError:
            print('Error in DMA read')
            
        self.openADCInterface.writeEnable(0) 
        
       
        
    def arm(self, outputBuffer, blockSize=900):
        #print("updated")
        #from pynq import Xlnk
        #import numpy as np
            
        #readChannel = True
        #listcapture = []
        #count = 0
        
        # Prepare the openADCInterface for capture
        #import math
        self.dmaErrorReset()
        self.openADCInterface.writeCaptureMode(0);
        #self.openADCInterface.writeDivisor(divisor)
        self.openADCInterface.resetTransmit()
        self.openADCInterface.writeBlockSize(blockSize)
        self.openADCInterface.writeCaptureCount(1)
  
        self.openADCInterface.writeEnable(1) 

        #outputBuffer[0] = 0xdeadbeef
        try:
            self.dma.recvchannel.transfer(outputBuffer)
            #self.dma.recvchannel.wait()
        except RuntimeError:
            print('Error in DMA read')
        
        #self.openADCInterface.writeEnable(0) 
        # done with memory, free it
        #print(count)
        #print(blockSize)
        #tic = time.time()
        #finaltraces=[]
        #for i in range (0, int(count * blockSize)):
         #   finaltraces.append(int((listcapture[i] >> np.uint64(54)) & np.uint64(0x3FF)))
          #  finaltraces.append(int((listcapture[i] >> np.uint64(38)) & np.uint64(0x3FF)))
           # finaltraces.append(int((listcapture[i] >> np.uint64(22)) & np.uint64(0x3FF)))
            #finaltraces.append(int((listcapture[i] >> np.uint64(6)) & np.uint64(0x3FF)))
        
        #toc = time.time()
        #print("processing time = " + str(toc-tic))
        #return finaltraces
    
    def clearFifo(self, blockSize=900):
        import traceback
        import time
        from pynq import Xlnk
        import numpy as np
        readChannel = True
        xlnk = Xlnk()
        outputBuffer = xlnk.cma_array(shape=(blockSize,), dtype=np.uint64)
        while readChannel is True:
            outputBuffer[0] = 0xdeadbeef
            try:
                self.dma.recvchannel.transfer(outputBuffer)
                # wait for dma to finalize transfer
                timeout = self.dmaWaitWithTimeout(1)
                if (timeout):
                    self.dma.recvchannel.stop()
                    readChannel = False
                if (outputBuffer[0] == 0xdeadbeef):
                    readChannel = False
            except RuntimeError:
                traceback.print_tb
                readChannel = False
                
        outputBuffer.freebuffer()
        
    def defineBusClock(self, busClock):
        self.busClk = busClock
        
    def setAdcClockFreq(self, adcClockValue):
        self.adcClk.setClock0Freq(adcClockValue)
        
    def setAdcClockPhase(self, phase):
        import math
        if (phase > 360 or phase < 0):
            raise Exception('ADC Phase may only be between 0 and 360 degrees')
        self.adcClk.writeClk0Phase(math.floor(phase*1000))

    def setGain(self, gain):
        self.openADCInterface.writeGain(gain)
        
