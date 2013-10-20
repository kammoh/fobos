library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity driver is
    Port ( FIFO1_FULL : in  STD_LOGIC;
           FIFO2_FULL : in  STD_LOGIC;
           FIFO1_EMPTY : in  STD_LOGIC;
           FIFO2_EMPTY : in  STD_LOGIC;
           FIFO1_RD_EN : out  STD_LOGIC;
           FIFO2_RD_EN : out  STD_LOGIC;
           FIFO1_WR_EN : out  STD_LOGIC;
           FIFO2_WR_EN : out  STD_LOGIC);
end driver;

architecture Behavioral of driver is

begin


end Behavioral;

