-- and_3TI

library ieee;
use ieee.std_logic_1164.ALL;

entity and_3TI is
    port (

	xa, xb, ya, yb  : in  std_logic;
	o		: out std_logic
	);

end entity and_3TI;

architecture dataflow of and_3TI is

attribute keep_hierarchy : string;
attribute keep_hierarchy of dataflow: architecture is "true";

begin

	o <= (xb and ya) xor (xa and yb) xor (xa and ya);

end dataflow;
