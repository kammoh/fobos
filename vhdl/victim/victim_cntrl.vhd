library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.victim_pkg.all;

entity victim_contrl is 
	port(
	     clock: in std_logic;
		 reset: in std_logic;
		 src_ready : in std_logic;
		 dst_ready : in std_logic;
		 done_exe : in std_logic;
		 cmd_buffer : in std_logic_vector( 15 downto 0);
		 start_to_crypto : out std_logic;
		 src_read  : out std_logic;
		 dst_write : out std_logic;
		 data_enb : out std_logic;
		 key_enb : out std_logic;
		 cmd_enb : out std_logic;
		 sr_output_enb : out std_logic;
		 sr_output_load : out std_logic

		 );
end victim_contrl;

architecture structure of victim_contrl is
type STATE is (init1, ldcmd, init2, start, st1, st2, st3, st4, st5, st6, last); 
signal pr_state,nx_state:state;
signal buffer_full_key, buffer_full_data, load_cnt_data, load_cnt_key, load_cnt_output, buffer_empty, key_data_bit, load_cnt : std_logic;
signal cnt_out1, cnt_out2, cnt_out3 : std_logic_vector( 12 downto 0); 
signal bytes_check : std_logic_vector (12 downto 0);
signal enb_cnt_data, enb_cnt_key, enb_cnt_output :std_logic;
begin
	bytes_check <= cmd_buffer(14 downto 2);
------------------------ Control signals to Victim Controller------------
count_input_key : 	counter generic map(N => 13) port map(
		 clock => clock,
		 reset => reset,
		 load => load_cnt_key,
		 enable => enb_cnt_key,
		 data_in => bytes_check ,
		 q => cnt_out1);
buffer_full_key <= '1' when cnt_out1 = "0000000000001"  else '0';

count_input_data : 	counter generic map(N => 13) port map(
		 clock => clock,
		 reset => reset,
		 load => load_cnt_data,
		 enable => enb_cnt_data,
		 data_in => bytes_check ,
		 q => cnt_out2);
buffer_full_data <= '1' when cnt_out2 = "0000000000001" else '0';

------------------------ Control signals to Victim Controller------------
count_output : 	counter generic map(N => 13) port map(
		 clock => clock,
		 reset => reset,
		 load => load_cnt_output,
		 enable => enb_cnt_output,
		 data_in => bytes_check,
		 q => cnt_out3);
buffer_empty <= '1' when cnt_out3 = "0000000000001" else '0';

key_data_bit <= cmd_buffer(0);
-----------------------------------------------------------------------------------	
present_state:	process (reset,clock)
					begin
						if(reset='1') then
							pr_state<=init1;
						elsif (clock'event and clock='1')then
							pr_state<=nx_state;
						end if;
end process;
-------------------------------------------------------------------------------------
next_state_function: process(clock,reset,src_ready, buffer_full_key,buffer_full_data, buffer_empty,done_exe, key_data_bit, dst_ready)
  begin
	  case pr_state is
		  when init1 =>
		  if (src_ready = '0') then
		  nx_state <= init1;
		  else
		  	if (key_data_bit = '1') then 
			  	nx_state<= st2;
		  	else
			  nx_state<=st3;
		  	end if;
		  end if;
		  
--		  when ldcmd =>
--		  nx_state <= st1;
--		  
--		  when st1 =>
--		  if (key_data_bit = '1') then 
--			  nx_state<= st2;
--		  else
--			  nx_state<=st3;
--		  end if;
		  
		  when st2 =>
		  if (buffer_full_key = '0' and src_ready = '1') then	
			  nx_state <= st2;
		  elsif (buffer_full_key = '1' and src_ready = '1' and buffer_full_data = '0') then
			  nx_state <= init1;
		  else
			  nx_state<= st4;
		  end if;
		  
		  when st3 =>
		  if (buffer_full_data = '0' and src_ready = '1') then	
			  nx_state <= st3;
		  elsif (buffer_full_data = '1' and src_ready = '1' and buffer_full_key = '0') then
			  nx_state <= init1;
		  else
			  nx_state<= st4;
		  end if;
		  
		  when st4 =>
		  if (done_exe = '1') then
			  nx_state <= st5;
		  else
			  nx_state <= st4;
		  end if;		  
		  
		  when st5=>
		  		if (dst_ready = '1') then
		  			nx_state <= last;
		  		else
					nx_state <= st5;
				end if;
				  
		  when others=>
		  if(buffer_empty='0') then
			  nx_state<= last;
		  else
			  nx_state<=init1;
		  end if; 		
		     
		end case;
end process; 
------------------------------------------------------------------------
 output_function: process(pr_state)
 begin	 
 dst_write<='0'; src_read<='0';--	start <= '0';data_enb <= '0';key_enb <= '0';cmd_enb <= '0';sr_output_enb <= '0';sr_output_load <= '0';load_cnt <= '1';
		
	case pr_state is 
		 when init1 =>
		 dst_write<='0';  
		 src_read<='1';	
		 start_to_crypto <= '1';
		 data_enb <= '0';
		 key_enb <= '0';
		 cmd_enb <= '0';
		 sr_output_enb <= '0';
		 sr_output_load <= '0';
		 load_cnt_key <= '1'; enb_cnt_key <= '0';
		 load_cnt_data <= '1'; enb_cnt_data <= '0';
		 load_cnt_output <= '1';enb_cnt_output <= '0';
		 
--		 when ldcmd =>
--		 dst_write<='0'; 
--		 src_read<='1';	
--		 start_to_crypto <= '1';
--		 data_enb <= '0';
--		 key_enb <= '0';
--		 cmd_enb <= '1';
--		 sr_output_enb <= '0';
--		 sr_output_load <= '0';
--		 load_cnt_key <= '0'; enb_cnt_key <= '0';
--		 load_cnt_data <= '0'; enb_cnt_data <= '0';
--		 load_cnt_output <= '0';enb_cnt_output <= '0';
		 
		 when st1 => 
		 dst_write<='0'; 
		 src_read<='1';	
		 start_to_crypto <= '1';
		 data_enb <= '0';
		 key_enb <= '0';
		 cmd_enb <= '0';
		 sr_output_enb <= '0';
		 sr_output_load <= '0';
		 load_cnt_key <= '0'; enb_cnt_key <= '0';
		 load_cnt_data <= '0'; enb_cnt_data <= '0';
		 load_cnt_output <= '0';enb_cnt_output <= '0';
		 
		 when st2 =>		 
		 dst_write<='0'; 
		 src_read<='1';	
		 start_to_crypto <= '1';
		 data_enb <= '0';
		 key_enb <= '1';
		 cmd_enb <= '0';
		 sr_output_enb <= '0';
		 sr_output_load <= '0';
		 load_cnt_key <= '0'; enb_cnt_key <= '1';
		 load_cnt_data <= '0'; enb_cnt_data <= '0';
		 load_cnt_output <= '0';enb_cnt_output <= '0';
		 
		 when st3=>
		 
		 dst_write<='0'; 
		 src_read<='1';	
		 start_to_crypto <= '1';
		 data_enb <= '1';
		 key_enb <= '0';
		 cmd_enb <= '0';
		 sr_output_enb <= '0';
		 sr_output_load <= '0';
		 load_cnt_key <= '0'; enb_cnt_key <= '0';
		 load_cnt_data <= '0'; enb_cnt_data <= '1';
		 load_cnt_output <= '0';enb_cnt_output <= '0';
		 
--		 when init2 =>
--		 dst_write<='0'; 
--		 src_read<='1';	
--		 start_to_crypto <= '0';
--		 data_enb <= '0';
--		 key_enb <= '0';
--		 cmd_enb <= '1';
--		 sr_output_enb <= '0';
--		 sr_output_load <= '0';
--		 load_cnt <= '1';
--		 
		 when st4=>		 --crypto run
		 
		 dst_write<='0'; 
		 src_read<='0';	
		 start_to_crypto <= '0';
		 data_enb <= '0';
		 key_enb <= '0';
		 cmd_enb <= '0';
		 sr_output_enb <= '0';
		 sr_output_load <= '0';
		 load_cnt_key <= '0'; enb_cnt_key <= '0';
		 load_cnt_data <= '0'; enb_cnt_data <= '0';
		 load_cnt_output <= '0';enb_cnt_output <= '0';
		 
		 when st5=>
		 dst_write<='1'; 
		 src_read<='0';	
		 start_to_crypto <= '0';
		 data_enb <= '0';
		 key_enb <= '0';
		 cmd_enb <= '0';
		 sr_output_enb <= '0';
		 sr_output_load <= '1';
		 load_cnt_key <= '0'; enb_cnt_key <= '0';
		 load_cnt_data <= '0'; enb_cnt_data <= '0';
		 load_cnt_output <= '0';enb_cnt_output <= '0';
		 
		 when others =>
		 
		 dst_write<='1'; 
		 src_read<='0';	
		 start_to_crypto <= '0';
		 data_enb <= '0';
		 key_enb <= '0';
		 cmd_enb <= '0';
		 sr_output_enb <= '1';
		 sr_output_load <= '0';
		 load_cnt_key <= '0'; enb_cnt_key <= '0';
		 load_cnt_data <= '0'; enb_cnt_data <= '0';
		 load_cnt_output <= '0';enb_cnt_output <= '1';
		 
	end case;
end process;


end structure; 