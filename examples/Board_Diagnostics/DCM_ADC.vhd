library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;
use work.fobos_package.all;

entity DCM_ADC is
generic (board : integer := NEXYS2); 
   port ( clkin        : in    std_logic;  
          rst         : in    std_logic;
          clkout : out   std_logic; 
			 clktobramN2 : out std_logic;
          locked_out      : out   std_logic);
end DCM_ADC;

architecture BEHAVIORAL of DCM_ADC is
   signal CLK0_BUF ,CLKFB_IN     : std_logic;
   signal CLK100MHz_BUF, CLK100MHz_OUT       : std_logic;
	signal CLKBRAM, CLKBRAM_BUF1, CLKBRAM_BUF2, CLKBRAM_N3 : std_logic;
   constant GND_BIT         : std_logic := '0';
begin


	CLK0_BUFG_INST : BUFG
      port map (I=>CLK0_BUF,
                O=>CLKFB_IN);
					 
	CLK_BRAM_N3_INST1 : BUFG
      port map (I=>CLKFB_IN,
                O=>CLKBRAM_N3);
   
	CLK100_BUFG_INST : BUFG
      port map (I=>CLK100MHz_BUF,
                O=>CLK100MHz_OUT);

	CLKBRAM_N2_INST1 : BUFG
      port map (I=>CLKBRAM,
                O=>CLKBRAM_BUF1);

	CLKBRAM_N2_INST2 : BUFG
      port map (I=>CLKBRAM_BUF1,
                O=>CLKBRAM_BUF2);	
				 
   DCM_SP_INST : DCM_SP
   generic map( CLK_FEEDBACK => "1X",
            CLKDV_DIVIDE => 2.0,
            CLKFX_DIVIDE => 1,
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
      port map (CLKFB=>CLKFB_IN,
                CLKIN=>clkin,
                DSSEN=>GND_BIT,
                PSCLK=>GND_BIT,
                PSEN=>GND_BIT,
                PSINCDEC=>GND_BIT,
                RST=>rst,
                CLKDV=>open,
                CLKFX=>CLKBRAM,
                CLKFX180=>open,
                CLK0=>CLK0_BUF,
                CLK2X=>CLK100MHz_BUF,
                CLK2X180=>open,
                CLK90=>open,
                CLK180=>open,
                CLK270=>open,
                LOCKED=>locked_out,
                PSDONE=>open,
                STATUS=>open);
                
clkout <= CLKFB_IN when board = NEXYS3 else 
	  CLK100MHz_OUT when board = NEXYS2 else
	  GND_BIT;
clktobramN2 <= CLKBRAM_BUF2 when board = NEXYS2 else
					CLKBRAM_N3   when board = NEXYS3 else
					GND_BIT;
end BEHAVIORAL;


