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
   clk : in std_logic;  
   EppAstb: in std_logic;        -- Address strobe
   EppDstb: in std_logic;        -- Data strobe
   EppWrite  : in std_logic;        -- Port write signal
   EppDB  : inout std_logic_vector(7 downto 0); -- port data bus
   EppWait: out std_logic;       -- Port wait signal  
   seven_seg : out std_logic_vector(11 downto 0);
   EXTClock : in std_logic;
   dutClockSelector: in std_logic;
   clkseltest : out std_logic;
   -- Oscilloscope Ports
   trigger : out std_logic;
   --long_trigger : out std_logic;
	-- DUT Ports from DUT point of view, i.e. dataout is data from dut to control
	DUTClock: out std_logic; 
	reset: out std_logic;
	di_valid: out std_logic;
	do_ready: out std_logic;
	din: out std_logic_vector(interfaceWidth-1 downto 0); 
	di_ready: in std_logic;
	do_valid: in std_logic;
	dout: in std_logic_vector(interfaceWidth-1 downto 0)
);
end fobosControlTop;

architecture Behavioral of fobosControlTop is 

signal hosttofpga_data : std_logic_vector(7 downto 0);
signal regEppAdrOut : std_logic_vector(7 downto 0);
signal ctlEppDwrOut : std_logic;
signal fpgatohost_data : std_logic_vector(7 downto 0);
signal register_data   : std_logic_vector(7 downto 0);
constant  inactive : std_logic := '0';
constant active : std_logic := '1';
signal  ctlEppRdCycleOut, ctlEppStartOut : std_logic;
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
signal vdlEnb, vdlRst, vklEnb, vklRst, vrRst, vrEnb, cdlEnb, cklEnb, cklRst: std_logic;
signal dataToCtrlBrd : std_logic_vector(7 downto 0); --fixed
signal dataFromCtrlBrd : std_logic_vector(7 downto 0); --fixed
signal dataFromPc, dataToPc : std_logic_vector(7 downto 0);
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
signal noOfTriggerWaitCycles, triggerLength : std_logic_vector( 31 downto 0); -- address 80,81,82,83,84,85,86,87\
signal triggerMode : std_logic_vector(7 downto 0);
signal dutWorking : std_logic;
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

signal display_data : std_logic_vector(15 downto 0); 

signal push_to_dut_int, pop_from_dut_int : std_logic;
signal state_debug : std_logic_vector(7 downto 0);
------------
signal d_write_pointer : std_logic_vector(10 downto 0);
signal read_reg,strobe_reg,rst_dut_reg,rst_dutComm_reg ,sys_rst_reg ,
		pc_comm_done_reg: std_logic_vector(7 downto 0); -- address 88 for debug only
signal dut_done : std_logic;
--debug
signal debug_ram, debug_dout_ram, debug_addr :	STD_LOGIC_VECTOR(7 downto 0);

begin
------------------------------------------------------------------------
-- CERG Banner Display
------------------------------------------------------------------------
--sevensegdisplayN2_gen : if (board = NEXYS2) generate
--display: cerg_display 
--generic map (N => NEXYS2_7SEGRR)
--port map (clk => clk, cergbanner_segment => cergbanner);
--end generate;
--
--sevensegdisplayN3_gen : if (board = NEXYS3) generate
--display: cerg_display 
--generic map (N => NEXYS3_7SEGRR)
--port map (clk => clk, cergbanner_segment => cergbanner);
--end generate;

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

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"89" then
			triggerMode(7 downto 0) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"AA" then
			sys_rst_reg <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"BB" then
			rst_dutComm_reg <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"CC" then
			rst_dut_reg <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"DD" then
			pc_comm_done_reg <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"EE" then
			debug_addr <= hosttofpga_data;
		end if;
	end if;
end process;


------------------------------------------------------------------------
-- Control Signals
------------------------------------------------------------------------

system_reset <= '1' when sys_rst_reg = x"FF" else '0';
frequency_counter_reset <= '1' when controlReg = x"02" else '0';
dlEnb <= '1' when controlReg = x"06" else '0';
push_to_dut_int <= '1' when regEppAdrOut = x"7A" and ctlEppDwrOut = '1' else '0'; 
pop_from_dut_int <= '1' when regEppAdrOut = x"71"  else '0'; 
EndPCDataComm <= '1' when pc_comm_done_reg = x"FF" else '0';
resetdutCommunicationController <= '1' when rst_dutComm_reg = x"FF" else '0';
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
clkseltest <= push_to_dut_int;
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
-- dut Clock Generation
------------------------------------------------------------------------
dutClockGeneration : dutDCM  generic map (board => board)
   port map ( clkin => clk,   rst => system_reset, clkout => generatedClkFordut,
          locked_out  => dutDCMLocked);
			 
dataToPC <= dataFromCtrlBrd;
--------DUT Interface
dutInterface_4bit :  entity work.dutInterface_4bit(struct) 
	Port map( 
	        wr => push_to_dut_int, --push to dut interface
           rd => pop_from_dut_int,
           rst => resetdutCommunicationController,
			  sys_clk => clk, --EppDstb,--clk,
           dut_clk =>   DUTClk ,
			  snd_to_dut => EndPCDataComm,
			  done => dut_done,
           di_valid => di_valid,
           di_ready => di_ready,
           do_valid => do_valid,
           do_ready => do_ready,
			  trigger => triggerCheck,
			  long_trigger => dutWorking,
           din => din,
           dout => dout,
           data_to_dut => hosttofpga_data,
           data_from_dut => dataFromCtrlBrd,
			  state_debug => state_debug,
			  debug_ram => debug_ram,
			  debug_dout_ram => debug_dout_ram,
			  debug_addr => debug_addr,
			  --
			  EppDstb => EppDstb,
			  clr_dout_r_cnt => system_reset --reset dout read counter
			  
);

trig_unit: entity work.trigger_module
   port map(
		clk => dutClk,
		rst => system_reset,
		dut_working => dutWorking,
		trigger_length => triggerLength,
		trigger_wait => noOfTriggerWaitCycles,
	   trigger_mode => triggerMode,
		trigger_out => trigger
   );
----------------------------------------------------------------------------
------- DISPLAY LEDs for Debugging
------------------------------------------------------------------------------
-- display_byte <= dataBlockSize when displayReg = x"01" else
--			  keySize when displayReg = x"02" else
--			  stateMachineLeds when displayReg = x"03" else
--			  plainTextForTarget(15 downto 8) when displayReg = x"04" else
--			  plainTextForTarget(7 downto 0) when displayReg = x"05" else
--			  "0000" & keyTextTodut(3 downto 0) when displayReg = x"06" else
--			  "0000" & plainTextTodut(3 downto 0) when displayReg = x"07" else
--			  --"0000" & dataout(3 downto 0) when displayReg = x"08" else
--			  --"0000" & datain(3 downto 0) when displayReg = x"09" else
--			  commandToTargetControl when displayReg = x"0A" else
--			  stateMachineLedsTarget when displayReg = x"0B" else
--			  "0000000" & EndPCDataComm when displayReg = x"0C" else
--			  dataToCtrlBrd(7 downto 0) when displayReg = x"0D" else
--			  dataToCtrlBrd(15 downto 8) when displayReg = x"0E" else
--			  displayReg;
			  
--display_data <= x"00" & dataToCtrlBrd;
--display_data <= dataFromCtrlBrd;
display_data <= x"00" & state_debug;
--display_data <= x"00" & debug_ram;
--display_data <= x"00" & debug_dout_ram;

--display_data <= "00000" & d_write_pointer;
--display_data<= x"0123";
debug_seven_seg : entity work.display(behav) 
port map (clk => clk,  d0 => display_data(3 downto 0) , 
d1 => display_data(7 downto 4), d2 => display_data(11 downto 8) , 
d3=> display_data(15 downto 12), seven_seg=> seven_seg);
--trigger <= triggerCheck;			  
--Commented out to get direct clock
DUTClock <=   dutClk;
reset <= resetdutCommunicationController;
end Behavioral;