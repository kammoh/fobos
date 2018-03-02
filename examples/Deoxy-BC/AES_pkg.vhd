-------------------------------------------------------------------------------
--! @file       AES_pkg.vhd
--! @brief      Package definition used by various AES modules
--! @project    CAESAR Candidate Evaluation
--! @author     Marcin Rogawski   
--! @author     Ekawat (ice) Homsirikamol
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

package AES_pkg is
	-- aes constants
	constant AES_SBOX_SIZE				: integer :=  8;
	constant AES_WORD_SIZE				: integer := 32;
	constant AES_BLOCK_SIZE				: integer :=128;
	constant AES_KEY_SIZE				: integer :=128;
    constant AES_ROUNDS                 : integer := 14;

    type t_AES_state     is array (0 to 3, 0 to 3) of std_logic_vector( 7 downto 0);
    type t_AES_column    is array (0 to 3)         of std_logic_vector( 7 downto 0);    
end AES_pkg;