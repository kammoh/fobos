library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller is
    Port (
			clk : IN STD_LOGIC;
--Write to these pins to the memory module (part of the datapath!)
--EppCtrl Side          
			EppAstb : OUT STD_LOGIC;
			EppDstb : OUT STD_LOGIC;
			EppWr : OUT STD_LOGIC;
			EppRst : OUT STD_LOGIC;
			EppDB : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			EppWait : IN STD_LOGIC;
--Memory Side
			RamCS : IN STD_LOGIC; 
			FlashCS : IN STD_LOGIC;
			MemWr : IN STD_LOGIC;
			MemOe : IN STD_LOGIC;
			RamUB : IN STD_LOGIC;
			RamLB : IN STD_LOGIC;
			RamCre : IN STD_LOGIC;
			RamAdv : IN STD_LOGIC;
			RamClk : IN STD_LOGIC;
			RamWait : OUT STD_LOGIC;
			FlashRp : IN STD_LOGIC;			
			FlashStSts : OUT STD_LOGIC;
			MemAdr : IN STD_LOGIC_VECTOR(23 DOWNTO 1);
			MemDB : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			FlashByte : IN STD_LOGIC;
			MemCtrlEnabled : IN STD_LOGIC					
					
					
			);
end Controller;

architecture cont_arch of Controller is

begin

--Writing a RAM Location Using the Automatic RAM Write Register (16-Bit Mode)
--1. Enable the OnBoardMemCfg component and set the 16-bit mode:
--1.1. Write "xx111111" to the regMemCtl, at EPP address MemCtrlReg = 0)
--2. Load the Memory Address Bus Register (MemAdr(18 downto 0)) with an even value:
--2.1. Write the lowest address byte to EPP Register MemAdr(7 downto 0) at EPP address
--MemAdrL = 1
--2.2. Write the middle address byte to EPP Register MemAdr(15 downto 8) at EPP address
--MemAdrM = 2
--2.3. Write the highest address byte to EPP Register MemAdr(18 downto 16) at EPP address
--MemAdrH = 3
--(for bytes keeping the previous value, the steps above can be skipped)
--3. Write lower data byte to the regMemRdData(7 downto 0) register at address RamAutoRW = 6.
--C1MemCtrl stores the lower byte in an intermediate register and increments the MemAdr register.
--No RAM write cycle is generated.
--4. Write upper data byte to the regMemRdData(7 downto 0) register at address RamAutoRW = 6.
--C1MemCtrl automatically generates the write sequence to write both lower and upper data bytes
--and increments the MemAdr register.
--5. Repeat steps 3 and 4 to write successive RAM locations.

TYPE state IS (S1, S1_1, S2, S2_1, S2_2, S2_3, S3, S4, S5);
SIGNAL Moore_state: state;

U_Moore: PROCESS (clock, reset)
BEGIN
	IF(reset = '1') THEN
		Moore_state <= S0;
	ELSIF (clock = '1' AND clock'event) THEN
		CASE Moore_state IS
			WHEN S0 =>
			  IF input = '1' THEN
                    Moore_state <= S1; 
                ELSE
                   Moore_state <= S0;
                END IF;

                       WHEN S1 =>
			  IF input = '0' THEN 
                                     Moore_state <= S2; 
                              ELSE
                                     Moore_state <= S1; 
                              END IF;
	                  WHEN S2 =>
			  IF input = '0' THEN
                                     Moore_state <= S0; 
			  ELSE 
                                     Moore_state <= S1; 
                              END IF;
		END CASE;
	END IF;
END PROCESS;

Output <= '1' WHEN Moore_state = S2 ELSE '0';




end cont_arch;

