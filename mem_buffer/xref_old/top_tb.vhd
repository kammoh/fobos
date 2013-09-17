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
         Input : IN  std_logic_vector(15 downto 0);
         Output : OUT  std_logic_vector(15 downto 0);
         process_data : IN  std_logic;
         RESET : IN  std_logic;
         CLOCK : IN  std_logic;
         Stall : OUT  std_logic;
         fif1out : OUT  std_logic_vector(15 downto 0);
         fif2out : OUT  std_logic_vector(15 downto 0);
         muxout : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Input : std_logic_vector(15 downto 0) := (others => '0');
   signal process_data : std_logic := '0';
   signal RESET : std_logic := '0';
   signal CLOCK : std_logic := '0';

 	--Outputs
   signal Output : std_logic_vector(15 downto 0);
   signal Stall : std_logic;
   signal fif1out : std_logic_vector(15 downto 0);
   signal fif2out : std_logic_vector(15 downto 0);
   signal muxout : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          Input => Input,
          Output => Output,
          process_data => process_data,
          RESET => RESET,
          CLOCK => CLOCK,
          Stall => Stall,
          fif1out => fif1out,
          fif2out => fif2out,
          muxout => muxout
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

      -- insert stimulus here 

      wait;
   end process;

END;
