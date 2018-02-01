LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY display_rom IS
PORT (
Addr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
Dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END display_rom;
ARCHITECTURE dataflow OF display_rom IS
SIGNAL temp: INTEGER RANGE 0 TO 15;
TYPE vector_array IS ARRAY (0 to 15) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
CONSTANT memory : vector_array :=
(  "11000000",
	"11001111",
	"10100100",
	"10110000",
	"10011001",
	"10010010",
	"10000010",
	"11111000",
	"10000000",
	"10010000",
	"10001000",
	"10000011",
	"11000110",
	"10100001",
   "10110000",
	"10001110"
	);
BEGIN
temp <= to_integer(unsigned(Addr));
Dout <= memory(temp);
END dataflow;
