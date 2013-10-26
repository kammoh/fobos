library  ieee;
use  ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- num = range(255, 0, -8)
-- num = num[:] + num[::-1]
-- template = 'X"{}", '
-- s = [template.format(hex(v)[2:]) for (i, v) in enumerate(num)]

entity DRAM_MEM is
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
end DRAM_MEM;

architecture behavioral of DRAM_MEM is

	subtype WORD is std_logic_vector(WIDTH_DOUT-1 downto 0);
	type MEM is array(0 to 2**DEPTH_MEM_BITS-1) of WORD;
	signal ram: MEM := (X"ff",  X"f7",  X"ef",  X"e7",  X"df",  X"d7",  X"cf",  X"c7",  
							  X"bf",  X"b7",  X"af",  X"a7",  X"9f",  X"97",  X"8f",  X"87",  
							  X"7f",  X"77",  X"6f",  X"67",  X"5f",  X"57",  X"4f",  X"47",  
							  X"3f",  X"37",  X"2f",  X"27",  X"1f",  X"17",  X"0f",  X"07",  
							  X"07",  X"0f",  X"17",  X"1f",  X"27",  X"2f",  X"37",  X"3f",  
							  X"47",  X"4f",  X"57",  X"5f",  X"67",  X"6f",  X"77",  X"7f",  
							  X"87",  X"8f",  X"97",  X"9f",  X"a7",  X"af",  X"b7",  X"bf",  
							  X"c7",  X"cf",  X"d7",  X"df",  X"e7",  X"ef",  X"f7",  X"ff");
	signal q: WORD;
	--signal q: std_logic_vector(WIDTH_DOUT-1 downto 0);
	

begin
	process(rst, clk)
	begin

		if (rst = '1') then
			q <= ram(0);
		else
			if rising_edge(clk) then
				if (rd = '1') then
					q <= ram(conv_integer(addr));
				end if;
			end if;
		end if;
	end process;
	
	data <= q;
	
end behavioral;

--		ram(0) := X"ff";
--		ram(1) := X"f7";
--		ram(2) := X"ef";
--		ram(3) := X"e7";
--		ram(4) := X"df";
--		ram(5) := X"d7";
--		ram(6) := X"cf";
--		ram(7) := X"c7";
--		ram(8) := X"bf";
--		ram(9) := X"b7";
--		ram(10) := X"af";
--		ram(11) := X"a7";
--		ram(12) := X"9f";
--		ram(13) := X"97";
--		ram(14) := X"8f";
--		ram(15) := X"87";
--		ram(16) := X"7f";
--		ram(17) := X"77";
--		ram(18) := X"6f";
--		ram(19) := X"67";
--		ram(20) := X"5f";
--		ram(21) := X"57";
--		ram(22) := X"4f";
--		ram(23) := X"47";
--		ram(24) := X"3f";
--		ram(25) := X"37";
--		ram(26) := X"2f";
--		ram(27) := X"27";
--		ram(28) := X"1f";
--		ram(29) := X"17";
--		ram(30) := X"f";
--		ram(31) := X"7";
--		ram(32) := X"7";
--		ram(33) := X"f";
--		ram(34) := X"17";
--		ram(35) := X"1f";
--		ram(36) := X"27";
--		ram(37) := X"2f";
--		ram(38) := X"37";
--		ram(39) := X"3f";
--		ram(40) := X"47";
--		ram(41) := X"4f";
--		ram(42) := X"57";
--		ram(43) := X"5f";
--		ram(44) := X"67";
--		ram(45) := X"6f";
--		ram(46) := X"77";
--		ram(47) := X"7f";
--		ram(48) := X"87";
--		ram(49) := X"8f";
--		ram(50) := X"97";
--		ram(51) := X"9f";
--		ram(52) := X"a7";
--		ram(53) := X"af";
--		ram(54) := X"b7";
--		ram(55) := X"bf";
--		ram(56) := X"c7";
--		ram(57) := X"cf";
--		ram(58) := X"d7";
--		ram(59) := X"df";
--		ram(60) := X"e7";
--		ram(61) := X"ef";
--		ram(62) := X"f7";
--		ram(63) := X"ff";
				