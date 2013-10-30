LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         dout : OUT  std_logic_vector(15 downto 0);
         CLOCK : IN  std_logic;
         RESET : IN  std_logic;
         COUNTER_EN : IN  std_logic;
         MemAdr : OUT  std_logic_vector(25 downto 0);
         RamClk : OUT  std_logic;
         RamAdv : OUT  std_logic;
         RamCRE : OUT  std_logic;
         RamCS : OUT  std_logic;
         MemOE : OUT  std_logic;
         MemWR : OUT  std_logic;
         RamLB : OUT  std_logic;
         RamUB : OUT  std_logic;
         MemDB : INOUT  std_logic_vector(15 downto 0);
         RamWait : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal COUNTER_EN : std_logic := '0';
   signal RamWait : std_logic := '0';

	--BiDirs
   signal MemDB : std_logic_vector(15 downto 0);

 	--Outputs
   signal dout : std_logic_vector(15 downto 0);
   signal MemAdr : std_logic_vector(25 downto 0);
   signal RamClk : std_logic;
   signal RamAdv : std_logic;
   signal RamCRE : std_logic;
   signal RamCS : std_logic;
   signal MemOE : std_logic;
   signal MemWR : std_logic;
   signal RamLB : std_logic;
   signal RamUB : std_logic;

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
   constant RamClk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          dout => dout,
          CLOCK => CLOCK,
          RESET => RESET,
          COUNTER_EN => COUNTER_EN,
          MemAdr => MemAdr,
          RamClk => RamClk,
          RamAdv => RamAdv,
          RamCRE => RamCRE,
          RamCS => RamCS,
          MemOE => MemOE,
          MemWR => MemWR,
          RamLB => RamLB,
          RamUB => RamUB,
          MemDB => MemDB,
          RamWait => RamWait
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
 
   RamClk_process :process
   begin
		RamClk <= '0';
		wait for RamClk_period/2;
		RamClk <= '1';
		wait for RamClk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		RESET <= '1';
      wait for 100 ns;	

      wait for CLOCK_period*10;

      -- insert stimulus here 
		RESET <= '0';
		RamWait <= '0';
		MemDB <= "HLLH" & "HHHH" & "LLLL" & "LHHL";
      --COUNTER_EN : IN  std_logic;
      --MemDB : INOUT  std_logic_vector(15 downto 0);
			
      wait;
   end process;

END;
