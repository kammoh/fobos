use IO::Handle;
use IO::File;
use Bit::Vector;
require "linux_openadc_core.pl";

#############################################################
#Main Program from here
#############################################################
&clear_screen();
print "-----------------------------------------------------------------\n";
print "Starting #data_collect# PC-Board Communication Script\n";
print "-----------------------------------------------------------------\n";
&reset_data_collect();
&set_GainReg(39) #Put in a number insted of hex
&get_clkfreq();
&data2pc_stream(1000,$data_file,0);
system('perl openadc_graph.pl');




