-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
use work.AES_pkg.all;

  ENTITY DBC_dp_tb IS
  END DBC_dp_tb;

  ARCHITECTURE behavior OF DBC_dp_tb IS 
          signal K, T, din, dout: std_logic_vector(127 downto 0);
			 signal i : std_logic_vector (3 downto 0);
			 signal en_kt, init,clk, en_state, sel_in: std_logic;
			 --signal STKi_state_debug : t_AES_state;
          constant clk_period : time := 10 ns;
  BEGIN

  -- Component Instantiation
          uut: entity work.DBC_dp(struct) PORT MAP(
           din => din,
           dout => dout,
           K => K,
           T => T,
           sel_in => sel_in,
           en_state => en_state,
           en_kt => en_kt,
			  init => init,
			  i => i,
			  clk => clk
          );
			 
			 

	
	
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
       --K <= x"0F0E0D0C0B0A09080706050403020100";
		 --T <= x"0F0E0D0C0B0A09080706050403020100";
		 --T<= x"01000000000000e0c0a0806040200040";
		 K <= x"000102030405060708090a0b0c0d0e0f";
		 --T <= x"000102030405060708090a0b0c0d0e0f";
		 din <= x"000102030405060708090a0b0c0d0e0f";
		 --din<=x"0F0E0D0C0B0A09080706050403020100";
		 T <= x"400020406080a0c0e000000000000001";
		 
		 
		 --added to load registers with K and T
		 init <= '1';
		 en_kt <= '1';
		 i <= "0000";
		 en_state <= '1';
		 sel_in <= '1';
		 wait for clk_period;
		 wait for clk_period;
		 -- end addition
		 --round 0
		 en_state <= '1';
		 sel_in <= '1';
		 init <= '0';
		 en_kt <= '1';
		 i <= "0000";
		 wait for clk_period;
		 --round 1
		 sel_in <= '0';
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
		 
		  --round 4
		 init <= '0';
		 en_kt <= '1';
		 i <= "0100";
		 wait for clk_period;
		 
		  --round 5
		 init <= '0';
		 en_kt <= '1';
		 i <= "0101";
		 wait for clk_period;
		 
		  --round 6
		 init <= '0';
		 en_kt <= '1';
		 i <= "0110";
		 wait for clk_period;
		 
		  --round 7
		 init <= '0';
		 en_kt <= '1';
		 i <= "0111";
		 wait for clk_period;
		 
		  --round 8
		 init <= '0';
		 en_kt <= '1';
		 i <= "1000";
		 wait for clk_period;
		 
		  --round 9
		 init <= '0';
		 en_kt <= '1';
		 i <= "1001";
		 wait for clk_period;
		 
		  --round 10
		 init <= '0';
		 en_kt <= '1';
		 i <= "1010";
		 wait for clk_period;
		 
		  --round 11
		 init <= '0';
		 en_kt <= '1';
		 i <= "1011";
		 wait for clk_period;
		 
		 
		  --round 12
		 init <= '0';
		 en_kt <= '1';
		 i <= "1100";
		 wait for clk_period;
		 
		  --round 13
		 init <= '0';
		 en_kt <= '1';
		 i <= "1101";
		 wait for clk_period;
		 
		 
		  --round 14
		 init <= '0';
		 en_kt <= '1';
		 i <= "1110";
		 wait for clk_period;
		 
		

       wait; -- will wait forever
     END PROCESS tb;
--		 --round 0
--		 init <= '1';
--		 en_kt <= '1';
--		 i <= "0000";
--		 
--		 en_state <= '1';
--		 sel_in <= '1';
--		 wait for clk_period;
--		 --round 1
--		 init <= '0';
--		 en_kt <= '1';
--		 i <= "0001";
--		 
--		 en_state <= '1';
--		 sel_in <= '0';
--		 wait for clk_period;
--		 
--		  --round 2
--		 init <= '0';
--		 en_kt <= '1';
--		 i <= "0010";
--		 
--		 en_state <= '1';
--		 sel_in <= '0';
--		 wait for clk_period;
--		 
--		  --round 3
--		 init <= '0';
--		 en_kt <= '1';
--		 i <= "0011";
--		 
--		 en_state <= '1';
--		 sel_in <= '0';
--		 wait for clk_period;
--
--       wait; -- will wait forever
--     END PROCESS tb;
  --  End Test Bench 

  END;
