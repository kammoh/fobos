library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.fobos_package.all;


entity trigger_module is
port (
		clock : in std_logic;
		reset : in std_logic;
		startOfEncryption : in std_logic;
		endOfEncryption : in std_logic;
		noOfTraces : in std_logic_vector(31 downto 0);
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

signal cnt_trig_en, cnt_trig_ld, triggerOutBuffer : std_logic;
signal cnt_trig_out : std_logic_vector(31 downto 0);

signal Z1000, Zop : std_logic;

type STATE is (load, st0, st1, st2, st3); 
signal pr_state,nx_state:state;

begin

counterTrigger : counter generic map (N=>32) port map(clk=>clock,reset=>cnt_trig_ld,enable=>cnt_trig_en,counter_out=>cnt_trig_out);
Zop   <= '1' when cnt_trig_out < noOfTraces else '0';

--------------------Async Reset---------------------------------
present_state:	process (reset,clock)
					begin
						if(reset='1') then
							pr_state<=load;
						elsif (clock'event and clock='1')then
							pr_state<=nx_state;
						end if;
end process;
-----------------------------------------------------------------

next_state_function: process(clock,reset,Z1000, Zop, pr_state)
  begin
	  case pr_state is
		  when load =>
			nx_state <= st0;
			
		  when st0 =>
		  if (startOfEncryption = '1') then
			nx_state <= st1;
			else
			nx_state <= st0;
		 end if;
		  
		  when st1 =>
		  if (endOfEncryption = '1') then
			nx_state <= st2;
			else
			nx_state <= st1;
		 end if;	
		
		 when st2 => 
		 if (Zop = '1') then
			nx_state <= st3;
		else
			nx_state <= load;
		 end if; 
		  when others=>
			  nx_state<=st3; 		
		     
		end case;
end process; 

output_function: process(pr_state)
 begin	 
	triggerOutBuffer <= '0';		
	case pr_state is 
		 when load =>
			cnt_trig_en <= '0'; cnt_trig_ld <= '1'; triggerOutBuffer <= '0';
		 when st0 => 
			cnt_trig_en <= '0';  cnt_trig_ld <= '0';triggerOutBuffer <= '0';
		 when st1 => 
			cnt_trig_en <= '0';  cnt_trig_ld <= '0';triggerOutBuffer <= '1';
		 when st2 =>		 
			cnt_trig_en <= '1'; cnt_trig_ld <= '0';	triggerOutBuffer <= '0';		
		 when others =>
			cnt_trig_en <= '0';  cnt_trig_ld <= '1';triggerOutBuffer <= '0';
		 
	end case;
end process;
trigger_out <= triggerOutBuffer;
end structural;


