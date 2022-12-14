#class that encapsulate logic to talk to oscilloscope
from socket import *
import logging
import time
import numpy

class Scope():
   """docstring fos Scope"""
   def __init__(self):
      logging.basicConfig(filename='fobos.log', level=logging.INFO, format='%(asctime)s %(message)s')

      self.logger = logging.getLogger("__name__")
      self.logger.warn("Hello")
      self.socket = socket(AF_INET, SOCK_STREAM)
      self.cutMode = 'TRIG_HIGH'
      self.numSamples = 1000 #number of samples to be returned for scope
      self.conf = {
         'OSCILLOSCOPE'    : "", 'OSCILLOSCOPE_IP'  : "", 'OSCILLOSCOPE_PORT' : "", 
         'RESOURCE'        : "", 'AUTOSCALE'        : "", 'IMPEDANCE'         : "",        
         'CHANNEL1_RANGE'  : "", 'CHANNEL2_RANGE'   : "", 'CHANNEL3_RANGE'    : "", 
         'CHANNEL_4RANGE'  : "", 'CHANNEL1_DISPLAY' : "",
         'CHANNEL2_DISPLAY': "", 'CHANNEL3_DISPLAY' : "", 'CHANNEL4_DISPLAY'  : "", 
         'TIME_RANGE'      : "", 'TIMEBASE_REF'     : "", 'TRIGGER_SOURCE'    : "",
         'TRIGGER_MODE'    : "", 'TRIGGER_SWEEP'    : "", 'TRIGGER_LEVEL'     : "",    
         'TRIGGER_SLOPE'   : "", 'SAMPLE_INPUT'     : "", 'ACQUIRE_TYPE'      : "",
         'ACQUIRE_MODE'    : "", 'ACQUIRE_COMPLETE' : "", 'WAVE_DATA_SIZE'    : "",   
         'NUM_PWR_TRACE'   : "", 'SCREEN_CAP'       : "", 'SCREEN_FORMAT'     : "",   
         'SCREEN_NAME'     : "", 'OUTPUT_DIR'       : "",
      }

   def setCutMode(self, cutMode):
       # 'TRIG_HIGH' | 'FULL'
      self.cutMode = cutMode

   def getConfig(self):
      return self.conf

   def setConfig(self, conf):
      for key, value in conf.items():
         #print key , value
         self.conf[key] = value

   def applyConfig(self):
      if self.conf['IMPEDANCE'] :
         cmdString = ":CHANNEL1:IMPEDANCE " + self.conf['IMPEDANCE']
         self.send(cmdString + '\n')
      if self.conf['CHANNEL1_RANGE'] :
         cmdString = ":CHANNEL1:RANGE " + self.conf['CHANNEL1_RANGE']
         self.send(cmdString + '\n')
      if self.conf['CHANNEL2_RANGE'] :
         cmdString = ":CHANNEL2:RANGE " + self.conf['CHANNEL2_RANGE']
         self.send(cmdString + '\n')
      if self.conf['CHANNEL3_RANGE'] :  
         cmdString = ":CHANNEL3:RANGE " + self.conf['CHANNEL3_RANGE']
         self.send(cmdString+'\n')
      if self.conf['CHANNEL4_RANGE'] :
         cmdString = ":CHANNEL4:RANGE " + self.conf['CHANNEL4_RANGE']
         self.send(cmdString + '\n')
      if self.conf['TIME_RANGE'] :
         cmdString = ":TIM:RANG " + self.conf['TIME_RANGE']
         self.send(cmdString + '\n')
      if self.conf['TIMEBASE_REF'] :
         cmdString = ":TIMEBASE:REFERENCE " + self.conf['TIMEBASE_REF']
         self.send(cmdString + '\n')
      if self.conf['TRIGGER_SOURCE'] :
         cmdString = ":TRIGger:EDGE:SOURce " + self.conf['TRIGGER_SOURCE']
         self.send(cmdString + '\n')
      if self.conf['TRIGGER_MODE'] :
         cmdString = ":TRIGGER:MODE " + self.conf['TRIGGER_MODE']
         self.send(cmdString + '\n')
      if self.conf['TRIGGER_SWEEP'] :
         cmdString = ":TRIGGER:SWEEP " + self.conf['TRIGGER_SWEEP']
         self.send(cmdString + '\n')
      if self.conf['TRIGGER_LEVEL'] :
         cmdString = ":TRIGGER:EDGE:LEVEL " + self.conf['TRIGGER_LEVEL']
         self.send(cmdString + '\n')
      if self.conf['TRIGGER_SLOPE'] :
         cmdString = ":TRIGGER:EDGE:SLOPE " + self.conf['TRIGGER_SLOPE']
         self.send(cmdString + '\n')
      if self.conf['ACQUIRE_TYPE'] :
         cmdString = ":ACQUIRE:TYPE " + self.conf['ACQUIRE_TYPE']
         self.send(cmdString + '\n')
      if self.conf['ACQUIRE_MODE'] :
         cmdString = ":ACQUIRE:MODE " + self.conf['ACQUIRE_MODE']
         self.send(cmdString + '\n')
      
      cmdString = ":ACQUIRE:COMPLETE 100"
      self.send(cmdString + '\n')
      self.send(":WAVEFORM:FORMAT BYTE" + '\n')
      self.send(":WAVEFORM:POINTS:MODE RAW" + '\n')
      #get more than 1000 points only then this line is on 2/26 JK ?????

   def send(self, msg):
      #self.logger.info("Sending to scop: " + msg)
      #testing
      #return
      #print(bytes(msg, 'ascii'))
      self.socket.send(bytes(msg, 'ascii'))

   def recv(self, numBytes):
      msg = self.socket.recv(numBytes)
      return (msg)

   def openConnection(self):
     self.socket.connect((self.conf['OSCILLOSCOPE_IP'], int(self.conf['OSCILLOSCOPE_PORT'])))
     #self.send("*RST" + '\n')
     self.send("*IDN?"+'\n')
     oscID = self.recv(200)
     self.logger.info("\tConnected to Oscilloscope ID :" + str(oscID) + '\n')
     
   def closeConnection(self):
      self.socket.close()

   def arm(self):
      channels = []
      if self.conf['CHANNEL1_RANGE']   != 'OFF' :
         channels.append('CHAN1')
      if self.conf['CHANNEL2_RANGE'] != 'OFF' :
         channels.append('CHAN2')
      if self.conf['CHANNEL3_RANGE'] != 'OFF' :
         channels.append('CHAN3')
      if self.conf['CHANNEL4_RANGE'] != 'OFF' :
         channels.append('CHAN4')

      channels = ', '.join(channels)
      cmdString = ":DIGITIZE " + channels
      #print(cmdString)
      self.send(cmdString.strip() + '\n')
      #time.sleep(0.1)

   def getAlignedTrace(self):
      powerChan = ""
      if self.conf['CHANNEL1_RANGE']   != 'OFF' :
         powerChan = 'CHAN1'
      elif self.conf['CHANNEL2_RANGE'] != 'OFF' :
         powerChan = 'CHAN2'
      elif self.conf['CHANNEL3_RANGE'] != 'OFF' :
         powerChan = 'CHAN3'
      elif self.conf['CHANNEL4_RANGE'] != 'OFF' :
         powerChan = 'CHAN4'

      triggerChan = self.conf['TRIGGER_SOURCE']

      powerSignal = self.readChannel(powerChan)
      powerSignal=  self.adjustSampleSize(self.numSamples, powerSignal)
      triggerSignal = self.readChannel(triggerChan)
      triggerSignal = self.adjustSampleSize(self.numSamples, triggerSignal)
      alginedTrace = self.alginTrace(powerSignal, triggerSignal)
      return alginedTrace

   def readChannel(self, channelName):
      t1 = time.time()
      self.send(":WAVEFORM:SOURCE " + channelName + "\n")
      self.send(":WAVEFORM:MODE BYTE\n")
      self.send(":WAVEFORM:POINTS " + str(self.numSamples) + '\n')
      self.send(":WAVEFORM:PREAMBLE?" + '\n')
      preamble = self.recv(400)
      preamble= preamble.split(bytes(',', 'ascii'))
      #print(preamble)
      vdiv = 32 * float(preamble[7])
      off = float(preamble[8])
      sdiv = float(preamble[2]) * float(preamble[4]) / 10
      delay = (float(preamble[2]) / 2) * float(preamble[4]) + float(preamble[5])
      self.send(":WAVEFORM:DATA?" + '\n')
      tData = int(preamble[2])
      wavedata = bytes()
      temp = self.recv(11)
      temp = self.recv(tData)
      wavedata = wavedata+temp
      while (len(wavedata) < tData):
         temp = self.recv(tData)
         wavedata = wavedata + temp   
      #print(wavedata )
      rawImg = numpy.frombuffer(wavedata, dtype = numpy.ubyte, count = int(preamble[2]))
      imgY1 = (rawImg - float(preamble[9])) * float(preamble[7]) + float(preamble[8])
      measuredData = numpy.array(imgY1, dtype = numpy.float64)
      t2 = time.time()
      #print("++++++++++++++++++++++++++++++++++++++++t2-t1=%s" % str(t2-t1))
      return measuredData


   def alginTrace(self, measuredPowerData, measuredTriggerData):     
      start, end = getCutPoints(self, measuredTriggerData)
      print("Cutting trace : start= " + str(start) + " end=" + str(end))
      return measuredPowerData[start:end]
    
   def getCutPoints(self, measuredTriggerData):
      sampleNo = 0
      firstTriggerHigh = False
      tempArray = numpy.zeros(0)
      start = 0 
      end = len(measuredTriggerData)
      threshold = float(self.conf['TRIGGER_LEVEL'])
      for sampleNo in range(0, len(measuredTriggerData)):
         if(measuredTriggerData[sampleNo] > threshold and firstTriggerHigh == False):
            start = sampleNo
            firstTriggerHigh = True
            if self.cutMode != "TRIG_HIGH":
               break
         elif(measuredTriggerData[sampleNo] < threshold  and firstTriggerHigh == True):
            end = sampleNo
            break
      return (start,end)


   def adjustSampleSize(self, sampleLength, dataArray):
      temp = dataArray.shape
      newDataArray = dataArray
      arrLen = temp[0]
      if (arrLen == sampleLength):
         return dataArray
      elif (arrLen > sampleLength):
         diff = arrLen-sampleLength
         for count in range(0,diff):
            newDataArray = np.delete(newDataArray, -1, 0)
         return newDataArray  
      elif (arrLen < sampleLength):
         diff = sampleLength-arrLen
         for count in range (0,diff):
            newDataArray = np.append(newDataArray,0)
         return newDataArray  

def main():
   scopConfig = {
         'OSCILLOSCOPE'       : 'AGILENT', #AGILENT|OPENADC
         'OSCILLOSCOPE_IP'    : '192.168.10.10',
         'OSCILLOSCOPE_PORT'  : '5025',
         'AUTOSCALE'          : 'NO',   # YES|NO    
         'IMPEDANCE'          : 'ONEMEG', #FIFTY|ONEMEG
         # VOLTAGE AND TIME RANGE OPTIONS        
         'CHANNEL1_RANGE'     : '0.1V',
         'CHANNEL2_RANGE'     : '6V',
         'CHANNEL3_RANGE'     : 'OFF', # ON|OFF|voltage range
         'CHANNEL4_RANGE'     : 'OFF', # ON|OFF|voltage range
         'TIME_RANGE'         :  '0.000040',
         'TIMEBASE_REF'       : 'LEFT',    
         # TRIGGER OPTIONS
         'TRIGGER_SOURCE'     : 'CHANNEL2',
         'TRIGGER_MODE'       : 'EDGE',   
         'TRIGGER_SWEEP'      : 'NORM',
         'TRIGGER_LEVEL'      : '1',
         'TRIGGER_SLOPE'      : 'POSITIVE',
         # ACQUIRE OPTIONS
         'ACQUIRE_TYPE'       : 'NORM', # NORM|PEAK|HRES|AVER
         'ACQUIRE_MODE'       : 'RTIM'   # RTIM | ETIM| SEG
   }
   sc = Scope()
   sc.openConnection()
   sc.setConfig(scopConfig)
   print(sc.getConfig())
   sc.openConnection()
   sc.arm()
   sc.closeConnection()

if __name__=="__main__":
   main()