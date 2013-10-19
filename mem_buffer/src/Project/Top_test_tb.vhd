LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Top_test_tb IS
END Top_test_tb;
 
ARCHITECTURE behavior OF Top_test_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top_test
    PORT(
         CLOCK : IN  std_logic;
         EppAstb : IN  std_logic;
         EppDstb : IN  std_logic;
         EppWr : IN  std_logic;
         EppRst : IN  std_logic;
         EppDB : INOUT  std_logic_vector(7 downto 0);
         EppWait : OUT  std_logic;
         RamCS : OUT  std_logic;
         FlashCS : OUT  std_logic;
         MemWr : OUT  std_logic;
         MemOe : OUT  std_logic;
         RamUB : OUT  std_logic;
         RamLB : OUT  std_logic;
         RamCre : OUT  std_logic;
         RamAdv : OUT  std_logic;
         RamClk : OUT  std_logic;
         RamWait : IN  std_logic;
         FlashRp : OUT  std_logic;
         FlashStSts : IN  std_logic;
         MemAdr : OUT  std_logic_vector(23 downto 1);
         MemDB : INOUT  std_logic_vector(15 downto 0);
         FlashByte : OUT  std_logic;
         MemCtrlEnabled : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK : std_logic := '0';
   signal EppAstb : std_logic := '0';
   signal EppDstb : std_logic := '0';
   signal EppWr : std_logic := '0';
   signal EppRst : std_logic := '0';
   signal RamWait : std_logic := '0';
   signal FlashStSts : std_logic := '0';

	--BiDirs
   signal EppDB : std_logic_vector(7 downto 0);
   signal MemDB : std_logic_vector(15 downto 0);

 	--Outputs
   signal EppWait : std_logic;
   signal RamCS : std_logic;
   signal FlashCS : std_logic;
   signal MemWr : std_logic;
   signal MemOe : std_logic;
   signal RamUB : std_logic;
   signal RamLB : std_logic;
   signal RamCre : std_logic;
   signal RamAdv : std_logic;
   signal RamClk : std_logic;
   signal FlashRp : std_logic;
   signal MemAdr : std_logic_vector(23 downto 1);
   signal FlashByte : std_logic;
   signal MemCtrlEnabled : std_logic;

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
   constant RamClk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top_test PORT MAP (
          CLOCK => CLOCK,
          EppAstb => EppAstb,
          EppDstb => EppDstb,
          EppWr => EppWr,
          EppRst => EppRst,
          EppDB => EppDB,
          EppWait => EppWait,
          RamCS => RamCS,
          FlashCS => FlashCS,
          MemWr => MemWr,
          MemOe => MemOe,
          RamUB => RamUB,
          RamLB => RamLB,
          RamCre => RamCre,
          RamAdv => RamAdv,
          RamClk => RamClk,
          RamWait => RamWait,
          FlashRp => FlashRp,
          FlashStSts => FlashStSts,
          MemAdr => MemAdr,
          MemDB => MemDB,
          FlashByte => FlashByte,
          MemCtrlEnabled => MemCtrlEnabled
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
      wait for 100 ns;	

      wait for CLOCK_period*10;

      -- insert stimulus here 
		     EppAstb <= '0';
           EppDstb <= '0';
           EppWr <= '0';
           EppRst <= '0';
           EppDB <= "00000000";
           RamWait <= '0';
           FlashStSts <= '0';
           MemDB <= "0000000000000000";
			  FlashStSts <= '0';
			  MemDB <= "0000000000000000";

		
		

      wait;
   end process;

END;
