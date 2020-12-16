----------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    15:22:42 07/19/2016 
-- Design Name: 
-- Module Name:    DBC - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DBC is
    Port ( key : in  STD_LOGIC_VECTOR (127 downto 0);
           --tweak : in  STD_LOGIC_VECTOR (127 downto 0); -- not used , we locally generate tweak hear
           din : in  STD_LOGIC_VECTOR (127 downto 0);
           dout : out  STD_LOGIC_VECTOR (127 downto 0);
           --ready : out  STD_LOGIC;
           start : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           --reset : in  STD_LOGIC;
           done : out  STD_LOGIC);
end DBC;

architecture struct of DBC is
	signal sel_in, en_kt, en_state, init, en_out: STD_LOGIC;
	signal i : STD_LOGIC_VECTOR(3 downto 0);
	signal j : STD_LOGIC_VECTOR(60 downto 0); --used to generate tweak
	signal myTweak : STD_LOGIC_VECTOR(127 downto 0);
	signal npub : STD_LOGIC_VECTOR(63 downto 0);
	signal rst :   STD_LOGIC;
	signal enc_j : STD_LOGIC ;

begin
	------------------------mapping to AES_state
	j_counter  : entity work.counter(behav) generic map (N  => 61) 
		port map (D=> (0=> '1', others=>'0') , Q=> j, clk => clk, enable => enc_j, load=>rst);
	----------------------------------------------Datapath
	u_doexys_bc_datapath: entity work.DBC_dp(struct) port map(
           din => din,
           dout => dout,
           K => key,
           T => myTweak,
           sel_in => sel_in,
           en_state => en_state,
           en_kt => en_kt,
			  init => init,
			  i => i,
			  clk => clk,
			  en_out  => en_out,
			  rst => rst
			
   );
	------------------------------------------------Controller
	u_deoxys_bc_controller: entity work.DBC_ctrl(behav) port map(
           --external signals
			  done => done,
           start => start,
			  clk => clk,
			  rst => rst,
			  --ready => ready,
			  --internal signals
           sel_in => sel_in,
			  en_kt => en_kt,
           iii => i,
           en_state => en_state,
			  init => init,
			  en_out => en_out,
			  enc_j => enc_j
	);
	npub <= x"00000000000000ff";
	myTweak <= "000" & npub & j;
	
end struct;

