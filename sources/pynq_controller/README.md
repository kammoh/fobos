# Requirements

1. Vivado 2017.2 is required to build the project. It must be on the PATH, i.e. it can be invoked directrly from the shell.

# Build the project from source

1. `$cd fobos/sources/pynq_controller/vivado/`.
2. `$make create_project`

# Modify the project

1. Add your IPs under `fobos/sources/pynq_controller/vivado/ip_repo` under their own folders.
2. Modify the block design using Vivado GUI.
3. Export the updated block design to `fobos/sources/pynq_controller/vivado/src/bd/ctrl_top.tcl` (File-> Export -> Export Block Design...). 
4. Export the project tcl file to `fobos/sources/pynq_controller/vivado/build_proj.tcl`.
5. Commit the changes to the ip_repo folder, ctrl_top.tcl and build_proj.tcl.

# Synthesize the project

TODO
