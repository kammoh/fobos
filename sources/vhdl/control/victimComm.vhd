library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fobos_package.all;

entity victimComm is 
	port(
	     clock: in std_logic;
		 start : in std_logic;
		 reset: in std_logic;	 
		 targetClock : in std_logic;
		 src_read  : in std_logic;
		 dst_write : in std_logic;
		 block_size : in std_logic_vector(7 downto 0);
		 key_size : in std_logic_vector(7 downto 0);
		 vdlRst : out std_logic;
		 vdlEnb : out std_logic;
		 vklRst : out std_logic;
		 vklEnb : out std_logic;		 
		 vrRst : out std_logic;
		 vrEnb : out std_logic;
		 src_ready : out std_logic;
		 dst_ready : out std_logic		 
		 );
end victimComm;


architecture structure of victimComm is
type state is (boot, init1, st1, st2, st3, st4, st5); 
signal pr_state,nx_state:state;

signal load_cnt_key, enb_cnt_key, load_cnt_data, enb_cnt_data, load_cnt_ct, enb_cnt_ct : std_logic;
signal data_set, key_set, ct_set : std_logic;  
signal dataBlockSize, keyBlockSize, vDataBlockSize : std_logic_vector(7 downto 0);

begin
	
------------------------ Control signals to Victim Controller------------
dataTovictimCounter : 	counter generic map(N => 8) port map(
		 clk => targetClock,
		 reset => load_cnt_data,
		 enable => enb_cnt_data,
		 counter_out => dataBlockSize);
keyTovictimCounter : 	counter generic map(N => 8) port map(
		 clk => targetClock,
		 reset => load_cnt_key,
		 enable => enb_cnt_key,
		 counter_out => keyBlockSize);
		 
dataFromVictimCounter :  counter generic map(N => 8) port map(
		 clk => targetClock,
		 reset => load_cnt_data,
		 enable => enb_cnt_data,
		 counter_out => vDataBlockSize);
		 		 

data_set <= '1' when  dataBlockSize >= block_size else '0';
key_set <= '1' when  keyBlockSize >= key_size else '0';
ct_set <= '1' when vDataBlockSize >= block_size else '0';
-----------------------------------------------------------------------------------	
present_state:	process (reset,clock)
					begin
						if(reset='1') then
							pr_state<=boot;
						elsif (clock'event and clock='1')then
							pr_state<=nx_state;
						end if;
end process;
-------------------------------------------------------------------------------------
next_state_function: process(clock,src_read,key_set,data_set)
  begin
	  case pr_state is
		  when boot =>
		  if(start = '0') then
		  nx_state <= boot;
		  else
		  nx_state <= init1;
		  end if;
		  when init1 =>
		  if (src_read = '0') then
		  nx_state <= init1;
		  else
		  nx_state <= st1;
		  end if;

		  when st1 =>
		  if (key_set = '0') then	
			  nx_state <= st1;
		  else
			  nx_state<= st2;
		  end if;

		  when st2 =>
		  if (data_set = '0') then	
			  nx_state <= st2;
		  else
			  nx_state<= st3;
		  end if;
		  
		  when st3 => 
		  if (dst_write = '0') then
			  nx_state <= st3;
		  else 
			  nx_state <= st4;
		  end if;
		  
		  when st4 =>
		  if (ct_set='0') then
				nx_state <= st4;
		  else
				nx_state <= boot;
		  end if;
		end case;
end process; 
------------------------------------------------------------------------
 output_function: process(pr_state)
 begin	 
   src_ready <= '0';dst_ready <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '0';
		
	case pr_state is 
		 when boot =>
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1';load_cnt_ct <= '1';enb_cnt_ct <= '0'; 
		 enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '0';vdlRst <= '1'; vdlEnb <= '0'; vklRst <= '1'; vklEnb <= '0'; vrRst <= '1'; vrEnb <= '0';
		 when init1 =>
		 src_ready <= '1'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '0';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '1'; vdlEnb <= '0'; vklRst <= '1'; vklEnb <= '0'; vrRst <= '1'; vrEnb <= '0';
		 when st1 => 
		 src_ready <= '1'; load_cnt_key <= '0'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '1';dst_ready <= '0';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '1'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '1'; vrRst <= '1'; vrEnb <= '0';
		 when st2 =>		 
	 	 src_ready <= '1'; load_cnt_key <= '1'; load_cnt_data <= '0'; enb_cnt_data<= '1'; enb_cnt_key<= '0';dst_ready <= '0';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '1'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '0';
		 when st3=>
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '1';	 
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '0';
		 when st4=>		  
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0';dst_ready <= '1';	 
		 load_cnt_ct <= '0';enb_cnt_ct <= '1';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '1';
		 when others =>
		 src_ready <= '0'; load_cnt_key <= '1'; load_cnt_data <= '1'; enb_cnt_data<= '0'; enb_cnt_key<= '0'; dst_ready <= '0';
		 load_cnt_ct <= '1';enb_cnt_ct <= '0';vdlRst <= '0'; vdlEnb <= '0'; vklRst <= '0'; vklEnb <= '0'; vrRst <= '0'; vrEnb <= '0';
	end case;
end process;


end structure; 