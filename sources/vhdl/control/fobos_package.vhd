library ieee;
use ieee.std_logic_1164.all;

package fobos_package is

------------------------------------------------------------------------
-- USER CONTROLLED VAIRABLES
------------------------------------------------------------------------
constant board : integer := 1;
constant interfaceWidth : integer := 16;
constant maxBlockSize : integer := 128;
constant maxKeySize : integer := 128;
------------------------------------------------------------------------
-- Different Control Board Versions
------------------------------------------------------------------------

constant NEXYS2 : integer := 1;
constant NEXYS3 : integer := 2;

constant NEXYS2_7SEGRR : integer := 14;
constant NEXYS3_7SEGRR : integer := 19;

------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
component cerg_display is
generic (N : integer := 19);
port (
    clk : in std_logic;
    cergbanner_segment : out std_logic_vector(11 downto 0)
);
end component;

component frequency_counter is
generic (board : integer := NEXYS2);
port (
refclk : in std_logic;
sampleclk : in std_logic;
reset : in std_logic;
frequency_counter_out : out std_logic_vector(31 downto 0));
end component;

component errorCodes is
port (
		victimDCMLocked : in std_logic;
		dataReadyToPickup : in std_logic;
		statusCode : out std_logic_vector(7 downto 0));

end component;


component EppCtrl is
    Port (

-- Epp-like bus signals
      clk    : in std_logic;        -- system clock (50MHz)
      EppAstb: in std_logic;        -- Address strobe
      EppDstb: in std_logic;        -- Data strobe
      EppWr  : in std_logic;        -- Port write signal
      EppRst : in std_logic;        -- Port reset signal
      EppDB  : inout std_logic_vector(7 downto 0); -- port data bus
      EppWait: out std_logic;       -- Port wait signal
-- User signals
      busEppOut: out std_logic_vector(7 downto 0); -- Data Output bus
      busEppIn: in std_logic_vector(7 downto 0);   -- Data Input bus
      ctlEppDwrOut: out std_logic;         -- Data Write pulse
      ctlEppRdCycleOut: inout std_logic;   -- Indicates a READ Epp cycle
      regEppAdrOut: inout std_logic_vector(7 downto 0) := "00000000"; 
                                         -- Epp Address Register content
      HandShakeReqIn: in std_logic;      -- User Handshake Request
      ctlEppStartOut: out std_logic;     -- Automatic process Start   
      ctlEppDoneIn: in std_logic         -- Automatic process Done 
         );
end component;

component counter is
	generic ( 
	    N : integer := 32
	);
	port ( 	  
		clk : in std_logic;
		reset : in std_logic;
--	   load : in std_logic;
	   enable : in std_logic; 
--		input  : in std_logic_vector(N-1 downto 0);
      counter_out : out std_logic_vector(N-1 downto 0)
	);
end component;

component bram_adc_store is
    Port (clock : in std_logic;
		  addr : in std_logic_vector(14 downto 0);
		  wen : in std_logic;
		  en : in std_logic;
		  din : in std_logic_vector(15 downto 0);
		  dout : out std_logic_vector(15 downto 0));
end component;

component dataCommunication is 
	port(
		 clock: in std_logic;
		 reset: in std_logic; 
		 bramaddress_clock : in std_logic;
		 targetClock : in std_logic;
		 controlCommand : in std_logic_vector(7 downto 0);
		 pc_datain_data : in std_logic_vector(15 downto 0);
		 pc_datain_key  : in std_logic_vector(15 downto 0);
		 block_size : in std_logic_vector(7 downto 0);
		 key_size : in std_logic_vector(7 downto 0); 
		 stateMachineLeds : out std_logic_vector(7 downto 0);
		 stateMachineLedsTarget : out std_logic_vector(7 downto 0);
		 pc_dataout_ct : out std_logic_vector(15 downto 0));
end component;

component DCM_ADC is
generic (board : integer := NEXYS2); 
   port ( clkin        : in    std_logic;  
          rst         : in    std_logic;
          clkout : out   std_logic; 
			 clktobramN2 : out std_logic;
          locked_out      : out   std_logic);
end component;

component victimDCM is
generic (board : integer := NEXYS2); 
   port ( clkin        : in    std_logic;  
          rst         : in    std_logic;
          clkout : out   std_logic; 
          locked_out      : out   std_logic);
end component;

component trigger_module is
port (
		clock : in std_logic;
		reset : in std_logic;
		startOfEncryption : in std_logic;
		triggerLength : in std_logic_vector(31 downto 0);
		noOfTriggerWaitCycles : in std_logic_vector(31 downto 0);
		trigger_out : out std_logic);

end component;

component shiftregDataFromPC IS
generic (dataSize : integer := 128);
port
(
clock: in std_logic;
reset: in std_logic;
sr_e : in std_logic;
sr_input : in std_logic_vector (7 downto 0);
sr_output: out std_logic_vector (dataSize-1 downto 0)

) ;
end component;

component shiftregDataToPC IS
generic (dataSize: integer := 128);
port
(
clock: in std_logic;
load: in std_logic; 
sr_e : in std_logic;
sr_input : in std_logic_vector (dataSize-1 downto 0);
sr_output: out std_logic_vector (7 downto 0)

) ;
end component;

component shiftregDataToVictim IS
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

component shiftregDataFromVictim IS
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

component victimCommunicationHandler is 
	port(
	     clock: in std_logic;
		 start : in std_logic;
		 reset: in std_logic;	 
		 targetClock : in std_logic;
		 src_read  : in std_logic;
		 dst_write : in std_logic;
		 databusHandle : out std_logic; -- data/key to victim selection line		 
		 vdlRst : out std_logic; -- Victim TO Data load 
		 vdlEnb : out std_logic; -- Victim TO Data enable
		 vklRst : out std_logic; -- Victim TO Key load
		 vklEnb : out std_logic; -- Victim TO Key load		 
		 vrRst : out std_logic; -- Victim FROM data load
		 vrEnb : out std_logic; -- Victim FROM data enable
		 stateMachineStatus: out std_logic_vector(7 downto 0); -- For debug purpose		 
		 src_ready : out std_logic;
		 dst_ready : out std_logic;
                 encStart : out std_logic		 
		 );
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


----------------------------------------------
---------------VICTIM TOP LEVEL---------------
----------------------------------------------
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
		 stateMachineStatus: out std_logic_vector (7 downto 0);		 
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

component victimTopLevel is 
	port(
	     clock: in std_logic;
		 reset: in std_logic;
		 src_ready : in STD_LOGIC;
		 dst_ready : in STD_LOGIC;
		 datain : in std_logic_vector(interfaceWidth-1 downto 0);
		 src_read  : out STD_LOGIC;
		 dst_write : out STD_LOGIC;
		 stateMachineStatus: out std_logic_vector (7 downto 0);		 
		 dataout : out std_logic_vector(interfaceWidth-1 downto 0)

		 );
end component;
------------------------------------------------------------------
------- FOLLOWING AES INSTANTIATION NEEDS TO BE DELETED ----------
------------------------------------------------------------------

component aes_non_pipe is
	port (	
			clock : in std_logic ;
			start : in std_logic ;
			data_in : in std_logic_vector (0 to 127);
			key_in : in std_logic_vector (0 to 127);
			data_out : out std_logic_vector (0 to 127);	
			--trigger : out std_logic	;
			done : out std_logic
			);

end component;
end fobos_package;
