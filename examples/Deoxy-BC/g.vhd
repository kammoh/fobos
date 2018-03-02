----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    10:26:16 11/26/2015 
-- Design Name: 
-- Module Name:    g - Behavioral 
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
use work.AES_pkg.ALL;

entity g is
    Port ( ii : in t_AES_state;
           oo : out  t_AES_state;
			  alpha : in STD_LOGIC_VECTOR(2 downto 0));
end g;

architecture struct of g is
	type mul_array is array(0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
	constant mul2 : mul_array := (
		  X"00" , X"02", X"04", X"06", X"08", X"0A", X"0C", X"0E", X"10", X"12", X"14", X"16", X"18", X"1A", X"1C", X"1E",
		  X"20", X"22", X"24", X"26", X"28", X"2A", X"2C", X"2E", X"30", X"32", X"34", X"36", X"38", X"3A", X"3C", X"3E",
		  X"40", X"42", X"44", X"46", X"48", X"4A", X"4C", X"4E", X"50", X"52", X"54", X"56", X"58", X"5A", X"5C", X"5E",
		  X"60", X"62", X"64", X"66", X"68", X"6A", X"6C", X"6E", X"70", X"72", X"74", X"76", X"78", X"7A", X"7C", X"7E",
		  X"80", X"82", X"84", X"86", X"88", X"8A", X"8C", X"8E", X"90", X"92", X"94", X"96", X"98", X"9A", X"9C", X"9E",
		  X"A0", X"A2", X"A4", X"A6", X"A8", X"AA", X"AC", X"AE", X"B0", X"B2", X"B4", X"B6", X"B8", X"BA", X"BC", X"BE",
		  X"C0", X"C2", X"C4", X"C6", X"C8", X"CA", X"CC", X"CE", X"D0", X"D2", X"D4", X"D6", X"D8", X"DA", X"DC", X"DE",
		  X"E0", X"E2", X"E4", X"E6", X"E8", X"EA", X"EC", X"EE", X"F0", X"F2", X"F4", X"F6", X"F8", X"FA", X"FC", X"FE",
		  X"1B", X"19", X"1F", X"1D", X"13", X"11", X"17", X"15", X"0B", X"09", X"0F", X"0D", X"03", X"01", X"07", X"05",
		  X"3B", X"39", X"3F", X"3D", X"33", X"31", X"37", X"35", X"2B", X"29", X"2F", X"2D", X"23", X"21", X"27", X"25",
		  X"5B", X"59", X"5F", X"5D", X"53", X"51", X"57", X"55", X"4B", X"49", X"4F", X"4D", X"43", X"41", X"47", X"45",
		  X"7B", X"79", X"7F", X"7D", X"73", X"71", X"77", X"75", X"6B", X"69", X"6F", X"6D", X"63", X"61", X"67", X"65",
		  X"9B", X"99", X"9F", X"9D", X"93", X"91", X"97", X"95", X"8B", X"89", X"8F", X"8D", X"83", X"81", X"87", X"85",
		  X"BB", X"B9", X"BF", X"BD", X"B3", X"B1", X"B7", X"B5", X"AB", X"A9", X"AF", X"AD", X"A3", X"A1", X"A7", X"A5",
		  X"DB", X"D9", X"DF", X"DD", X"D3", X"D1", X"D7", X"D5", X"CB", X"C9", X"CF", X"CD", X"C3", X"C1", X"C7", X"C5",
		  X"FB", X"F9", X"FF", X"FD", X"F3", X"F1", X"F7", X"F5", X"EB", X"E9", X"EF", X"ED", X"E3", X"E1", X"E7", X"E5");

	signal temp, after_mux, m : t_AES_state;
	signal temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp10, temp11, temp12, temp13, temp14, temp15 : integer range 0 to 255;

begin
		temp0 <= to_integer(unsigned(ii(0,0))); temp1 <= to_integer(unsigned(ii(1,0)));
		temp2 <= to_integer(unsigned(ii(2,0))); temp3 <= to_integer(unsigned(ii(3,0)));
		temp4 <= to_integer(unsigned(ii(0,1))); temp5 <= to_integer(unsigned(ii(1,1)));
		temp6 <= to_integer(unsigned(ii(2,1))); temp7 <= to_integer(unsigned(ii(3,1)));
		temp8 <= to_integer(unsigned(ii(0,2))); temp9 <= to_integer(unsigned(ii(1,2)));
		temp10 <= to_integer(unsigned(ii(2,2))); temp11 <= to_integer(unsigned(ii(3,2)));
		temp12 <= to_integer(unsigned(ii(0,3))); temp13 <= to_integer(unsigned(ii(1,3)));
		temp14 <= to_integer(unsigned(ii(2,3))); temp15 <= to_integer(unsigned(ii(3,3)));
		-------------
		m(3,3) <= mul2(temp15);m(2,3) <= mul2(temp14);m(1,3) <= mul2(temp13);m(0,3) <= mul2(temp12);m(3,2) <= mul2(temp11);
		m(2,2) <= mul2(temp10);m(1,2) <= mul2(temp9);m(0,2) <= mul2(temp8);m(3,1) <= mul2(temp7);m(2,1) <= mul2(temp6);
		m(1,1) <= mul2(temp5);m(0,1) <= mul2(temp4);m(3,0) <= mul2(temp3);m(2,0) <= mul2(temp2);m(1,0) <= mul2(temp1);m(0,0) <= mul2(temp0);
		
		
		-------------
		after_mux <= m when alpha = "010" else ii;
		oo <= after_mux;
end struct;

