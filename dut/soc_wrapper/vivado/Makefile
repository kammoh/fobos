###Make file to re-create the project and synthesize it from sources
create_project:
	vivado -mode batch -source build_proj.tcl
synth: create_project
	vivado -mode batch -source synth.tcl

### removes vivado log and jou files ###
clean:
	rm -f *.log *.jou
	rm -f build_proj_modified.tcl
	rm -rf soc_dut/
