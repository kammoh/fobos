-------------------------------------------------------------------------------
--! @file       AES_map.vhd
--! @brief      Mapping of std_logic to AES state
--!
--! This unit converts from std_logic_vector to t_AES_state.
--!
--! order of state bytes on a bus (most-significant to least-significant position)
--! (0,0), (1,0), (2,0), (3,0), (0,1), (1,1), (2,1), (3,1),
--! (0,2), (1,2), (2,2), (3,2), (0,3), (1,3), (2,3), (3,3)
--! order of state bits in state bytes (most-significant to least-significant position)
--! (8*j..8*j+7)
--!
--! @project    CAESAR Candidate Evaluation  
--! @author     Ekawat (ice) Homsirikamol
--! @modified by Abubakr Abdulgadir
--! @version    1.0
--! @copyright  Copyright (c) 2014 Cryptographic Engineering Research Group
--!             ECE Department, George Mason University Fairfax, VA, U.S.A.
--!             All rights Reserved.
--! @license    This project is released under the GNU Public License.
--!             The license and distribution terms for this file may be
--!             found in the file LICENSE in this distribution or at 
--!             http://www.gnu.org/licenses/gpl-3.0.txt
--! @note       This is publicly available encryption source code that falls
--!             under the License Exception TSU (Technology and software-
--!             —unrestricted)
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.AES_pkg.all;

entity AES_map is  
    port (
        ii :   in  std_logic_vector(AES_BLOCK_SIZE-1 downto 0);
        oo :   out t_AES_state
    );
end AES_map;

-------------------------------------------------------------------------------
--! @brief  Architecture definition of AES_map
-------------------------------------------------------------------------------
architecture structure of AES_map is   
begin
--    gRow: for i in 0 to 3 generate
--       gCol: for j in 0 to 3 generate
--           oo(j,i)  <= ii(AES_BLOCK_SIZE-(j*8+i*AES_WORD_SIZE)-1 downto AES_BLOCK_SIZE-(j*8+i*AES_WORD_SIZE)-8); 
--       end generate;
--    end generate;
	  --
--	 oo(0,0) <= ii(7 downto  0);
--	 oo(1,0) <= ii(15 downto 8);
--	 oo(2,0) <= ii(23 downto 16);
--	 oo(3,0) <= ii(31 downto 24);
--	 oo(0,1) <= ii(39 downto 32);
--	 oo(1,1) <= ii(47 downto 40);
--	 oo(2,1) <= ii(55 downto 48);
--	 oo(3,1) <= ii(63 downto 56);
--	 oo(0,2) <= ii(71 downto 64);
--	 oo(1,2) <= ii(79 downto 72);
--	 oo(2,2) <= ii(87 downto 80);
--	 oo(3,2) <= ii(95 downto 88);
--	 oo(0,3) <= ii(103 downto 96);
--	 oo(1,3) <= ii(111 downto 104);
--	 oo(2,3) <= ii(119 downto 112);
--	 oo(3,3) <= ii(127 downto 120);
--	 
	 oo(0,0) <= ii(127 downto 120);
	 oo(1,0) <= ii(119 downto 112);
	 oo(2,0) <= ii(111 downto 104);
	 oo(3,0) <= ii(103 downto 96);
	 oo(0,1) <= ii(95 downto 88);
	 oo(1,1) <= ii(87 downto 80);
	 oo(2,1) <= ii(79 downto 72);
	 oo(3,1) <= ii(71 downto 64);
	 oo(0,2) <= ii(63 downto 56);
	 oo(1,2) <= ii(55 downto 48);
	 oo(2,2) <= ii(47 downto 40);
	 oo(3,2) <= ii(39 downto 32);
	 oo(0,3) <= ii(31 downto 24);
	 oo(1,3) <= ii(23 downto 16);
	 oo(2,3) <= ii(15 downto 8);
	 oo(3,3) <= ii(7 downto  0);
	 
	 
end structure;