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


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;
use work.fobos_package.all;

entity dutDCM is
generic (board : integer := NEXYS2); 
   port ( clkin        : in    std_logic;  
          rst         : in    std_logic;
          clkout : out   std_logic; 
          locked_out      : out   std_logic);
end dutDCM;

architecture BEHAVIORAL of dutDCM is
   signal CLK0_BUF_DCM1, CLK0_BUF_DCM2, CLKFB_IN_5MHz, CLKFB_IN_500KHz     : std_logic;
   signal clk5MHzN2, clk5MHzN3, clk50MHzToDCM       : std_logic;
   constant GND_BIT         : std_logic := '0';
   signal lockedOutDCM5MHz, lockedOutDCM500KHz : std_logic;
begin


clockForN2 : if (board = NEXYS2) generate

	CLK0_BUFG_INST : BUFG
      port map (I=>CLK0_BUF_DCM1,
                O=>CLKFB_IN_5MHz);
	
				 
   DCM_SP_INSTANCE_10DIV : DCM_SP
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 10.0,
            CLKFX_DIVIDE => 20,
            CLKFX_MULTIPLY => 2,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 20.000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"C080",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>CLKFB_IN_5MHz,
                CLKIN=>clkin,
                DSSEN=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>rst,
                CLKDV=>open,
                CLKFX=>clk5MHzN2,
                CLKFX180=>open,
                CLK0=>CLK0_BUF_DCM1,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>lockedOutDCM5MHz,
                PSDONE=>open,
                STATUS=>open);




	CLK0_BUFG_INST_N2 : BUFG
      port map (I=>CLK0_BUF_DCM2,
                O=>CLKFB_IN_500KHz);
	
				 
   DCM_SP_INST_10DIV : DCM_SP
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 10.0,
            CLKFX_DIVIDE => 20,
            CLKFX_MULTIPLY => 2,
            CLKIN_DIVIDE_BY_2 => FALSE,
            CLKIN_PERIOD => 20.000,
            CLKOUT_PHASE_SHIFT => "NONE",
            DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
            DFS_FREQUENCY_MODE => "LOW",
            DLL_FREQUENCY_MODE => "LOW",
            DUTY_CYCLE_CORRECTION => TRUE,
            FACTORY_JF => x"C080",
            PHASE_SHIFT => 0,
            STARTUP_WAIT => FALSE)
      port map (CLKFB=>CLKFB_IN_500KHz,
                CLKIN=>clk5MHzN2,
                DSSEN=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>rst,
                CLKDV=>open,
                CLKFX=>clkout,
                CLKFX180=>open,
                CLK0=>CLK0_BUF_DCM2,
                CLK2X=>open,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>lockedOutDCM500KHz,
                PSDONE=>open,
                STATUS=>open);
end generate;
--
clockForN3 : if (board = NEXYS3) generate
	
DCM_CLKGEN_instance_N3 : DCM_CLKGEN
generic map
(
	CLKFXDV_DIVIDE => 32, -- CLKFXDV divide value (2, 4, 8, 16, 32)
	CLKFX_DIVIDE => 16, -- Divide value - D - (1-256)
	CLKFX_MD_MAX => 0.01, -- Specify maximum M/D ratio for timing anlysis
	CLKFX_MULTIPLY => 4, -- Multiply value - M - (2-256)
	CLKIN_PERIOD => 10.0, -- Input clock period specified in nS
	SPREAD_SPECTRUM => "NONE", -- Spread Spectrum mode "NONE", "CENTER_LOW_SPREAD", "CENTER_HIGH_SPREAD",
	-- "VIDEO_LINK_M0", "VIDEO_LINK_M1" or "VIDEO_LINK_M2"
	STARTUP_WAIT => FALSE -- Delay config DONE until DCM_CLKGEN LOCKED (TRUE/FALSE)
)
port map
(
	CLKFX => open, -- 1-bit output: Generated clock output
	CLKFX180 => open, -- 1-bit output: Generated clock output 180 degree out of phase from CLKFX.
	CLKFXDV => clkout, -- 1-bit output: Divided clock output
	LOCKED => open, -- 1-bit output: Locked output
	PROGDONE => open, -- 1-bit output: Active high output to indicate the successful re-programming
	STATUS => open, -- 2-bit output: DCM_CLKGEN status
	CLKIN => clkin, -- 1-bit input: Input clock
	FREEZEDCM => open, -- 1-bit input: Prevents frequency adjustments to input clock
	PROGCLK => clkin, -- 1-bit input: Clock input for M/D reconfiguration
	PROGDATA => open, -- 1-bit input: Serial data input for M/D reconfiguration
	PROGEN => open, -- 1-bit input: Active high program enable
	RST => rst -- 1-bit input: Reset input pin
);
end generate;

locked_out <= lockedOutDCM5MHz and lockedOutDCM500KHz; 
end BEHAVIORAL;


