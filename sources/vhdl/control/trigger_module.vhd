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
		triggerLength : in std_logic_vector(31 downto 0);
		noOfTriggerWaitCycles : in std_logic_vector(31 downto 0);
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

signal cntTrigLenEn, cntTrigWaitEn, cntTrigLenLd, cntTrigWaitLd, triggerOutBuffer : std_logic;
signal cntTriggerLenOut, cntTriggerWaitOut : std_logic_vector(31 downto 0);

signal zTriggerWait, zTriggerLen : std_logic;

type STATE is (load, st0, st1, st2, st3); 
signal pr_state,nx_state:state;

begin

triggerWaitCounter   : counter generic map (N=>32) port map (clk => clock, reset => cntTrigWaitLd, enable => cntTrigWaitEn, counter_out => cntTriggerWaitOut);
triggerLengthCounter : counter generic map (N=>32) port map (clk => clock, reset => cntTrigLenLd,  enable => cntTrigLenEn,  counter_out => cntTriggerLenOut);
zTriggerWait   <= '1' when cntTriggerWaitOut < noOfTriggerWaitCycles else '0';
zTriggerLen   <= '0' when cntTriggerLenOut < triggerLength else '1';

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

next_state_function: process(clock,reset,zTriggerWait, zTriggerLen, startOfEncryption, pr_state)
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
		  if (zTriggerWait = '1') then
			nx_state <= st1;
			else
			nx_state <= st2;
		 end if;	
		
		 when st2 => 
		 if (zTriggerLen = '1') then
			nx_state <= st3;
		else
			nx_state <= st2;
		 end if; 
		 
		 when st3 =>
			if (startOfEncryption = '1') then
				nx_state <= st3;
			else
				nx_state <= load;
			end if;
			
		  when others=>
			  nx_state<=load; 		
		     
		end case;
end process; 

output_function: process(pr_state)
 begin	 
	triggerOutBuffer <= '0';		
	case pr_state is 
		 when load =>
			cntTrigLenEn <= '0'; cntTrigLenLd <= '1'; 
			cntTrigWaitEn <= '0'; cntTrigWaitLd <= '1'; 			
			triggerOutBuffer <= '0';
		 when st0 => 
			cntTrigLenEn <= '0';  cntTrigLenLd <= '1';
			cntTrigWaitEn <= '0'; cntTrigWaitLd <= '1'; 			
			triggerOutBuffer <= '0';
		 when st1 => 
			cntTrigLenEn <= '0';  cntTrigLenLd <= '0';
			cntTrigWaitEn <= '1'; cntTrigWaitLd <= '0'; 			
			triggerOutBuffer <= '0';
		 when st2 =>		 
			cntTrigLenEn <= '1'; cntTrigLenLd <= '0';	
			cntTrigWaitEn <= '0'; cntTrigWaitLd <= '0'; 			
			triggerOutBuffer <= '1';		
		 when st3 =>		 
			cntTrigLenEn <= '0'; cntTrigLenLd <= '1';	
			cntTrigWaitEn <= '0'; cntTrigWaitLd <= '1'; 			
			triggerOutBuffer <= '0';
		 when others =>
			cntTrigLenEn <= '0';  cntTrigLenLd <= '1';
			cntTrigWaitEn <= '0'; cntTrigWaitLd <= '1'; 			
			triggerOutBuffer <= '0';
		 
	end case;
end process;
trigger_out <= triggerOutBuffer;
end structural;


