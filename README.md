FOBOS
=====

Flexible Open-source workBench fOr Side-channel analysis (FOBOS) is an "acquisition to analysis" solution which includes all necessary software to control the device under test (attack) (DUT), trigger the oscilloscope, obtain the measurements and analyze them using several power analysis techniques.

FOBOS splits the Side Channel Analysis (SCA) setup into a separate control board and a DUT.

FOBOS Control Board
-------------------
* `control`
   VHDL sources for configuring the FOBOS Control Boards. Requires Xilinx Vivado 2019.1.
   * `basys3ctrl`
     Using a Digilent Inc Basys 3 as control board and an oscilloscope for measurements.
   * `pynqctrl`
     Using a Digilent Inc PYNQ-Z1 as control board and either the FOBOS Shield or an oscilloscope for measurements.
   * `ip-repo` 
     Modules used by either control board.

FOBOS DUT
---------
* `dut`
  VHDL sources for FOBOS wrapper and pin assignments to prepare a DUT for instantiating a target algorithm.
  * `fpga_wrapper`
    Source code of the FOBOS wrapper common to all FPGA targets.
  * `soc_wrapper`
    Source code for system on chip boards such as Zybo.
  * `example_cores`
    Contains implementations of example algorithms required for the tutorials.
  * `fpga_boards`
     Config files for supported FPGA DUT boards
     * `CW305`
       NewAE CW305 Artix FPGA Target Board Xilinx Artix 7 FPGA
     * `Nexys4DDR`
       Digilent Inc Nexys 4 DDR board with Xilinx Artix 7 FPGA. Requires Xilinx ISE or Xilinx Vivado.
     * `Nexys4`
       Digilent Inc Nexys 4 board with Xilinx Artix 7 FPGA. Requires Xilinx ISE or Xilinx Vivado.
     * `Nexys3`
       Digilent Inc Nexys 3 board with Xilinx Spartan 6 FPGA. Requires Xilinx ISE.

FOBOS Hardware
--------------
* `hardware`
  Printed Circuit Board design files for FOBOS boards. Requires KiCad.
  * `fobos-shield`
    FOBOS Shield is a data aqcuisition boad that can be attached to the PYNQ-Z1 controller.
  * 'fobos-mtc'
    FOBOS Multi Target Connector allows simple connection of several DUT boards to the FOBOS Shield.

FOBOS Software
--------------
* `software`
  FOBOS is controlled by a series of Python scripts. They can be executed in several different ways.
  1. Command line, either on PYNQ or on a PC, tested on Windows 10 and Linux.
  1. Jupyter Notebook, either on PYNQ or on a PC, tested on Windows 10 and Linux.
  1. Jupyter Hub, tested on Linux.
  Requires Python 3.

  * `foboslib` contains all FOBOS functions.
  * `tutorials` contain the FOBOS tutorials.
  * `fobos_workspace` is an empty directory in which FOBOS will store all files created at run-time.

Documentation
-------------

* `docs` 
  Contains the sources for the Sphinx based documentation of FOBOS and the makefile to compile it.
  All figures used for the FOBOS documentation are in the folder `docs\source\figures`.



