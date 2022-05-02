from chipwhisperer.capture.targets.CW305 import CW305

cw = CW305()
#cw.con(bsfile="/nhome/aabdulga/projects/dut_aes_128/FOBOS_DUT.bit", force=True)
cw.con(bsfile="/home/bakry/vivado_projects/aes_cw305_half_duplex/aes_cw305_half_duplex.runs/impl_1/half_duplex_dut.bit", force=True)
#cw.con(bsfile="/nhome/aabdulga/Artix7-DUT/will_aead2/will_aead2.runs/impl_1/FOBOS_DUT.bit", force=True)
#cw.con(bsfile="/home/aabdulga/research/ascon_sca/ascon_dut/ascon_dut.runs/impl_1/FOBOS_DUT.bit", force=True)
#cw.con(bsfile="/nhome/aabdulga/fobos_dut/artix7_dut/artix7_dut.runs/impl_1/FOBOS_DUT.bit", force=True)
#cw.con(bsfile="/nhome/aabdulga/projects/test_artix7/test_artix7.runs/impl_1/upcount.bit", force=True)

print("programming done!")

