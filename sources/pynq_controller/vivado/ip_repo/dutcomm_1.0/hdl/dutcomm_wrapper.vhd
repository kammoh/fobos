----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2019 11:03:20 AM
-- Design Name: 
-- Module Name: dutcomm_wrapper - behav
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

entity dutcomm_wrapper is
    port(
       clk         : in STD_LOGIC;
       rst         : in STD_LOGIC; --also resets the dut
       tx_data     : in STD_LOGIC_VECTOR (31 downto 0);
       tx_valid    : in STD_LOGIC;
       tx_ready    : out STD_LOGIC;
       rx_data     : out STD_LOGIC_VECTOR (31 downto 0);
       rx_valid    : out STD_LOGIC;
       rx_ready    : in STD_LOGIC;
       rx_last     : out std_logic;
       dut_rst     : out std_logic;
       start       : in std_logic;
       status      : out std_logic_vector(7 downto 0);
       snd_start   : out std_logic; --tell other that sending data to dut started.
       op_done     : out std_logic; --tell others that operation (i.e. encryption) is done.
       dut_working : out std_logic;
       started     : out std_logic;
       expected_out_len : in std_logic_vector(31 downto 0);
       --interface selection
       legacy_interface : in std_logic;
       ---External bus--original interface
       din         : out STD_LOGIC_VECTOR (3 downto 0);
       di_valid    : out STD_LOGIC;
       di_ready    : in STD_LOGIC;        
       dout        : in STD_LOGIC_VECTOR (3 downto 0);
       do_valid    : in STD_LOGIC;
       do_ready    : out STD_LOGIC;
       ---External bus--half duplex interface 
       shared_handshake_out : out std_logic; 
       shared_handshake_in  : in std_logic;
       dbus : inout STD_LOGIC_VECTOR (3 downto 0);
       direction_out : out std_logic);
       
end dutcomm_wrapper;

architecture behav of dutcomm_wrapper is
---signals connected to dutcomm
signal din_d         :  STD_LOGIC_VECTOR (3 downto 0);
signal di_valid_d    :  STD_LOGIC;
signal di_ready_d    :  STD_LOGIC;        
signal dout_d        :  STD_LOGIC_VECTOR (3 downto 0);
signal do_valid_d    :  STD_LOGIC;
signal do_ready_d    :  STD_LOGIC;
signal direction     : std_logic;
---signals connected to half_duplex_interface
signal handshake0_out_h : std_logic;
signal handshake1_out_h : std_logic;
signal handshake0_in_h  : std_logic;
signal handshake1_in_h  : std_logic;
signal dout_h : std_logic_vector(3 downto 0);-- from the user point of view
signal din_h  : std_logic_vector(3 downto 0);

begin
    --dutcomm instance
    dutcm: entity work.dutComm(behav)
    port map ( 
            clk => clk,
            rst => rst,
            tx_data => tx_data,
            tx_valid    => tx_valid,
            tx_ready    => tx_ready,
            rx_data => rx_data,
            rx_valid => rx_valid,
            rx_last => rx_last,
            rx_ready    => rx_ready,
            ---External bus
            din        => din_d,
            di_valid => di_valid_d,
            di_ready  => di_ready_d,        
            dout => dout_d,
            do_valid => do_valid_d,
            do_ready => do_ready_d,
            direction => direction,
            ---End external bus
            dut_rst => dut_rst,
            start => start,
            status => status,
            snd_start => snd_start,
            op_done => op_done,
            dut_working => dut_working,
            started     => started,
            expected_out_len => expected_out_len
        );
    hd_int: entity work.half_duplex_interface(behav)
        generic map(
            MASTER => true
        )
        port map( 
            --external bus
            shared_handshake_out => shared_handshake_out,
            shared_handshake_in  => shared_handshake_in,
            dbus => dbus,
            direction_out => direction_out, 
            --user connection
            ---out/in from the view point of the interface user
            handshake0_out => handshake0_out_h,
            handshake1_out => handshake1_out_h,
            handshake0_in =>  handshake0_in_h,
            handshake1_in =>  handshake1_in_h,
            --data
            dout => dout_h, -- from the user point of view
            din  => din_h, -- from the user point of view
            ---control
            direction_in => direction -- 0 --for phase0 (ctrl -> dut)-- drived by master
                   
        );
--    --interface selection mux
--    int_mux: process(din_d, di_valid_d, do_ready_d, dout, do_valid, di_ready,
--                    handshake0_in_h, handshake1_in_h, din_d, din_h)
--    begin
--        --default values
--        din             <= (others=>'0');
--        di_valid        <= '0';
--        do_ready        <= '0';
--        dout_d          <= (others=>'0');
--        do_valid_d      <= '0';
--        di_ready_d      <= '0';
--        handshake0_out_h<= '0';
--        handshake1_out_h<= '0';
--        dout_h          <= (others=>'0');
--        dout_d          <= (others=>'0');
--        -----
--        if legacy_interface = '1' then
--            din         <= din_d;
--            di_valid    <= di_valid_d;
--            do_ready    <= do_ready_d;
--            dout_d      <= dout;
--            do_valid_d  <= do_valid;
--            di_ready_d  <= di_ready;
--        else
--            handshake0_out_h <= di_valid_d;
--            handshake1_out_h <= do_ready_d;
--            di_ready_d <= handshake0_in_h;
--            do_valid_d <= handshake1_in_h;
--            dout_h <= din_d;
--            dout_d  <= din_h;
--        end if;
--    end process;
    
    handshake0_out_h <= di_valid_d;
                handshake1_out_h <= do_ready_d;
                di_ready_d <= handshake0_in_h;
                do_valid_d <= handshake1_in_h;
                dout_h <= din_d;
                dout_d  <= din_h;

end behav;
