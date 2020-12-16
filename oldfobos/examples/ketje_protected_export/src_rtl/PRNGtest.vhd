-- PRNG

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity PRNGtest is
	 generic( S: integer:=128;
			    R: integer:=32;
				 L: integer:=8);
    port(
	clk		: in std_logic;
	--rst		: in std_logic;
	--en		: in std_logic;
	ld		: in std_logic:='0';
   rseed            : in  std_logic_vector(S-1 downto 0);
   rnum    		: out std_logic_vector(R-1 downto 0)
    );

end PRNGtest;

architecture structural of PRNGtest is

type lfsr_column is array (0 to R-1) of std_logic_vector(L-1 downto 0);
type next_bit_array is array(0 to R-1) of std_logic;

signal next_num : lfsr_column;
signal next_seq, num_reg : lfsr_column;
signal next_bit : next_bit_array;
--signal rseed : std_logic_vector(S-1 downto 0):=(others => '0');
 
begin


i1: for i in 0 to R-1 generate

next_seq(i) <= rseed((i*3) mod (S-8) + 7 downto (i*3) mod (S-8)) + rseed((i*7) mod (S-8) + 7 downto (i*7) mod (S-8)) when (ld = '1') else num_reg(i);

rnum(i) <= next_bit(i);
--next_bit(i) <= next_seq(i)(0) xor next_seq(i)(1) xor next_seq(i)(2) xor next_seq(i)(7); -- LFSR x^4 + x^3 + 1
next_bit(i) <= next_seq(i)(0) xor next_seq(i)(2) xor next_seq(i)(3) xor next_seq(i)(4); -- LFSR x^4 + x^3 + 1

next_num(i) <= next_bit(i) & next_seq(i)(L-1 downto 1);

 reg1: entity work.regn(behavioral)
	generic map(N=>L)
	port map(
		clk => clk,
		--rst => rst,
		en => '1',
		d  => next_num(i),
		q  => num_reg(i)
		);

end generate i1;

end architecture structural;
