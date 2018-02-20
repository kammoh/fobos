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

entity DeppInterface is 
port (
   --Interface to host PC
   clk : in std_logic;  
   EppAstb: in std_logic;        -- Address strobe
   EppDstb: in std_logic;        -- Data strobe
   EppWrite  : in std_logic;     -- Port write signal
   EppDB  : inout std_logic_vector(7 downto 0); -- port data bus
   EppWait: out std_logic;      -- Port wait signal  
	-----Fobos config parameters. Signals to other Fobos units
	dataReg0 : out std_logic_vector(7 downto 0);
	dataReg1 : out std_logic_vector(7 downto 0);
	adcGain : out std_logic_vector(7 downto 0);
	adcAmp : out std_logic_vector(7 downto 0);
	controlReg : out std_logic_vector(7 downto 0);
	DisplayReg : out std_logic_vector(7 downto 0);
	commandToTargetControl : out std_logic_vector(7 downto 0);
	dataBlockSize : out std_logic_vector(7 downto 0);
	keySize : out std_logic_vector(7 downto 0);
	noOfTriggerWaitCycles : out std_logic_vector(31 downto 0);
	triggerLength : out std_logic_vector(31 downto 0);
	trigger_mode : out std_logic_vector(7 downto 0);
	sys_rst_reg : out std_logic_vector(7 downto 0);
	rst_dutComm_reg : out std_logic_vector(7 downto 0);
	rst_dut_reg : out std_logic_vector(7 downto 0);
	pc_comm_done_reg : out std_logic_vector(7 downto 0);
	debug_addr : out std_logic_vector(7 downto 0);
	hosttofpga_data_o :out  std_logic_vector(7 downto 0);
   ---Inputs from other Fobos units -- to be read by host PC
   bram_output : in std_logic_vector(15 downto 0); -- address 10, 11
   mainclockfrequency : in std_logic_vector(31 downto 0); -- address 20,21,22,23
   dutClockFrequency : in std_logic_vector(31 downto 0); -- address 24,25,26,27  
   statusReg : in std_logic_vector(7 downto 0);  -- address 31
	programOK : in std_logic_vector(7 downto 0);
   dataToPc : in std_logic_vector(7 downto 0);
	----Control signals for the rest of the system
	system_reset : out std_logic;
   frequency_counter_reset : out std_logic;
   push_to_dut_int : out std_logic;
   pop_from_dut_int : out std_logic;
   EndPCDataComm : out std_logic;
   resetdutCommunicationController : out std_logic




);
end DeppInterface;

architecture Behav of DeppInterface is 

   ---Depp protocol signals
   signal hosttofpga_data : std_logic_vector(7 downto 0);
   signal regEppAdrOut : std_logic_vector(7 downto 0);
   signal ctlEppDwrOut : std_logic;
   signal fpgatohost_data : std_logic_vector(7 downto 0);
   signal register_data   : std_logic_vector(7 downto 0);
   constant  inactive : std_logic := '0';
   constant active : std_logic := '1';
   signal  ctlEppRdCycleOut, ctlEppStartOut : std_logic;
   signal ctlEppDoneIn : std_logic;
   -----Registers
   signal dataReg0_s :  std_logic_vector(7 downto 0);
   signal dataReg1_s :  std_logic_vector(7 downto 0);
   signal adcGain_s :  std_logic_vector(7 downto 0);
	signal adcAmp_s :  std_logic_vector(7 downto 0);
	signal controlReg_s :  std_logic_vector(7 downto 0);
	signal DisplayReg_s :  std_logic_vector(7 downto 0);
	signal commandToTargetControl_s :  std_logic_vector(7 downto 0);
	signal dataBlockSize_s :  std_logic_vector(7 downto 0);
	signal keySize_s :  std_logic_vector(7 downto 0);
	signal noOfTriggerWaitCycles_s :  std_logic_vector(31 downto 0);
	signal triggerLength_s :  std_logic_vector(31 downto 0);
	signal trigger_mode_s :  std_logic_vector(7 downto 0);
	signal sys_rst_reg_s :  std_logic_vector(7 downto 0);
	signal rst_dutComm_reg_s :  std_logic_vector(7 downto 0);
	signal pc_comm_done_reg_s : std_logic_vector(7 downto 0);
	signal debug_addr_s :  std_logic_vector(7 downto 0);	
   signal rst_dut_reg_s :  std_logic_vector(7 downto 0);
	
begin

  hosttofpga_data_o <= hosttofpga_data;
  
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
		  -----
	 dataReg0  <= dataReg0_s;
    dataReg1  <= dataReg1_s;
    adcGain  <= adcGain_s;
	 adcAmp  <= adcAmp_s;
	 controlReg  <= controlReg_s;
	 DisplayReg <= DisplayReg_s;
	 commandToTargetControl  <= commandToTargetControl_s;
	 dataBlockSize  <= dataBlockSize_s;
	 keySize  <= keySize_s;
	 noOfTriggerWaitCycles  <= noOfTriggerWaitCycles_s;
	 triggerLength  <= triggerLength_s;
	 sys_rst_reg <= sys_rst_reg_s;
	 rst_dutComm_reg  <= rst_dutComm_reg_s;
	 pc_comm_done_reg  <= pc_comm_done_reg_s;
	 debug_addr 	 <= debug_addr_s;
    rst_dut_reg  <= rst_dut_reg_s;
------------------------------------------------------------------------
-- fpga to host data output mux
------------------------------------------------------------------------
fpgatohost_data <=  dataReg0_s when regEppAdrOut = x"00" else
		    dataReg1_s when regEppAdrOut = x"01" else
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
		    controlReg_s when regEppAdrOut = x"30" else
		    statusReg  when regEppAdrOut = x"31" else
		    ----------------------------------------
		    displayReg_s when regEppAdrOut = x"40" else
		    ----------------------------------------
		    programOK  when regEppAdrOut = x"50" else
			----------------------------------------
			adcGain_s when regEppAdrOut = x"60" else
			adcAmp_s when regEppAdrOut = x"61" else
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
			dataReg0_s <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"01" then
			dataReg1_s <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"60" then
			adcGain_s <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"61" then
			adcAmp_s <= hosttofpga_data;
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
			controlReg_s <= hosttofpga_data;
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
			displayReg_s <= hosttofpga_data;
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
			commandToTargetControl_s <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"78" then
			dataBlockSize_s <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"79" then
			keySize_s <= hosttofpga_data;
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
			noOfTriggerWaitCycles_s(31 downto 24) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"81" then
			noOfTriggerWaitCycles_s(23 downto 16) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"82" then
			noOfTriggerWaitCycles_s(15 downto 8) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"83" then
			noOfTriggerWaitCycles_s(7 downto 0) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"84" then
			triggerLength_s(31 downto 24) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"85" then
			triggerLength_s(23 downto 16) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"86" then
			triggerLength_s(15 downto 8) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"87" then
			triggerLength_s(7 downto 0) <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"AA" then
			sys_rst_reg_s <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"BB" then
			rst_dutComm_reg_s <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"CC" then
			rst_dut_reg_s <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"DD" then
			pc_comm_done_reg_s <= hosttofpga_data;
		end if;
	end if;
end process;
process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"EE" then
			debug_addr_s <= hosttofpga_data;
		end if;
	end if;
end process;

process (clk, regEppAdrOut, ctlEppDwrOut, hosttofpga_data)
	begin
	if clk = '1' and clk'Event then
		if ctlEppDwrOut = '1' and regEppAdrOut = x"EF" then
			trigger_mode_s <= hosttofpga_data;
		end if;
	end if;
end process;


-----Control signals to the rest of the system
system_reset <= '1' when sys_rst_reg_s = x"FF" else '0';
frequency_counter_reset <= '1' when controlReg_s = x"02" else '0';
push_to_dut_int <= '1' when regEppAdrOut = x"7A" and ctlEppDwrOut = '1' else '0'; 
pop_from_dut_int <= '1' when regEppAdrOut = x"71"  else '0'; 
EndPCDataComm <= '1' when pc_comm_done_reg_s = x"FF" else '0';
resetdutCommunicationController <= '1' when rst_dutComm_reg_s = x"FF" else '0';


end Behav;