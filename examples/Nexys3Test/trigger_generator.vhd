library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fobos_control_package.all; 

entity trigger_generator is
	generic ( N : integer := 32);
    Port (
		clock 	: in std_logic;
		reset	: in std_logic;
		start_DUT 	: in std_logic;
		trigger_start 	: in std_logic_vector(N-1 downto 0);
		trigger_restart : in std_logic_vector(N-1 downto 0);
		trigger_high 	: in std_logic_vector(N-1 downto 0);
		trigger_signal : out std_logic
	);
end trigger_generator;

architecture Behavioral of trigger_generator is

------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
 
------------------------------------------------------------------------
-- Local Type Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
--  Constant Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------
signal trigger_start_done : std_logic;
signal trigger_high_done : std_logic;
signal trigger_restart_done : std_logic;

signal trigger_start_counter_en : std_logic;
signal trigger_high_counter_en : std_logic;
signal trigger_restart_counter_en : std_logic;

signal trigger_start_counter_load : std_logic;
signal trigger_high_counter_load : std_logic;
signal trigger_restart_counter_load : std_logic;

signal trigger_start_counter_output : std_logic_vector(N-1 downto 0);
signal trigger_high_counter_output : std_logic_vector(N-1 downto 0);
signal trigger_restart_counter_output : std_logic_vector(N-1 downto 0);

signal trigger_signal_buffer : std_logic;


type STATE is (st0, st1, st2, st3, st4, st5); 
signal pr_state,nx_state:state;

------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------

begin
trigger_start_counter : counter generic map (N => N) port map (clk => clock, reset => trigger_start_counter_load, 
						enable => trigger_start_counter_en, counter_out => trigger_start_counter_output);

trigger_start_done <= '1' when trigger_start_counter_output >= trigger_start else '0';
						
trigger_high_counter : counter generic map (N => N) port map (clk => clock, reset => trigger_high_counter_load,
						enable => trigger_high_counter_en, counter_out => trigger_high_counter_output);
					
trigger_high_done <= '1' when trigger_high_counter_output >= trigger_high else '0';

trigger_restart_counter : counter generic map (N => N) port map (clk => clock, reset => trigger_restart_counter_load,
						enable => trigger_restart_counter_en, counter_out => trigger_restart_counter_output);
					
trigger_restart_done <= '1' when trigger_restart_counter_output >= trigger_restart else '0';

------------------------------------------------------------------------
-- Present State Sync Reset
------------------------------------------------------------------------
present_state:	process (reset,clock)
				begin
				if (clock'event and clock='1')then
					if(reset='1') then
						pr_state<=st0;
					else
						pr_state<=nx_state;
					end if;
				end if;
end process;

------------------------------------------------------------------------
-- Next state function
------------------------------------------------------------------------
next_state_function: process(clock,reset,Z1000, Zop, pr_state)
  begin
	  case pr_state is
		  when st0 =>
		  if(start_DUT  = '1')
			nx_state <= st1;
		  else
			nx_state <= st0;
		  
		  when st1 =>
		  if (trigger_start_done = '1')
			nx_state <= st2;
		  else
			nx_state <= st1;
			
		  when st2 =>
		  if (trigger_high_done = '1') then 
			  nx_state<=st3;
			  else
			  nx_state <= st2;
		  end if;		  
		  
		  when st3 =>
		  if (trigger_restart_done = '1') then	
			  nx_state <= st2;
		  else
			  nx_state <= st3;
		  end if;
		  
		  when others=>
			  nx_state<=st0; 		
		     
		end case;
end process; 

------------------------------------------------------------------------
-- Output state function
------------------------------------------------------------------------

output_function: process(pr_state)
 begin	 		
	case pr_state is 
		 when st0 => 			
			trigger_start_counter_en <= '0'; trigger_high_counter_en <= '0';
			trigger_restart_counter_en <= '0'; trigger_start_counter_load <= '1';
			trigger_high_counter_load <= '1';trigger_restart_counter_load <= '1';
			trigger_signal_buffer <= '0';
		 when st1 => 
			trigger_start_counter_en <= '1'; trigger_high_counter_en <= '0';
			trigger_restart_counter_en <= '0'; trigger_start_counter_load <= '0';
			trigger_high_counter_load <= '1';trigger_restart_counter_load <= '1';	
			trigger_signal_buffer <= '0';			
		 when st2 =>
			trigger_start_counter_en <= '0'; trigger_high_counter_en <= '1';
			trigger_restart_counter_en <= '1'; trigger_start_counter_load <= '0';
			trigger_high_counter_load <= '0';trigger_restart_counter_load <= '0';		 
			trigger_signal_buffer <= '1';			
		 when st3 =>
			trigger_start_counter_en <= '0'; trigger_high_counter_en <= '0';
			trigger_restart_counter_en <= '1'; trigger_start_counter_load <= '0';
			trigger_high_counter_load <= '1';trigger_restart_counter_load <= '0';		 
			trigger_signal_buffer <= '0';			
		 when others =>
			trigger_start_counter_en <= '0'; trigger_high_counter_en <= '0';
			trigger_restart_counter_en <= '0'; trigger_start_counter_load <= '0';
			trigger_high_counter_load <= '0';trigger_restart_counter_load <= '0';		 
			trigger_signal_buffer <= '0';			
	end case;
end process;

trigger_signal <= trigger_signal_buffer;
end Behavioral;
