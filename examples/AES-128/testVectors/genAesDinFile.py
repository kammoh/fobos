pdiHeader = '00C0'
sdiHeader = '00C1'
command = '0080'
start = '0001'
expectedOutCmd = '0081'
pdiLength = '0010'
sdiLength = '0010'
expectedOut = '0010'

sdi =  '00112233445566778899AABBCCDDEEFF' ##KEY

fs = open('random_plaintext.txt', 'r')
fd = open('dinFile_aes_20000.txt','w')
lines = fs.readlines()
for pdi in lines:
   pdi = pdi.replace(" " , "").strip()

   data = pdiHeader + pdiLength + pdi + sdiHeader + sdiLength + sdi  + expectedOutCmd + expectedOut + command + start + '\n'
   fd.write(data)

fs.close()
fd.close()
