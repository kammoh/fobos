----------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    19:33:32 01/17/2016 
-- Design Name: 
-- Module Name:    key_sched - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.AES_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key_sched is
    Port ( K : in   t_AES_state; --Key
           T : in   t_AES_state; --Tweak
           i : in  STD_LOGIC_VECTOR (3 downto 0);  --Round number
           STKi : out  t_AES_state; --Round key
			  en_kt : in STD_LOGIC;
           clk : in  STD_LOGIC;
           init : in  STD_LOGIC);
end key_sched;

architecture key_size_128 of key_sched is
	type rcon_array is array(0 to 16) of STD_LOGIC_VECTOR(7 downto 0);
	constant RCON_ROM : rcon_array := (X"2f" ,X"5e", X"bc", X"63", X"c6", X"97", X"35", X"6a", X"d4", 
												  X"b3", X"7d", X"fa", X"ef", X"c5", X"91", X"39",X"72");
	 signal rcon_i : std_logic_vector(7 downto 0);
	 signal TKi1, TKi2 : t_AES_state;
begin
	----
	KS1 : entity work.KS(struct) port map (W => K, alpha => "010", init => init, en_kt => en_kt, TKi => TKi1, clk => clk);
	KS2 : entity work.KS(struct) port map (W => T, alpha => "001", init => init, en_kt => en_kt, TKi => TKi2, clk => clk);
	----
	--RCON ROM
	rcon_i <= RCON_ROM(to_integer(unsigned(i)));
	----STKi
	STKi(0,0) <= TKi1(0,0) xor TKi2(0,0) xor X"01";
	STKi(1,0) <= TKi1(1,0) xor TKi2(1,0) xor X"02";
	STKi(2,0) <= TKi1(2,0) xor TKi2(2,0) xor X"04";
	STKi(3,0) <= TKi1(3,0) xor TKi2(3,0) xor X"08";
	STKi(0,1) <= TKi1(0,1) xor TKi2(0,1) xor rcon_i;
	STKi(1,1) <= TKi1(1,1) xor TKi2(1,1) xor rcon_i;
	STKi(2,1) <= TKi1(2,1) xor TKi2(2,1) xor rcon_i;
	STKi(3,1) <= TKi1(3,1) xor TKi2(3,1) xor rcon_i;
	STKi(0,2) <= TKi1(0,2) xor TKi2(0,2);
	STKi(1,2) <= TKi1(1,2) xor TKi2(1,2);
	STKi(2,2) <= TKi1(2,2) xor TKi2(2,2);
	STKi(3,2) <= TKi1(3,2) xor TKi2(3,2);
	STKi(0,3) <= TKi1(0,3) xor TKi2(0,3);
	STKi(1,3) <= TKi1(1,3) xor TKi2(1,3);
	STKi(2,3) <= TKi1(2,3) xor TKi2(2,3);
	STKi(3,3) <= TKi1(3,3) xor TKi2(3,3);


end key_size_128;

