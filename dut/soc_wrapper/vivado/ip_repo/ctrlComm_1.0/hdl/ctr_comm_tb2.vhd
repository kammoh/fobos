----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/13/2018 03:35:24 PM
-- Design Name: 
-- Module Name: test_dutcomm_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl_comm_tb2 is
--  Port ( );
end ctrl_comm_tb2;

architecture Behavioral of ctrl_comm_tb2 is

signal  clk         : STD_LOGIC := '0';
signal  rst         : std_logic;
signal  s_axis_tvalid :  STD_LOGIC;
signal  s_axis_tdata :  STD_LOGIC_VECTOR ( 31 downto 0 );
signal  s_axis_tready :  STD_LOGIC;
signal  start :  STD_LOGIC;
---
signal  res_ready : std_logic;
signal  rx_data : std_logic_vector(31 downto 0);
signal  rx_valid : std_logic;
signal  rx_ready : std_logic;
signal  status_c   : std_logic_vector(7 downto 0);
signal  status_d   : std_logic_vector(7 downto 0);

constant  period : time := 10 ns;

begin

dut : entity work.test_ctrl_comm_wrapper(structure)
port map (
clk => clk,
res_ready_0 => res_ready,
rst => rst,
rx_data_0 => rx_data,
rx_ready_0 => rx_ready,
rx_valid_0 => rx_valid,
s_axis_tdata_0 => s_axis_tdata,
s_axis_tready_0 => s_axis_tready,
s_axis_tvalid_0 => s_axis_tvalid,
start => start,
status_c => status_c,
status_d => status_d
);



clk <= not clk after period / 2;

stim: process 
begin
rst <= '1';
start <= '0';
res_ready <= '0';
s_axis_tvalid <= '0';


wait for 20 * period;
rst <= '0';
wait for 10 * period;
--fill tx fifo
s_axis_tvalid <= '1';
s_axis_tdata <= x"12345678";
wait for period;
s_axis_tdata <= x"9abcdef0";
wait for period;
s_axis_tvalid <= '0';
wait for 4 * period;
start <= '1';
wait for 20 * period;
--get data from dutComm
res_ready <= '1';
rx_ready <= '1';
wait for period;

wait;
end process;

end Behavioral;
