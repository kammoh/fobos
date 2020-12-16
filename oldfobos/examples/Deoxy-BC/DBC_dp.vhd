----------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    12:31:39 05/17/2016 
-- Design Name: 
-- Module Name:    DBC_dp - Behavioral 
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

entity DBC_dp is
    Port ( din : in  STD_LOGIC_VECTOR (127 downto 0);
           dout : out  STD_LOGIC_VECTOR (127 downto 0);
           K : in  STD_LOGIC_VECTOR (127 downto 0);
           T : in  STD_LOGIC_VECTOR (127 downto 0);
           sel_in : in  STD_LOGIC;
           en_state : in  STD_LOGIC;
           en_kt : in  STD_LOGIC;
			  en_out : in STD_LOGIC;
			  init : in STD_LOGIC;
			  clk : in STD_LOGIC;
			  signal i : std_logic_vector (3 downto 0);
			  rst : in STD_LOGIC);
end DBC_dp;

architecture struct of DBC_dp is
	signal din_state, din_xor_rkey, dout_state, K_state,T_state, STKi_state, 
		STKi_state_p, after_round, after_state_reg, after_in_mux, after_out_reg: t_AES_state;
	signal  STKI_debug, after_round_d, after_state_reg_d, after_in_mux_d, after_subbytes_d, din_xor_rkey_d : STD_LOGIC_VECTOR(127 downto 0);
	
	signal	after_subbytes		: t_AES_state;
    signal	after_shiftrows		: t_AES_state;
    signal	after_mixcolumns	: t_AES_state;
begin
   --------------------------map i/o
	u_map_din: entity work.AES_map(structure)
   port map ( ii => din, 
              oo => din_state);
	u_map_key: entity work.AES_map(structure)
   port map ( ii => K, 
              oo => K_state);
	u_map_tweak: entity work.AES_map(structure)
   port map ( ii => T, 
              oo => T_state);
   u_map_dout: entity work.AES_invmap(structure)
   port map ( ii => dout_state, 
              oo => dout);
	---------------debug map
	u1: entity work.AES_invmap(structure)
   port map ( ii => STKi_state, 
              oo => STKI_debug);
	u2: entity work.AES_invmap(structure)
   port map ( ii => after_round, 
              oo => after_round_d);
	u3: entity work.AES_invmap(structure)
   port map ( ii => after_state_reg, 
              oo => after_state_reg_d);
	u4: entity work.AES_invmap(structure)
   port map ( ii => after_in_mux, 
              oo => after_in_mux_d);
	u5: entity work.AES_invmap(structure)
   port map ( ii => din_xor_rkey, 
              oo => din_xor_rkey_d);
	u6: entity work.AES_invmap(structure)
   port map ( ii => after_subbytes, 
              oo => after_subbytes_d);
	
	--plain text/round key-prewightening------------------
	preWighteningRow: for i in 0 to 3 generate
       preWighteningCol: for j in 0 to 3 generate
				din_xor_rkey(j,i) <= din_state(j,i) xor STKi_state(j,i);
        end generate;
    end generate;

   ---------------------------------------------
	after_in_mux <=  din_xor_rkey when sel_in = '1' else after_round;
	--State_reg  : entity work.reg128(Behav) port map (D=> after_in_mux, Q=> after_state_reg, clk => clk, enable => en_state);

	
	---------------------------------------------------
	
	key_sched: entity work.key_sched(key_size_128) PORT MAP(
           K => K_state,
           T => T_state,
           STKi => STKi_state,
			  i    => i,
			  en_kt => en_kt,
			  init => init,
			  clk => clk
    );
	 
	 --DCC_Round: entity work.DBC_Round(basic) PORT MAP(
      --            din => after_state_reg,
     --             dout => after_round,
		--				rkey => STKi_state
	 --);
	 
	 
	     --! SubBytes
    sb	: entity work.AES_SubBytes(basic)	port map (input=>after_in_mux,     output=>after_subbytes);
	 
	 State_reg  : entity work.reg128(Behav) port map (D=> after_subbytes, Q=> after_state_reg, clk => clk, enable => en_state);

    --! ShiftRows
    sr	: entity work.AES_ShiftRows(basic)	port map (input=>after_state_reg,    output=>after_shiftrows);

    --! MixColumns
    mc	: entity work.AES_MixColumns(basic)	port map (input=>after_shiftrows,   output=>after_mixcolumns);

    --! AddRoundKey
    gAddRoundKeyRow: for i in 0 to 3 generate
        gAddRoundKeyCol: for j in 0 to 3 generate
            --dout_fdb(j,i) <= after_mixcolumns(j,i) xor rkey(j,i);
            --dout(j,i)     <= after_shiftrows(j,i)  xor rkey(j,i);
				after_round(j,i) <= after_mixcolumns(j,i) xor STKi_state(j,i);
        end generate;
    end generate;
	 
	 
	 
	 
	 --removed 8-15-2016
	------Final add-round-tweakkey
	--! AddRoundKey
--   finalAddRoundKeyRow: for i in 0 to 3 generate
--       finalAddRoundKeyCol: for j in 0 to 3 generate
--				dout_state(j,i) <= after_state_reg(j,i) xor STKi_state(j,i);
--        end generate;
--    end generate;
	 --end removed
	 out_reg  : entity work.reg128(Behav) port map (D=> after_round, Q=> after_out_reg, clk => clk, enable => en_out);
	 --dout_state <= after_round;
	 dout_state <= after_out_reg;
	 --end added
	 
	 
	 
			 
			 
end struct;

