library  ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity INJECTION is
	generic(
		WIDTH_DOUT: natural := 8;
		DEPTH_MEM_BITS: natural := 6;
		WIDTH_SPEED: natural := 8
			);
	port(
		rst: in std_logic;
		clk:  in std_logic;
		inj_fault: in std_logic;
		injecting: out std_logic;
		dout: out std_logic_vector(WIDTH_DOUT-1 downto 0);
		dac_clk: out std_logic
		);
end injection;

architecture structural of INJECTION is

	component FSM is
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
	end component;

	component DRAM_MEM is
		generic(
			WIDTH_DOUT: natural;
			DEPTH_MEM_BITS: natural
				);
		port(
			rst: in std_logic;
			clk: in std_logic;
			rd: in std_logic;
			addr: in std_logic_vector(DEPTH_MEM_BITS-1 downto 0);
			data: out std_logic_vector(WIDTH_DOUT-1 downto 0)
			);
	end component;
	
	component COUNTER is
		generic(
			WIDTH_CNT: natural;
			MAX_CNT: natural
				);
		port(
			rst: in std_logic;
			clk: in std_logic;
			en: in std_logic;
			clear: in std_logic;
			cnt: out std_logic_vector(WIDTH_CNT-1 downto 0)
			);
	end component;
	
	component CLK_DIV is
	generic(
		DIV_AMT: natural	-- Divisor value, should be even to ensure proper divison amount
			);
	port(
		rst: in std_logic;
		clk: in std_logic;
		rst_div: in std_logic;
		en_div: in std_logic;
		clk_div: out std_logic
		);
	end component;
	
	component SHIFT_REG is
		generic(
			DEPTH: natural
				);
		port(rst : in  STD_LOGIC;
				clk : in  STD_LOGIC;
				en: in STD_LOGIC;
				din : in  STD_LOGIC;
				dout : out  STD_LOGIC);
	end component;
		
	signal z_cnt: std_logic;
	signal rst_div: std_logic;
	signal en_div: std_logic;
	signal en_cnt: std_logic;
	signal en_memread: std_logic;
	signal en_counter: std_logic;
	signal clk_divided: std_logic;
	--signal clk_divided_dly: std_logic;
	signal mem_addr: std_logic_vector(DEPTH_MEM_BITS-1 downto 0);
	
	constant MAX_CNT_VALUE: natural := 2**DEPTH_MEM_BITS-1;
	
begin

	en_counter <= en_cnt AND clk_divided;
	z_cnt <= '1' when (unsigned(mem_addr) = conv_unsigned(MAX_CNT_VALUE, DEPTH_MEM_BITS)) else '0';
	
	state_machine: FSM 
		port map(rst => rst,
					clk => clk,
					start => inj_fault,
					running => injecting,
					z_cnt => z_cnt,
					rst_div => rst_div,
					en_div => en_div,
					en_cnt => en_cnt,
					en_memread => en_memread
					);
			
			
	waveform: DRAM_MEM 
		generic map(
						WIDTH_DOUT => WIDTH_DOUT,
						DEPTH_MEM_BITS => DEPTH_MEM_BITS
						)
		port map(rst => rst,
					clk => clk,
					rd => en_memread,
					addr => mem_addr,
					data => dout
					);
				
				
	count_mod_n: COUNTER
		generic map(
						WIDTH_CNT => DEPTH_MEM_BITS,
						MAX_CNT => MAX_CNT_VALUE
						)
		port map(rst => rst,
					clk => clk,
					en => en_counter,
					clear => rst_div,
					cnt => mem_addr
					);
								  
	
	speed_select: CLK_DIV
		generic map(
						DIV_AMT => 64
						)
		port map(rst => rst,
					clk => clk,
					rst_div => rst_div,
					en_div => en_div,
					clk_div => clk_divided
					);
					
	dac_clk_delay: SHIFT_REG
		generic map(
						DEPTH => 3
						)
		port map(rst => rst,
					clk => clk,
					en => en_div,
					din => clk_divided,
					dout => dac_clk
					);
								  
end architecture;
								