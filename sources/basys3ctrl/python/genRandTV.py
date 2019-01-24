import fobos
#USER PARAMETERS######################################################################
NUM_TRACES  = 1000     #number of traces to generate
PDI_LEN     = 16     #legnth of pdi(plaintext etc.) in bytes
SDI_LEN     = 16     #length of sdi(key) in bytes
RDI_LEN     = 0      #length of rdi(random data) in bytes
OUTPUT_LEN  = 16     #expected output(ciphertext) length in bytes
#store the files you generate into this directory
OUT_FILE     = "/home/aabdulga/fobos_workspace/aes/dinFile.txt" 

####################################################################################

def main():
   gen = fobos.DataGenerator()
   gen.randTVFile(PDI_LEN, SDI_LEN, RDI_LEN, OUTPUT_LEN, OUT_FILE, NUM_TRACES)

if __name__ == '__main__':
   main()
