FOBOS-DUT
=========

Development of our own DUT boards.

Resources
---------

* `fobos-shield` contains the KiCad files for the shield. It includes the pinout of the Target connector.
* `fobos-mtc` also contains the pinout of the Target connector and protection circuits for power glitching.
* [NewAE Technology](https://www.newae.com/) produces the ChipWhisperer data aquisition board and targets.
  Several designs, hardware, and software are open source and available in the
  [ChipWhisperer GIT](https://app.assembla.com/spaces/chipwhisperer/git/source/master). Please clone this 
  repository.
  Of particular interest for us are the following tools:
  * [CW501 Differential Probe](https://wiki.newae.com/CW501_Differential_Probe):
    We have them but their signals are very noisy. The built in CW502 of the CW305 Artix-7 target board
    has much cleaner wave forms.
    Its in the git path `/hardware/tools/diffprobe` including Eagle project.
  * [CW502 Low Noise Amplifier](https://wiki.newae.com/CW502_Low_Noise_Amplifier): 
    This is the same aplifier used on their CW305 Artix-7 target boad for power measurements.
    Its in the git path `hardware/tools/lna_3v` including Eagle project.
  * [CW503 Probe Power Supply](https://wiki.newae.com/CW503_Probe_Power_Supply): 
    Power supply for the CW501 Differential Probe and the CW502 Low Noise Amplifier. 
    Its not in git. This circuit is replicated on the FOBOS-Shield, but its slightly noisy.
  And target boards:
  * [CW305 Artix FPGA Target](https://wiki.newae.com/CW305_Artix_FPGA_Target):
    Its a target board for Artix-7 that contains a progammer, 
    USB-interface, voltage regulators, protection for glitching and power measurement circuitry. We will be using its power
    measurement circuitry. Its the same as the CW502.
    We have one CW305 in use and it is compatible with the FOBOS-shield.
    Its in the git path `hardware/victims/cw305_artixtarget`. It does not contain an Eagle project, but
    Verilog code and the source code for the two microcontrollers of which one of them is the USB 
    interface and programmer.
  * [CW308 UFO Target](https://wiki.newae.com/CW308_UFO_Target):
    Its a board without a victim, but contains all necessary support circuitry.
    Its in the git path `hardware/victims/cw308_ufo_main`. It contains only the schematic.
  * [CW308T-S6LX6](https://wiki.newae.com/CW308T-S6LX9):
    Its a Spartan-6 target board that plugs into the UFO board.
    Its in the git path `hardware/victims/cw308_ufo_target/spartan6lx9`. It contains a Verilog example, schematic,
    and gerber files.
* FPGA Development Boards
  * [Cmod A7: Breadboardable Artix-7 FPGA Module](https://store.digilentinc.com/cmod-a7-breadboardable-artix-7-fpga-module/):
    Small, bare bones FPGA board. Its smallest FPGA option contains an XC7A15T-1CPG236C with 10,400 lookup tables. 
    The webpage has the schematics.
    Ommited from the schematics is the builtin USB progammer.
  * [Cmod S7: Breadboardable Spartan-7 FPGA Module](https://store.digilentinc.com/cmod-s7-breadboardable-spartan-7-fpga-module/):
    Another small, bare bones FPGA board. It contains an XC7S25-1CSGA225C which is also bigger than what we need at 14,600 lookup tables. 
    The webpage has the schematics.
    Ommited from the schematics is the builtin USB progammer.
  * [Intel Cyclone 10 LP FPGA Evaluation Kit](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=253&No=1140):
    A more complex board then the previous two. It contains an 10CL025YU256I7G with 25,000 LEs. 
    The webpage has the schematics.
  * [ULX3S](https://radiona.org/ulx3s/):
    Open source FPGA board based on Lattice Semiconductor ECP5  LFE5U-85F-6BG381C FPGA with 84,000 LUTs. Its a complex board.
    They announced also version with the ECP5-25F which has 25,000 LUTs and 12F. The PCB design files are
    available in their [git repository](https://github.com/emard/ulx3s). 
   
