# Requirements

1. Vivado 2017.2 is required to build the project. It must be on the PATH, i.e. it can be invoked directrly from the shell.

# Build the project from source

1. `$cd fobos/sources/soc_dut/vivado/`.
2. `$make create_project`

# Modify the project

1. Add your IPs under `fobos/sources/soc_dut/vivado/ip_repo` under their own folders.
2. Modify the block design using Vivado GUI.
3. Export the updated block design to `fobos/sources/soc_dut/vivado/src/bd/ctrl_top.tcl` (File-> Export -> Export Block Design...). 
4. Export the project tcl file to `fobos/sources/soc_dut/vivado/build_proj.tcl`.
5. Commit the changes to the ip_repo folder, ctrl_top.tcl and build_proj.tcl.

# Synthesize the project

1. In Vivado, click Generate Bitsream.

# Create SDK project

1. In Vivado, File>Export> Export Hardware(include bitsream).
   Export to fobos/sources/soc_dut/sdk/workdir
2. From Vivado, launch SDK and set export location and workspace to the directory above.
3. In SDK create a new empty project(File> New applicationproject). You will need to select the hardware platform.
   SDK will create the BSP project from the hardware platfom and create the empty projetc.
4. Link all the .c and .h files in the fobos/sources/soc_dut/sdk/src to the project 
   (right-click on (project/src) -> Import -> General-> file system -> browse to file). 
   make sure to check "Advanced-> Create links in the workspace" and "Create virtual folders" .
8- Program FPGA.
8- Run the project.


