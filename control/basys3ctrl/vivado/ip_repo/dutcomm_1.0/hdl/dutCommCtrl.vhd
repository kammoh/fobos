----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/11/2018 03:19:09 PM
-- Design Name: 
-- Module Name: dutCommCtrl - Behavioral
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

entity dutCommCtrl is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        tx_valid : in STD_LOGIC;
        tx_ready : out STD_LOGIC;
        di_valid : out STD_LOGIC;
        di_ready : in std_logic;
        rx_valid : out STD_LOGIC;
        rx_ready : in STD_LOGIC;
        rx_last  : out std_logic;
        do_ready : out STD_LOGIC;
        do_valid : in std_logic;
        dut_rst  : out std_logic;
        start    : in std_logic; -- signal to start sending data
        ---Internal control/status
        din_cnt_clr : out std_logic;
        din_cnt_en : out std_logic;
        din_cnt_last : in std_logic;
        
        dout_cnt_clr : out std_logic;
        dout_cnt_en : out std_logic;
        dout_cnt_last : in std_logic;
        sipo_en       : out std_logic;
        status         : out std_logic_vector(7 downto 0);
        op_done         : out std_logic;
        dut_working     : out std_logic;
        started         : out std_logic
        ---     
    );
end dutCommCtrl;

architecture Behav of dutCommCtrl is

type STATE is (S_IDLE, S_WAIT_TXVALID, S_WAIT_READY, S_SND, S_WAIT_VALID, S_RCV, S_DONE );
signal current_state,next_state:state;
--status codes
constant IDLE       : std_logic_vector(7 downto 0) := x"01";
constant C_TX_VALID   : std_logic_vector(7 downto 0) := x"02";
constant WAIT_READY : std_logic_vector(7 downto 0) := x"05";
constant SND        : std_logic_vector(7 downto 0) := x"0a";
constant WAIT_VALID : std_logic_vector(7 downto 0) := x"0f";
constant RCV        : std_logic_vector(7 downto 0) := x"15";
constant DONE       : std_logic_vector(7 downto 0) := x"1a";
--------
begin

state_reg: process (clk)
begin
    if(rising_edge(clk)) then
        if (rst = '1') then
            current_state <= S_IDLE;
        else
            current_state <= next_state;
        end if;
    end if;
end process;

process(current_state, tx_valid, di_ready, do_valid, start,din_cnt_last, rx_ready, dout_cnt_last)
begin
--default outputs
di_valid        <= '0';
tx_ready        <= '0';
do_ready        <= '0';
rx_valid        <= '0';
rx_last         <= '0';
op_done         <= '0';
dut_working     <= '0';
dut_rst         <= '0';
---Internal ctrl
din_cnt_clr     <= '0';
din_cnt_en      <= '0';
dout_cnt_clr    <= '0';
dout_cnt_en     <= '0';
sipo_en         <= '0';
started         <= '0';


case current_state is
    when S_IDLE =>
        status <= IDLE;
        din_cnt_clr <= '1';
        dout_cnt_clr <= '1';
        dut_rst     <= '1';
        next_state <= S_WAIT_TXVALID;
        
    when S_WAIT_TXVALID => --we do not want started to be issue when we reset this FSM
        status <= C_TX_VALID;
        if tx_valid = '1' then
            next_state <= S_WAIT_READY;
            started <= '1';
        else
            next_state <= S_WAIT_TXVALID;
        end if;
        
    when S_WAIT_READY =>
        status <= WAIT_READY;
        if di_ready = '1' then 
            next_state <= S_SND;
        else
            next_state <= S_WAIT_READY;
        end if;
    
    when S_SND  =>
        status <= SND;
        if tx_valid = '1' then
            di_valid <= '1';
        end if;
        if di_ready = '1' then
            if tx_valid = '1' then
                din_cnt_en <= '1';
                --di_valid <= '1';
            end if;
            if din_cnt_last = '1'then
                tx_ready <= '1';
            end if;
            next_state <= S_SND;
        else
            dut_working <= '1';
            --due to inverted clock, last 4bit block sent is not counted. So it stays in the FIFO and software will hang
            --this is becaus di_ready is set to zero half-cycle early.
            --drain the fifo
            tx_ready <= '1'; 
            next_state <= S_WAIT_VALID;
        end if;
    
    when S_WAIT_VALID =>
        status <= WAIT_VALID;
        do_ready <= '1';
        if do_valid = '1' then
            next_state <= S_RCV;
            dout_cnt_en <= '1';
            sipo_en <= '1';
        else
            dut_working <= '1';
            next_state <= S_WAIT_VALID;
        end if;
    
    when S_RCV  =>
        status <= RCV;
        if rx_ready = '1' then
            do_ready <= '1';
        end if;
        if do_valid = '1' then 
            if dout_cnt_last = '1' then
                rx_valid <= '1';
                if rx_ready = '1' then
                    dout_cnt_clr <= '1';
                    --do_ready <= '1';
                end if;
            else
                --do_ready <= '1';
                dout_cnt_en <= '1';
                sipo_en <= '1';    
            end if;
            next_state <= S_RCV;
        else
            next_state <= S_DONE; --when do_valid = 0 we are done
            rx_last <= '1';
            rx_valid <= '1'; --needed for slave to accept tlast-- ivalid  data
            op_done <= '1';
        end if;
        
    when S_DONE =>
        status <= DONE;
        if tx_valid = '1' then --wait unit upper level consumes the data
            next_state <= S_IDLE;
        else
            next_state <= S_DONE;
        end if;
        
    
end case;    

end process;

end Behav;
