library  ieee;
use  ieee.std_logic_1164.all;

entity FSM is
	port(
		rst: in std_logic;
		clk: in std_logic;
		start: in std_logic;
		running: out std_logic;
		z_cnt: in std_logic;
		rst_div: out std_logic;
		en_div: out std_logic;
		en_cnt: out std_logic;
		en_memread: out std_logic
		);
end FSM;

architecture behavioral of FSM is

	type state_type is 
		(idle, inject, reset, error);
	signal state, state_next: state_type;
	
begin
	
	process(rst, clk)
	begin
		if (rst = '1') then
			state <= idle;
		elsif rising_edge(clk) then
			state <= state_next;
		end if;
	end process;
	
	process(state, start, z_cnt)
	begin
		running <= '0';
		rst_div <= '0';
		en_div <= '0';
		en_cnt <= '0';
		en_memread <= '0';
		state_next <= error;
		
		case state is
		when idle =>
			rst_div <= '1';
			if (start = '1') then
				state_next <= inject;
			else
				state_next <= idle;
			end if;
		
		when inject =>
			if (z_cnt = '1') then
				state_next <= reset;
			else
				state_next <= inject;
			end if;
			running <= '1';
			en_div <= '1';
			en_cnt <= '1';
			en_memread <= '1';
		
		when reset =>
			if (z_cnt = '0') then
				state_next <= idle;
			else
				state_next <= reset;
			end if;
			running <= '1';
			en_div <= '1';
			en_cnt <= '1';
			en_memread <= '1';
			--rst_div <= '1';
			
	when others =>
		state_next <= error;
			
		end case;
	end process;
	
end architecture;