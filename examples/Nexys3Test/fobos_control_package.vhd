library ieee;
use ieee.std_logic_1164.all;

package fobos_control_package is

component counter is
	generic ( N : integer := 32);
	port(clk : in std_logic;
		reset : in std_logic;
--	   load : in std_logic;
	   enable : in std_logic; 
--		input  : in std_logic_vector(N-1 downto 0);
      counter_out : out std_logic_vector(N-1 downto 0));
end component;


end fobos_control_package;