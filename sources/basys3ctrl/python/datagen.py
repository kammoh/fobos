"""FOBOS data generator
Used to generate random data to be used as 
test vectors
"""
import random
import binascii

class DataGenerator():
   ###FOBOS protocol headers
   """
   00C0 = PDI(public data(plaintext), 00C1 = SDI(secret data input (key)), 
   00C2 = RDI(random data input).
   0081 = Expected output length
   0080 = Command, 0001 = start_command
   """
   H_PDI = "00c0"
   H_SDI = "00c1"
   H_RDI = "00c2"
   H_OUT_LEN = "0081"
   H_CMD = "0080"
   START_CMD = "0001"

   def randBytes(self, len):
      """
      returns a random list of bytes
      len is the number of bytes
      """
      r = []
      for i in range(0,len):
         r.append(random.randint(0,255))
      return r

   def randBytesHex(self, len):
      """
      returns a random string of bytes in hex string
      len is the number of bytes
      """
      l = self.randBytes(len)
      return binascii.hexlify(bytearray(l))

   def to2ByteHex(self, num):
      """
      Converts num to 2 byte hex number.
      e.g 20 ->> "14"
      """
      lsb = num % 256
      msb = num / 256
      return binascii.hexlify(bytearray([msb, lsb]))
      
   def randTestVector(self, pdiLen, sdiLen, rdiLen, outLen):
      """
      returns a test vector in FOBOS format.
      Legend 
      00C0 = PDI(public data(plaintext), 00C1 = SDI(secret data input (key)), 
      00C2 = RDI(random data input).
      0081 = Expected output length
      0080 = Command, 0001 = start_command
      """
      sdi = self.randBytesHex(sdiLen)
      pdi = self.randBytesHex(pdiLen)
      s = self.H_PDI + self.to2ByteHex(pdiLen) + pdi +  self.H_SDI + self.to2ByteHex(sdiLen) + sdi
      if rdiLen != 0:
         rdi = self.randBytesHex(rdiLen)
         s += self.H_RDI + self.to2ByteHex(rdiLen) + rdi
      s += self.H_OUT_LEN + self.to2ByteHex(outLen) + self.H_CMD + self.START_CMD

      return s

def main():
   """
   Tesing routine
   """
   d = DataGenerator()
   print d.randBytes(3)
   print d.randBytesHex(3)
   print d.randTestVector(2,2,2,4)

if __name__ == '__main__':
   main()
      

