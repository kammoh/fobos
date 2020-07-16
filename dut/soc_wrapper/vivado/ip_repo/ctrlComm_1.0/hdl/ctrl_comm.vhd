library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl_comm is
    port ( 
        clk         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        tx_data     : in STD_LOGIC_VECTOR (31 downto 0);
        tx_valid    : in STD_LOGIC;
        tx_ready    : out STD_LOGIC;
        rx_data     : out STD_LOGIC_VECTOR (31 downto 0);
        rx_valid    : out STD_LOGIC;
        rx_ready    : in STD_LOGIC;
        rx_last     : out std_logic;
        dout        : out STD_LOGIC_VECTOR (3 downto 0);
        do_valid    : out STD_LOGIC;
        do_ready    : in STD_LOGIC;        
        din         : in STD_LOGIC_VECTOR (3 downto 0);
        di_valid    : in STD_LOGIC;
        di_ready    : out STD_LOGIC;
        res_ready   : in std_logic;
        status      : out std_logic_vector(7 downto 0)
     );
end ctrl_comm;

architecture behav of ctrl_comm is

signal dout_cnt, next_dout_cnt : std_logic_vector(2 downto 0);
signal dout_cnt_clr,dout_cnt_en: std_logic;
signal dout_cnt_last          : std_logic;
---din logic signals
signal din_cnt, next_din_cnt : std_logic_vector(2 downto 0);
signal din_cnt_clr,din_cnt_en: std_logic;
signal din_cnt_last          : std_logic;
signal sipo_reg : std_logic_vector(27 downto 0);
signal sipo_en : std_logic;

begin


---dout_mux
with dout_cnt select dout <=
    tx_data(31 downto 28) when "000",
    tx_data(27 downto 24) when "001",
    tx_data(23 downto 20) when "010",
    tx_data(19 downto 16) when "011",
    tx_data(15 downto 12) when "100",
    tx_data(11 downto  8) when "101",
    tx_data(7  downto  4) when "110",
    tx_data(3  downto  0) when "111",
    "0000"                when others;
   
--dout_cnt_reg-----------------------------------------------
process(clk)
begin
    if(rising_edge(clk)) then
        dout_cnt <= next_dout_cnt;
    end if;
end process;
next_dout_cnt <= (others => '0')  when dout_cnt_clr = '1' else
                dout_cnt + 1      when dout_cnt_en  = '1' else
                dout_cnt;
                
dout_cnt_last <= '1' when dout_cnt = "111" else '0';
-------------------------------------------------------------

--din logic-------------------------------------------------
sipo : process(clk)
begin
    if rising_edge(clk) then
        if sipo_en = '1' then
            sipo_reg <= sipo_reg(23 downto 0) & din;
        end if;
    end if;
end process;
--sipo cnt
process(clk)
begin
    if(rising_edge(clk)) then
        din_cnt <= next_din_cnt;
    end if;
end process;
next_din_cnt <= (others => '0')  when din_cnt_clr = '1' else
                din_cnt + 1      when din_cnt_en  = '1' else
                din_cnt;

din_cnt_last <= '1' when din_cnt = "111" else '0';
rx_data <= sipo_reg & din;



-------------------------------------------------------------
---controller

ctrl: entity work.ctrl_comm_ctrl(behav)
    port map (
        clk         => clk,
        rst         => rst,
        tx_valid    => tx_valid,
        tx_ready    => tx_ready,
        rx_valid    => rx_valid,
        rx_ready    => rx_ready,
        rx_last     => rx_last,
        do_valid    => do_valid,
        do_ready    => do_ready,
        di_valid    => di_valid,
        di_ready    => di_ready,
        res_ready   => res_ready,
        ---Internal control/status
        dout_cnt_clr => dout_cnt_clr,
        dout_cnt_en  => dout_cnt_en,
        dout_cnt_last=> dout_cnt_last,
        din_cnt_clr => din_cnt_clr,
        din_cnt_en  => din_cnt_en,
        din_cnt_last=> din_cnt_last,
        sipo_en => sipo_en,
        status => status
        ---     
    );
 
end Behav;
