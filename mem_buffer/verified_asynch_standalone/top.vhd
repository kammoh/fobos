library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    Port ( 
				dout : out  STD_LOGIC_VECTOR (15 downto 0); --output from Control Module

				CLOCK : IN STD_LOGIC;
				RESET : IN STD_LOGIC;
				COUNTER_EN : IN STD_LOGIC;
				
				--Memory Interface to Micron Inputs/Outputs
				MemAdr : OUT STD_LOGIC_VECTOR(25 DOWNTO 0);
				RamClk : OUT STD_LOGIC;
				RamAdv : OUT STD_LOGIC;
				RamCRE : OUT STD_LOGIC;
				RamCS : OUT STD_LOGIC;
				MemOE : OUT STD_LOGIC;
				MemWR : OUT STD_LOGIC;
				RamLB : OUT STD_LOGIC;
				RamUB : OUT STD_LOGIC;

				MemDB : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				RamWait : IN STD_LOGIC
			
			);
end top;

architecture top_arch of top is

SIGNAL counter_output : STD_LOGIC_VECTOR(15 DOWNTO 0);

--Control to Memory Interface Signals
SIGNAL addr_o : STD_LOGIC_VECTOR(25 DOWNTO 0);
SIGNAL data_i : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL data_o : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL we_o : STD_LOGIC;
SIGNAL go_o : STD_LOGIC;

begin
dout <= data_i;
--Counter
counter : ENTITY work.counter(Behavioral)
	GENERIC MAP( 
	    N=> 16
	)
	PORT MAP( 	  
		clk=>CLOCK,
		reset=>RESET,
	   enable=>go_o,--COUNTER_EN,
      counter_out=>counter_output
	);

--Control
control : ENTITY work.control(write_then_read)
	GENERIC MAP( 
					addr_width=>26,
					data_width=>16
				   )
    PORT MAP(
					--din=>counter_output,
					--dout=>dout
					clk_i=>CLOCK,
					addr_o=>addr_o,
					data_i=>counter_output,
					data_o=>data_o,
					we_o=>we_o,
					go_o=>go_o
			);


--Memory Interface
memory_interface : ENTITY work.memory_interface(Behavioral1)
	GENERIC MAP( addr_width =>26,
				data_width=>16)
	PORT MAP(
		-- These pins are used to talk to the celular ram  (memory_interface <--> cellular_ram);
		addr_o=>MemAdr,
		clk_o=>RamClk,
		addr_valid_o=>RamAdv,
		cntl_reg_enable_o=>RamCRE,
		chip_enable_o=>RamCS,
		output_enable_o=>MemOE,
		write_en_o=>MemWR,
		lower_byte_en_o=>RamLB,
		upper_byte_en_o=>RamUB,
		data_io=>MemDB,
		wait_i=>RamWait,
		-- These are the pins used to help interface the memory as if it were a block ram ( some module <--> memory_interface);
		addr_i=>addr_o,
		we_i=>we_o,
		data_i=>data_o,
		data_o=>data_i,
		clk_i=>CLOCK,
		go_i=>go_o --top module should set this to 0.  when ready to use, set to 1 for one cycle (max 90 ns) then bring down.  when go_i is high it will read or write otherwise it will be idle.;
	);

end top_arch;

