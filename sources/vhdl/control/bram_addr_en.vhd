-------------------------------------------------------------------------------
--
-- Title       : bram_addr_en
-- Design      : bram_addr_en
-- Author      : 220admin
-- Company     : GMU
--
-------------------------------------------------------------------------------
--
-- File        : bram_addr_en.vhd
-- Generated   : Tue Oct 23 11:25:33 2012
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {bram_addr_en} architecture {structural}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity bram_addr_en is
	 port(
	 clock : in STD_LOGIC;
	 reset : in std_logic;
		 trigger : in STD_LOGIC;
		 to_store : out std_logic_vector(4 downto 0);
		 bram_we_en : out STD_LOGIC
	     );
end bram_addr_en;

--}} End of automatically maintained section

architecture structural of bram_addr_en is

component counter is
	generic (N : integer := 32);
	port ( 	  
		clk : in std_logic;
		reset : in std_logic;
	   enable : in std_logic; 
      counter_out : out std_logic_vector(N-1 downto 0)
	);
end component;

type STATE is (st1, st2, st3); 
signal pr_state,nx_state:state;

signal bram_we_en_temp,load_trig_cnt, enb_trig_cnt,Z20 : std_logic;

signal cnt_out1 : std_logic_vector(4 downto 0);
begin
  
------------------------ Counter to count 20CC------------
count_input_key : 	counter generic map(N => 5) port map(
		 clk => clock,
		 reset => load_trig_cnt,
		 enable => enb_trig_cnt,
		 counter_out => cnt_out1);

Z20 <= '1' when cnt_out1 >= "10011" else '0'; 
	
---------------------------------------------------------------

--------------------Async Reset---------------------------------
present_state:	process (reset,clock)
					begin
						if(reset='1') then
							pr_state<=st1;
						elsif (clock'event and clock='1')then
							pr_state<=nx_state;
						end if;
end process;
-----------------------------------------------------------------

next_state_function: process(clock,reset,trigger, Z20, pr_state)
  begin
	  case pr_state is
		  when st1 =>
		  if (trigger = '1') then
		  nx_state <= st2;
		  else
		  nx_state <= st1;
		  end if;
		
		  when st2 =>
		  if (Z20 = '1' and trigger = '1') then 
			  nx_state<=st3;
			  else
			  nx_state <= st2;
		  end if;		  
		  
		  when st3 =>
		  if (trigger = '1') then	
			  nx_state <= st3;
		  else
			  nx_state <= st1;
		  end if;
		  
		  when others=>
			  nx_state<=st1; 		
		     
		end case;
end process; 

output_function: process(pr_state)
 begin	 
 bram_we_en_temp<='0';
		
	case pr_state is 
		 		 
		 when st1 => 
		  load_trig_cnt <= '1';
		  enb_trig_cnt <= '0';
		  bram_we_en_temp<= '0';
		 when st2 =>		 
		  load_trig_cnt <= '0';
		  enb_trig_cnt <= '1';
		  bram_we_en_temp<= '1';
		 when st3=>
		  load_trig_cnt <= '0';
		  enb_trig_cnt <= '0';
		  bram_we_en_temp<= '0';
		
		 when others =>
		  load_trig_cnt <= '0';
		  enb_trig_cnt <= '0';
		  bram_we_en_temp<= '0';
		 
	end case;
end process;
bram_we_en <= bram_we_en_temp;
--to_store <= '0' when cnt_out1 = "10011" else bram_we_en_temp;
to_store <= cnt_out1;
end structural;
