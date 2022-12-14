.. _dut_setup-label:
===============
Setup DUT Board
===============

A DUT (Design Under Test) board must be connected to the control board to run SCA. Here, 
we show how to connect and (modify board if needed) so that it can be used in FOBOS.

Digilent Nexy3 (Spartan 6 FPGA)
-------------------------------

Connection to Basys3 control board
----------------------------------

The PMOD ports on both boards are used to transfer data. The ports should be connected as follows

- Basys3 JA -> Nexys3 JC
- Basys3 JXADC -> Nexys3 JD

The connector must connect each pin to its corresponding pin in the other board. The GND of the two
ports must be connected, However, the Vcc SHOULD NOT be connected.

The pin mapping in the Nexys3 DUT is as follows: ::


    #JC
    #+----------+----------+----------+----------+
    #|          |  din3    |  do_ready|  rst     |
    #|          |          |          |          |
    #+----------+----------+----------+----------+
    #|  din0    |  din2    |  din1    |  do_valid|
    #|          |          |          |          |
    #+----------+----------+----------+----------+

    #JD
    #+----------+----------+----------+----------+
    #|  dout1   |  dout3   |  di_ready|  clk     |
    #|          |          |          |          |
    #+----------+----------+----------+----------+
    #|  dout0   |  dout2   |  di_valid|          |
    #|          |          |          |          |
    #+----------+----------+----------+----------+

The pin mapping in the Basys3 control board is as follows: ::


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

Board modification
------------------

- To make perfoming SCA attacks easier, all capacitors on the FPGA core voltage rail have been removed.
- The board is modified to be able to access the FPGA core voltage rail.
- To measere power, an inductive power porbe may be used (e.g. Tektronix CT-1).

NewAE CW305 (Artix7 FPGA)
-----------------------------


The PMOD ports JA and JXADC in the Basys3 control board should be connected to 40-pin port JP3.
The pin mapping in the NewAE CW305 is as follows: ::

    ######JP3
    #+----------+----------+----------+----------+
    #|          |  din3    |  do_ready|  rst     |
    #|  NC      |  D16     |  E16     |  F12     |
    #+----------+----------+----------+----------+
    #|  din0    |  din2    |  din1    |  do_valid|
    #|  D15     |  E15     |  E13     |  F15     |
    #+----------+----------+----------+----------+

    #+----------+----------+----------+----------+
    #|  dout1   |  dout3   |  di_ready|  clk     |
    #|  B12     |  A13     |  B15     |  C11     |
    #+----------+----------+----------+----------+
    #|  dout0   |  dout2   |  di_valid|          |
    #|  A12     |  A14     |  A15     |  C12     |
    #+----------+----------+----------+----------+

To measure the power, you can connect your oscilloscope to test poin X4. For more information,
refer to the manufacturer web-site.
