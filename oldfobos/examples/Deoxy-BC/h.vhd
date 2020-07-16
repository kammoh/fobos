----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Abubakr Abdulgadir
-- 
-- Create Date:    10:56:57 11/26/2015 
-- Design Name: 
-- Module Name:    h - Behavioral 
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
use work.AES_pkg.all;
entity h is
    Port ( ii : in  t_AES_state;
           oo : out  t_AES_state);
end h;

architecture struct of h is

begin
	oo(0,0) <= ii(3,1);
	oo(1,0) <= ii(0,0);
	oo(2,0) <= ii(1,3);
	oo(3,0) <= ii(2,2);
	oo(0,1) <= ii(3,2);
	oo(1,1) <= ii(0,1);
	oo(2,1) <= ii(1,0);
	oo(3,1) <= ii(2,3);
	oo(0,2) <= ii(3,3);
	oo(1,2) <= ii(0,2);
	oo(2,2) <= ii(1,1);
	oo(3,2) <= ii(2,0);
	oo(0,3) <= ii(3,0);
	oo(1,3) <= ii(0,3);
	oo(2,3) <= ii(1,2);
	oo(3,3) <= ii(2,1);
	
--	oo(2,3) <= ii(3,3);
--	oo(1,2) <= ii(2,3);
--	oo(0,1) <= ii(1,3);
--	oo(3,0) <= ii(0,3);
--	oo(2,2) <= ii(3,2);
--	oo(1,1) <= ii(2,2);
--	oo(0,0) <= ii(1,2);
--	oo(3,3) <= ii(0,2);
--	oo(2,1) <= ii(3,1);
--	oo(1,0) <= ii(2,1);
--	oo(0,3) <= ii(1,1);
--	oo(3,2) <= ii(0,1);
--	oo(2,0) <= ii(3,0);
--	oo(1,3) <= ii(2,0);
--	oo(0,2) <= ii(1,0);
--	oo(3,1) <= ii(0,0);
end struct;

