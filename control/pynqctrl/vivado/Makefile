###Make file to re-create the project and synthesize it from sources
create_project:
	vivado -mode batch -source build_proj.tcl
	cd pynq_controller/pynq_controller.srcs/sources_1/imports/hdl
	ln -s ../../../../../src/ctrl_top_wrapper.vhd .
	cd ../../../../../
synth: create_project
	vivado -mode batch -source synth.tcl

### removes vivado log and jou files ###
clean:
	rm -f *.log *.jou
	rm -f build_proj_modified.tcl
	rm -rf pynq_controller/
