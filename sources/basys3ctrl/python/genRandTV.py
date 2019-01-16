import fobos
#USER PARAMETERS######################################################################
NUM_TRACES  = 10     #number of traces to generate
PDI_LEN     = 16     #legnth of pdi(plaintext etc.) in bytes
SDI_LEN     = 16     #length of sdi(key) in bytes
RDI_LEN     = 0      #length of rdi(random data) in bytes
OUTPUT_LEN  = 16     #expected output(ciphertext) length in bytes
#store the files you generate into this directory
OUT_DIR     = "/home/bakry/Documents/fobos_workspace/acorn/dinFile.txt" 

####################################################################################

def main():
   gen = fobos.DataGenerator()
   gen.randTVFile(PDI_LEN, SDI_LEN, RDI_LEN, OUTPUT_LEN, OUT_DIR, NUM_TRACES)

if __name__ == '__main__':
   main()