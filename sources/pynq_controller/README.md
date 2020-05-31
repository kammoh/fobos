# Requirements

1. Vivado 2019.1 is required to build the project. It must be on the PATH, i.e. it can be invoked directrly from the shell.

# Build the project from source

1. `$cd fobos/sources/pynq_controller/vivado/`.
2. `$make create_project`

# Modify the project

1. Add your IPs under `fobos/sources/pynq_controller/vivado/ip_repo` under their own folders.
2. Modify the block design using Vivado GUI.
3. Export the updated block design to `fobos/sources/pynq_controller/vivado/src/bd/ctrl_top_wrapper.tcl` (File-> Export -> Export Block Design...). 
4. Export the project tcl file to `fobos/sources/pynq_controller/vivado/build_proj.tcl`.
5. Commit the changes to the ip_repo folder, ctrl_top.tcl and build_proj.tcl.

# Synthesize the project

1. Open the project in Vivado and click Generate Bitstream.
2. Copy the generated bitstream to `fobos/sources/pynq_controller/python3/`.
3. Generate block diagram tcl file. Open the block diagram then issue the `write_bd_tcl` command in the TCL console.
4. Copy the generated block diagram tcl file to `fobos/sources/pynq_controller/python3/`. Make sure it is named `ctrl_top_wrapper.tcl`.

# Preparing the control board

1. Copy the `fobos/sources/pynq_controller/python3/` folder to the PYNQ board `~/jupyter_notebooks/pynq_fobos/` directory.
2. Edit the file `~/jupyter_notebooks/pynq_fobos/python3/pynqserver.py` to change the IP address to the correct address of the PYNQ board (TO BE CHANGED TO BE AUTOMATIC).

2. Allow the xilinx user to be able to use sudo whithout password. This is needed to run control software which needs access to hardware. Use the command `sudo visudo` to add the following line to the sudoers file:

 `xilinx ALL=(ALL) NOPASSWD:ALL`. 

2. Add the following line to `/etc/crontab` to start/restart the control software 

`*/5  *    * * *   xilinx   cd /home/xilinx/jupyter_notebooks/pynq_fobos/python3/ && sudo python3 /home/xilinx/jupyter_notebooks/pynq_fobos/python3/serverWatchdog.py >>/tmp/fobos.log 2>&1`


# Test Run

 1. In the PC connected to the PYNQ board. Open Jupyter-notebook and run the file `fobos/software/capture_traces_v3.ipynb`.

# Note about lock file

 Lock file is located at `/tmp/fobos.lock`. If this file is removed, the lock is released. (TO DO. create a method to avoid using the lock in signle user mode). Now locking is disabled.