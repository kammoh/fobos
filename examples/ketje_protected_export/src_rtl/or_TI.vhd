

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;

entity or_TI is
    Port ( 
           xa, xb : in std_logic;
           ya, yb : in std_logic;
           m1, m2 : in std_logic;
           o1, o2 : out std_logic
    
           );
end or_TI;

architecture structural of or_TI is

signal x1, x2, x3, y1, y2, y3, z1, z2, z3 : std_logic;

attribute keep : string;
attribute keep of x1, x2, x3, y1, y2, y3, z1, z2, z3 : signal is "true";

begin

    x1 <= xa xor m1;
    x2 <= m1;
    x3 <= xb;
    
    y1 <= yb;
    y2 <= m2;
    y3 <= ya xor m2;
    
    or1: entity work.or_3TI(dataflow)
            port map(
            xa => x2,
            xb => x3,
            ya => y2,
            yb => y3,
            o => z1
				);

    or2: entity work.or_3TI(dataflow)
            port map(
            xa => x3,
            xb => x1,
            ya => y3,
            yb => y1,
            o => z2
				);

    or3: entity work.or_3TI(dataflow)
            port map(
            xa => x1,
            xb => x2,
            ya => y1,
            yb => y2,
            o => z3
				);

o1 <= z1 xor z2;
o2 <= z3;
				
end structural;
