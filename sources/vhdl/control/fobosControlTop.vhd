--##################################################################################
--#                                                                                #
--#	Copyright 2016 Cryptographic Engineering Research Group (CERG)               #
--#	George Mason University							                                   #	
--#   http://cryptography.gmu.edu/fobos                                            #                            
--#                                                   							        #                             	 
--#	Licensed under the Apache License, Version 2.0 (the "License");        	     #
--#	you may not use this file except in compliance with the License.       	     #
--#	You may obtain a copy of the License at                                	     #
--#	                                                                       	     #
--#	    http://www.apache.org/licenses/LICENSE-2.0                         	     #
--#	                                                                       	     #
--#	Unless required by applicable law or agreed to in writing, software    	     #
--#	distributed under the License is distributed on an "AS IS" BASIS,      	     #
--#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.     #
--#	See the License for the specific language governing permissions and          #
--#	limitations under the License.                                               #
--#                                                                           	  #
--##################################################################################


library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fobos_package.all;
use unisim.vcomponents.all;

entity fobosControlTop is 
port (
  clk : in std_logic;           -- system clock
  EppAstb: in std_logic;        -- Address strobe
  EppDstb: in std_logic;        -- Data strobe
  EppWrite  : in std_logic;        -- Port write signal
  --EppReset : in std_logic;        -- Port reset signal
  EppDB  : inout std_logic_vector(7 downto 0); -- port data bus
  EppWait: out std_logic;       -- Port wait signal
 -- displayLED : out std_logic_vector(7 downto 0);
  cergbanner : out std_logic_vector(11 downto 0);
  EXTClock : in std_logic;
  dutClockSelector: in std_logic;
  clkseltest : out std_logic;
  -- ADC PORTS
--  adc_clock : out std_logic;
--  amp_gain : out std_logic;
--  amp_hilo : out std_logic;
--  adc_data : in std_logic_vector(9 downto 0);
--  adc_or : in std_logic

   -- Oscilloscope Ports
	trigger : out std_logic;

	-- DUT Ports from DUT point of view, i.e. dataout is data from dut to control
	DUTClock: out std_logic;
	reset: out std_logic;
	src_ready: out std_logic;
	dst_ready: out std_logic;
	datain: out std_logic_vector(interfaceWidth-1 downto 0);
	src_read: in std_logic;
	dst_write: in std_logic;
	dataout: in std_logic_vector(interfaceWidth-1 downto 0)

);
end fobosControlTop;

architecture Behavioral of fobosControlTop is 
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
signal clktobram, targetModuleReset, resetdutCommunicationController : std_logic;
signal generatedClkFordut, dutClk : std_logic; 
signal dutDCMLocked : std_logic;
signal EndPCDataComm, encStart, encEnd, triggerCheck : std_logic;
signal dlEnb, dlRst, drRst, drEnb, klRst, klEnb : std_logic;
signal vdlEnb, vdlRst, vklEnb, vklRst, vrRst, vrEnb, cdlEnb, cklEnb, cklRst : std_logic;
signal dataToCtrlBrd : std_logic_vector(maxBlockSize-1 downto 0);
signal keyToCtrlBrd : std_logic_vector(maxKeySize-1 downto 0);
signal dataFromCtrlBrd : std_logic_vector(maxBlockSize-1 downto 0);
signal dataFromPc, dataToPc : std_logic_vector(7 downto 0);
-- signal src_read, src_ready, dst_ready, dst_write : std_logic;
-- signal datain, dataout, 
signal keyTextTodut, plainTextTodut : std_logic_vector(interfaceWidth-1 downto 0);
signal databusHandle : std_logic; -- data/key to dut selection line
------------------------------------------------------------------------
-- Data Registers Declarations
------------------------------------------------------------------------
signal dataReg0 : std_logic_vector(7 downto 0); -- address 00
signal dataReg1 : std_logic_vector(7 downto 0); -- address 01
signal bram_output : std_logic_vector(15 downto 0); -- address 10, 11
signal mainclockfrequency : std_logic_vector(31 downto 0); -- address 20,21,22,23
signal dutClockFrequency : std_logic_vector(31 downto 0); -- address 24,25,26,27
signal adcGain : std_logic_vector(7 downto 0); -- address 60
signal adcAmp : std_logic_vector(7 downto 0); -- address 61
signal plainTextForTarget : std_logic_vector(15 downto 0); -- address 73,74
signal secretKeyForTarget : std_logic_vector(15 downto 0); -- address 75,76
signal dataFromTarget : std_logic_vector(15 downto 0); -- address 71,72
signal commandToTargetControl, stateMachineLeds,stateMachineLedsTarget : std_logic_vector(7 downto 0); -- address 77
signal dataBlockSize : std_logic_vector(7 downto 0); -- address 78
signal keySize : std_logic_vector(7 downto 0); -- address 79
signal noOfTriggerWaitCycles, triggerLength : std_logic_vector( 31 downto 0); -- address 80,81,82,83,84,85,86,87
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
			dutClockFrequency(31 downto 24) when regEppAdrOut = x"24" else
		    dutClockFrequency(23 downto 16) when regEppAdrOut = x"25" else			 
			dutClockFrequency(15 downto 8)  when regEppAdrOut = x"26" else
		    dutClockFrequency(7 downto 0)   when regEppAdrOut = x"27" else			
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
			--dataFromTarget(15 downto 8) when regEppAdrOut = x"71" else
			--dataFromTarget(7 downto 0) when regEppAdrOut = x"72" else
			dataToPc when regEppAdrOut = x"71" else
			
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

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"7A" then
			dataFromPc <= hosttofpga_data;
		end if;
	end if;
end process;

------------------------------------------------------------------------
-- Trigger signal registers
------------------------------------------------------------------------


process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"80" then
			noOfTriggerWaitCycles(31 downto 24) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"81" then
			noOfTriggerWaitCycles(23 downto 16) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"82" then
			noOfTriggerWaitCycles(15 downto 8) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"83" then
			noOfTriggerWaitCycles(7 downto 0) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"84" then
			triggerLength(31 downto 24) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"85" then
			triggerLength(23 downto 16) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"86" then
			triggerLength(15 downto 8) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"87" then
			triggerLength(7 downto 0) <= hosttofpga_data;
		end if;
	end if;
end process;

------------------------------------------------------------------------
-- Control Signals
------------------------------------------------------------------------

system_reset <= '1' when controlReg = x"01" else '0';
frequency_counter_reset <= '1' when controlReg = x"02" else '0';
targetModuleReset <= '1' when controlReg = x"03" else '0';
dlRst <= '1' when controlReg = x"04" else '0';
drRst <= '1' when controlReg = x"05" else '0';
dlEnb <= '1' when controlReg = x"06" else '0';
drEnb <= '1' when controlReg = x"07" else '0';
klRst <= '1' when controlReg = x"08" else '0';
klEnb <= '1' when controlReg = x"09" else '0';

EndPCDataComm <= '1' when dataReg1 = x"FF" else '0';
resetdutCommunicationController <= '1' when dataReg1 = x"02" else '0';
--bram_extaddress_reset <= dataReg0(7);
--bram_extaddress_enable <= dataReg0(6);
--counter_adc_select <= dataReg0(5);
--bram_data_collect_start <= dataReg0(0);

------------------------------------------------------------------------
-- Control Signals
------------------------------------------------------------------------
statusReg(0) <= dutDCMLocked;
statusReg(1) <= '0';
statusReg(2) <= '0';
statusReg(3) <= '0';
statusReg(4) <= '0';
statusReg(5) <= '0';
statusReg(6) <= '0';
statusReg(7) <= '0';

------------------------------------------------------------------------
-- dut Clock Selector
------------------------------------------------------------------------
dutClockSelectingMux : BUFGMUX generic map (CLK_SEL_TYPE => "SYNC")
port map (
O => dutClk, -- 1-bit Clock MUX output
I0 => EXTClock, -- 1-bit Clock0 input
I1 => generatedClkFordut, -- 1-bit Clock1 input
S => dutClockSelector -- 1-bit Clock select input
);
-- E

clkseltest <= dutClockSelector;

------------------------------------------------------------------------
-- Frequency checkers
------------------------------------------------------------------------
mainclockFreqChecker : frequency_counter generic map (board => board) port map (refclk => clk,
sampleclk => clk, reset => frequency_counter_reset,
frequency_counter_out => mainclockfrequency);

dutclockFreqChecker : frequency_counter generic map (board => board) port map (refclk => clk,
sampleclk => dutClk, reset => frequency_counter_reset,
frequency_counter_out => dutClockFrequency);

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

------------------------------------------------------------------------
-- dut Clock Generation
------------------------------------------------------------------------
dutClockGeneration : dutDCM  generic map (board => board)
   port map ( clkin => clk,   rst => system_reset, clkout => generatedClkFordut,
          locked_out  => dutDCMLocked);
			 
------------------------------------------------------------------------
-- Trigger Generation for Oscilloscope
------------------------------------------------------------------------			 
triggerGen : trigger_module port map (clock => dutClk, reset => system_reset, startOfEncryption => encStart, 
triggerLength => triggerLength, noOfTriggerWaitCycles => noOfTriggerWaitCycles, trigger_out => triggerCheck); 

--------------------------------------------------------------------------
----- SHIFT REGISTERS FOR PC TO CONTROL BOARD AND CONTROL BOARD TO PC
--------------------------------------------------------------------------

--
pcToControlBoardDataShiftReg : shiftregDataFromPC generic map (dataSize => maxBlockSize) port map (clock => EppDstb, reset =>dlRst,
sr_e => dlEnb, sr_input => dataFromPc, sr_output => dataToCtrlBrd);
--
pcToControlBoardKeyShiftReg : shiftregDataFromPC generic map (dataSize => maxKeySize)port map (clock => EppDstb, reset =>klRst,
sr_e => klEnb, sr_input => dataFromPc, sr_output => keyToCtrlBrd);
--
controlBoardToPCShiftReg : shiftregDataToPC generic map (dataSize => maxBlockSize)port map (clock => EppDstb, load =>drRst,
sr_e => drEnb, sr_input => dataFromCtrlBrd, sr_output => dataToPc); 
--
--
------------------------------------------------------------------------
-------- SHIFT REGISTERS FOR CONTROL BOARD TO dut BOARD AND VICE-VERSA
----------------------------------------------------------------------------
--
--dataFromCtrlBrd <= dataToCtrlBrd xor keyToCtrlBrd;


ControldutCommunication: dutCommunicationHandler port map(
clock => dutClk, start => EndPCDataComm, reset => resetdutCommunicationController, targetClock => dutCLk, databusHandle => databusHandle, src_read  => src_read, dst_write => dst_write, vdlRst => vdlRst, vdlEnb => vdlEnb, vklRst => vklRst, vklEnb => vklEnb, vrRst => vrRst, vrEnb => vrEnb, src_ready => src_ready, dst_ready => dst_ready, stateMachineStatus => stateMachineLeds, encStart => encStart);
--
controlBoardTodutDataShiftreg : shiftregDataTodut generic map( interfaceSize => interfaceWidth,
		dataSize => maxBlockSize) port map (clock => dutClk, load =>vdlRst,
sr_e => vdlEnb, sr_input => dataToCtrlBrd, sr_output => plainTextTodut);
--
controlBoardTodutKeyShiftreg : shiftregDataTodut generic map( interfaceSize => interfaceWidth,
		dataSize => maxBlockSize) port map(clock => dutClk, load =>vklRst,
sr_e => vklEnb, sr_input => keyToCtrlBrd, sr_output => keyTextTodut);

datain <= plainTextTodut when databusHandle = '1' else keyTextTodut;
--
dutToControlBoardShiftReg : shiftregDataFromdut generic map( interfaceSize => interfaceWidth,
		dataSize => maxBlockSize) port map(clock => dutClk, reset =>vrRst,
sr_e => vrEnb, sr_input => dataout, sr_output => dataFromCtrlBrd);

--------------------------------------------------------------------------
----- FOR TESTING PURPOSE dut IS IMPLEMENTED HERE -- PLEASE DELETE IT
--------------------------------------------------------------------------

-- dutDeclaration : dutTopLevel port map( clock => dutClk, reset => not EndPCDataComm,
-- src_ready => src_ready, dst_ready => dst_ready, datain => dataout, 
-- src_read => src_read, dst_write => dst_write, dataout => datain, stateMachineStatus => stateMachineLedsTarget);



----------------------------------------------------------------------------
------- DISPLAY LEDs for Debugging
----------------------------------------------------------------------------
-- displayLED <= dataBlockSize when displayReg = x"01" else
--			  keySize when displayReg = x"02" else
--			  stateMachineLeds when displayReg = x"03" else
--			  plainTextForTarget(15 downto 8) when displayReg = x"04" else
--			  plainTextForTarget(7 downto 0) when displayReg = x"05" else
--			  "0000" & keyTextTodut(3 downto 0) when displayReg = x"06" else
--			  "0000" & plainTextTodut(3 downto 0) when displayReg = x"07" else
--			  "0000" & dataout(3 downto 0) when displayReg = x"08" else
--			  "0000" & datain(3 downto 0) when displayReg = x"09" else
--			  commandToTargetControl when displayReg = x"0A" else
--			  stateMachineLedsTarget when displayReg = x"0B" else
--			  "0000000" & EndPCDataComm when displayReg = x"0C" else
--			  displayReg;

trigger <= triggerCheck;			  
DUTClock <= not dutClk;
reset <= not EndPCDataComm;

end Behavioral;

