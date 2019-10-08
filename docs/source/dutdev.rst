DUT Algorithm Development
*************************

This document describes how to interface the DUT (Design Under Test) or victim to the DUT Wrapper.
The DUT is the algorithm to be attacked or tested.
The DUT or victim algorithm is user provided. However, the DUT wrapper is included with FOBOS.
The DUT Wrapper handles communication to the control board and includes FIFOs to store input data for the DUT along with output FIFO.


Data flow description:
======================

Test vectors are sent form PC one at a time to the control board which stores them breifly in a FIFO.
The PC sends a command indicating test vector is complete. This will initiates the process of sending the data from the controller to the DUT through the interface shown in the figure above.
The DUT wrapper then puts data in the correct FIFOs (PDI, SDI and RDI).
Once the DUT wrapper receives the start command from the controller, it de-assersts the reset signal and the DUT will run and use the data in the FIFOs. The output of the DUT is stored in the DO fifo. Once the DO FIFO accumulates EXPECTED_OUTPUT bytes, the DUT wrapper will send this data to the control board which forwards it to the PC.


The DUT Wrapper – DUT interface

The protocol follows a simle AXI stream protocol.
The DUT (victim) is instantiated as follows in the FOBOS_DUT.vhd file.

.. code-block:: vhdl


    victim: entity work.victim(behav)
        -- Choices for W and SW are independently any multiple of 4, defined in generics above
        generic map  (
            G_W          => W, -- ! pdi and do width (mulltiple of 4)
            G_SW         => SW -- ! sdi width (multiple of 4) 
        )
        port map(
            clk => clk,
            rst => start,  
            -- data signals
            pdi_data  => pdi_data,
            pdi_valid => pdi_valid,
            pdi_ready => pdi_ready,
            sdi_data => sdi_data,
            sdi_valid => sdi_valid,
            sdi_ready => sdi_ready,
            do_data => result_data,
            do_ready => result_ready,
            do_valid => result_valid

        --  ! if rdi_interface for side-channel protected versions is required,
        --  ! uncomment the rdi interface
        --  ,rdi_data => rdi_data,
        --  rdi_ready => rdi_ready,
        --  rdi_valid => rdi_valid
    );

The generic W is the PDI and DO width.
The generic SW is the SDI width.


It is highly recommended that the DUT is tested using the sources/dut/fobos_dut_tb.vhd test bench and ensure that the result data in the do port is valid. This testbench needs one test vector to be stored in the file dinFile.txt (see  testVectorGeneration in doc/QickStart).

Dummy DUT Example
=================

You can find an example dummy dut in 


.. code-block:: vhdl

    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    entity dummy is
        Generic(
            N        : integer := 8;
            NUMWORDS : integer := 6
        );
        port(clk       : in  STD_LOGIC;
             rst       : in  STD_LOGIC;
             pdi_data  : in  STD_LOGIC_VECTOR(N - 1 downto 0);
             pdi_valid : in  STD_LOGIC;
             pdi_ready : out STD_LOGIC;
             sdi_data  : in  STD_LOGIC_VECTOR(N - 1 downto 0);
             sdi_valid : in  STD_LOGIC;
             sdi_ready : out STD_LOGIC;
             do_data   : out STD_LOGIC_VECTOR(N - 1 downto 0);
             do_valid  : out STD_LOGIC;
             do_ready  : in  STD_LOGIC
            );
    end dummy;

    architecture behav of dummy is
        type state is (IDLE, RUN);
        signal current_state             : state;
        signal next_state                : state;
        signal cnt_clr, cnt_en, cnt_done : std_logic;
        signal cnt, next_cnt             : std_logic_vector(15 downto 0);

    begin

        ctrl : process(clk)
        begin
            if (rising_edge(clk)) then
                if (rst = '1') then
                    current_state <= IDLE;
                else
                    current_state <= next_state;
                end if;

            end if;

        end process;

        comb : process(current_state, pdi_valid, sdi_valid, do_ready, cnt_done)
        begin
            -- defaults
            pdi_ready <= '0';
            sdi_ready <= '0';
            do_valid  <= '0';
            cnt_clr   <= '0';
            cnt_en    <= '0';

            case current_state is
                when IDLE =>
                    cnt_clr <= '1';
                    if pdi_valid = '1' and sdi_valid = '1' and do_ready = '1' then
                        next_state <= RUN;
                    else
                        next_state <= IDLE;
                    end if;

                when RUN =>
                    if cnt_done = '1' then
                        next_state <= IDLE;
                    else
                        if pdi_valid = '1' and sdi_valid = '1' and do_ready = '1' then
                            pdi_ready <= '1';
                            sdi_ready <= '1';
                            do_valid  <= '1';
                            cnt_en    <= '1';
                        end if;
                        next_state <= RUN;
                    end if;

                when others =>
                    next_state <= IDLE;

            end case;

        end process;
        --do_data <= pdi_data xor sdi_data;
        do_data <= pdi_data;

        count : process(clk)
        begin
            if (rising_edge(clk)) then
                cnt <= next_cnt;
            end if;
        end process;
        next_cnt <= (others => '0') when cnt_clr = '1'
                    else cnt + 1 when cnt_en = '1'
                    else cnt;

        cnt_done <= '1' when (cnt = NUMWORDS) else '0';

    end behav;