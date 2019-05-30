"""FOBOS Dummy serial port
Used to creat a dummy serial port to debug the software 
without a need for real hardware connection
"""
import random
import binascii

class DummySerial():

   def randBytes(self, len):
      """
      returns a random list of bytes
      len is the number of bytes
      """
      r = []
      for i in range(0,len):
         r.append(random.randint(0,255))
      return r

   def read(self, len):
      """
      returns a random string of bytes in hex string
      len is the number of bytes
      """
      l = self.randBytes(len)
      return binascii.hexlify(bytearray(l))

   def write(self, data):
      pass
