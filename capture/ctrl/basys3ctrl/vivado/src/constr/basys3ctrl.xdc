#############################################################################
#                                                                           #
#   Copyright 2019 CERG                                                     #
#                                                                           #
#   Licensed under the Apache License, Version 2.0 (the "License");         #
#   you may not use this file except in compliance with the License.        #
#   You may obtain a copy of the License at                                 #
#                                                                           #
#       http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                           #
#   Unless required by applicable law or agreed to in writing, software     #
#   distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#   See the License for the specific language governing permissions and     #
#   limitations under the License.                                          #
#                                                                           #
#############################################################################
#JA
#+----------+----------+----------+----------+
#|          |  din3    |  do_ready|  rst |
#|  G2      |  J2      |  L2      |  J1      |
#+----------+----------+----------+----------+
#|  din0    |  din2    |  din1    |  do_valid|
#|  G3      |  H2      |  K2      |  H1      |
#+----------+----------+----------+----------+

#JXADC
#+----------+----------+----------+----------+
#|  dout1   |  dout3   |  di_ready|  dut_clk     |
#|  N2      |  M2      |  L3      |  J3      |
#+----------+----------+----------+----------+
#|  dout0   |  dout2   |  di_valid|          |
#|  N1      |  M1      |  M3      |  K3      |
#+----------+----------+----------+----------+

#JC
#+----------+----------+----------+------------+
#|          |          |          | trigger_out|
#|          |          |          |            |
#+----------+----------+----------+------------+
#|          |          |          |            |
#|          |          |          |            |
#+----------+----------+----------+------------+
###################################################################
## Clock signal
set_property PACKAGE_PIN W5 [get_ports sys_clock]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports sys_clock]
###################################################################
###reset is center button
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
###################################################################
##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {dut_rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {dut_rst}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports do_ready]
set_property IOSTANDARD LVCMOS33 [get_ports do_ready]
#Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {din[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[3]}]
#Sch name = JA4
#set_property PACKAGE_PIN G2 [get_ports {din[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {din[1]}]
#Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports do_valid]
set_property IOSTANDARD LVCMOS33 [get_ports do_valid]
#Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {din[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[1]}]
#Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {din[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[2]}]
#Sch name = JA10
set_property PACKAGE_PIN G3 [get_ports {din[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[0]}]
###################################################################
##Pmod Header JC
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports trigger_out]
set_property IOSTANDARD LVCMOS33 [get_ports trigger_out]
###################################################################
#Pmod Header JXADC
#Sch name = XA1_P
set_property PACKAGE_PIN J3 [get_ports {dut_clk[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dut_clk[0]}]
#Sch name = XA2_P
set_property PACKAGE_PIN L3 [get_ports di_ready]
set_property IOSTANDARD LVCMOS33 [get_ports di_ready]
#Sch name = XA3_P
set_property PACKAGE_PIN M2 [get_ports {dout[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[3]}]
#Sch name = XA4_P
set_property PACKAGE_PIN N2 [get_ports {dout[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[1]}]
#Sch name = XA1_N
#set_property PACKAGE_PIN K3 [get_ports {JXADC[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {JXADC[4]}]
#Sch name = XA2_N
set_property PACKAGE_PIN M3 [get_ports di_valid]
set_property IOSTANDARD LVCMOS33 [get_ports di_valid]
#Sch name = XA3_N
set_property PACKAGE_PIN M1 [get_ports {dout[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[2]}]
#Sch name = XA4_N
set_property PACKAGE_PIN N1 [get_ports {dout[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[0]}]
###################################################################
##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports RsRx]
set_property IOSTANDARD LVCMOS33 [get_ports RsRx]
set_property PACKAGE_PIN A18 [get_ports RsTx]
set_property IOSTANDARD LVCMOS33 [get_ports RsTx]
## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
##################################################################
##Seven-seg display
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {cathods[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[0]}]
set_property PACKAGE_PIN W6 [get_ports {cathods[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[1]}]
set_property PACKAGE_PIN U8 [get_ports {cathods[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[2]}]
set_property PACKAGE_PIN V8 [get_ports {cathods[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[3]}]
set_property PACKAGE_PIN U5 [get_ports {cathods[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[4]}]
set_property PACKAGE_PIN V5 [get_ports {cathods[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[5]}]
set_property PACKAGE_PIN U7 [get_ports {cathods[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[6]}]
set_property PACKAGE_PIN V7 [get_ports {cathods[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cathods[7]}]

set_property PACKAGE_PIN U2 [get_ports {anodes[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[0]}]
set_property PACKAGE_PIN U4 [get_ports {anodes[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[1]}]
set_property PACKAGE_PIN V4 [get_ports {anodes[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[2]}]
set_property PACKAGE_PIN W4 [get_ports {anodes[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anodes[3]}]
##################################################################
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out2]