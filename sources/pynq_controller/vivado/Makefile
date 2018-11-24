###Make file to re-create the project and synthesize it from sources
create_project:
	python modify_project_tcl.py && vivado -mode batch -source build_proj_modified.tcl
synth: create_project
	vivado -mode batch -source synth.tcl

### removes vivado log and jou files ###
clean:
	rm *.log *.jou
	rm -rf pynq_controller/
