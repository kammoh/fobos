Introduction
************
The Flexible Opensource workBench fOr Sidechannel analysis (FOBOS) is a platform that
can be used for side channel analysis.
You can perform trace collection (Data Acquisition) and attacks (Data Analysis).
The system is suitable for educational and research purposes.

.. figure::  figures/fobos2-block.png
   :align:   center

   FOBOS Block Diagram

Feature Overview
================

- Separate control and (Design Under Test) boards allowing addition of new DUTs easily.
- Uses commercial over-the-shelf boards to when possible to reduce cost.
- Digilent Basys3 and Nexys A7 control board.
- DUT support includes Diginelt Nexys3 board (Xilinx Spartan6) and compatible with NewAE CW305
  (Xilinx Artix7 boards).
- Adjustable DUT clock.
- Adjustable trigger signal.
- Scripts to perform Deferential Power Analysis (DPA).
- Leakage assessment using t-test.


