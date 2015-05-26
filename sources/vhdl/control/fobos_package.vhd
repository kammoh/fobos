library ieee;
use ieee.std_logic_1164.all;

package fobos_package is

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

component shiftreg_8x128 IS
port
(
clock: in std_logic;
reset: in std_logic;
sr_e : in std_logic;
sr_input : in std_logic_vector (7 downto 0);
sr_output: out std_logic_vector (127 downto 0)

) ;
end component;

component shiftreg_128x8 IS
port
(
clock: in std_logic;
reset: in std_logic; 
sr_e : in std_logic;
sr_input : in std_logic_vector (127 downto 0);
sr_output: out std_logic_vector (7 downto 0)

) ;
end component;

component shiftreg_128x16 IS
port
(
clock: in std_logic;
reset: in std_logic; 
sr_e : in std_logic;
sr_input : in std_logic_vector (127 downto 0);
sr_output: out std_logic_vector (15 downto 0)

) ;

end component;

component shiftreg_16x128 IS
port
(
clock: in std_logic;
reset: in std_logic;
sr_e : in std_logic;
sr_input : in std_logic_vector (15 downto 0);
sr_output: out std_logic_vector (127 downto 0)

) ;

end component;

end fobos_package;