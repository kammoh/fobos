----------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    20:12:01 01/17/2016 
-- Design Name: 
-- Module Name:    KS - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity KS is
    Port ( W : in  t_AES_state;
           alpha : in  STD_LOGIC_VECTOR (2 downto 0);
           init : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  en_kt : in STD_lOGIC;
           TKi : out t_AES_state);
end KS;

architecture struct of KS is
	signal after_mux, after_h, after_g, after_reg : t_AES_state;
	signal d_after_mux, d_after_h, d_after_g, d_after_reg : STD_LOGIC_VECTOR (127 downto 0);
begin
   --debug
	 d1: entity work.AES_invmap(structure)
    port map ( ii => after_mux, 
               oo => d_after_mux);
	d2: entity work.AES_invmap(structure)
    port map ( ii => after_h, 
               oo => d_after_h);
	d3: entity work.AES_invmap(structure)
    port map ( ii => after_g, 
               oo => d_after_g);
	d4: entity work.AES_invmap(structure)
    port map ( ii => after_reg, 
               oo => d_after_reg);
	--
	--mux
	after_mux <= W when init = '1' else after_g;
	KT_reg  : entity work.reg128(Behav) port map (D=> after_mux, Q=> after_reg, clk => clk, enable => en_kt);
	h : entity work.h(struct) port map (ii=> after_reg, oo=> after_h);
	g : entity work.g(struct) port map (ii=>after_h, oo=> after_g, alpha => alpha);
	TKi <= after_reg;
end struct;

