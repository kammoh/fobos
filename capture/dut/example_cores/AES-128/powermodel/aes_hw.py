import os
import sys
import math
# AES SBox
sbox = [0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67,
        0x2b, 0xfe, 0xd7, 0xab, 0x76, 0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59,
        0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0, 0xb7,
        0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1,
        0x71, 0xd8, 0x31, 0x15, 0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05,
        0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75, 0x09, 0x83,
        0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29,
        0xe3, 0x2f, 0x84, 0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
        0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf, 0xd0, 0xef, 0xaa,
        0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c,
        0x9f, 0xa8, 0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc,
        0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2, 0xcd, 0x0c, 0x13, 0xec,
        0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19,
        0x73, 0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee,
        0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb, 0xe0, 0x32, 0x3a, 0x0a, 0x49,
        0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
        0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4,
        0xea, 0x65, 0x7a, 0xae, 0x08, 0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6,
        0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a, 0x70,
        0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9,
        0x86, 0xc1, 0x1d, 0x9e, 0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e,
        0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf, 0x8c, 0xa1,
        0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0,
        0x54, 0xbb, 0x16]

# AES SBoxInverse
rsbox =[0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3,
        0x9e, 0x81, 0xf3, 0xd7, 0xfb, 0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f,
        0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb, 0x54,
        0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b,
        0x42, 0xfa, 0xc3, 0x4e, 0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24,
        0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25, 0x72, 0xf8,
        0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d,
        0x65, 0xb6, 0x92, 0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda,
        0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84, 0x90, 0xd8, 0xab,
        0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3,
        0x45, 0x06, 0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1,
        0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b, 0x3a, 0x91, 0x11, 0x41,
        0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6,
        0x73, 0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9,
        0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e, 0x47, 0xf1, 0x1a, 0x71, 0x1d,
        0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
        0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0,
        0xfe, 0x78, 0xcd, 0x5a, 0xf4, 0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07,
        0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f, 0x60,
        0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f,
        0x93, 0xc9, 0x9c, 0xef, 0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5,
        0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61, 0x17, 0x2b,
        0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55,
        0x21, 0x0c, 0x7d]
class Nonlinear:
    def getSBoxValue(num):
        """Retrieves a given S-Box Value"""
        return sbox[num]
    
    def getSBoxInvert(num):
        """Retrieves a given Inverted S-Box Value"""
        return rsbox[num]
    
    def getHW(num):
        """Calculates the Hamming Weight"""
        l = 0
        while num:
            num &= num -1
            l += 1
        return l    
    
if __name__ == "__main__":
    newpath1 = r'./GeneratedFiles' 
    newpath2 = r'./GeneratedFiles/intermediate'
    if not os.path.exists(newpath1):
      os.makedirs(newpath1) 
    if not os.path.exists(newpath2):
      os.makedirs(newpath2) 
      
    file_pt  = open("plaintexts.txt",'r')
    file_ct  = open("ciphertexts.txt",'r')
    #file_hw  = open("/home/pyalla/projects/fobos/data/hw2000x256.txt",'w')
    file_pt_rd = open("./%s/plaintexts_read.txt"%newpath1,'w') 
    file_ct_rd = open("./%s/ciphertexts_read.txt"%newpath1,'w') 
    
    zero     = 0
    #Setting the number of samples
    NoS = 5000
    
    #Declaration of input read arrays
    ptin = [0 for i in range(NoS*16)]
    ctin = [0 for i in range(NoS*16)]
    
    for p in range(0, NoS):
      x = file_pt.readline()
      y = file_ct.readline()
      for t in range(0, 16):
        drange_start = t*3
        drange_end   = 2+t*3
        #print(drange_start)
        #print(drange_end)
        ctin[p*16+t] =  int(y[drange_start:drange_end],16)
        ptin[p*16+t] =  int(x[drange_start:drange_end],16)#considering only the first byte
        file_pt_rd.write(str(hex(ptin[p*16+t])[2:4].upper()))
        file_ct_rd.write(str(hex(ctin[p*16+t])[2:4].upper()))
        file_pt_rd.write(' ')
        file_ct_rd.write(' ')
      file_pt_rd.write('\n')
      file_ct_rd.write('\n')
    file_pt.close()
    file_ct.close()
    file_pt_rd.close()
    file_ct_rd.close()
    
    for byte in range(0, 16):
      file_hd_pt=open("./%s/HD_of_PT_byte%s.txt" %(newpath1, byte),"w")
      for u in range(0, NoS):
        m=Nonlinear.getHW(ptin[u*16+byte])
        file_hd_pt.write('{}'.format(m))
        file_hd_pt.write('\n')
      file_hd_pt.close()  
    
    #Calcuation of hamming distance 
    for byte in range(0, 16):#Loop for each of the 16 bytes
        file_hw = open("./%s/HPower_byte_%s.txt" %(newpath1, NoS, byte), "w")
        file_im3 = open("./%s/Intermediate_data_for_%sSamples_with_byte_%s.txt" %(newpath2, NoS, byte),'w')
        file_im3.write('Intermediate Values for verification HW(sbox(PT[i] xor KeyGuess),sbox(CT[i-1]')
        file_im3.write('\n=========================================================================================================\n')
        file_im3.write('No\t \t')
        #file_im3.write('\t \t')
        file_im3.write('PT\t \t')
        file_im3.write('Sbox(PT)\t')
        file_im3.write('CT\t \t')
        file_im3.write('Sbox(CT)\t')
        file_im3.write('PT xor CT\t')
        file_im3.write('HW')
        file_im3.write('\n=========================================================================================================\n')
        for q in range(0, 256):#Loop for each of the 255 key guess
          file_im3.write('-------------------------------------------------------------------------------------------------------\n')
          file_im3.write('KeyGuess=%s'%(str(hex(q)[2:4].upper())))
          #file_im3.write(str(hex(q)[2:4].upper()))
          file_im3.write('\n-------------------------------------------------------------------------------------------------------\n')
          for r in range(0, NoS):#Loop for each of the NoS samples (Plaintexts, Ciphertexts)
            #a = int(x[6:8],16)#considering only the first byte
            #h.write(str(hex(a)[2:4].upper()))
            #h.write('\n')
            b = ptin[r*16+byte] ^ q        #CT xor KeyGuess
            c = Nonlinear.getSBoxValue(b)#SBox(PT xor KeyGuess)
            #Determine the change of bits aftertransformation
            if r == 0: 
              d = c ^ 0
            else: 
              ctsbox = Nonlinear.getSBoxValue(ctin[(r-1)*16+byte]) 
              d =  ctsbox ^ c
            e = Nonlinear.getHW(d)
            #h.write(str(b))
            file_hw.write('{}'.format(e))
            file_hw.write(' ')
            file_im3.write(str(r))
            file_im3.write('\t \t')
            file_im3.write(str(hex(ptin[r*16+byte])[2:4].upper()))
            file_im3.write('\t \t')
            file_im3.write(str(hex(c)[2:4].upper()))
            file_im3.write('\t \t')
            if r==0:
              file_im3.write(str(hex(zero)[2:4].upper()))
              file_im3.write('\t \t')
              file_im3.write(str(hex(zero)[2:4].upper()))
              file_im3.write('\t \t')
            else:  
              file_im3.write(str(hex(ctin[(r-1)*16+byte])[2:4].upper()))
              file_im3.write('\t \t')
              file_im3.write(str(hex(ctsbox)[2:4].upper()))
              file_im3.write('\t \t')
            file_im3.write(str(hex(d)[2:4].upper()))
            file_im3.write('\t \t')
            file_im3.write('{}'.format(e))
            file_im3.write('\n')
          if q < 255:
            file_hw.write('\n')
            #file_im3.write('\n')
          r=0
        file_hw.close()
        file_im3.close() 
    
