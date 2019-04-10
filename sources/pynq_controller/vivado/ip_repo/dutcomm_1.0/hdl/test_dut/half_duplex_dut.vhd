---------------------------------------------------------------------------------
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

entity half_duplex_dut is
    generic(
        W : integer := 128;
        SW : integer :=128
    );
    port(
       clk         : in STD_LOGIC;
       rst         : in STD_LOGIC; --also resets the dut
       ---External bus--half duplex interface 
       shared_handshake_out : out std_logic; 
       shared_handshake_in  : in std_logic;
       dbus : inout STD_LOGIC_VECTOR (3 downto 0);
       direction_in : in std_logic
       );
       
end half_duplex_dut;

architecture behav of half_duplex_dut is

signal din_s         :  STD_LOGIC_VECTOR (3 downto 0);
signal di_valid_s    :  STD_LOGIC;
signal di_ready_s    :  STD_LOGIC;        
signal dout_s        :  STD_LOGIC_VECTOR (3 downto 0);
signal do_valid_s    :  STD_LOGIC;
signal do_ready_s    :  STD_LOGIC;

begin

    
    hd_int: entity work.half_duplex_interface(behav)
        generic map(
            MASTER => false
        )
        port map( 
            --external bus
            shared_handshake_out => shared_handshake_out,
            shared_handshake_in  => shared_handshake_in,
            dbus => dbus,
            direction_out => open, 
            --user connection
            ---out/in from the view point of the interface user
            handshake0_out => di_ready_s,
            handshake1_out => do_valid_s,
            handshake0_in =>  di_valid_s,
            handshake1_in =>  do_ready_s,
            --data
            dout => dout_s, -- from the user point of view
            din  => din_s, -- from the user point of view
            ---control
            direction_in => direction_in -- 0 --for phase0 (ctrl -> dut)-- drived by master
                   
        );
        
    dut: entity work.FOBOS_DUT(structural)
        generic map(       
            W => W,
            SW => SW                                    
        )
        port map(
            clk => clk,
            rst => rst,
            di_valid => di_valid_s,
            do_ready => do_ready_s,
            di_ready => di_ready_s, 
            do_valid => do_valid_s,
            din   => din_s,
            dout  => dout_s   
        );

end behav;
