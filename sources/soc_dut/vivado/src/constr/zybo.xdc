
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
#JE
#+----------+----------+----------+----------+
#|          |  din3    |  do_ready|  dut_clk |
#|          |          |          |          |
#+----------+----------+----------+----------+
#|  din0    |  din2    |  din1    |  do_valid|
#|          |          |          |          |
#+----------+----------+----------+----------+

#JD
#+----------+----------+----------+----------+
#|  dout1   |  dout3   |  di_ready|  rst     |
#|          |          |          |          |
#+----------+----------+----------+----------+
#|  dout0   |  dout2   |  di_valid|          |
#|          |          |          |          |
#+----------+----------+----------+----------+

#JC
#+----------+----------+----------+------------+
#|          |          |          | trigger_out|
#|          |          |          |            |
#+----------+----------+----------+------------+
#|          |          |          |            |
#|          |          |          |            |
#+----------+----------+----------+------------+
##Clock signal
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports dut_clk]
create_clock -period 50.000 -name sys_clk_pin -waveform {0.000 25.000} -add [get_ports dut_clk]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets dut_clk_IBUF]
#################################################################################################
#Pmod Header JD
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports dut_rst]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports di_ready]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {dout[3]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {dout[1]}]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { jd_p[2] }]; #IO_L11P_T1_SRCC_34 Sch=JD3_P
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports di_valid]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {dout[2]}]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {dout[0]}]
#################################################################################################
#Pmod Header JE
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { dutl_clk] }]; #IO_L4P_T0_34 Sch=JE1
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports do_ready]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {din[3]}]
#set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {din[1]}]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports do_valid]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports {din[1]}]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports {din[2]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {din[0]}]
