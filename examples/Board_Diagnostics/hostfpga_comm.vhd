library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity hostfpga_comm is 
port (
  clk : in std_logic;           -- system clock
  EppAstb: in std_logic;        -- Address strobe
  EppDstb: in std_logic;        -- Data strobe
  EppWrite  : in std_logic;        -- Port write signal
  --EppReset : in std_logic;        -- Port reset signal
  EppDB  : inout std_logic_vector(7 downto 0); -- port data bus
  EppWait: out std_logic;       -- Port wait signal
  displayLED : out std_logic_vector(7 downto 0);
  cergbanner : out std_logic_vector(11 downto 0)
);
end hostfpga_comm;

architecture Behavioral of hostfpga_comm is 

------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
component cerg_display is 
port (
    clk : in std_logic;
    cergbanner_segment : out std_logic_vector(11 downto 0)
);
end component;

component frequency_counter is
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
------------------------------------------------------------------------
-- Constant and Signal Declarations
------------------------------------------------------------------------
signal hosttofpga_data : std_logic_vector(7 downto 0);
signal fpgatohost_data : std_logic_vector(7 downto 0);
signal register_data   : std_logic_vector(7 downto 0);
signal regEppAdrOut : std_logic_vector(7 downto 0);
constant  inactive : std_logic := '0';
constant active : std_logic := '1';
signal ctlEppDwrOut, ctlEppRdCycleOut, ctlEppStartOut : std_logic;
signal ctlEppDoneIn : std_logic;
signal int_addressGen_BRAM, bram_address, addressGen_BRAM : std_logic_vector(15 downto 0);
signal z20k, int_addressGen_BRAM_enable, bram_extaddress_reset, bram_extaddress_enable: std_logic; 
signal system_reset, frequency_counter_reset : std_logic;
signal datatoBRAM  : std_logic_vector(15 downto 0);
------------------------------------------------------------------------
-- Data Registers Declarations
------------------------------------------------------------------------
signal dataReg0 : std_logic_vector(7 downto 0); -- address 00
signal dataReg1 : std_logic_vector(7 downto 0); -- address 01
signal bram_output : std_logic_vector(15 downto 0); -- address 10, 11
signal mainclockfrequency : std_logic_vector(31 downto 0); -- address 20,21,22,23

------------------------------------------------------------------------
-- Display (LED) Registers Declarations
------------------------------------------------------------------------
signal displayReg : std_logic_vector(7 downto 0); -- address 40
------------------------------------------------------------------------
-- Control & Status Registers
------------------------------------------------------------------------
signal controlReg : std_logic_vector(7 downto 0); -- address 30
signal statusReg : std_logic_vector(7 downto 0);  -- address 31
constant programOK : std_logic_vector(7 downto 0) := x"4B"; --address 50
begin
------------------------------------------------------------------------
-- CERG Banner Display
------------------------------------------------------------------------
banner_dis: cerg_display port map (
			clk => clk,
			cergbanner_segment => cergbanner);

------------------------------------------------------------------------
-- USB Controller
------------------------------------------------------------------------			
EPP_Controller : EppCtrl port map (
		  clk => clk,
		  EppAstb => EppAstb,
		  EppDstb => EppDstb,
		  EppWr => EppWrite,
		  EppRst => active,
		  EppDB => EppDB,
		  EppWait => EppWait,
		  busEppOut => hosttofpga_data,
		  busEppIn => fpgatohost_data,
		  regEppAdrOut => regEppAdrOut,
		  ctlEppDwrOut => ctlEppDwrOut,
		  ctlEppRdCycleOut => ctlEppRdCycleOut,
		  HandShakeReqIn => inactive,
		  ctlEppStartOut => ctlEppStartOut,
		  ctlEppDoneIn => ctlEppDoneIn
		  );
		  
------------------------------------------------------------------------
-- fpga to host data output mux
------------------------------------------------------------------------
fpgatohost_data <=  dataReg0 when regEppAdrOut = x"00" else
		    dataReg1 when regEppAdrOut = x"01" else
		    ---------------------------------------
		    bram_output(15 downto 8) when regEppAdrOut = x"10" else
		    bram_output(7 downto 0) when regEppAdrOut = x"11" else
		    ---------------------------------------
			 mainclockfrequency(31 downto 24) when regEppAdrOut = x"20" else
		    mainclockfrequency(23 downto 16) when regEppAdrOut = x"21" else			 
			 mainclockfrequency(15 downto 8)  when regEppAdrOut = x"22" else
		    mainclockfrequency(7 downto 0)   when regEppAdrOut = x"23" else
		    ---------------------------------------
		    controlReg when regEppAdrOut = x"30" else
		    statusReg  when regEppAdrOut = x"31" else
		    ----------------------------------------
		    displayReg when regEppAdrOut = x"40" else
		    ----------------------------------------
		    programOK  when regEppAdrOut = x"50" else
		    x"00";
	
------------------------------------------------------------------------
-- Data Registers
------------------------------------------------------------------------
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"00" then
			dataReg0 <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"01" then
			dataReg1 <= hosttofpga_data;
		end if;
	end if;
end process;
------------------------------------------------------------------------
-- Control and Status Register
------------------------------------------------------------------------
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"30" then
			controlReg <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"31" then
			statusReg <= hosttofpga_data;
		end if;
	end if;
end process;
------------------------------------------------------------------------
-- Display (LED) Register
------------------------------------------------------------------------
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"40" then
			displayReg <= hosttofpga_data;
		end if;
	end if;
end process;
displayLED <= displayReg;

------------------------------------------------------------------------
-- Control Signals
------------------------------------------------------------------------
system_reset <= controlReg(0);
frequency_counter_reset <= controlReg(1);
bram_extaddress_reset <= dataReg0(7);
bram_extaddress_enable <= dataReg0(6);
------------------------------------------------------------------------
-- Frequency checkers
------------------------------------------------------------------------
mainclock : frequency_counter port map (refclk => clk,
sampleclk => clk, reset => frequency_counter_reset,
frequency_counter_out => mainclockfrequency);


------------------------------------------------------------------------
-- BRAM Declarations and Address counters
------------------------------------------------------------------------
Internal_BRAM_Address_Generator : counter generic map (N => 16) port map(
clk => clk, reset => system_reset, enable => int_addressGen_BRAM_enable,
counter_out => int_addressGen_BRAM);

z20k <= '1' when int_addressGen_BRAM >= "000100111000100000" else '0';
int_addressGen_BRAM_enable <= '1' when z20k = '0' else '0';

External_BRAM_Address_Generator : counter generic map (N => 16) port map(
clk=> EppDstb, reset =>bram_extaddress_reset, enable => bram_extaddress_enable, counter_out => addressGen_BRAM);

bram_address <= int_addressGen_BRAM when bram_extaddress_enable = '0' else
addressGen_BRAM;

datatoBRAM <= "000000" & int_addressGen_BRAM(9 downto 0);
bram_data_store : bram_adc_store port map
(clock => clk, addr  => bram_address(14 downto 0), wen   => int_addressGen_BRAM_enable,
en => active, din   => datatoBRAM, dout  => bram_output);

end Behavioral;

