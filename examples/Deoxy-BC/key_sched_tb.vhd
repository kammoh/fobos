-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
use work.AES_pkg.all;

  ENTITY key_sched_tb IS
  END key_sched_tb;

  ARCHITECTURE behavior OF key_sched_tb IS 

  

          signal K, T, STKi : std_logic_vector(127 downto 0);
			 signal K_state, T_state, STKi_state : t_AES_state;
			 signal i : std_logic_vector (3 downto 0);
			 signal init, en_kt, clk : std_logic;
			 --signal STKi_state_debug : t_AES_state;
          constant clk_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
          uut: entity work.key_sched(key_size_128) PORT MAP(
           K => K_state,
           T => T_state,
           STKi => STKi_state,
			  i    => i,
			  en_kt => en_kt,
			  init => init,
			  clk => clk
          );
			 
			 
	u_map_tweak: entity work.AES_map(structure)
    port map ( ii => T, 
               oo => T_state);
	u_map_key: entity work.AES_map(structure)
    port map ( ii => K, 
               oo => K_state);
               
    u_STKi_invmap: entity work.AES_invmap(structure)
    port map ( ii => STKi_state, 
               oo => STKi);
	
	
	
	clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;

  --  Test Bench Statements
     tb : PROCESS
     BEGIN

       wait for 20 ns; -- wait until global set/reset completes

       K <= x"0F0E0D0C0B0A09080706050403020100";
		 T <= x"0F0E0D0C0B0A09080706050403020100";
		 --added to load registers with K and T
		 init <= '1';
		 en_kt <= '1';
		 i <= "0000";
		 wait for clk_period;
		 wait for clk_period;
		 -- end addition
		 --round 0
		 init <= '0';
		 en_kt <= '1';
		 i <= "0000";
		 wait for clk_period;
		 --round 1
		 init <= '0';
		 en_kt <= '1';
		 i <= "0001";
		 wait for clk_period;
		 
		  --round 2
		 init <= '0';
		 en_kt <= '1';
		 i <= "0010";
		 wait for clk_period;
		 
		  --round 3
		 init <= '0';
		 en_kt <= '1';
		 i <= "0011";
		 wait for clk_period;

       wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
