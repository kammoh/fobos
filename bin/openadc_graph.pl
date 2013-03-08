use GD;
use GD::Text;
use GD::Graph::lines; 
$voltage_file = "data_adc_voltages.txt";
$img_file = "graph.png";
#####################################################################
# Open Config File
#####################################################################
sub analyze_file {
    #print "Analyzing the file $_[0]...\n";
    #STDOUT->autoflush(1);
    open THEFILE, '<', $_[0] or die;
	my @data = <THEFILE>;
	close THEFILE;
	#print @data;
	return (@data);
}
#####################################################################
# Creating X Labels
#####################################################################
sub x_array{
my $r = 0;
my @x_array =();
while ($r < 999){
	$x_array[$r] = $r."\n";
	$r++;}
return (@x_array);
}
#####################################################################
# Main
#####################################################################

print "-----------------------------------------------------------------\n";
print "Starting Graph Plotter Script\n";
print "-----------------------------------------------------------------\n";
print "\tReading the file -> $voltage_file ....\n";
@data = analyze_file($voltage_file);
@x_ar = x_array();
@new = [ \@x_ar, \@data];

$my_graph = GD::Graph::lines->new(800,400);
$my_graph->set( 
x_label => 'Time (x 10ns)', 
y_label => 'Voltage (Volts)', 
title => 'Voltage Readings from ADC', 

y_min_value => 0, 
y_max_value => 4, 
y_tick_number => 20, 
y_label_skip => 1, 

x_tick_number => 20, 
x_label_skip => 1, 

box_axis => 0, 
line_width => 2, 
x_label_position => 1/2, 
r_margin => 15,
l_margin => 15, 
t_margin => 15,
b_margin => 15, 
zero_axis => 1,
zero_axis_only => 1,


x_labels_vertical => 1, 

transparent => 0, 

legend_spacing => 5, #spacing between legend elements
legend_placement =>'RT', #put legend to the centre right of chart
); 
print "\tPlotting Data ....\n";
$my_graph->set_legend('Voltage'); 
$my_graph->set_title_font('verdana',22); 

open(IMG, '>', $img_file) or die $!;
binmode IMG;
print IMG $my_graph->plot(@new)->png;
close IMG;
print "\tGraph Generated -> $img_file ....\n";
print "-----------------------------------------------------------------\n";
