

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;

entity or_3TI is
    Port ( 
           xa, xb : in std_logic;
           ya, yb : in std_logic;
           o      : out std_logic
    
           );
end or_3TI;

architecture dataflow of or_3TI is

attribute keep_hierarchy : string;
attribute keep_hierarchy of dataflow : architecture is "true";

begin
    o <= (xa or yb) xor (ya and xb) xor (xa and ya);

end dataflow;
