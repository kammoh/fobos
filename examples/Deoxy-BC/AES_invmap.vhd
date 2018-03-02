-------------------------------------------------------------------------------
--! @file       AES_invmap.vhd
--! @brief      Inverse mapping of AES state to std_logic
--!
--! This unit converts from t_AES_state to t_AES_state.
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

entity AES_invmap is  
    port (
        ii :   in  t_AES_state;
        oo :   out std_logic_vector(AES_BLOCK_SIZE-1 downto 0)
    );
end AES_invmap;

-------------------------------------------------------------------------------
--! @brief  Architecture definition of AES_invmap
-------------------------------------------------------------------------------
architecture structure of AES_invmap is   
begin
--    gRow: for i in 0 to 3 generate
--       gCol: for j in 0 to 3 generate
--            oo(AES_BLOCK_SIZE-(j*8+i*AES_WORD_SIZE)-1 downto AES_BLOCK_SIZE-(j*8+i*AES_WORD_SIZE)-8)  <=  ii(j,i);
--        end generate;
--   end generate;

--     oo(7 downto  0)<= ii(0,0);
--	  oo(15 downto 8) <= ii(1,0);
--	  oo(23 downto 16)<= ii(2,0);
--	  oo(31 downto 24)<= ii(3,0);
--	  oo(39 downto 32)<= ii(0,1);
--	  oo(47 downto 40)<= ii(1,1);
--	  oo(55 downto 48)<= ii(2,1);
--	  oo(63 downto 56)<= ii(3,1);
--	  oo(71 downto 64)<= ii(0,2);
--	  oo(79 downto 72)<= ii(1,2);
--	  oo(87 downto 80)<= ii(2,2);
--	  oo(95 downto 88)<= ii(3,2);
--	  oo(103 downto 96)<= ii(0,3);
--	  oo(111 downto 104)<= ii(1,3);
--	  oo(119 downto 112)<= ii(2,3);
--	  oo(127 downto 120)<= ii(3,3);


     oo(127 downto  120)<= ii(0,0);
	  oo(119 downto 112) <= ii(1,0);
	  oo(111 downto 104)<= ii(2,0);
	  oo(103 downto 96)<= ii(3,0);
	  oo(95 downto 88)<= ii(0,1);
	  oo(87 downto 80)<= ii(1,1);
	  oo(79 downto 72)<= ii(2,1);
	  oo(71 downto 64)<= ii(3,1);
	  oo(63 downto 56)<= ii(0,2);
	  oo(55 downto 48)<= ii(1,2);
	  oo(47 downto 40)<= ii(2,2);
	  oo(39 downto 32)<= ii(3,2);
	  oo(31 downto 24)<= ii(0,3);
	  oo(23 downto 16)<= ii(1,3);
	  oo(15 downto 8)<= ii(2,3);
	  oo(7 downto 0)<= ii(3,3);

	 

	 
	 
end structure;