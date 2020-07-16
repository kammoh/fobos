library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port ( 
				process_data : IN  STD_LOGIC;
				clock : IN  STD_LOGIC;
				reset : IN  STD_LOGIC;
				FIFO1_EMPTY : IN  STD_LOGIC;
				FIFO2_EMPTY : IN  STD_LOGIC;
				FIFO1_FULL : IN  STD_LOGIC;
				FIFO2_FULL : IN  STD_LOGIC;
				MUX_SEL : OUT  STD_LOGIC;
				FIFO1_RD_EN : OUT  STD_LOGIC;
				FIFO2_RD_EN : OUT  STD_LOGIC;
				FIFO1_WR_EN : OUT  STD_LOGIC;
				FIFO2_WR_EN : OUT  STD_LOGIC;
				DRAM_WR_EN : OUT  STD_LOGIC;
				DRAM_Count_en : OUT STD_LOGIC;
				DRAM_RESET : OUT STD_LOGIC;
				stall : OUT  STD_LOGIC
			);
end controller;

architecture contr_arch of controller is
	TYPE State_type IS (START, write_FIFO1, write_FIFO2, read_FIFO1, read_FIFO2) ;
	SIGNAL y : State_type ;
BEGIN
	PROCESS(reset, clock)
	BEGIN
		IF reset = '0' THEN
			y <= START ;
		ELSIF (Clock'EVENT AND clock = '1') THEN			
			CASE y IS
				WHEN START =>
				--may have to add some blank signals for timing
					IF process_data = '0' THEN 
						y <= START;--if we do not have data to process
					ELSE 
						y <= write_FIFO1;--if we have data to process
					END IF;

				WHEN write_FIFO1 =>
					IF (FIFO1_FULL = '1' OR FIFO2_FULL = '1') THEN
						y <= read_FIFO1;
					ELSE
						y <= write_FIFO2;
					END IF;
				
				WHEN write_FIFO2 =>
					IF (FIFO1_FULL = '1' OR FIFO2_FULL = '1') THEN
						y <= read_FIFO2;
					ELSE
						y <= write_FIFO1;
					END IF;

				WHEN read_FIFO1 =>
					IF ((FIFO1_EMPTY = '1') AND (FIFO2_EMPTY = '1')) THEN
						y <= START;
					ELSE
						y <= read_FIFO2;
					END IF;
				
				WHEN read_FIFO2 =>
					IF ((FIFO1_EMPTY = '1') AND (FIFO2_EMPTY = '1')) THEN
						y <= START;
					ELSE
						y <= read_FIFO1;
					END IF;


			END CASE ;
		
		END IF ;
	END PROCESS ;
			
			--9 Output Control Signals Based Upon 7 Input Status Signals
			FIFO1_WR_EN <= '1' WHEN y = write_FIFO1 ELSE '0';
			FIFO2_WR_EN <= '1' WHEN y = write_FIFO2 ELSE '0';
			FIFO1_RD_EN <= '1' WHEN y = read_FIFO1 ELSE '0';
			FIFO2_RD_EN <= '1' WHEN y = read_FIFO2 ELSE '0';
			MUX_SEL <= '1' WHEN y = read_FIFO2 ELSE '0';
			DRAM_WR_EN <= '1' WHEN ((y = read_FIFO1) OR (y = read_FIFO2)) ELSE '0';
			DRAM_Count_en <= '1' WHEN ((y = read_FIFO1) OR (y = read_FIFO2)) ELSE '0';
			DRAM_RESET <= '1' WHEN y = START ELSE '0';
			stall <= '1' WHEN ((y = read_FIFO1) OR (y = read_FIFO2)) ELSE '0';


end contr_arch;

