library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity victim_fpga_tb is
end;

architecture bench of victim_fpga_tb is

  component victim_fpga 
  	port(
  	     clock: in std_logic;
  		 reset: in std_logic;
  		 src_ready : in STD_LOGIC;
  		 dst_ready : in STD_LOGIC;
  		 datain : in std_logic_vector(15 downto 0);
  		 src_read  : out STD_LOGIC;
  		 dst_write : out STD_LOGIC;
  		 dataout : out std_logic_vector(15 downto 0)
  		 );
  end component;

  signal clock: std_logic := '0';
  signal reset: std_logic;
  signal src_ready: STD_LOGIC;
  signal dst_ready: STD_LOGIC;
  signal datain: std_logic_vector(15 downto 0);
  signal src_read: STD_LOGIC;
  signal dst_write: STD_LOGIC;
  signal dataout: std_logic_vector(15 downto 0) ;
  signal t : time := 20ns;
begin

  uut: victim_fpga port map ( clock     => clock,
                              reset     => reset,
                              src_ready => src_ready,
                              dst_ready => dst_ready,
                              datain    => datain,
                              src_read  => src_read,
                              dst_write => dst_write,
                              dataout   => dataout );
   clock <= not clock after t;
  stimulus: process
  begin
  	     reset <= '1';
  		 src_ready <= '0';
  		 dst_ready <= '0';
  		 datain <= (others => '0');
	wait for 2*t;
    -- Put initialisation code here
	reset <= '0';
	wait for 2*t;
	src_ready <= '1';
	--wait until src_read = '1';
	datain <= x"0023";
	wait for 2*t;				 
		datain <= x"2b7e";
	wait for 2*t;	
		datain <= x"1516";
	wait for 2*t;	
		datain <= x"28ae";
	wait for 2*t;	
		datain <= x"d2a6";
	wait for 2*t;	
		datain <= x"abf7";
	wait for 2*t;	
		datain <= x"1588";
	wait for 2*t;	
		datain <= x"09cf";
	wait for 2*t;	
		datain <= x"4f3c";
	wait for 2*t;	
		datain <= x"0022";
	wait for 2*t;	
		datain <= x"0000";
	wait for 2*t;	
		datain <= x"0000";
	wait for 2*t;	
		datain <= x"0000";
	wait for 2*t;	
		datain <= x"0000";
	wait for 2*t;	
		datain <= x"0000";
	wait for 2*t;	
		datain <= x"0000";
	wait for 2*t;	
		datain <= x"0000";
	wait for 2*t;
	datain <= x"0000";
	src_ready <= '0';
	wait until dst_write = '1';
	dst_ready <= '1';
	

    -- Put test bench stimulus code here

    wait;
  end process;


end;
  