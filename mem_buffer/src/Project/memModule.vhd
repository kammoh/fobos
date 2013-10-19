--This file is just used for encapsulating the three modules needed to talk to the cellular RAM:
--EppCtrl, CompSel, NexysOnBoardMemCtrl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memModule is
Port(
--EppCtrl Side          
			clk : IN STD_LOGIC;
			EppAstb : IN STD_LOGIC;
			EppDstb : IN STD_LOGIC;
			EppWr : IN STD_LOGIC;
			EppRst : IN STD_LOGIC;
			EppDB : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			EppWait : OUT STD_LOGIC;
--Memory Side
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
			MemCtrlEnabled : OUT STD_LOGIC);
			
end memModule;

architecture memModule_arch of memModule is

--Signals named from the EppCtrl Perspective
SIGNAL busEppOut_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL busEppIn_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL ctlEppDwrOut_sig : STD_LOGIC;
SIGNAL ctlEppRdCycleOut_sig : STD_LOGIC;
SIGNAL HandShakeReqIn_sig : STD_LOGIC;
SIGNAL ctlEppStartOut_sig : STD_LOGIC;
SIGNAL ctlEppDoneIn_sig : STD_LOGIC;
SIGNAL regEppAdrOut_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);

--Signal named from the CompSel perspective
SIGNAL CS0_7_sig : STD_LOGIC;

BEGIN

--EppCtrl Module
EppCtrl : ENTITY work.EppCtrl(Behavioral)
    Port map(
-- Epp-like bus signals
      clk=>clk,-- system clock (50MHz)
      EppAstb=>EppAstb,-- Address strobe
      EppDstb=>EppDstb,-- Data strobe
      EppWr=>EppWr,-- Port write signal
      EppRst=>EppRst,-- Port reset signal
      EppDB=>EppDB,-- port data bus
      EppWait=>EppWait,-- Port wait signal
-- User signals
      busEppOut=>busEppOut_sig,-- Data Output bus
      busEppIn=>busEppIn_sig,-- Data Input bus
      ctlEppDwrOut=>ctlEppDwrOut_sig,-- Data Write pulse
      ctlEppRdCycleOut=>ctlEppRdCycleOut_sig,-- Indicates a READ Epp cycle
      regEppAdrOut=>regEppAdrOut_sig,-- Epp Address Register content
      HandShakeReqIn=>HandShakeReqIn_sig,-- User Handshake Request
      ctlEppStartOut=>ctlEppStartOut_sig,-- Automatic process Start   
      ctlEppDoneIn=>ctlEppDoneIn_sig-- Automatic process Done 
         );


--CompSel Module
CompSel : ENTITY work.CompSel(Behavioral)
    Port map(regEppAdrIn=>regEppAdrOut_sig,
          CS0_7=>CS0_7_sig
			 );


--NexysOnBoardMemCtrl Module
NexysOnBoardMemCtrl : ENTITY work.NexysOnBoardMemCtrl(Behavioral)
  Port map(
       clk=>clk ,-- system clock (50MHz)
-- Epp interface signals
       HandShakeReqOut=>HandShakeReqIn_sig,-- User Handshake Request
       ctlMsmStartIn=>ctlEppStartOut_sig,-- Automatic process Start 
       ctlMsmDoneOut=>ctlEppDoneIn_sig,-- Automatic process Done 
       ctlMsmDwrIn=>ctlEppDwrOut_sig,-- Data Write pulse
       ctlEppRdCycleIn=>ctlEppRdCycleOut_sig,-- Indicates a READ Epp cycle
       EppRdDataOut=>busEppIn_sig,-- Data Input bus
       EppWrDataIn=>busEppOut_sig,-- Data Output bus
       regEppAdrIn=>regEppAdrOut_sig,-- Epp Address Register content (bits 7:3 ignored)
       ComponentSelect=>CS0_7_sig,
		 -- active HIGH, selects the current MemCtrl instance
--      If a single "client" component (CxMemCfg or other) is connected
--      to a "host" component (EppCtrl or other), ComponentSelect signal 
--      can be held permanently active (connected to Vcc).
--      When more "client" components (CxMemCfg or other) are connected  
--      to a "host" component (EppCtrl or other), the ComponentSelect 
--      input of each client must be synthesized by decoding the higher
--      bits of regEppAdrOut bus, such a way to provide a distinct  
--      address range for each.
--      C1MemCfg component requires 8 Epp data registers 
--      (address range xxxxx000...xxxxx111)

-- Memory bus signals
       MemDB=>MemDB,-- Memory data bus
       MemAdr=>MemAdr,-- Memory Address bus
		 FlashByte=>FlashByte,-- Byte enable('0') or word enable('1')
       RamCS=>RamCS,-- RAM CS
       FlashCS=>FlashCS,-- Flash CS
       MemWR=>MemWr,-- memory write 
       MemOE=>MemOe,-- memory read (Output Enable), 
		                           -- also controls the MemDB direction
       RamUB=>RamUB,-- RAM Upper byte enable 
       RamLB=>RamLB,-- RAM Lower byte enable 
       RamCre=>RamCre,-- Cfg Register enable 
       RamAdv=>RamAdv,-- RAM Address Valid pin
       RamClk=>RamClk,-- RAM Clock 
       RamWait=>RamWait,-- RAM Wait pin 
       FlashRp=>FlashRp,-- Flash RP pin 
       FlashStSts=>FlashStSts,-- Flash ST-STS pin 
		  
       MemCtrlEnabled=>MemCtrlEnabled-- MemCtrl takes bus control 

       );

end memModule_arch;