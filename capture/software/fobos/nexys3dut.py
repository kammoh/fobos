###DUT utilities 
##This can be used to program DUT
###Requiremet : This requires Digilent Adept runtime and utilities to be installed

import subprocess
class Nexys3DUT:
   
   def __init__(self):
      self.bitFile = ""
      self.deviceID = "Nexys3"
      self.jtagID = 0

   def setBitFile(self, bitFile):
      self.bitFile = bitFile

   def program(self):
      """
      runs a command similar to
      djtgcfg prog -d Nexys3 -i 0 -f ~/fobos_workspace/aes/FOBOS_DUT.bit 
      This requires Digilent Adept runtime and utilities to be installed
      """
      if self.bitFile == "":
         print "FATAL Error: DUT programming bit file not set. Please set it to a valid .bit file. Exiting..."
         exit()

      cmd_init = ['djtgcfg', 'init', '-d', self.deviceID]
      cmd_prog = ['djtgcfg', 'prog', '-d', self.deviceID, '-i', str(self.jtagID), '-f', self.bitFile]
      print "Programming device using the following commands:"
      print " ".join(cmd_init)
      print " ".join(cmd_prog)
      subprocess.check_output(cmd_init)
      output = subprocess.check_output(cmd_prog)
      print output
      if not (output.strip().endswith("Programming succeeded.")):
         print "FATAL Error: DUT programming failed!. Exiting..."
         exit()

def main():
   dut = Nexys3DUT()
   dut.setBitFile("/home/aabdulga/fobos_workspace/aes/FOBOS_DUT.bit")
   dut.program()

if __name__ == "__main__":
   main()
