library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--
--	Memory Hardware Abstraction Layer (H.A.L)
--

entity HAL is
	generic ( addr_width : natural := 26;
			  data_width : natural := 16);
    Port ( 
			clk_i : in  STD_LOGIC;
			rst : in  STD_LOGIC;
			-- Interface to rest of Sample Collection module
			sample_din : in std_logic_vector(data_width-1 downto 0);
			sample_dout : out  STD_LOGIC_VECTOR (data_width-1 downto 0);
			wr_en : in STD_LOGIC;
			rd_en : in STD_LOGIC;
			full : out STD_LOGIC;
			empty : out STD_LOGIC;
--			ready : out STD_LOGIC;
			-- Interface to Memory Controller
			addr_o : out  STD_LOGIC_VECTOR (addr_width-1 downto 0); --select addr of ;
			data_i : in std_logic_vector(data_width-1 downto 0);
			data_o : out  STD_LOGIC_VECTOR (data_width-1 downto 0);
			we_o : out  STD_LOGIC;
			go_o : out  STD_LOGIC
			);
end HAL;


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------BEGIN NO MEM HAL--------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
architecture no_mem of HAL is
	
begin
	sample_dout <= (others => '0');
	full <= '1';
	empty <= '1';
--	ready <= '0';
	
	addr_o <= (others => '0');
	data_o <= (others => '0');
	we_o <= '0';
	go_o <= '0';
end no_mem;
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------END NO MEM HAL----------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------BEGIN SLOW MEM HAL------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--#start_arch
architecture slow_mem of HAL is
	--This arch will write a unique number to address's 0 to 16k.  
	--for each memory location 0 to 16k.  It will do one cycle of reading
	--and then have 1/4 second of idle time.  Idle time is used to show what was read.
	--it will repeat the reads when it reaches 16k.
	 constant init_time_const : integer := 16000;
	 constant delay_write_time_const : integer := 9-1;
	 constant hold_data_time_const : integer := (10**8)/4;
	 constant max_cnt_const : integer := (2**14)-1;
	 type st is (init, do_writes,  delay_write ,do_read, hold_data_for_one_second);
	 signal nextstate, state : st := init;
	 type fsm_sig is record
			we_s, go_s: std_logic;
			addr_s : std_logic_vector(addr_width-1 downto 0);
			data_s : std_logic_vector(data_width-1 downto 0);
			cnt : integer range 0 to max_cnt_const; 
			recycle : integer range 0 to hold_data_time_const;
	  end record;
			signal nxt : fsm_sig := ( '0', '0', ( others => '0'), ( others => '0'), 0, 0);
			signal cur : fsm_sig := ( '0', '0', ( others => '0'), ( others => '0'), 0, 0);
begin
   addr_o(addr_width-1 downto 0) <= cur.addr_s; 
   data_o(data_width-1 downto 0) <= "0000000000000000";--cur.data_s; 
	we_o <= cur.we_s;
	go_o <= cur.go_s;

	sync_data: process(clk_i) begin
		if clk_i = '1' and clk_i'event then
			state <= nextstate;
			cur <= nxt;
		end if;
	end process sync_data;
	output_proc: process(state,  cur)begin
		nxt <= cur;
		
		if state = init then 
			nxt <= ( we_s => '0', go_s => '0', recycle => (cur.recycle + 1), cnt => 0,
						addr_s => (others => '0'), data_s => (others => '0'));
			if cur.recycle >= init_time_const then nxt.recycle <= 0; end if;
		elsif state = do_writes then 
			nxt <= ( we_s => '1', go_s => '1', cnt => (cur.cnt +1), recycle => cur.recycle,
						addr_s =>	conv_std_logic_vector( cur.cnt , addr_width), 
						data_s => conv_std_logic_vector( (cur.cnt), data_width)); 
		elsif state = delay_write then 
			nxt.we_s <= '0';
			nxt.go_s <= '0';
			nxt.recycle <= cur.recycle + 1;
			if cur.recycle >= delay_write_time_const then 
				if cur.cnt >= max_cnt_const then 
					nxt.cnt <= 0; 
				end if;
				nxt.recycle <= 0; 
			end if;
		elsif state = do_read then 
			nxt <= ( we_s => '0', go_s => '1', cnt => (cur.cnt +1), recycle => cur.recycle,
						addr_s =>	conv_std_logic_vector( cur.cnt , addr_width), 
						data_s => (3 => '1', 2 => '0', 1 => '1', 0 => '0',
										 others => '0'
											)
						); 
		elsif state = hold_data_for_one_second then 
			 nxt.we_s <= '0';
			 nxt.go_s <= '0';
			 nxt.recycle <= cur.recycle + 1;
			 if cur.cnt >= max_cnt_const then nxt.cnt <= 0; end if;
			 if cur.recycle >= hold_data_time_const then nxt.recycle <= 0; end if;
		else
			nxt <= ( we_s => '0', go_s => '0', cnt => 0, recycle => 0, 
					addr_s => (others => '0'), data_s => (others => '0'));
		end if;
	end process output_proc;
	
	trans_proc: process(state, cur)begin
		nextstate <= state;
		case state is
			when init => 
				if cur.recycle >=  init_time_const then nextstate <= do_writes; end if;
			when do_writes => 
				nextstate <= delay_write;
			when delay_write =>
				if cur.recycle >= delay_write_time_const then
					if cur.cnt >= max_cnt_const then
						nextstate <= do_read;
					else  
						nextstate <= do_writes;
					end if;
				end if;
			when do_read =>
				nextstate <= hold_data_for_one_second;
			when hold_data_for_one_second =>
				if cur.recycle >= hold_data_time_const then nextstate <= do_read; end if;
			when others =>
				nextstate <= init;
		end case;
	end process trans_proc;
	
end slow_mem;
--#end_arch
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------END NO MEM HAL----------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


