set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

launch_runs impl_1 -to_step write_bitstream -jobs 8
file mkdir /home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk
file copy -force /home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.runs/impl_1/top_wrapper.sysdef /home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk/top_wrapper.hdf 


launch_sdk -workspace /home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk -hwspec /home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk/top_wrapper.hdf





add_files -norecurse /home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk/ctrl/Release/ctrl.elf
set_property used_in_simulation 0 [get_files /home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk/ctrl/Release/ctrl.elf]
set_property SCOPED_TO_REF top [get_files -all -of_objects [get_fileset sources_1] {/home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk/ctrl/Release/ctrl.elf}]
set_property SCOPED_TO_CELLS { microblaze_0 } [get_files -all -of_objects [get_fileset sources_1] {/home/aabdulga/repos/fobos_gitlab/fobos/capture/ctrl/basys3ctrl/vivado/basys3ctrl/basys3ctrl.sdk/ctrl/Release/ctrl.elf}]

create_hw_cfgmem -hw_device [lindex [get_hw_devices xc7a35t_0] 0] [lindex [get_cfgmem_parts {s25fl032p-spi-x1_x2_x4}] 0]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices xc7a35t_0] 0]]
refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]

