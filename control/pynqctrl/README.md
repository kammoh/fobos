# Requirements

1. Vivado 2020.2 is required to build the project. It must be on the PATH, i.e. it can be invoked directrly from the shell.

# Build the project from source

Using a command line:

1. `cd fobos/sources/pynq_controller/vivado/`.
2. `make create_project`
3. `make synth`
4. Go and make yourself a cup of coffee or tea, this is going to take a while


# Preparing the control board

**This section needs updating**
1. Copy the `fobos/sources/pynq_controller/python3/` folder to the PYNQ board `~/jupyter_notebooks/pynq_fobos/` directory.
2. Edit the file `~/jupyter_notebooks/pynq_fobos/python3/pynqserver.py` to change the IP address to the correct address of the PYNQ board (TO BE CHANGED TO BE AUTOMATIC).

2. Allow the xilinx user to be able to use sudo whithout password. This is needed to run control software which needs access to hardware. Use the command `sudo visudo` to add the following line to the sudoers file:

 `xilinx ALL=(ALL) NOPASSWD:ALL`. 

2. Add the following line to `/etc/crontab` to start/restart the control software 

`*/5  *    * * *   xilinx   cd /home/xilinx/jupyter_notebooks/pynq_fobos/python3/ && sudo python3 /home/xilinx/jupyter_notebooks/pynq_fobos/python3/serverWatchdog.py >>/tmp/fobos.log 2>&1`


# Test Run
**This section needs updating**
 1. In the PC connected to the PYNQ board. Open Jupyter-notebook and run the file `fobos/software/capture_traces_v3.ipynb`.

# Note about lock file

 Lock file is located at `/tmp/fobos.lock`. If this file is removed, the lock is released. (TO DO. create a method to avoid using the lock in signle user mode). Now locking is disabled.

# Modify the project

1. Add your IPs under `fobos/sources/pynq_controller/vivado/ip_repo` under their own folders.
2. Modify the block design using Vivado GUI.
3. Export the updated block design to `fobos/sources/pynq_controller/vivado/src/bd/ctrl_top_wrapper.tcl` (File-> Export -> Export Block Design...). 
4. Export the project tcl file to `fobos/sources/pynq_controller/vivado/build_proj.tcl`.
5. Commit the changes to the ip_repo folder, ctrl_top.tcl and build_proj.tcl.

# Synthesize the project

1. Open the project in Vivado. In Vivado's sources window, right-click the block design file (ctrl_top.bd) and select "Generate Output Products...".
2. The Generate Output Products window, select "Global" under Synthesis Options then click "Generate".
3. After the output products generation completes, click Generate Bitstream.
4. Copy the generated bitstream to `fobos/sources/pynq_controller/python3/`.
5. Generate block diagram tcl file. Open the block diagram then issue the `write_bd_tcl` command in the TCL console.
6. Copy the generated block diagram tcl file to `fobos/sources/pynq_controller/python3/`. Make sure it is named `ctrl_top_wrapper.tcl`.


# Committing updated project into GIT

* In Vivado open block design and go to the Menu: File -> Project -> Write TCL
* Select options: Copy sources to new project
* Open the resulting file and make the following edits
  * remove all lines till but not including: `set origin_dir`
  * remove lines from including:  `# Set 'sources_1' fileset object`
                 till not including:  `# Set 'sources_1' fileset properties`
  * Add at the end of the file:
```
#######Added manually to create block design and wrapper
## Create block design
# source $origin_dir/src/bd/ctrl_top.tcl
#
## Generate the wrapper
# set design_name [get_bd_designs]
# make_wrapper -files [get_files $design_name.bd] -top -import
#
######END ADDED
```
* On the command line execute: `mv pynq_controller.tcl build_proj.tcl`
* Create block diagram tcl file by using the Vivado tcl console and type `write_bd_tcl ctrl_top.tcl`
* move this file using in the command line: `mv ctrl_top.tcl src/bd/`


