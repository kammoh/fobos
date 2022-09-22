--##############################################################################
--#                                                                            #
--# Copyright 2022 Cryptographic Engineering Research Group (CERG)             #
--# George Mason University                                                    #
--#    http://cryptography.gmu.edu/fobos                                       #                            
--#                                                                            #
--# Licensed under the Apache License, Version 2.0 (the "License");            #
--# you may not use this file except in compliance with the License.           #
--# You may obtain a copy of the License at                                    #
--#                                                                            #
--#     http://www.apache.org/licenses/LICENSE-2.0                             #
--#                                                                            #
--# Unless required by applicable law or agreed to in writing, software        #
--# distributed under the License is distributed on an "AS IS" BASIS,          #
--# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
--# See the License for the specific language governing permissions and        #
--# limitations under the License.                                             #
--#                                                                            #
--##############################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

use work.LWC_config.all;

entity core_wrapper is

    generic(
        PDI_FIFO_DEPTH : positive := (3 + 16 + 16 + 16); -- headers, nonce, pt/ct, ad
        SDI_FIFO_DEPTH : positive := (1 + 16); -- header, key
        DO_FIFO_DEPTH  : positive := (2 + 16 + 16) -- headers, ct/pt, tag
    );
    port(
        clk      : in  std_logic;
        rst      : in  std_logic;
        di_valid : in  std_logic;
        di_ready : out std_logic;
        din      : in  std_logic_vector(3 downto 0);
        do_valid : out std_logic;
        do_ready : in  std_logic;
        dout     : out std_logic_vector(3 downto 0);
        status   : out std_logic        --report error e.g. via LED
    );

end core_wrapper;

architecture behav of core_wrapper is

    type state_type is (CLR, INST0, INST1, INST2, INST3, PARAM0, PARAM1, PARAM2, PARAM3, -- 0..8
                        LOAD_FIFO, RUN, UNLOAD, CONF_PRNG, SND_ACK, DELAY, INVALID_INST); -- 9..15
    signal state_r, nx_state : state_type;
    signal dbg_state         : natural;
    signal cnt_r, nx_cnt     : unsigned(15 downto 0);

    signal ins_reg0_en, ins_reg1_en, ins_reg2_en, ins_reg3_en         : std_logic;
    signal param_reg0_en, param_reg1_en, param_reg2_en, param_reg3_en : std_logic;

    signal ins_reg0_r, ins_reg1_r, ins_reg2_r, ins_reg3_r         : std_logic_vector(3 downto 0);
    signal param_reg0_r, param_reg1_r, param_reg2_r, param_reg3_r : std_logic_vector(3 downto 0);

    signal write_fifo : std_logic;
    signal write_reg  : std_logic;
    signal fifo_rst   : std_logic;
    signal reg_rst    : std_logic;

    --==================
    constant FIFO_OUT_WIDTH : positive := PDI_SHARES * W;

    signal wrapper_do_valid, wrapper_do_ready   : std_logic;
    signal wrapper_pdi_valid, wrapper_pdi_ready : std_logic;
    signal wrapper_sdi_valid, wrapper_sdi_ready : std_logic;
    signal wrapper_do_data                      : std_logic_vector(4 - 1 downto 0);
    signal lwc_do_fire                          : std_logic;
    --==================

    -- configuration registers
    signal conf_reg0_r, conf_reg1_r, conf_reg2_r, conf_reg3_r, conf_reg4_r, conf_reg5_r, conf_reg6_r, conf_reg7_r : std_logic_vector(15 downto 0);

    -- cmd
    signal opcode   : std_logic_vector(3 downto 0);
    signal dest_sel : std_logic_vector(3 downto 0);
    signal word_cnt : std_logic_vector(16 downto 0); -- in 4-bit words
    signal cmd      : std_logic_vector(4 - 1 downto 0);

    signal param           : std_logic_vector(15 downto 0);
    signal clr_cmd_reg     : std_logic;
    signal crypto_input_en : std_logic;
    signal outlen          : std_logic_vector(16 - 1 downto 0); -- expected outlen in bytes

    signal sel_out        : std_logic;
    signal ctrl_status    : std_logic_vector(4 - 1 downto 0);
    -- constants
    constant CMD_START    : std_logic_vector(3 downto 0) := x"1";
    constant CMD_GEN_RAND : std_logic_vector(3 downto 0) := x"2";

begin

    dbg_state <= state_type'pos(state_r);

    SCA_WRAPPER_INST : entity work.LWC_SCA_wrapper
        generic map(
            XRW            => 0,
            XW             => 4,
            PDI_FIFO_DEPTH => PDI_FIFO_DEPTH,
            SDI_FIFO_DEPTH => SDI_FIFO_DEPTH,
            DO_FIFO_DEPTH  => DO_FIFO_DEPTH
        )
        port map(
            clk         => clk,
            rst         => rst,
            pdi_data    => din,
            pdi_valid   => wrapper_pdi_valid,
            pdi_ready   => wrapper_pdi_ready,
            sdi_data    => din,
            sdi_valid   => wrapper_sdi_valid,
            sdi_ready   => wrapper_sdi_ready,
            do_data     => wrapper_do_data,
            do_valid    => wrapper_do_valid,
            do_ready    => wrapper_do_ready,
            rdi_data    => (others => '0'),
            rdi_valid   => '0',
            rdi_ready   => open,
            in_enable   => crypto_input_en,
            lwc_do_fire => lwc_do_fire
        );

    --=========================================================================================
    opcode   <= ins_reg2_r;
    dest_sel <= ins_reg3_r;
    word_cnt <= param_reg0_r & param_reg1_r & param_reg2_r & param_reg3_r & "0";
    param    <= param_reg0_r & param_reg1_r & param_reg2_r & din;
    outlen   <= conf_reg1_r;
    cmd      <= conf_reg0_r(3 downto 0);
    --

    dout <= ctrl_status when sel_out = '1' else wrapper_do_data;
    --==============================================
    -- comb : process(all)
    comb : process(state_r, lwc_do_fire, outlen, dest_sel, wrapper_sdi_ready, di_valid, wrapper_do_valid, wrapper_pdi_ready, cmd, word_cnt, di_ready, opcode, do_ready, cnt_r)
    begin
        --default values
        di_ready         <= '0';
        do_valid         <= '0';
        --
        ins_reg0_en      <= '0';
        ins_reg1_en      <= '0';
        ins_reg2_en      <= '0';
        ins_reg3_en      <= '0';
        param_reg0_en    <= '0';
        param_reg1_en    <= '0';
        param_reg2_en    <= '0';
        param_reg3_en    <= '0';
        write_fifo       <= '0';
        write_reg        <= '0';
        fifo_rst         <= '0';
        reg_rst          <= '0';
        clr_cmd_reg      <= '0';
        crypto_input_en  <= '0';
        wrapper_do_ready <= '0';
        --
        sel_out          <= '0';        --select output from ctrl (to send status)
        ctrl_status      <= (others => '0');
        status           <= '0';

        --
        nx_state <= state_r;
        nx_cnt   <= cnt_r;
        case (state_r) is
            when CLR =>
                fifo_rst    <= '1';
                clr_cmd_reg <= '1';
                nx_cnt      <= (others => '0');
                nx_state    <= INST0;

            when INST0 =>
                if cmd = CMD_GEN_RAND then
                    clr_cmd_reg <= '1';
                    nx_state    <= DELAY;
                elsif cmd = CMD_START then -- start cmd
                    clr_cmd_reg <= '1';
                    nx_state    <= RUN;
                else
                    di_ready <= '1';
                    if di_valid = '1' then
                        ins_reg0_en <= '1';
                        nx_state    <= INST1;
                    end if;
                    nx_cnt   <= (others => '0');
                end if;

            when INST1 =>
                di_ready <= '1';
                if di_valid = '1' then
                    ins_reg1_en <= '1';
                    nx_state    <= INST2;
                end if;

            when INST2 =>
                di_ready <= '1';
                if di_valid = '1' then
                    ins_reg2_en <= '1';
                    nx_state    <= INST3;
                end if;

            when INST3 =>
                di_ready <= '1';
                if di_valid = '1' then
                    ins_reg3_en <= '1';
                    nx_state    <= PARAM0;
                end if;

            when PARAM0 =>
                di_ready <= '1';
                if di_valid = '1' then
                    param_reg0_en <= '1';
                    nx_state      <= PARAM1;
                end if;

            when PARAM1 =>
                di_ready <= '1';
                if di_valid = '1' then
                    param_reg1_en <= '1';
                    nx_state      <= PARAM2;
                end if;

            when PARAM2 =>
                di_ready <= '1';
                if di_valid = '1' then
                    param_reg2_en <= '1';
                    nx_state      <= PARAM3;
                end if;

            when PARAM3 =>
                di_ready <= '1';
                if di_valid = '1' then
                    param_reg3_en <= '1';
                    case (opcode) is
                        when x"C" =>
                            nx_state <= LOAD_FIFO;
                        when x"8" =>
                            write_reg <= '1';
                            nx_state  <= INST0;
                        when x"0" =>
                            nx_state <= INST0; -- NOOP
                        when others =>
                            nx_state <= INVALID_INST;

                    end case;
                end if;

            when LOAD_FIFO =>
                case dest_sel is
                    when x"0" =>
                        di_ready <= wrapper_pdi_ready;
                        assert wrapper_pdi_ready = '1' report "wrapper_pdi_ready is not 1" severity error;
                    when x"1" =>
                        di_ready <= wrapper_sdi_ready;
                        assert wrapper_sdi_ready = '1' report "wrapper_sdi_ready is not 1" severity error;
                    when others =>
                        assert false report "bad dest_sel" severity error;
                        null;
                end case;

                if di_ready = '1' and di_valid = '1' then
                    if cnt_r = unsigned(word_cnt) then
                        nx_cnt      <= (others => '0');
                        ins_reg0_en <= '1';
                        nx_state    <= INST1;
                    else
                        write_fifo <= '1';
                        nx_cnt     <= cnt_r + 1;
                        nx_state   <= LOAD_FIFO;
                    end if;
                end if;

            when RUN =>
                crypto_input_en <= '1';
                if lwc_do_fire = '1' then
                    if cnt_r * (FIFO_OUT_WIDTH / 8) = unsigned(outlen) - FIFO_OUT_WIDTH / 8 then
                        nx_cnt   <= (others => '0');
                        nx_state <= UNLOAD;
                    else
                        nx_cnt   <= cnt_r + 1;
                        nx_state <= RUN;
                    end if;
                end if;

            when UNLOAD =>
                do_valid <= '1';
                if do_ready = '1' and wrapper_do_valid = '1' then
                    wrapper_do_ready <= '1';
                    if cnt_r = unsigned(outlen & "0") - 1 then --count nibbles
                        nx_cnt   <= (others => '0');
                        nx_state <= CLR;
                    else
                        nx_cnt   <= cnt_r + 1;
                        nx_state <= UNLOAD;
                    end if;
                end if;

            when DELAY =>
                if cnt_r = 16 - 1 then  -- 32-bit status
                    nx_cnt   <= (others => '0');
                    nx_state <= SND_ACK;
                else
                    nx_cnt   <= cnt_r + 1;
                    nx_state <= DELAY;
                end if;

            when SND_ACK =>
                sel_out     <= '1';
                do_valid    <= '1';
                ctrl_status <= x"A";
                if do_ready = '1' then
                    if cnt_r = 8 - 1 then -- 32-bit status
                        nx_cnt   <= (others => '0');
                        -- nx_state <= GEN_RAND;
                        nx_state <= INST0;
                    else
                        nx_cnt   <= cnt_r + 1;
                        nx_state <= SND_ACK;
                    end if;
                end if;

            when INVALID_INST =>
                status   <= '1';
                nx_state <= INVALID_INST; --hang wait for user reset

            when others =>
                nx_state <= INST0;
        end case;

    end process;

    reg : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state_r <= CONF_PRNG;
                cnt_r   <= (others => '0');
            else
                state_r <= nx_state;
                cnt_r   <= nx_cnt;
            end if;

            if ins_reg0_en = '1' then
                ins_reg0_r <= din;
            end if;

            if ins_reg1_en = '1' then
                ins_reg1_r <= din;
            end if;

            if ins_reg2_en = '1' then
                ins_reg2_r <= din;
            end if;

            if ins_reg3_en = '1' then
                ins_reg3_r <= din;
            end if;

            if param_reg0_en = '1' then
                param_reg0_r <= din;
            end if;

            if param_reg1_en = '1' then
                param_reg1_r <= din;
            end if;

            if param_reg2_en = '1' then
                param_reg2_r <= din;
            end if;

            if param_reg3_en = '1' then
                param_reg3_r <= din;
            end if;

        end if;
    end process;

    decoder : process(dest_sel, write_fifo)
    begin
        wrapper_pdi_valid <= '0';
        wrapper_sdi_valid <= '0';
        -- sipo2_di_valid <= '0';
        -- sipo3_di_valid <= '0';
        if write_fifo = '1' then
            case (dest_sel) is
                when x"0" =>
                    wrapper_pdi_valid <= '1';
                when x"1" =>
                    wrapper_sdi_valid <= '1';
                -- when x"2" =>
                --     sipo2_di_valid <= '1';
                -- when x"3" =>
                --     sipo3_di_valid <= '1';
                when others =>
                    null;
            end case;
        end if;

    end process;

    -- registers
    cmd_reg : process(clk)
    begin
        if rising_edge(clk) then
            if clr_cmd_reg = '1' then
                conf_reg0_r <= (others => '0');
            else
                if write_reg = '1' and dest_sel = x"0" then
                    conf_reg0_r <= param;
                end if;
            end if;
        end if;
    end process;

    conf_regs : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                conf_reg1_r <= (others => '0');
                conf_reg2_r <= (others => '0');
                conf_reg3_r <= (others => '0');
                conf_reg4_r <= (others => '0');
                conf_reg5_r <= (others => '0');
                conf_reg6_r <= (others => '0');
                conf_reg7_r <= (others => '0');
            elsif write_reg = '1' then
                case (dest_sel) is
                    when x"1" =>
                        conf_reg1_r <= param;

                    when x"2" =>
                        conf_reg2_r <= param;

                    when x"3" =>
                        conf_reg3_r <= param;

                    when x"4" =>
                        conf_reg4_r <= param;

                    when x"5" =>
                        conf_reg5_r <= param;

                    when x"6" =>
                        conf_reg6_r <= param;

                    when x"7" =>
                        conf_reg7_r <= param;

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

end behav;
