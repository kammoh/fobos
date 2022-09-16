--File  : core_warpper_tb.vhd
--Author: Abubakr Abdulgadir
--Date  : 4/12/2022

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;

entity core_wrapper_tb is
    generic(
        G_CONFIG_FNAME : string := "../KAT/v1/configFile.txt";
        G_DIN_FNAME    : string := "../KAT/v1/dinFile.txt";
        G_DOUT_FNAME   : string := "../KAT/v1/doutFile.txt"
    );
end core_wrapper_tb;

architecture behav of core_wrapper_tb is

    constant period : time      := 10 ns;
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal err      : std_logic := '0';

    FILE configFile : TEXT OPEN READ_MODE is G_CONFIG_FNAME;
    FILE dinFile    : TEXT OPEN READ_MODE is G_DIN_FNAME;
    FILE doutFile   : TEXT OPEN WRITE_MODE is G_DOUT_FNAME;

    -- crypto core signals
    signal di_ready                  : std_logic;
    signal din                       : std_logic_vector(3 downto 0);
    signal di_valid                  : std_logic := '0';
    signal do_ready                  : std_logic := '0';
    signal dout                      : std_logic_vector(3 downto 0);
    signal do_valid                  : std_logic;
    --
    signal writestrobe, do_was_valid : std_logic;
    signal config_done               : std_logic := '0';
    signal stop_clk                  : std_logic := '0';

begin

    clk <= not clk after period / 2 when stop_clk = '0' else '0';

    inst_core_wrapper : entity work.core_wrapper(behav)
            -- generic map(
            -- )
        port map(
            clk      => clk,
            rst      => rst,
            di_valid => di_valid,
            di_ready => di_ready,
            do_valid => do_valid,
            do_ready => do_ready,
            din      => din,
            dout     => dout
        );

    readVec : process
        variable line_data : LINE;
        variable word      : std_logic_vector(3 downto 0);
        variable read_good : boolean := True;
        variable space     : character;
    begin
        --! Send Config------------------------------------------------
        rst <= '1';
        wait for period;
        rst <= '0';
        wait for 4 * period;

        report "## FOBOS_TB: Sending configuration.";
        while not endfile(configFile) loop
            readline(configFile, line_data);
            loop                        --read data words from line
                hread(line_data, word, good => read_good);
                if not read_good then   -- if end of line go to next line
                    exit;
                else
                    di_valid <= '1';
                    din      <= word;
                    wait until di_ready = '1' and rising_edge(clk); -- until word consumed by destination
                    di_valid <= '0';
                end if;
            end loop;
            report "## FOBOS_TB: sent config line.";
        end loop;
        wait for period;
        config_done <= '1';
        report "## FOBOS_TB: sending config done.";
        wait for 10 * period;

        --! Send TVs---------------------------------------------------

        while not endfile(dinFile) loop
            report "## FOBOS_TB: reading one line of tv.";
            readline(dinFile, line_data);
            loop                        --read data words from line
                hread(line_data, word, good => read_good);
                if not read_good then   -- if end of line go to next line
                    --report "## FOBOS_TB: Read not good.";
                    exit;
                else
                    di_valid <= '1';
                    din      <= word;
                    wait until di_ready = '1' and rising_edge(clk); -- until word consumed by desitination
                    di_valid <= '0';
                end if;
            end loop;
            report "## FOBOS_TB: sending tv done. Waiting for output.";
            wait until writestrobe = '1';
            report "## FOBSO_TB: output unloaded.";
        end loop;
        wait for period;
        stop_clk <= '1';
        report "## FOBOS_TB: Simulation finished.";
        wait;
    end process;

    process(clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                do_was_valid <= '0';
            else
                do_was_valid <= do_valid;
            end if;
        end if;
    end process;

    writestrobe <= do_was_valid and not do_valid;

    do_ready <= '1';

    writeVec : process(clk)
        variable VectorLine : LINE;
    begin
        if (rising_edge(clk)) then
            if (do_ready = '1' and do_valid = '1') then
                hwrite(VectorLine, dout);
            end if;
            if (writestrobe = '1') then
                writeline(doutFile, VectorLine);
            end if;
        end if;
    end process;

end behav;
