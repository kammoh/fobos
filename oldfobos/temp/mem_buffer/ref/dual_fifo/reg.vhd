LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Reg IS
	GENERIC(size : INTEGER := 16);
	PORT(
			D : IN STD_LOGIC_VECTOR(size-1 DOWNTO 0);
			Q : OUT STD_LOGIC_VECTOR(size-1 DOWNTO 0);
			ENABLE : IN STD_LOGIC;
			RESET : IN STD_LOGIC;
			CLOCK : IN STD_LOGIC
		);
END Reg;

ARCHITECTURE reg_arch OF Reg IS
BEGIN	   
	 
	PROCESS(CLOCK, ENABLE) 
	BEGIN 
	IF (rising_edge(CLOCK)) AND (ENABLE = '1') THEN 
		IF RESET = '1' THEN 
			Q <= (OTHERS => '0'); 
		ELSE
			Q <= D; 
		END IF; 
	END IF;
	END PROCESS;

END reg_arch;
