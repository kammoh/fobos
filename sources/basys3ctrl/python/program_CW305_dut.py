from chipwhisperer.capture.targets.CW305 import CW305

cw = CW305()
#cw.con(bsfile="/nhome/aabdulga/projects/dut_aes_128/FOBOS_DUT.bit", force=True)
cw.con(bsfile="/nhome/aabdulga/Artix7-DUT/aes_dut_artix7_nobram/aes_dut_artix7_nobram.runs/impl_1/FOBOS_DUT.bit", force=True)
#cw.con(bsfile="/nhome/aabdulga/fobos_dut/artix7_dut/artix7_dut.runs/impl_1/FOBOS_DUT.bit", force=True)
#cw.con(bsfile="/nhome/aabdulga/projects/test_artix7/test_artix7.runs/impl_1/upcount.bit", force=True)

print "programming done!"

