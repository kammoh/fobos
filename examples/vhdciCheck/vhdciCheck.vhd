library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vhdciCheck is 
generic (N : integer := 10);
port (
    clk : in std_logic;
    vhdciOut : out std_logic_vector(39 downto 0)
);
end vhdciCheck;

architecture Behavioral of vhdciCheck is 
signal hbcntr : std_logic_vector(N-1 downto 0) := (others => '0');
signal freqShifter : std_logic_vector(7 downto 0):= (others => '0');
signal hb : std_logic;

begin

process (clk)
	begin
	if clk = '1' and clk'Event then
		hbcntr <= hbcntr + 1;
	end if;
end process;
	
	hb <= hbcntr(N-1);
	
process(hb)
	begin
	if hb = '1' and hb'Event then
		freqShifter <= freqShifter + 1;
		if (freqShifter = x"27" ) then
			freqShifter <= (others => '0');
		end if;
	end if;
end process;	
--		
vhdciOut <= (0=>clk, others => '0') when freqShifter = x"00" else
			(1=>clk, others => '0') when freqShifter = x"01" else
			(2=>clk, others => '0') when freqShifter = x"02" else
			(3=>clk, others => '0') when freqShifter = x"03" else
			(4=>clk, others => '0') when freqShifter = x"04" else
			(5=>clk, others => '0') when freqShifter = x"05" else
			(6=>clk, others => '0') when freqShifter = x"06" else
			(7=>clk, others => '0') when freqShifter = x"07" else
			(8=>clk, others => '0') when freqShifter = x"08" else
			(9=>clk, others => '0') when freqShifter = x"09" else
			(10=>clk, others => '0') when freqShifter = x"0A" else
			(11=>clk, others => '0') when freqShifter = x"0B" else
			(12=>clk, others => '0') when freqShifter = x"0C" else
			(13=>clk, others => '0') when freqShifter = x"0D" else
			(14=>clk, others => '0') when freqShifter = x"0E" else
			(15=>clk, others => '0') when freqShifter = x"0F" else
			(16=>clk, others => '0') when freqShifter = x"10" else
			(17=>clk, others => '0') when freqShifter = x"11" else
			(18=>clk, others => '0') when freqShifter = x"12" else
			(19=>clk, others => '0') when freqShifter = x"13" else
			(20=>clk, others => '0') when freqShifter = x"14" else
			(21=>clk, others => '0') when freqShifter = x"15" else
			(22=>clk, others => '0') when freqShifter = x"16" else
			(23=>clk, others => '0') when freqShifter = x"17" else
			(24=>clk, others => '0') when freqShifter = x"18" else
			(25=>clk, others => '0') when freqShifter = x"19" else
			(26=>clk, others => '0') when freqShifter = x"1A" else
			(27=>clk, others => '0') when freqShifter = x"1B" else
			(28=>clk, others => '0') when freqShifter = x"1C" else
			(29=>clk, others => '0') when freqShifter = x"1D" else
			(30=>clk, others => '0') when freqShifter = x"1E" else
			(31=>clk, others => '0') when freqShifter = x"1F" else
			(32=>clk, others => '0') when freqShifter = x"20" else
			(33=>clk, others => '0') when freqShifter = x"21" else
			(34=>clk, others => '0') when freqShifter = x"22" else
			(35=>clk, others => '0') when freqShifter = x"23" else
			(36=>clk, others => '0') when freqShifter = x"24" else
			(37=>clk, others => '0') when freqShifter = x"25" else
			(38=>clk, others => '0') when freqShifter = x"26" else
			(39=>clk, others => '0') when freqShifter = x"27" else
			(others =>'0');
			
end Behavioral;			