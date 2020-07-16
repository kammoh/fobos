library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fobos_package.all;

entity hostfpga_comm is 
generic (board : integer := NEXYS2);
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
  -- ADC PORTS
--  adc_clock : out std_logic;
--  amp_gain : out std_logic;
--  amp_hilo : out std_logic;
--  adc_data : in std_logic_vector(9 downto 0);
--  adc_or : in std_logic
);
end hostfpga_comm;

architecture Behavioral of hostfpga_comm is 
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
signal pwmAccumulator : std_logic_vector(8 downto 0);
signal dataFromAdc : std_logic_vector(15 downto 0);
signal counter_adc_select, bram_data_collect_start : std_logic;
signal ADC_DCM_OK : std_logic;
signal clktobram, targetModuleReset : std_logic;
------------------------------------------------------------------------
-- Data Registers Declarations
------------------------------------------------------------------------
signal dataReg0 : std_logic_vector(7 downto 0); -- address 00
signal dataReg1 : std_logic_vector(7 downto 0); -- address 01
signal bram_output : std_logic_vector(15 downto 0); -- address 10, 11
signal mainclockfrequency : std_logic_vector(31 downto 0); -- address 20,21,22,23
signal adcGain : std_logic_vector(7 downto 0); -- address 60
signal adcAmp : std_logic_vector(7 downto 0); -- address 61
signal plainTextForTarget : std_logic_vector(15 downto 0); -- address 73,74
signal secretKeyForTarget : std_logic_vector(15 downto 0); -- address 75,76
signal dataFromTarget : std_logic_vector(15 downto 0); -- address 71,72
signal commandToTargetControl, stateMachineLeds,stateMachineLedsTarget : std_logic_vector(7 downto 0); -- address 77
signal dataBlockSize : std_logic_vector(7 downto 0); -- address 78
signal keySize : std_logic_vector(7 downto 0); -- address 79
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

sevensegdisplayN2_gen : if (board = NEXYS2) generate
display: cerg_display 
generic map (N => NEXYS2_7SEGRR)
port map (clk => clk, cergbanner_segment => cergbanner);
end generate;

sevensegdisplayN3_gen : if (board = NEXYS3) generate
display: cerg_display 
generic map (N => NEXYS3_7SEGRR)
port map (clk => clk, cergbanner_segment => cergbanner);
end generate;

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
			----------------------------------------
			adcGain when regEppAdrOut = x"60" else
			adcAmp when regEppAdrOut = x"61" else
			----------------------------------------
			dataFromTarget(15 downto 8) when regEppAdrOut = x"71" else
			dataFromTarget(7 downto 0) when regEppAdrOut = x"72" else
			----------------------------------------
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

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"60" then
			adcGain <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"61" then
			adcAmp <= hosttofpga_data;
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
--displayLED <= displayReg;

------------------------------------------------------------------------
-- Target Registers
------------------------------------------------------------------------

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"73" then
			plainTextForTarget(15 downto 8) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"74" then
			plainTextForTarget(7 downto 0) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"75" then
			secretKeyForTarget(15 downto 8) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"76" then
			secretKeyForTarget(7 downto 0) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"77" then
			commandToTargetControl <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"78" then
			dataBlockSize <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"79" then
			keySize <= hosttofpga_data;
		end if;
	end if;
end process;
------------------------------------------------------------------------
-- Control Signals
------------------------------------------------------------------------
--system_reset <= controlReg(0);
--frequency_counter_reset <= controlReg(1);
system_reset <= '1' when controlReg = x"01" else '0';
frequency_counter_reset <= '1' when controlReg = x"02" else '0';
targetModuleReset <= '1' when controlReg = x"03" else '0';
bram_extaddress_reset <= dataReg0(7);
bram_extaddress_enable <= dataReg0(6);
counter_adc_select <= dataReg0(5);
bram_data_collect_start <= dataReg0(0);
------------------------------------------------------------------------
-- Control Signals
------------------------------------------------------------------------
statusReg(0) <= ADC_DCM_OK;
statusReg(1) <= '0';
statusReg(2) <= '0';
statusReg(3) <= '0';
statusReg(4) <= '0';
statusReg(5) <= '0';
statusReg(6) <= '0';
statusReg(7) <= '0';
------------------------------------------------------------------------
-- Frequency checkers
------------------------------------------------------------------------
mainclock : frequency_counter port map (refclk => clk,
sampleclk => clk, reset => frequency_counter_reset,
frequency_counter_out => mainclockfrequency);

------------------------------------------------------------------------
-- ADC Ports In/Out
------------------------------------------------------------------------
-- ADC Clock

--ADC_ClockGen : DCM_ADC generic map (board => board) 
--port map ( clkin => clk, rst => system_reset, clktobramN2 => clktobram,
--clkout => adc_clock, locked_out => ADC_DCM_OK);
--------------------------------------------------------------------------
----ADC Gain
--process (clk, adcGain)
--	begin
--		if clk = '1' and clk'Event then
--			pwmAccumulator <= ("0" & pwmAccumulator(7 downto 0))
--									 + ("0" & adcGain);
--		end if;
--end process;
--amp_gain <= pwmAccumulator(8);
--------------------------------------------------------------------------
---- ADC Amplifier Hi/Lo
--amp_hilo <= adcAmp(0);
--------------------------------------------------------------------------
----ADC data in 10-bit + adc_or(1-bit)+"00000"
--dataFromAdc <= "00000" & adc_or & adc_data;
--------------------------------------------------------------------------
---- BRAM Declarations and Address counters
--------------------------------------------------------------------------
--Internal_BRAM_Address_Generator : counter generic map (N => 16) port map(
--clk => clktobram, reset => bram_data_collect_start, enable => int_addressGen_BRAM_enable,
--counter_out => int_addressGen_BRAM);
--
--bram_data_store : bram_adc_store port map
--(clock => clktobram, addr  => bram_address(14 downto 0), wen   => int_addressGen_BRAM_enable,
--en => active, din   => datatoBRAM, dout  => bram_output);
--
--
--z20k <= '1' when int_addressGen_BRAM >= "000100111000100000" else '0';
--int_addressGen_BRAM_enable <= '1' when z20k = '0' else '0';
--
--External_BRAM_Address_Generator : counter generic map (N => 16) port map(
--clk=> EppDstb, reset =>bram_extaddress_reset, enable => bram_extaddress_enable, counter_out => addressGen_BRAM);
--
--bram_address <= int_addressGen_BRAM when bram_extaddress_enable = '0' else
--addressGen_BRAM;
--
--datatoBRAM <= "000000" & int_addressGen_BRAM(9 downto 0) when counter_adc_select = '0' else dataFromAdc;
------------------------------------------------------------------------
-- Target
------------------------------------------------------------------------
target : dataCommunication port map(
		 clock => clk,
		 reset => targetModuleReset,
		 bramaddress_clock => EppDstb,
		 targetClock => clk,
		 controlCommand => commandToTargetControl,
		 pc_datain_data => plainTextForTarget,
		 pc_datain_key => secretKeyForTarget,
		 block_size => dataBlockSize,
		 key_size => keySize,
		 stateMachineLeds => stateMachineLeds,
		 stateMachineLedsTarget => stateMachineLedsTarget,
		 pc_dataout_ct => dataFromTarget);
		 
displayLED <= dataBlockSize when displayReg = x"01" else
						  keySize when displayReg = x"02" else
			  stateMachineLeds when displayReg = x"03" else
			  plainTextForTarget(15 downto 8) when displayReg = x"04" else
			  plainTextForTarget(7 downto 0) when displayReg = x"05" else
			  secretKeyForTarget(15 downto 8) when displayReg = x"06" else
			  secretKeyForTarget(7 downto 0) when displayReg = x"07" else
			  dataFromTarget(15 downto 8) when displayReg = x"08" else
			  dataFromTarget(7 downto 0) when displayReg = x"09" else
			  commandToTargetControl when displayReg = x"0A" else
			  stateMachineLedsTarget when displayReg = x"0B" else
				displayReg;
end Behavioral;

