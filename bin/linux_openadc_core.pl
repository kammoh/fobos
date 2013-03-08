#!/usr/bin/perl

#Open ADC Send/Receive Commands
$CG_SEND = "./DeppDemo -p ";
$CG_RECV = "./DeppDemo -g ";
$CG_NEXD = "-d Nexys2 ";

# $CG_SEND = "dpcutil.exe -p ";
# $CG_RECV = "dpcutil.exe -g ";
# $CG_NEXD = "";

#Open ADC  Command/Status Registers
$PC2BD_CMD_REG = "0x00 ";
$GAIN_REG = "0x02 ";
#Open ADC  Data Send/Receive Registers
$BD2PC_DATA_SEND_REG1 = 11;
$BD2PC_DATA_SEND_REG2 = 12;
$BD2PC_DATA_SEND_REG3 = 13;
$BD2PC_DATA_SEND_REG4 = 14;

###############################################################################################################
###### Command Code Hash #########################################################################
###############################################################################################################
  %cmd_code = (all_ok  => '0x40', switch => '0xA0',
			   reset   => '0x41', start_gc => '0x20',
			   start   => '0x00',);
################################################################################################################

sub dec2hex {
$hexval = sprintf("%02X", $_[0]);
return $hexval;
}

sub hex2dec {
$decval = sprintf("%d", $_[0]);
return $decval;
}

sub clear_screen {
system ('clear');
}

sub recv_data2pc{
#print " Receiving from Reg -> $_[0] ....";
my $REG_INDEX = dec2hex($_[0]);
my $cmd = $CG_RECV.$REG_INDEX." ".$CG_NEXD;
#my $cmd = "dpcutil.exe -g 0x".$REG_INDEX;
#print $cmd."\n";
$output = `$cmd`;
#print $output."\n";
my @temp = split (" ", $output);
my $hex = dec2hex($temp[3]);
#print "$hex..[DONE]\n";
return $hex;

}

sub set_GainReg {
print "\tSetting Gain Reg ...";
my $VAL2SEND = dec2hex($_[0]);
my $cmd = $CG_SEND.$GAIN_REG.$CG_NEXD."-b ".$VAL2SEND;
#my $cmd = $CG_SEND.$GAIN_REG.$CG_NEXD.$VAL2SEND;
$output = `$cmd`;
sleep(2);
print "...[DONE]\n";
}


sub reset_data_collect {
print "\tSending Reset Command ...";
my $cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."-b 0xC0";
#my $cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."0xC0";
$output = `$cmd`;
print "..[DONE]\n";
print "\tSending Start Command ...";
$cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."-b 0x00";
#$cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."0xC0";
$output = `$cmd`;
#print $cmd."\n";
print "..[DONE]\n";
#print $output.'\n';		
}

sub get_clkfreq {
my @clk_data;
print "\tReading DCM Clock Frequency -> \n";
sleep(3);
$clk_data[1] = recv_data2pc(7);
$clk_data[2] = recv_data2pc(8);
$clk_data[3] = recv_data2pc(9);
$clk_data[4] = recv_data2pc(10);
$dcm_clkfreq = $clk_data[1].$clk_data[2].$clk_data[3].$clk_data[4];
$dcm_clkfreqhz = hex($dcm_clkfreq);
$dcm_clkfreqhz = $dcm_clkfreqhz/1000000;
print "------------------------------------------------\n";
print "DCM Clock Frequency (in MHz) -> $dcm_clkfreqhz\n";
print "------------------------------------------------\n";
}

sub currentTime{
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = localtime();
	$year += 1900;
	$sec = "0".$sec if( $sec < 10);
	$min = "0".$min if( $min < 10);
	$hour = "0".$hour if( $hour < 10);
	$mday = "0".$mday if( $mday < 10);
	$mon = "0".$mon if( $mon < 10);

	return "$hour:$min:$sec";
}

sub calculate_voltages{
my @byte1 = @{ $_[0] };
my @byte2 = @{ $_[1] };
my @voltage_val = ();
my $databytes = $_[2];
my $r = 0;
while ($r < $databytes){
	my @val = split("", unpack("B8", pack("V", $byte1[$r])).unpack("B8", pack("V", $byte2[$r])));
	
	my $bitstring = join("",@val[6..15]);
	#print "$bitstring\n";
	$vec = Bit::Vector->new_Bin(16, "000000".$bitstring);
	$voltage_val[$r] = $vec->to_Dec();
	$voltage_val[$r] = sprintf("%.3f",($voltage_val[$r])*(3.3/1023));
	$r++;}
return (@voltage_val);
}

sub data_switch {
#print "\tSwitch to read from BRAM ...";
my $cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."-b 0x20";
#my $cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."0x20";
$output = `$cmd`;
#print "..[DONE]\n";		
}

sub reset_bram_counter {
#print "\tSwitch to read from BRAM ...";
my $cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."-b 0x30";
#my $cmd = $CG_SEND.$PC2BD_CMD_REG.$CG_NEXD."0x30";
$output = `$cmd`;
#print "..[DONE]\n";		
}

sub data2pc_stream {
my $databytes = $_[0];
my $r = 0;
my $format = $_[2];
my @data1 = ();
my @data2 = ();
$current_time = currentTime();
my $data_file = "data_mem_1000.txt";
my $voltage_reading = "data_adc_voltages.txt";
print "--------------------------------------------------------------\n";
print "Starting Data Collect script @ $current_time\n";
print "--------------------------------------------------------------\n";
my $start = time;
print "\tSwitching to read from BRAM ...\n";
&reset_bram_counter();
&data_switch();
my $startT = time;
print "\tReading Started @ $current_time\n";
print "\tCollecting Data....";
#print "r = $r\n";
while ($r < $databytes) {
		$data1[$r] = recv_data2pc(11);
		$r++;}
&reset_bram_counter();
&data_switch();
$r =0;
while ($r < $databytes) {
		$data2[$r] = recv_data2pc(12);
		$r++;}

my $datatns_time = time - $startT;
print "\tReading Completed.\n";
print "\tTime Taken = $datatns_time\n";
print "\tOpening the file $data_file for writing ....";
open OUTFILE, '>', $data_file or die;
print "...[DONE]\n";
if($format == 0){print"\tWriting Data in Binary format ....";}else{print"\tWriting Data in Decimal format ....";}
	while ($r < $databytes) {
		if($format == 0){
			print OUTFILE unpack("B8", pack("V", $data1[$r]))." ".unpack("B8", pack("V", $data2[$r]))."\n";}
		else{
			print OUTFILE $data1[$r]." ".$data2[$r]."\n";}
		$r++;
	}
close OUTFILE;
print "...[Done]\n";
print "\tConverting Data to Voltages and writing to file $voltage_reading ....";
open VOLTFILE, '>', $voltage_reading or die;
my @voltages = calculate_voltages(\@data1, \@data2, $databytes);
foreach $voltvals (@voltages){print VOLTFILE $voltvals."\n";}
close VOLTFILE;	
print "...[Done]\n";
my $time_taken = time - $start;
$current_time = currentTime();
print "--------------------------------------------------------------\n";
print "Data Collection Complete @ $current_time\n";
print "Elapsed Time : $time_taken Sec\n";
print "--------------------------------------------------------------\n";
}
1;
