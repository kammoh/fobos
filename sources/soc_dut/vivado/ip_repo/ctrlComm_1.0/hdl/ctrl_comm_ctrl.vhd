library IEEE;
use ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl_comm_ctrl is
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        tx_valid : in STD_LOGIC;
        tx_ready : out STD_LOGIC;
        di_valid : in STD_LOGIC;
        di_ready : out std_logic;
        rx_valid : out STD_LOGIC;
        rx_ready : in STD_LOGIC;
        rx_last     : out std_logic;
        do_ready : in STD_LOGIC;
        do_valid : out std_logic;
        res_ready    : in std_logic; -- signal to start sending data
        ---Internal control/status
        din_cnt_clr : out std_logic;
        din_cnt_en : out std_logic;
        din_cnt_last : in std_logic;
        dout_cnt_clr : out std_logic;
        dout_cnt_en : out std_logic;
        dout_cnt_last : in std_logic;
        sipo_en       : out std_logic;
        status         : out std_logic_vector(7 downto 0)
    );
end ctrl_comm_ctrl;

architecture Behav of ctrl_comm_ctrl is

type STATE is (S_IDLE, S_WAIT_READY, S_SND, S_WAIT_VALID, S_RCV, S_WAIT_RES);
signal current_state,next_state:state;
--status codes
constant IDLE       : std_logic_vector(7 downto 0) := x"01";
constant WAIT_READY : std_logic_vector(7 downto 0) := x"05";
constant SND        : std_logic_vector(7 downto 0) := x"0a";
constant WAIT_VALID : std_logic_vector(7 downto 0) := x"0f";
constant RCV        : std_logic_vector(7 downto 0) := x"15";
constant WAIT_RES       : std_logic_vector(7 downto 0) := x"1a";
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

process(current_state, tx_valid, do_ready, di_valid, res_ready,din_cnt_last, rx_ready, dout_cnt_last)
begin
--default outputs
do_valid        <= '0';
tx_ready        <= '0';
di_ready        <= '0';
rx_valid        <= '0';
rx_last         <= '0';
---Internal ctrl
din_cnt_clr     <= '0';
din_cnt_en      <= '0';
dout_cnt_clr    <= '0';
dout_cnt_en     <= '0';
sipo_en         <= '0';


case current_state is
    
    when S_IDLE =>
        status <= IDLE;
        din_cnt_clr <= '1';
        dout_cnt_clr <= '1';
        next_state <= S_WAIT_VALID;
        
    when S_WAIT_VALID =>
        status <= WAIT_VALID;
        di_ready <= '1';
        if di_valid = '1' then
             next_state <= S_RCV;
             din_cnt_en <= '1';
             sipo_en <= '1';
        else
             next_state <= S_WAIT_VALID;
        end if;
            
    when S_RCV  =>
        status <= RCV;
        if rx_ready = '1' then 
            di_ready <= '1';
        end if;
        if di_valid = '1' then 
            if din_cnt_last = '1' then
                rx_valid <= '1';
                if rx_ready = '1' then
                    din_cnt_clr <= '1';
                    --di_ready <= '1';
                end if;
            else
                --di_ready <= '1';
                din_cnt_en <= '1';
                sipo_en <= '1';    
            end if;
                next_state <= S_RCV;
        else
            rx_last <= '1';
            rx_valid <= '1'; -- so that tlast is accepted by slave--invalid data
            next_state <= S_WAIT_RES; --when do_valid = 0 we are done
        end if;
    
    when S_WAIT_RES =>
        status <= WAIT_RES;
        if res_ready = '1' then
            next_state <= S_SND;
        else
            next_state <= S_WAIT_RES;
        end if;
        
    when S_WAIT_READY =>
        status <= WAIT_READY;
        if do_ready = '1' then 
            next_state <= S_SND;
        else
            next_state <= S_WAIT_READY;
        end if;
    
    when S_SND  =>
        status <= SND;
        if tx_valid <= '1' then
            do_valid <= '1';
        end if;
        if do_ready = '1' and tx_valid = '1' then
            dout_cnt_en <= '1';
            --do_valid <= '1';
            if dout_cnt_last = '1'then
                tx_ready <= '1';
            end if;
            next_state <= S_SND;
        else
            next_state <= S_IDLE;
        end if;
     
end case;    

end process;

end Behav;
