----------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakr Abdulgadir
-- 
-- Create Date:    12:56:15 08/15/2017 
-- Design Name: 
-- Module Name:    rdi_preprocessor - Behavioral 
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

entity rdi_preprocessor is
    Generic(
	     G_W : integer := 32;
		  M : integer := 4;
		  N : integer := 4
	 );
    Port ( --External interface
			  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rdi_data : in  STD_LOGIC_VECTOR (G_W -1 downto 0);
           rdi_valid : in  STD_LOGIC;
           rdi_ready : out  STD_LOGIC;
			  --To user
           pdi_rdata_rdy : out  STD_LOGIC;
           sdi_rdata_rdy : out  STD_LOGIC;
           pdi_rdata : out  STD_LOGIC_VECTOR(N * G_W -1 downto 0);
           sdi_rdata : out  STD_LOGIC_VECTOR(M * G_W -1 downto 0);
           --From user
			  pdi_rdata_ld : in  STD_LOGIC;
           sdi_rdata_ld : in  STD_LOGIC);
end rdi_preprocessor;

architecture Struct of rdi_preprocessor is
signal en_pdi_rdata : STD_LOGIC:='0';
signal en_sdi_rdata : STD_LOGIC:='0';
signal pdi_cnt_rst : STD_LOGIC:='0';
signal sdi_cnt_rst : STD_LOGIC:='0';
signal pdi_rdata_full  : STD_LOGIC:='0';
signal sdi_rdata_full : STD_LOGIC:='0';
begin

rdi_dp : entity work.rdi_dp(Behav)
    generic map(
	     G_W => G_W,
		  N => N,
		  M => M
	 )
    port map(
        --External
	     clk => clk,
        rst => rst,
        rdi_data => rdi_data,
		  --To User
        pdi_rdata => pdi_rdata,
        sdi_rdata => sdi_rdata,
		  --To ctrl
		  en_pdi_rdata => en_pdi_rdata,
        en_sdi_rdata => en_sdi_rdata,
		  pdi_cnt_rst => pdi_cnt_rst,
        sdi_cnt_rst => sdi_cnt_rst,
		  pdi_rdata_full => pdi_rdata_full,
		  sdi_rdata_full => sdi_rdata_full
		  
	 );
	 
dpi_ctrl : entity work.rdi_ctrl(Behav)
    port map(
	     --External
			clk => clk,
         rst => rst,
			rdi_ready => rdi_ready,
			rdi_valid => rdi_valid,
			--To user
         pdi_rdata_ld => pdi_rdata_ld,
         sdi_rdata_ld => sdi_rdata_ld,
         pdi_rdata_rdy => pdi_rdata_rdy,
         sdi_rdata_rdy => sdi_rdata_rdy,
			--Internal -to rdi_dp
         en_pdi_rdata => en_pdi_rdata,
         en_sdi_rdata => en_sdi_rdata,
			pdi_cnt_rst => pdi_cnt_rst,
         sdi_cnt_rst => sdi_cnt_rst,
			pdi_rdata_full => pdi_rdata_full,
			sdi_rdata_full => sdi_rdata_full
	 );

end Struct;

