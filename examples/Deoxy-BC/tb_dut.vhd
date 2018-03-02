--##################################################################################
--#                                                                                #
--# Copyright 2016 Cryptographic Engineering Research Group (CERG)               #
--# George Mason University                                                            #    
--#   http://cryptography.gmu.edu/fobos                                            #                            
--#                                                                                     #                                
--# Licensed under the Apache License, Version 2.0 (the "License");              #
--# you may not use this file except in compliance with the License.             #
--# You may obtain a copy of the License at                                      #
--#                                                                              #
--#     http://www.apache.org/licenses/LICENSE-2.0                               #
--#                                                                              #
--# Unless required by applicable law or agreed to in writing, software          #
--# distributed under the License is distributed on an "AS IS" BASIS,            #
--# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.     #
--# See the License for the specific language governing permissions and          #
--# limitations under the License.                                               #
--#                                                                               #
--##################################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_dut IS
END tb_dut;
 
ARCHITECTURE behavior OF tb_dut IS 
 
    COMPONENT dutTopLevel
    PORT(
         clock      : IN  std_logic;
         reset      : IN  std_logic;
         src_ready  : IN  std_logic;
         dst_ready  : IN  std_logic;
         datain     : IN  std_logic_vector(15 downto 0);
         src_read   : OUT std_logic;
         dst_write  : OUT std_logic;
         dataout    : OUT std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock     : std_logic := '0';
   signal reset     : std_logic := '0';
   signal src_ready : std_logic := '0';
   signal dst_ready : std_logic := '0';
   signal datain    : std_logic_vector(15 downto 0) := (others => '0');

    --Outputs
   signal src_read  : std_logic;
   signal dst_write : std_logic;
   signal dataout   : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
   -- Test Vectors
   signal key       : std_logic_vector(127 downto 0):=
                                    x"55555555555555555555555555555555";
   signal key1      : std_logic_vector(127 downto 0):=
                                    x"FB284A91308B0C576C0B5D109D6CB009";
   signal key2      : std_logic_vector(127 downto 0):=
                                    x"1E594A095A0347E7457321BAADFFB975";
   signal plaintext1: std_logic_vector(127 downto 0):=
                                    x"ffffffffffffffffffffffffffffffff";
   signal plaintext2: std_logic_vector(127 downto 0):=
                                    x"CC428A030FDDEDF5AA63618750A23167";                                    
   signal Ciphertext2:std_logic_vector(127 downto 0):=
                                    x"C6402266201A962A0336B1F14BE31C44";                                    
   signal cmd_key       : std_logic_vector(15 downto 0);                                   
   signal cmd_plaintext : std_logic_vector(15 downto 0);                                   
   signal count         : integer :=0;                                   
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
    uut: dutTopLevel PORT MAP (
          clock     => clock,
          reset     => reset,
          src_ready => src_ready,
          dst_ready => dst_ready,
          datain    => datain,
          src_read  => src_read,
          dst_write => dst_write,
          dataout   => dataout
        );

    -- Clock process definitions
    clock_process :process
    begin
        clock <= '1';
        wait for clock_period/2;
        clock <= '0';
        wait for clock_period/2;
    end process;
    count_process :process
    begin
        count <= count +1;
          wait for clock_period;
    end process;
        
        
   -- Stimulus process
    stim_proc: process
    begin        
      -- hold reset state for 100 ns.
      reset     <= '1';
      wait for clock_period*3;
      wait for clock_period*1/5;
      reset     <='0';
      src_ready <='1';
      
      datain    <= cmd_key; 
      wait for clock_period*2;--Need to include extra wait. Don't know the reason
      
      L1:   for i in 7 downto 0 loop
                datain <= key(16*i+15 downto 16*i);
                wait for clock_period;
            end loop;
            
      datain    <= cmd_plaintext;
      wait for clock_period;
      
      L2:   for i in 7 downto 0 loop
                datain <= plaintext1(16*i+15 downto 16*i);
                wait for clock_period;
            end loop;
      src_ready <='0';
      dst_ready <='1';
      wait until dst_write<='1';
      dst_ready <='1';
      wait for clock_period*16;
      
    wait;
    end process;
    cmd_key         <= "00" & x"010" & "10";
    cmd_plaintext   <= "00" & x"010" & "11";
    
END;
