###Make file to re-create the project and synthesize it from sources
create_project:
	vivado -mode batch -source build_proj.tcl
synth: 
	vivado -mode batch -source synth.tcl

### removes vivado log and jou files ###
clean:
	rm -f *.log *.jou *.str
	rm -rf basys3ctrl
	rm -rf .Xil
