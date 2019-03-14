#from fobos.datagen import DataGenerator
import fobos
#USER PARAMETERS######################################################################
NUM_TRACES  = 1000000     #number of traces to generate
PDI_LEN     = 16     #legnth of pdi(plaintext etc.) in bytes
SDI_LEN     = 16     #length of sdi(key) in bytes
RDI_LEN     = 0      #length of rdi(random data) in bytes
OUTPUT_LEN  = 16     #expected output(ciphertext) length in bytes
KEY 	    = '0123456789abcdef0011223344556677'
#store the files you generate into this directory
TV_FILE     = "/home/xilinx/fobosworkspace/aes/dinFile.txt" 
PDI_FILE     = "/home/xilinx/fobosworkspace/aes/pdi.txt" 

####################################################################################

def main():
   gen = fobos.DataGenerator()
   gen.randTVFile(PDI_LEN, SDI_LEN, RDI_LEN, OUTPUT_LEN, TV_FILE, PDI_FILE, NUM_TRACES,KEY)

if __name__ == '__main__':
   main()
