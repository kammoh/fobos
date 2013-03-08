library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.victim_pkg.all;

entity victim_fpga is 
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
end victim_fpga;

architecture structure of victim_fpga is
signal data_enb : std_logic; -- from victim_contrl
signal key_enb : std_logic;	 -- from victim_contrl
signal cmd_enb : std_logic;	
signal done_exe : std_logic;
signal sr_output_enb : std_logic; -- from victim_contrl
signal sr_output_load : std_logic;-- from victim_contrl
signal start_to_crypto : std_logic; -- to crypto_core
signal trigger : std_logic;
signal cmd_buffer : std_logic_vector(15 downto 0);
signal data_to_crypto : std_logic_vector(127 downto 0); -- to crypto_core
signal key_to_crypto : std_logic_vector(127 downto 0);	-- to crypto_core
signal data_from_crypto : std_logic_vector(127 downto 0); -- from crypto_core
begin
 ------------------------ Input Command Buffer -------------------------
 command_reg: reg port map(
			a => datain,
			clk => clock,
			reset => reset,
			en   => cmd_enb,
			b    => cmd_buffer);
 ------------------------ Input Shift-Registers-------------------------
 pt : shiftreg_16x128 port map (
 			clock => clock,
			reset => reset,
			sr_e  => data_enb ,
			sr_input => datain,
			sr_output => data_to_crypto) ;

 key : shiftreg_16x128 port map (
 			clock => clock,
			reset => reset,
			sr_e  => key_enb ,
			sr_input => datain,
			sr_output => key_to_crypto) ;
------------------------ Output Shift-Registers-------------------------			
 ct  : shiftreg_128x16 port map(
			clock => clock,
			reset => reset, 
			sr_l  => sr_output_load,
			sr_e  => sr_output_enb,
			sr_input => data_from_crypto,
			sr_output => dataout) ;
------------------------ Victim outer-level Controller-------------------		
control: victim_contrl port map(
	     clock => clock,
		 reset => reset,
		 src_ready => src_ready,
		 dst_ready => dst_ready,
		 cmd_buffer => datain,
		 done_exe => done_exe,
		 start_to_crypto  => start_to_crypto,
		 src_read  => src_read,
		 dst_write => dst_write,
		 data_enb => data_enb,
		 key_enb => key_enb,
		 cmd_enb => cmd_enb,
		 sr_output_enb => sr_output_enb,
		 sr_output_load => sr_output_load
		 );
------------------------ Crypto Core ------------------------- 

crypto_core : aes_non_pipe	port map (	
						clock => clock,
						start => start_to_crypto,
						data_in => data_to_crypto,
						key_in  => key_to_crypto,
						data_out => data_from_crypto,
						trigger => trigger,
						done => done_exe
						);

-- data_from_crypto <= (key_to_crypto xor data_to_crypto) when start_to_crypto = '1' else (others => '0');
--done_exe <= '1' when start_to_crypto ='1' else '0';

	

end structure; 