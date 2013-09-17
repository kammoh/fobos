----------------------------------------------------------------------------------
--- Company: 
--- Engineer: 
--- 
--- Create Date:    15:30:32 01/09/2013 
--- Design Name: 
--- Module Name:    read_write_test_vhd - Behavioral 
--- Project Name: 
--- Target Devices: 
--- Tool versions: 
--- Description: 
---
--- Dependencies: 
---
--- Revision: 
--- Revision 0.01 - File Created
--- Additional Comments: 
---
----------------------------------------------------------------------------------;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity read_write_test_vhd is
	generic ( addr_width : natural := 26;
					data_width : natural := 16);
    Port ( clk_i : in  STD_LOGIC;
           addr_o : out  STD_LOGIC_VECTOR (addr_width-1 downto 0); --select addr of ;
			  data_i : in std_logic_vector(data_width-1 downto 0);
           data_o : out  STD_LOGIC_VECTOR (data_width-1 downto 0);
           we_o : out  STD_LOGIC;
           go_o : out  STD_LOGIC
			);
end read_write_test_vhd;


--#start_arch 
architecture Behavioral2 of read_write_test_vhd is
	--This arch will write 4 times wich each write taking 1 cycle.  Then it will read each
	--sector that was just written to.  It will read 4 entries with each entry taking 1 second
	--each.  In other words, it will continuosly cycle a read at the same location for 1 second.
	--When entries are read, it will show up on the seven segment display.  It will repeat
	--the 4 reads
	--
	component PES_clock is
	 generic (max_cnt: natural:= 500000); -- max_cnt = (period * clock_in_speed)/2;
    Port ( clock_in : in  STD_LOGIC;
           clock_out : out  STD_LOGIC);
	end component PES_clock;
	signal clk_s : std_logic:= '0';
	signal state_led_s : std_logic_vector(7 downto 0) := (others => '0');
	signal go_s : std_logic := '0';
begin
	make_10MHZ : pes_clock generic map((10**8)/(10**7)/(2))
						port map (clock_in => clk_i, clock_out => clk_s);
	
	go_o <= clk_s;-- when go_s = '1' else '0';
	go_s <= clk_s;
	test : process( go_s )
		type state is (init, write00, write01, write02, write03,
						read00, read01, read02, read03);
		variable st : state:= init ;
		variable cnt_v : integer:= 0;
	begin
		 --;
		if go_s = '1' and go_s'event then 
			case st is
				when init => 
					addr_o <= (others => '0');
					cnt_v := cnt_v +1;
					if cnt_v >= 1600 then st := write00; cnt_v := 0;
					end if;
				when write00 =>
					st := write01;
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"0";
					data_o <= x"A111";
					we_o <= '1'; 
				when write01 =>
					st := write02;
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"1";
					data_o <= x"1B11";
					we_o <= '1';
				when write02 =>
					st := write03;
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"2";
					data_o <= x"11C1";
					we_o <= '1';
				when write03 =>
					st := read00;
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"3";
					data_o <= x"1111";
					we_o <= '1';
				--;
				when read00 =>
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"0";
					we_o <= '0';
					cnt_v := cnt_v + 1;
					if cnt_v >= 10**7 then st := read01; cnt_v := 0; end if;
				when read01 =>
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"1";
					we_o <= '0';
					cnt_v := cnt_v + 1;
					if cnt_v >= 10**7 then st := read02; cnt_v := 0; end if;
				when read02 =>
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"2";
					we_o <= '0';
					cnt_v := cnt_v + 1;
					if cnt_v >= 10**7 then st := read03; cnt_v := 0; end if;
				when read03 =>
					addr_o(addr_o'left downto 4)  <= (others => '0');
					addr_o(3 downto 0) <= x"3";
					we_o <= '0';
					cnt_v := cnt_v + 1;
					if cnt_v >= 10**7 then st := read00; cnt_v := 0; end if;
				when others =>
					st := init;
			end case;
		end if;
	end process;
end Behavioral2;
--#end_arch

--#start_arch
architecture write_then_read of read_write_test_vhd is
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
   data_o(data_width-1 downto 0) <= cur.data_s; 
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
end write_then_read;
--#end_arch

--#start_arch
architecture random_read_write_with_confirm_flag of read_write_test_vhd is
	constant init_time_const : integer := 16000;
	constant rw_cycle_time_const : integer := (10-1);
	type st is ( init, write_x0760, write_x3999, read_x0000, write_x0080, read_x0760
				, write_x0000, read_x3999, read_x0080, write_flag2x7fff, read_x7fff);
	type fsm_sig is record
			state : st;
			we_s, go_s: std_logic;
			addr_s : std_logic_vector(addr_width-1 downto 0);
			data_s : std_logic_vector(data_width-1 downto 0);
			cnt : integer range 0 to init_time_const;
	 end record;
	 signal nxxt, curr: fsm_sig := ( init, '0', '0', (others => '0'), (others => '0'), 0);
	 signal next_error_flag, error_flag: std_logic_vector(data_width-1 downto 0) := (others => '0'); --4 flags x"0" means no error, x"F" means error 
begin
	sync_data: process(clk_i) begin
		if clk_i = '1' and clk_i'event then curr <= nxxt; error_flag <= next_error_flag; end if;
	end process sync_data;
	--
	addr_o <= curr.addr_s;
	data_o <= curr.data_s;
	we_o <= curr.we_s;
	go_o <= curr.go_s;
	--
	comb_logic: process( curr, data_i, error_flag) begin
		nxxt <= curr;
		next_error_flag <= error_flag;
		case curr.state is
			when init => 
				nxxt <= ( init, '0', '0', (others => '0'), (others => '0'), cnt => curr.cnt + 1);
				if curr.cnt >=  init_time_const then 
					nxxt.state <= write_x0760; 
					nxxt.cnt <= 0; 
				end if;
			when write_x0760 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_x3999, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', "00"&x"00_0760", x"BEEF", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_x3999 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt	
					nxxt <=( read_x0760, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go	
					nxxt <=( curr.state, '1', '1', "00"&x"00_3999", x"FEED", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when read_x0760 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_x0080, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					--set flag
					if data_i = x"beef" then next_error_flag <= error_flag AND x"F0FF";
					else next_error_flag <= error_flag OR x"0F00";
					end if;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', "00"&x"00_0760", x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_x0080 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_x3999, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', "00"&x"00_0080", x"ABCD", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when read_x3999 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_x0000, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					--set flag
					if data_i = x"feed" then next_error_flag <= error_flag AND x"FF0F";
					else next_error_flag <= error_flag OR x"00F0";
					end if;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', "00"&x"00_3999", x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_x0000 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_x0080, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', "00"&x"00_0000", x"aaa9", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when read_x0080 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_x0000, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					--set flag
					if data_i = x"ABCD" then next_error_flag <= error_flag AND x"FFF0";
					else next_error_flag <= error_flag OR x"000F";
					end if;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', "00"&x"00_0080", x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;	
			when read_x0000 => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_flag2x7fff, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					 if data_i = x"aaa9" then next_error_flag <= error_flag AND x"0FFF";--set flag
					 else next_error_flag <= error_flag OR x"F000";
					 end if;
					--next_error_flag <= data_i;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', "00"&x"00_0000", x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_flag2x7fff => -- write the error flag to memory
				--nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_x7fff, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', "11"&x"ff_7fff", error_flag, curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when read_x7fff => --read the error flag from memory
				--nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_x7fff, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', "11"&x"ff_7fff", x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when others =>
				nxxt <= ( init, '0', '0', (others => '0'), (others => '0'), 0);
		end case;
	end process comb_logic;
end random_read_write_with_confirm_flag;
--#end_arch

--#start_arch
architecture random_read_write_with_confirm_flag2 of read_write_test_vhd is
	constant init_time_const : integer := 16000;
	constant rw_cycle_time_const : integer := (10-1);
	type addr_data_r is record
		addr_const : std_logic_vector(addr_width-1 downto 0);
		data_const : std_logic_vector(data_width-1 downto 0);
	end record;
	constant pair_A : addr_data_r := (	"00"& x"01"& x"0760", x"0101");
	constant pair_B : addr_data_r := (	"00"& x"01"& x"2100", x"0123");
	constant pair_C : addr_data_r := (	"00"& x"01"& x"0080", x"468A");
	constant pair_D : addr_data_r := (	"00"& x"01"& x"0000", x"a5aa");
	shared variable echo_A, echo_B, echo_C, echo_D : std_logic_vector (data_width-1 downto 0) := (others => '0');
	type st is ( init, write_A, write_B, read_D, write_C, read_A
				, write_d, read_b, read_c, write_flag2x7fff, read_x7fff);
	type fsm_sig is record
			state : st;
			we_s, go_s: std_logic;
			addr_s : std_logic_vector(addr_width-1 downto 0);
			data_s : std_logic_vector(data_width-1 downto 0);
			cnt : integer range 0 to 4*(10**8) ;--init_time_const;
	 end record;
	 signal nxxt, curr: fsm_sig := ( init, '0', '0', (others => '0'), (others => '0'), 0);
	 signal next_error_flag, error_flag: std_logic_vector(data_width-1 downto 0) := (others => '0'); --4 flags x"0" means no error, x"F" means error 
	type echo_stuff is record
		A,B,C,D: std_logic_vector(data_width-1 downto 0);
	end record;
	signal e_nxt, e_cur: echo_stuff := (others => (others => '0'));
begin
	sync_data: process(clk_i) begin
		if clk_i = '1' and clk_i'event then curr <= nxxt; error_flag <= next_error_flag; e_cur <= e_nxt; end if;
	end process sync_data;
	--
	addr_o <= curr.addr_s;
	data_o <= curr.data_s;
	we_o <= curr.we_s;
	go_o <= curr.go_s;
	--
	comb_logic: process( curr, data_i, error_flag, e_cur) begin
		nxxt <= curr;
		next_error_flag <= error_flag;
		e_nxt <= e_cur;
		case curr.state is
			when init => 
				nxxt <= ( init, '0', '0', (others => '0'), (others => '0'), cnt => curr.cnt + 1);
				if curr.cnt >=  init_time_const then 
					nxxt.state <= write_A; 
					nxxt.cnt <= 0; 
				end if;
			when write_A => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_b, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', pair_A.addr_const, pair_A.data_const, curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_b => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt	
					nxxt <=( read_A, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go	
					nxxt <=( curr.state, '1', '1', pair_B.addr_const, pair_B.data_const, curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when read_A => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_C, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					e_nxt.A <= data_i;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', pair_A.addr_const, x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_C => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_b, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', pair_c.addr_const, pair_c.data_const, curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when read_b => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_D, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					e_nxt.b <= data_i;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', pair_b.addr_const, x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_D => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_C, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', pair_d.addr_const, pair_d.data_const, curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when read_C => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( read_D, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					e_nxt.C <= data_i;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', pair_c.addr_const, x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;	
			when read_D => --nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, curr.cnt); --armument list reminder
				if curr.cnt >= rw_cycle_time_const then --final time transitions and resets cnt
					nxxt <=( write_flag2x7fff, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
					e_nxt.D <= data_i;
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', pair_d.addr_const, x"0000", curr.cnt + 1);
				else  --middle lower we and go and increments cnt
					nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				end if;
			when write_flag2x7fff => -- write the error flag to memory
				nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				if curr.cnt >= 39 then --final time transitions and resets cnt
					nxxt <=( read_x7fff, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 30 then 
					nxxt <=( curr.state, '1', '1', "11"&x"ff_7ffc", e_cur.D, curr.cnt + 1);
				elsif curr.cnt = 20 then 
					nxxt <=( curr.state, '1', '1', "11"&x"ff_7ffd", e_cur.C, curr.cnt + 1);
				elsif curr.cnt = 10 then 
					nxxt <=( curr.state, '1', '1', "11"&x"ff_7ffe", e_cur.B, curr.cnt + 1);	
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', "11"&x"ff_7fff", e_cur.A, curr.cnt + 1);
				end if;
			when read_x7fff => --read the error flag from memory
				nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				if curr.cnt >= 4*(10**8)-1 then --final time transitions and resets cnt
					nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);	
				elsif curr.cnt = 3*(10**8) then 
					nxxt <=( curr.state, '0', '1', "11"&x"ff_7ffc", x"0000", curr.cnt + 1);
				elsif curr.cnt = 2*(10**8) then 
					nxxt <=( curr.state, '0', '1', "11"&x"ff_7ffd", x"0000", curr.cnt + 1);
				elsif curr.cnt = 10**8 then 
					nxxt <=( curr.state, '0', '1', "11"&x"ff_7ffe", x"0000", curr.cnt + 1);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', "11"&x"ff_7fff", x"0000", curr.cnt + 1);
				end if;
			when others =>
				nxxt <= ( init, '0', '0', (others => '0'), (others => '0'), 0);
		end case;
	end process comb_logic;
end random_read_write_with_confirm_flag2;
--#end_arch

--#start_arch
architecture random_read_write_with_confirm_flag3 of read_write_test_vhd is
	constant init_time_const : integer := 16000;
	constant rw_cycle_time_const : integer := (10-1);
	type addr_data_r is record
		addr_const : std_logic_vector(addr_width-1 downto 0);
		data_const : std_logic_vector(data_width-1 downto 0);
	end record;
	constant pair_A : addr_data_r := (	"00"& x"01"& x"0760", x"0101");
	constant pair_B : addr_data_r := (	"00"& x"01"& x"4100", x"0123");
	constant pair_C : addr_data_r := (	"00"& x"01"& x"0080", x"468A");
	constant pair_D : addr_data_r := (	"00"& x"01"& x"0000", x"aaaa");
	shared variable echo_A, echo_B, echo_C, echo_D : std_logic_vector (data_width-1 downto 0) := (others => '0');
	type st is ( init, write_flag2x7fff, read_x7fff);
	type fsm_sig is record
			state : st;
			we_s, go_s: std_logic;
			addr_s : std_logic_vector(addr_width-1 downto 0);
			data_s : std_logic_vector(data_width-1 downto 0);
			cnt : integer range 0 to 4*(10**8) ;--init_time_const;
	 end record;
	 signal nxxt, curr: fsm_sig := ( init, '0', '0', (others => '0'), (others => '0'), 0);
	 signal next_error_flag, error_flag: std_logic_vector(data_width-1 downto 0) := (others => '0'); --4 flags x"0" means no error, x"F" means error 
	type echo_stuff is record
		A,B,C,D: std_logic_vector(data_width-1 downto 0);
	end record;
	signal e_nxt, e_cur: echo_stuff := (others => (others => '0'));
begin
	sync_data: process(clk_i) begin
		if clk_i = '1' and clk_i'event then curr <= nxxt;  end if;
	end process sync_data;
	--
	addr_o <= curr.addr_s;
	data_o <= curr.data_s;
	we_o <= curr.we_s;
	go_o <= curr.go_s;
	--
	comb_logic: process( curr, data_i, error_flag, e_cur) begin
		nxxt <= curr;
		next_error_flag <= error_flag;
		e_nxt <= e_cur;
		case curr.state is
			when init => 
				nxxt <= ( init, '0', '0', (others => '0'), (others => '0'), cnt => curr.cnt + 1);
				if curr.cnt >=  init_time_const then 
					nxxt.state <= write_flag2x7fff; 
					nxxt.cnt <= 0; 
				end if;
			when write_flag2x7fff => -- write the error flag to memory
				nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				if curr.cnt >= 39 then --final time transitions and resets cnt
					nxxt <=( read_x7fff, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);
				elsif curr.cnt = 30 then 
					nxxt <=( curr.state, '1', '1', pair_D.addr_const, pair_D.data_const, curr.cnt + 1);
				elsif curr.cnt = 20 then 
					nxxt <=( curr.state, '1', '1', pair_C.addr_const, pair_C.data_const, curr.cnt + 1);
				elsif curr.cnt = 10 then 
					nxxt <=( curr.state, '1', '1', pair_B.addr_const, pair_B.data_const, curr.cnt + 1);	
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '1', '1', pair_A.addr_const, pair_A.data_const, curr.cnt + 1);
				end if;
			when read_x7fff => --read the error flag from memory
				nxxt <=( curr.state, '0', '0', curr.addr_s, curr.data_s, curr.cnt + 1);
				if curr.cnt >= 4*(10**8)-1 then --final time transitions and resets cnt
					nxxt <=( curr.state, curr.we_s, curr.go_s, curr.addr_s, curr.data_s, 0);	
				elsif curr.cnt = 3*(10**8) then 
					nxxt <=( curr.state, '0', '1', pair_D.addr_const, x"0000", curr.cnt + 1);
				elsif curr.cnt = 2*(10**8) then 
					nxxt <=( curr.state, '0', '1', pair_c.addr_const, x"0000", curr.cnt + 1);
				elsif curr.cnt = 10**8 then 
					nxxt <=( curr.state, '0', '1', pair_b.addr_const, x"0000", curr.cnt + 1);
				elsif curr.cnt = 0 then --first time sends go
					nxxt <=( curr.state, '0', '1', pair_a.addr_const, x"0000", curr.cnt + 1);
				end if;
			when others =>
				nxxt <= ( init, '0', '0', (others => '0'), (others => '0'), 0);
		end case;
	end process comb_logic;
end random_read_write_with_confirm_flag3;
--#end_arch





