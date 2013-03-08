library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity trigger_module is
port (
		clock : in std_logic;
		reset : in std_logic;
		trigger_out : out std_logic);

end trigger_module;
		
architecture structural of trigger_module is 

component counter is
	generic (N : integer := 32);
	port ( 	  
		clk : in std_logic;
		reset : in std_logic;
	   enable : in std_logic; 
      counter_out : out std_logic_vector(N-1 downto 0)
	);
end component;

signal cnt_1000_en, cnt_trig_en, cnt_1000_ld, cnt_trig_ld : std_logic;
signal cnt_1000_out : std_logic_vector(9 downto 0);
signal cnt_trig_out : std_logic_vector(3 downto 0);

signal Z1000, Zop : std_logic;

type STATE is (st0, st1, st2, st3, st4, st5); 
signal pr_state,nx_state:state;

begin

counter_1000 : counter generic map (N=>10) port map(clk=>clock,reset=>cnt_1000_ld,enable=>cnt_1000_en,counter_out=>cnt_1000_out);
counter_trig : counter generic map (N=>4) port map(clk=>clock,reset=>cnt_trig_ld,enable=>cnt_trig_en,counter_out=>cnt_trig_out);

Z1000 <= '1' when cnt_1000_out = "1111100111" else '0';
trigger_out    <= '1' when cnt_1000_out < "1111101000" else '0';
Zop   <= '1' when cnt_trig_out = "1000" else '0';

--------------------Async Reset---------------------------------
present_state:	process (reset,clock)
					begin
						if(reset='1') then
							pr_state<=st0;
						elsif (clock'event and clock='1')then
							pr_state<=nx_state;
						end if;
end process;
-----------------------------------------------------------------

next_state_function: process(clock,reset,Z1000, Zop, pr_state)
  begin
	  case pr_state is
		  when st0 =>
		  nx_state <= st1;
		  
		  when st1 =>
		  nx_state <= st2;
		
		  when st2 =>
		  if (Zop = '1') then 
			  nx_state<=st3;
			  else
			  nx_state <= st2;
		  end if;		  
		  
		  when st3 =>
		  if (Z1000 = '1') then	
			  nx_state <= st4;
		  else
			  nx_state <= st1;
		  end if;
		  
		  when others=>
			  nx_state<=st4; 		
		     
		end case;
end process; 

output_function: process(pr_state)
 begin	 

		
	case pr_state is 
		
		 when st0 => 
			cnt_1000_en <= '0';  cnt_trig_en <= '0';  cnt_1000_ld <= '1'; cnt_trig_ld <= '1';
		 when st1 => 
			cnt_1000_en <= '0';  cnt_trig_en <= '0';  cnt_1000_ld <= '1'; cnt_trig_ld <= '1';
		 when st2 =>		 
			cnt_1000_en <= '0';  cnt_trig_en <= '1';  cnt_1000_ld <= '0'; cnt_trig_ld <= '0';
		 when st3=>
			cnt_1000_en <= '1';  cnt_trig_en <= '0';  cnt_1000_ld <= '0'; cnt_trig_ld <= '0';			
		 when others =>
			cnt_1000_en <= '0';  cnt_trig_en <= '0';  cnt_1000_ld <= '1'; cnt_trig_ld <= '1';
		 
	end case;
end process;

end structural;


