--This module will include the FIFO as well as the memory module for talking to the cellular RAM
--FOW NOW WILL JUST HAVE THE MEMORY MODULE INSIDE FOR VERIFICATION
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Top_test is
    Port ( 
	 	 	 	
				CLOCK : IN STD_LOGIC;
				--EppCtrl Pins
				EppAstb : IN STD_LOGIC;
				EppDstb : IN STD_LOGIC;
				EppWr : IN STD_LOGIC;
				EppRst : IN STD_LOGIC;
				EppDB : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				EppWait : OUT STD_LOGIC;
				
				--NexysOnBoardMemCtrl Pins
				RamCS : OUT STD_LOGIC;
			   FlashCS : OUT STD_LOGIC;
			   MemWr : OUT STD_LOGIC;
			   MemOe : OUT STD_LOGIC;
			   RamUB : OUT STD_LOGIC;
			   RamLB : OUT STD_LOGIC;
			   RamCre : OUT STD_LOGIC;
			   RamAdv : OUT STD_LOGIC;
			   RamClk : OUT STD_LOGIC;
			   RamWait : IN STD_LOGIC;
			   FlashRp : OUT STD_LOGIC;		
			   FlashStSts : IN STD_LOGIC;
			   MemAdr : OUT STD_LOGIC_VECTOR(23 DOWNTO 1);
			   MemDB : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
				FlashByte : OUT STD_LOGIC;
				MemCtrlEnabled : OUT STD_LOGIC
			  
			  );
end Top_test;

architecture top_test_arch of Top_test is

BEGIN

--Controller
--Controller : ENTITY work.Controller(cont_arch)
--port map(


--        );



--memModule
memModule : ENTITY work.memModule(memModule_arch)
Port map(
--EppCtrl Side          
			clk=> CLOCK,
			EppAstb=>EppAstb,
			EppDstb=>EppDstb,
			EppWr=>EppWr,
			EppRst=>EppRst,
			EppDB=>EppDB,
			EppWait=>EppWait,
--Memory Side
			RamCS=> RamCS,
			FlashCS=> FlashCS,
			MemWr=> MemWr,
			MemOe=> MemOe,
			RamUB=> RamUB,
			RamLB=> RamLB,
			RamCre=> RamCre,
			RamAdv=> RamAdv,
			RamClk=> RamClk,
			RamWait=> RamWait,
			FlashRp=> FlashRp,
			FlashStSts=> FlashStSts,
			MemAdr=> MemAdr,
			MemDB=> MemDB,
			
			FlashByte=> FlashByte,
			MemCtrlEnabled=> MemCtrlEnabled
			);
			





--FIFO Module
--FIFO_16 : ENTITY work.FIFO_16(FIFO_16_a)
--  PORT MAP(
--    clk=> CLOCK,
--    rst=>,
--    din=>,
--    wr_en=>,
--    rd_en=>,
--    dout=>,
--    full=>,
--    empty=>
--  );


end top_test_arch;

