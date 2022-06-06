FOBOS
=====

Flexible Open-source workBench fOr Side-channel analysis (FOBOS) is an "acquisition to analysis" solution which includes all necessary software to control the device under test (attack) (DUT), trigger the oscilloscope, obtain the measurements and analyze them using several power analysis techniques.

FOBOS splits the Side Channel Analysis (SCA) setup into a control board, a DUT, and the SCA workstation. The firmware for the control board can be found in the folder `control`. The hardware description language files required to adapt a cryptographic algorithm to a particular FOBOS DUT are in the folder `DUT`. The `hardware` folder on the other hand contains circuit board design files for FOBOS boards such as the FOBOS Shield and several FOBOS DUTs. The `software` folder contains the scripts to run FOBOS. These python scripts run partially on the SCA workstation within a Jupyter notebook and partially on the Pynq DUT. The `docs` folder contains the FOBOS documentation.

FOBOS Control Board
-------------------
* `control`
   VHDL sources for configuring the FOBOS Control Boards. Requires Xilinx Vivado 2020.2.
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
    Source code of the FOBOS wrapper common to all FPGA targets and the contraint files for the supported DUTs.
  * `soc_wrapper`
    Source code for system on chip boards such as Zybo.
  * `example_cores`
    Contains implementations of example algorithms required for the tutorials.
 
FOBOS Hardware
--------------
* `hardware`
  Printed Circuit Board design files for FOBOS boards. Requires KiCad.
  * `fobos-shield`
    FOBOS Shield is a data aqcuisition and benchmarking boad that can be attached to the PYNQ-Z1 controller.
  * `fobos-mtc`
    FOBOS Multi Target Connector allows simple connection of several DUT boards to the FOBOS Shield.
  * `fobos-dut`
    Contains folders for each FOBOS DUT.

FOBOS Software
--------------
* `software`
  FOBOS is controlled by a series of Python 3 scripts. They can be executed in several different ways.
  1. Command line, either on PYNQ or on a PC, tested on Windows 10 and Linux.
  1. Jupyter Notebook, either on PYNQ or on a PC, tested on Windows 10 and Linux.

  * `foboslib` contains all common FOBOS functions.
  * `notebooks` contains Jupyter notebooks that run within Jypyter Lab on a PC.
  * `pynq=notebooks` contains Jupyter notebooks that run on within Jupyter Hub on Pynq.
  * `examples` contains command line examples

Documentation
-------------

* `docs` 
  Contains the sources for the Sphinx based documentation of FOBOS and the makefile to compile it.
  All figures used for the FOBOS documentation are in the folder `docs\source\figures`.



