----------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakry Abdugadir
-- 
-- Create Date:    13:33:19 08/15/2017 
-- Design Name: 
-- Module Name:    rdi_ctrl - Behavioral 
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

entity rdi_ctrl is
    Port ( --External
			  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  rdi_ready : out STD_LOGIC;
			  rdi_valid : in STD_LOGIC;
			  --To user
           pdi_rdata_ld : in  STD_LOGIC;
           sdi_rdata_ld : in  STD_LOGIC;
           pdi_rdata_rdy : out  STD_LOGIC;
           sdi_rdata_rdy : out  STD_LOGIC;
			  --Internal -to rdi_dp
           en_pdi_rdata : out  STD_LOGIC;
           en_sdi_rdata : out  STD_LOGIC;
			  pdi_cnt_rst : out  STD_LOGIC;
           sdi_cnt_rst : out  STD_LOGIC;
			  pdi_rdata_full : in STD_LOGIC;
			  sdi_rdata_full : in STD_LOGIC
			  );
end rdi_ctrl;

architecture Behav of rdi_ctrl is
type type_state is (S_RST, S_WAIT_CMD, S_WAIT_PEER, S_GET_DATA, S_DONE);
signal pdi_state, sdi_state      : type_state;
signal pdi_state_next, sdi_state_next : type_state;
signal pdi_fsm_busy, sdi_fsm_busy : STD_LOGIC;
signal pdi_fsm_working : STD_LOGIC; --used to know who should drive external outputs
signal pdi_ready, sdi_ready : STD_LOGIC;
begin

-- pdi state register
pdi_state_reg : process(clk)
begin
	 if rising_edge(clk) then
	     if rst = '1' then
		      pdi_state <= S_RST;
				sdi_state <= S_RST;
		  else
		      pdi_state <= pdi_state_next;
				sdi_state <= sdi_state_next;
		  end if;
	 end if;
end process;

--pdi state update and output function
pdi_comb : process(pdi_state, rdi_valid, pdi_rdata_ld, pdi_rdata_full,
                   sdi_rdata_full, sdi_fsm_busy)
begin
    --Default values
	 pdi_ready <= '0';
	 pdi_rdata_rdy <= '1'; -- make into latch
	 en_pdi_rdata <= '0';
	 pdi_fsm_busy <= '0';
	 pdi_fsm_working <= '0';
	 pdi_cnt_rst <= '0';
	 ----
	 case pdi_state is
	 when S_RST =>
	     --pdi_rdata_rdy <= '0';
	     pdi_cnt_rst <= '1';
	     pdi_state_next <= S_WAIT_CMD;
		  
	 when S_WAIT_CMD =>
	     if pdi_rdata_ld = '1' then
		      pdi_rdata_rdy <= '0'; -- latch
		      pdi_fsm_busy <= '1';
		      if sdi_fsm_busy = '1' then
		          pdi_state_next <= S_WAIT_PEER;
				else
				    pdi_state_next <= S_GET_DATA;
		      end if;
			else
			    pdi_state_next <= S_WAIT_CMD;
			end if;
			
	 when S_WAIT_PEER =>
	     pdi_rdata_rdy <= '0';
	     pdi_fsm_busy <= '1';
		  if sdi_fsm_busy = '1' then
		      pdi_state_next <= S_WAIT_PEER;
		  else
		      pdi_state_next <= S_GET_DATA;
		  end if;
	 
	 when S_GET_DATA =>
	     pdi_rdata_rdy <= '0';
	     pdi_fsm_busy <= '1';
		  pdi_fsm_working <= '1';
	     pdi_ready <= '1';
	     pdi_fsm_busy <= '1';
		  if pdi_rdata_full = '1' then
		      pdi_state_next <= S_DONE;
		  else
				if rdi_valid = '1' then
				    en_pdi_rdata <= '1';
				    --pdi_state_next <= S_GET_DATA;
				end if;
				pdi_state_next <= S_GET_DATA;
		   end if;
	 
	 when S_DONE =>
	     --pdi_rdata_rdy <= '1';
		  pdi_cnt_rst <= '1';
        pdi_state_next <= S_WAIT_CMD;
	 	 
	 when others => 
		  pdi_rdata_rdy <= '0';
		  pdi_state_next <= S_RST;	
	 end case;

end process;



--sdi state update and output function
sdi_comb : process(sdi_state, rdi_valid, sdi_rdata_ld, sdi_rdata_full,pdi_fsm_busy)
begin
    --Default values
	 sdi_ready <= '0';
	 sdi_rdata_rdy <= '1'; -- make into latch
	 en_sdi_rdata <= '0';
	 sdi_fsm_busy <= '0';
	 sdi_cnt_rst <= '0';
	 ----
	 case sdi_state is
	 when S_RST =>
		  --sdi_rdata_rdy <= '0';
	     sdi_cnt_rst <= '1';
	     sdi_state_next <= S_WAIT_CMD;
		  
	 when S_WAIT_CMD =>
	     if sdi_rdata_ld = '1' then
		      --sdi_fsm_busy <= '1'; don't set this now since pdi have priority
				sdi_rdata_rdy <= '0';
		      if pdi_fsm_busy = '1' then
		          sdi_state_next <= S_WAIT_PEER;
				else
				    sdi_state_next <= S_GET_DATA;
		      end if;
			else
			    sdi_state_next <= S_WAIT_CMD;
			end if;
			
	 when S_WAIT_PEER =>
	     sdi_rdata_rdy <= '0';
		  sdi_fsm_busy <= '1';
	     --sdi_fsm_busy <= '1';
		  if pdi_fsm_busy = '1' then
		      sdi_state_next <= S_WAIT_PEER;
		  else
		      sdi_state_next <= S_GET_DATA;
		  end if;
	 
	 when S_GET_DATA =>
	     sdi_rdata_rdy <= '0'; 
	     sdi_fsm_busy <= '1';
	     sdi_ready <= '1';
	     --sdi_fsm_busy <= '1';
		  if sdi_rdata_full = '1' then
		      sdi_state_next <= S_DONE;
		  else
				if rdi_valid = '1' then
				    en_sdi_rdata <= '1';
				    --sdi_state_next <= S_GET_DATA;
				end if;
				sdi_state_next <= S_GET_DATA;
		   end if;
	 
	 when S_DONE =>
	     --sdi_rdata_rdy <= '1';
		  sdi_cnt_rst <= '1';
        sdi_state_next <= S_WAIT_CMD;
	 
	 when others => 
		  sdi_state_next <= S_RST;
	 end case;

end process;

rdi_ready <= pdi_ready when pdi_fsm_working = '1' else sdi_ready;
end Behav;

