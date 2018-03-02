----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:49:32 06/28/2016 
-- Design Name: 
-- Module Name:    DBC_ctrl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
-- library UNISIM;
-- use UNISIM.VComponents.all;

entity DBC_ctrl is
    Port ( 
			  --external signals
			  done : out  STD_LOGIC;
           start : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  ready : out STD_LOGIC;
			  --internal signals
			  	rst : out STD_LOGIC;
           sel_in : out  STD_LOGIC;
			  en_kt : out  STD_LOGIC;
           iii : out  STD_LOGIC_VECTOR (3 downto 0);
           en_state : out  STD_LOGIC;
			  en_out : out STD_LOGIC;
			  enc_j : out STD_LOGIC;
			  init : out STD_LOGIC);
           
end DBC_ctrl;

architecture behav of DBC_ctrl is
	type State_type is (S_reset, S_wait_start, S_init1, S_init2, S_init3, S_iter_enc, S_done);
	signal state : State_type := S_reset;
	signal state_next : State_type;
	signal round_r : STD_LOGIC_VECTOR(3 downto 0);
	signal round_next : STD_LOGIC_VECTOR(3 downto 0);
	
begin
	--------------------------------------------------------------------------------------------
	pctrl: process(clk)
	begin
		
			if start = '1' then
				state <= S_reset;
				round_r <= (others=>'0');
			elsif rising_edge(clk) then
				state <= state_next;
				round_r <= round_next;
			end if;
	end process;
	--------------------------------------------------------------------------------------------
	iii <= round_r;
	--------------------------------------------------------------------------------------------
	pcomb: process(start, round_r, state, clk)
	begin
		--!default values
		sel_in <= '0';
		init <= '0';
		en_kt <= '0';
		ready <= '0';
      en_state <= '0';
		en_out <= '0';
		done <= '0';
		round_next <= round_r;
		rst <= '0';
		enc_j <= '0';
		------------------------------------------------------------------------------------------
		case state is 
		when S_reset =>
			round_next <= (others=>'0');
			state_next <= S_wait_start;
			rst <= '1';
		when S_wait_start =>
			ready <= '1';
			sel_in <='1';
			--en_state <= '1';
			--if start = '1' then
				init <= '1';
				en_kt <= '1';
				
				state_next <= S_init1;
				round_next<= (others=> '0');
			--end if;
		when S_init1 =>
			en_state <= '1';
			en_kt <= '1';
			init <= '1';
			sel_in <= '1';
			state_next <= S_init2;
		when S_init2 =>
			en_state <= '1';
			en_kt <= '1';
			init <= '1';
			sel_in <= '1';
			state_next <= S_init3;
		when S_init3 =>
			enc_j <= '1';
			en_state <= '1';
			en_kt <= '1';
			sel_in <= '1';
			round_next <= round_r + 1;
			state_next <= S_iter_enc;
		when S_iter_enc =>
			en_state <= '1';
			en_kt <= '1';
			if round_r = 14 then
				round_next <= (others=>'0');
				--new
				--state_next <= S_done;
				state_next <= S_done;
				--done <= '1';
				en_out <= '1';
			else
				round_next <= round_r + 1;
			end if;		
		when S_done =>
		   done <= '1';
		   state_next <= S_done;
		end case;
	end process;
	------------------------------------------------------------------------------------------------
end behav;

