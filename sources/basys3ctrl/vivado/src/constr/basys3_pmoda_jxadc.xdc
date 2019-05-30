#JA
#+----------+----------+----------+----------+
#|          |  din3    |  do_ready|  dut_clk |
#|  G2      |  J2      |  L2      |  J1      |
#+----------+----------+----------+----------+
#|  din0    |  din2    |  din1    |  do_valid|
#|  G3      |  H2      |  K2      |  H1      |
#+----------+----------+----------+----------+

#JXADC
#+----------+----------+----------+----------+
#|  dout1   |  dout3   |  di_ready|  rst     |
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


##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {dut_clk[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dut_clk[0]}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {do_ready}]
set_property IOSTANDARD LVCMOS33 [get_ports {do_ready}]
#Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {din[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {din[3]}]
#Sch name = JA4
#set_property PACKAGE_PIN G2 [get_ports {din[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {din[1]}]
#Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {do_valid}]
set_property IOSTANDARD LVCMOS33 [get_ports {do_valid}]
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
set_property PACKAGE_PIN K17 [get_ports {trigger_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {trigger_out}]
###################################################################
#Pmod Header JXADC
#Sch name = XA1_P
set_property PACKAGE_PIN J3 [get_ports {dut_rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {dut_rst}]
#Sch name = XA2_P
set_property PACKAGE_PIN L3 [get_ports {di_ready}]
set_property IOSTANDARD LVCMOS33 [get_ports {di_ready}]
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
set_property PACKAGE_PIN M3 [get_ports {di_valid}]
set_property IOSTANDARD LVCMOS33 [get_ports {di_valid}]
#Sch name = XA3_N
set_property PACKAGE_PIN M1 [get_ports {dout[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[2]}]
#Sch name = XA4_N
set_property PACKAGE_PIN N1 [get_ports {dout[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {dout[0]}]
###################################################################

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

