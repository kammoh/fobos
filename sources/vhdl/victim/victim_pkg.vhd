library ieee;
use ieee.std_logic_1164.all;

package victim_pkg is

------------------------------------------------------------------------
-- USER CONTROLLED VAIRABLES
------------------------------------------------------------------------
constant interfaceWidth : integer := 4;
constant maxBlockSize : integer := 128;
constant maxKeySize : integer := 128;


component reg is
port (   a     : IN  std_logic_vector(15 downto 0);
         clk   : IN  std_logic;
         reset : IN  std_logic;
         en    : IN  std_logic;                         -- enable '1', idle '0'
         b     : OUT std_logic_vector(15 downto 0));
end component;

component victimController is 
	port(
	     clock: in std_logic;
		 reset: in std_logic;
		 src_ready : in std_logic;
		 dst_ready : in std_logic;
		 done_exe : in std_logic;
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

component shiftregDataToControl IS
generic( interfaceSize : integer := 4;
		dataSize: integer:= 128);
port
(
clock: in std_logic;
load: in std_logic; 
sr_e : in std_logic;
sr_input : in std_logic_vector (dataSize-1 downto 0);
sr_output: out std_logic_vector (interfaceSize-1 downto 0)

) ;
end component;

component shiftregDataFromControl IS
generic( interfaceSize : integer := 4;
		dataSize: integer:= 128);
port
(
clock: in std_logic;
reset: in std_logic;
sr_e : in std_logic;
sr_input : in std_logic_vector (interfaceSize-1 downto 0);
sr_output: out std_logic_vector (dataSize-1 downto 0)

) ;
end component;

	
component integerCounter is  
	 port(
		 clock : in STD_LOGIC;
		 reset : in STD_LOGIC;	
		 load : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 q : out integer range 0 to (maxBlockSize/interfaceWidth)
	     );
end component;

end victim_pkg;