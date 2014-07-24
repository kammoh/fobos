library ieee;
use ieee.std_logic_1164.all;

package victim_pkg is

component reg is
port (   a     : IN  std_logic_vector(15 downto 0);
         clk   : IN  std_logic;
         reset : IN  std_logic;
         en    : IN  std_logic;                         -- enable '1', idle '0'
         b     : OUT std_logic_vector(15 downto 0));
end component;

component victim_contrl is 
	port(
	     clock: in std_logic;
		 reset: in std_logic;
		 src_ready : in std_logic;
		 dst_ready : in std_logic;	 
		 done_exe : in std_logic;
		 cmd_buffer : in std_logic_vector( 15 downto 0);
		 start_to_crypto : out std_logic;
		 src_read  : out std_logic;
		 dst_write : out std_logic;
		 data_enb : out std_logic;
		 key_enb : out std_logic;
		 cmd_enb : out std_logic;
		 sr_output_enb : out std_logic;
		 sr_output_load : out std_logic
		 );
end component;

	component shiftreg_16x128 is
		port(
			clock: in std_logic;
			reset: in std_logic;
			sr_e : in std_logic;
			sr_input : in std_logic_vector (15 downto 0);
			sr_output: out std_logic_vector (127 downto 0)) ;
	end component;
	
	component shiftreg_128x16 IS
		port(
			clock: in std_logic;
			reset: in std_logic; 
			sr_l : in std_logic;
			sr_e : in std_logic;
			sr_input : in std_logic_vector (127 downto 0);
			sr_output: out std_logic_vector (15 downto 0)) ;
	end component;

	
component counter is  
	generic (N : integer := 4);
	 port(
		 clock : in STD_LOGIC;
		 reset : in STD_LOGIC;	
		 load : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 data_in : in STD_LOGIC_VECTOR(N downto 1);
		 q : out STD_LOGIC_VECTOR(N-1 downto 0)
	     );
end component;
   
	component aes_non_pipe is
	port (	
			clock : in std_logic ;
			start : in std_logic ;
			data_in : in std_logic_vector (0 to 127);
			key_in : in std_logic_vector (0 to 127);
			data_out : out std_logic_vector (0 to 127);	
			trigger : out std_logic	;
			done : out std_logic
			);


	end component;


end victim_pkg;