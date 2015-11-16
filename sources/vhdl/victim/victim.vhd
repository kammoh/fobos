library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fobos_package.all;

entity victimTopLevel is 
	port(
	     clock: in std_logic;
		 reset: in std_logic;
		 src_ready : in STD_LOGIC;
		 dst_ready : in STD_LOGIC;
		 datain : in std_logic_vector(interfaceWidth-1 downto 0);
		 src_read  : out STD_LOGIC;
		 dst_write : out STD_LOGIC;
		 --stateMachineStatus: out std_logic_vector(7 downto 0); -- used for debog purpose only
		 dataout : out std_logic_vector(interfaceWidth-1 downto 0)

		 );
end victimTopLevel;

architecture structure of victimTopLevel is
signal data_enb : std_logic; -- from victim_contrl
signal key_enb : std_logic;	 -- from victim_contrl
signal cmd_enb : std_logic;	
signal done_exe : std_logic;
signal sr_output_enb : std_logic; -- from victim_contrl
signal sr_output_load : std_logic;-- from victim_contrl
signal start_to_crypto : std_logic; -- to crypto_core
signal cmd_buffer : std_logic_vector(interfaceWidth-1 downto 0);
signal data_to_crypto : std_logic_vector(maxBlockSize-1 downto 0); -- to crypto_core
signal key_to_crypto : std_logic_vector(maxKeySize-1 downto 0);	-- to crypto_core
signal data_from_crypto : std_logic_vector(maxBlockSize-1 downto 0); -- from crypto_core
signal stateMachineStatus : std_logic_vector(7 downto 0);
begin

 ------------------------ Input Shift-Registers-------------------------
 plainText : shiftregDataFromControl generic map (interfaceSize => interfaceWidth, dataSize => maxBlockSize ) 
			port map (
 			clock => clock,
			reset => reset,
			sr_e  => data_enb ,
			sr_input => datain,
			sr_output => data_to_crypto) ;

 key : shiftregDataFromControl generic map (interfaceSize => interfaceWidth, dataSize => maxKeySize ) 
			port map (
 			clock => clock,
			reset => reset,
			sr_e  => key_enb ,
			sr_input => datain,
			sr_output => key_to_crypto) ;
------------------------ Output Shift-Registers-------------------------			
 output  : shiftregDataToControl  generic map (interfaceSize => interfaceWidth, dataSize => maxBlockSize ) 
			port map (
			clock => clock,
			load => sr_output_load, 
			sr_e  => sr_output_enb,
			sr_input => data_from_crypto,
			sr_output => dataout) ;
------------------------ Victim outer-level Controller-------------------		
control: victimController port map(
	     clock => clock,
		 reset => reset,
		 src_ready => src_ready,
		 dst_ready => dst_ready,
		 done_exe => done_exe,
		 start_to_crypto  => start_to_crypto,
		 src_read  => src_read,
		 dst_write => dst_write,
		 data_enb => data_enb,
		 key_enb => key_enb,
		 cmd_enb => cmd_enb,
		 stateMachineStatus => stateMachineStatus,
		 sr_output_enb => sr_output_enb,
		 sr_output_load => sr_output_load
		 );
------------------------ Crypto Core ------------------------- 

-------------------------------------------------------------------------------------------------------
-----------------  DUMMY VICTIM -----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------
--data_from_crypto <= (data_to_crypto xor key_to_crypto) when start_to_crypto = '1' else (others => '0');
--done_exe <= '1' when start_to_crypto ='1' else '0';

-------------------------------------------------------------------------------------------------------
-----------------  AES 128 -----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------


victimAES : aes_non_pipe port map (	
			clock => clock,
			start =>  not start_to_crypto, -- active low
			data_in => data_to_crypto,
			key_in => key_to_crypto,
			data_out => data_from_crypto,	
			done => done_exe
			);



	

end structure; 