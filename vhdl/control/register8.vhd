library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

ENTITY rege8 IS 

PORT (   a     : IN  std_logic_vector(7 downto 0);
         clk   : IN  std_logic;
         reset : IN  std_logic;
         en    : IN  std_logic;                         -- enable '1', idle '0'
         b     : OUT std_logic_vector(7 downto 0));
END rege8;

ARCHITECTURE behav OF rege8 IS

BEGIN

    PROCESS(a,en,clk,reset)
    BEGIN
        IF reset='1' THEN
            b <= (others => '0');

        ELSIF clk'EVENT AND clk = '1' THEN
            if en='1' then
                b <= a;
            end if;
        END IF;

    END PROCESS;

END behav;
