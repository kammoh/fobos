library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;



entity dut_working_counter is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           dut_working : in STD_LOGIC;
           working_count : out STD_LOGIC_VECTOR (31 downto 0));
end dut_working_counter;

architecture mixed of dut_working_counter is
        TYPE fsm_state IS (DUT_IDLE, DUT_RUNNING);
        SIGNAL cstate, nstate : fsm_state;
        
        SIGNAL ctr, nctr: unsigned(31 DOWNTO 0); 
begin

    -- sequential --
    PROCESS (clk)
    BEGIN
        if rising_edge(clk) then
            if (rst = '1') then
                cstate <= DUT_IDLE;
                ctr <= to_unsigned(0, ctr'length);
            else
                ctr    <= nctr;
                cstate <= nstate;
            end if;
        end if;
    END PROCESS;
    
     
    PROCESS (dut_working, cstate, ctr)
    BEGIN
        case cstate is 
            WHEN DUT_IDLE =>
                if (dut_working = '1') then
                    nstate <= DUT_RUNNING;
                    nctr <= to_unsigned(0, ctr'length);
                else
                    nstate <= DUT_IDLE;
                    nctr   <= ctr;
                end if;
            WHEN DUT_RUNNING =>
                nctr <= ctr + 1;
                
                if (dut_working = '0') then
                    nstate <= DUT_IDLE;
                else
                    nstate <= DUT_RUNNING;
                end if;
        END CASE;
    END PROCESS;

    working_count <= STD_LOGIC_VECTOR(ctr);

end mixed;
