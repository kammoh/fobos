
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;
 

ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TOP
    PORT(
         Input : IN  std_logic_vector(15 downto 0);
         CLOCK : IN  std_logic;
         RESET : IN  std_logic;
         MUX_SEL : IN  std_logic;
         DRAM_ADDR : IN  std_logic_vector(10 downto 0);
         FIFO1_RD_EN : IN  std_logic;
         FIFO2_RD_EN : IN  std_logic;
         FIFO1_WR_EN : IN  std_logic;
         FIFO2_WR_EN : IN  std_logic;
         DRAM_WR_EN : IN  std_logic;
			--REG_EN : IN STD_LOGIC;
         FIFO1_FULL : OUT  std_logic;
         FIFO2_FULL : OUT  std_logic;
         FIFO1_EMPTY : OUT  std_logic;
         FIFO2_EMPTY : OUT  std_logic;
			fif1out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --test signal!
			fif2out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --test signal!
			muxout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); --test signal!
         Output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Input : std_logic_vector(15 downto 0) := (others => '0');
   signal CLOCK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal MUX_SEL : std_logic := '0';
   signal DRAM_ADDR : std_logic_vector(10 downto 0) := (others => '0');
   signal FIFO1_RD_EN : std_logic := '0';
   signal FIFO2_RD_EN : std_logic := '0';
   signal FIFO1_WR_EN : std_logic := '0';
   signal FIFO2_WR_EN : std_logic := '0';
   signal DRAM_WR_EN : std_logic := '0';
	--signal REG_EN : STD_LOGIC := '0';

 	--Outputs
   signal FIFO1_FULL : std_logic;
   signal FIFO2_FULL : std_logic;
   signal FIFO1_EMPTY : std_logic;
   signal FIFO2_EMPTY : std_logic;
	signal fif1out : std_logic_vector(15 downto 0);
	signal fif2out : std_logic_vector(15 downto 0);
	signal muxout : std_logic_vector(15 downto 0); 
   signal Output : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP PORT MAP (
          Input => Input,
          CLOCK => CLOCK,
          RESET => RESET,
          MUX_SEL => MUX_SEL,
          DRAM_ADDR => DRAM_ADDR,
          FIFO1_RD_EN => FIFO1_RD_EN,
          FIFO2_RD_EN => FIFO2_RD_EN,
          FIFO1_WR_EN => FIFO1_WR_EN,
          FIFO2_WR_EN => FIFO2_WR_EN,
          DRAM_WR_EN => DRAM_WR_EN,
			 --REG_EN => REG_EN,
          FIFO1_FULL => FIFO1_FULL,
          FIFO2_FULL => FIFO2_FULL,
          FIFO1_EMPTY => FIFO1_EMPTY,
          FIFO2_EMPTY => FIFO2_EMPTY,
			 fif1out => fif1out,
			 fif2out => fif2out,
			 muxout => muxout,
          Output => Output
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
      wait for CLOCK_period*10;
		
		--Temp
		--Reading into FIFOS
		FIFO1_WR_EN <= '1';
		FIFO2_WR_EN <= '0';
		FIFO1_RD_EN <= '0';
		FIFO2_RD_EN <= '0';
		Input <= "0000000000000001";
		MUX_SEL <= '0';
		DRAM_WR_EN <= '0';
		DRAM_ADDR <= "00000000000";
		wait for clock_period;

		FIFO1_WR_EN <= '0';
		FIFO2_WR_EN <= '1';
		FIFO1_RD_EN <= '0';
		FIFO2_RD_EN <= '0';
		Input <= "0000000000000010";
		DRAM_WR_EN <= '0';
		MUX_SEL <= '0';
		DRAM_ADDR <= "00000000000";
		wait for clock_period;

		FIFO1_WR_EN <= '1';
		FIFO2_WR_EN <= '0';
		Input <= "0000000000000100";
		FIFO1_RD_EN <= '0';
		FIFO2_RD_EN <= '0';
		DRAM_WR_EN <= '0';
		MUX_SEL <= '0';
		DRAM_ADDR <= "00000000000";
		wait for clock_period;
		
		FIFO1_WR_EN <= '0';
		FIFO2_WR_EN <= '1';
		Input <= "0000000000001000";
		FIFO1_RD_EN <= '0';
		FIFO2_RD_EN <= '0';
		DRAM_WR_EN <= '0';
		MUX_SEL <= '0';
		DRAM_ADDR <= "00000000000";
		wait for clock_period;
		
		--Reading into DRAM
		FIFO1_WR_EN <= '0';
		FIFO2_WR_EN <= '0';
		Input <= "1111111111111111";
		FIFO1_RD_EN <= '1';
		FIFO2_RD_EN <= '0';
		DRAM_WR_EN <= '1';
		DRAM_ADDR <= "00000000000";
		wait for clock_period;
		
		FIFO1_WR_EN <= '0';
		FIFO2_WR_EN <= '0';
		Input <= "1111111111111111";
		FIFO1_RD_EN <= '0';
		FIFO2_RD_EN <= '1';
		--REG_EN <= '1';
		DRAM_WR_EN <= '1';
		MUX_SEL <= '0';
		DRAM_ADDR <= "00000000001";
		wait for clock_period;
		
		FIFO1_WR_EN <= '0';
		FIFO2_WR_EN <= '0';
		Input <= "1111111111111111";
		FIFO1_RD_EN <= '1';
		FIFO2_RD_EN <= '0';
		DRAM_WR_EN <= '1';
		MUX_SEL <= '1';
		DRAM_ADDR <= "00000000010";
		wait for clock_period;
		
		FIFO1_WR_EN <= '0';
		FIFO2_WR_EN <= '0';
		Input <= "1111111111111111";
		FIFO1_RD_EN <= '0';
		FIFO2_RD_EN <= '1';
		DRAM_WR_EN <= '1';
		MUX_SEL <= '0';
		DRAM_ADDR <= "00000000011";
		wait for clock_period;

		MUX_SEL <= '1';
		FIFO1_RD_EN <= '0';
		FIFO2_RD_EN <= '0';
		DRAM_ADDR <= "00000000011";
		
		
      -- insert stimulus here 

      wait;
   end process;

END;
