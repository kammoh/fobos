#from fobos.datagen import DataGenerator
import fobos
#USER PARAMETERS######################################################################
NUM_TRACES  = 10000     #number of traces to generate
PDI_LEN     = 16     #legnth of pdi(plaintext etc.) in bytes
SDI_LEN     = 16     #length of sdi(key) in bytes
RDI_LEN     = 0      #length of rdi(random data) in bytes
OUTPUT_LEN  = 16     #expected output(ciphertext) length in bytes
SDI 	    = '0123456789abcdef123456789abcdef0'
PDI 	    = 'da39a3ee5e6b4b0d3255bfef95601890'
#store the files you generate into this directory
TV_FILE     = "/home/xilinx/fobosworkspace/aes_tvla/dinFileFVR.txt" 
CHOICE_FILE     = "/home/xilinx/fobosworkspace/aes_tvla/fvrChoice.txt" 

####################################################################################

def main():
   gen = fobos.DataGenerator()
   gen.genTVLAFile(PDI_LEN, SDI_LEN, RDI_LEN, OUTPUT_LEN, TV_FILE, 
         CHOICE_FILE, NUM_TRACES, PDI, SDI)

if __name__ == '__main__':
   main()
