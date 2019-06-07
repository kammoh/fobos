----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/10/2018 04:07:34 PM
-- Design Name: 
-- Module Name: rst_mod - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity rst_mod is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           dut_working : in STD_LOGIC;
           time_to_rst : in std_logic_vector(31 downto 0);
           dut_rst_cmd : out STD_LOGIC);
end rst_mod;
   
architecture behav of rst_mod is
----timeout 
type state is (S_IDLE, S_WORKING, S_RST_CMD);
constant C_IDLE     : std_logic_vector(31 downto 0)     := x"00000001";
constant C_STARTED  : std_logic_vector(31 downto 0)     := x"00000002";
constant C_RST : std_logic_vector(31 downto 0)     := x"00000004";

signal current_state, next_state : state;
signal rst_cnt              : unsigned(31 downto 0);
signal clr_rst_cnt      : std_logic;
signal en_rst_cnt       : std_logic;
signal cnt_exceed     : std_logic;
signal en_module    : std_logic;

begin

p_timeout_cnt : process(clk)
begin
    if rising_edge(clk) then
        if clr_rst_cnt = '1' then
            rst_cnt <= (others => '0');
        else 
            if en_rst_cnt = '1' then
                rst_cnt <= rst_cnt + 1;
            end if;
        end if;    
    end if;
end process;

state_reg: process (clk)
begin
    if(rising_edge(clk)) then
        if rst = '1' then
            current_state <= S_IDLE;
        else
            current_state <= next_state;
        end if;
    end if;
end process;

p_comb : process(current_state, dut_working, cnt_exceed)
begin
--default outputs
clr_rst_cnt <= '0';
en_rst_cnt  <= '0';
dut_rst_cmd <= '0';

case current_state is

    when S_IDLE => 
        if dut_working = '1' and en_module = '1' then
            en_rst_cnt <= '1';
            next_state <= S_WORKING;
        else 
            clr_rst_cnt <= '1';
            next_state <= S_IDLE;
        end if;

    when S_WORKING =>
        en_rst_cnt <= '1';
        if dut_working = '1' then
            if cnt_exceed = '1' then
                next_state <= S_RST_CMD;
            else
                next_state <= S_WORKING;
            end if;
        else
            next_state <= S_IDLE;        
        end if;
     
    when S_RST_CMD =>
        dut_rst_cmd <= '1';
        next_state <= S_IDLE;        
    
end case;
    
end process;
----
cnt_exceed <= '1' when unsigned(rst_cnt) >= unsigned(time_to_rst) else '0';
en_module <= '1' when time_to_rst > x"00000000" else '0'; --if timeout not set then nothing to do

end behav;