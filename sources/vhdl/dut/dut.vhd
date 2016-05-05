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


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fobos_package.all;

entity dutTopLevel is 
    port(
         clock      : in  STD_LOGIC;
         reset      : in  STD_LOGIC;
         src_ready  : in  STD_LOGIC;
         dst_ready  : in  STD_LOGIC;
         datain     : in  STD_LOGIC_VECTOR(interfaceWidth-1 downto 0);
         src_read   : out STD_LOGIC;
         dst_write  : out STD_LOGIC;
         --stateMachineStatus: out std_logic_vector(7 downto 0); -- used for debog purpose only
         dataout    : out STD_LOGIC_VECTOR(interfaceWidth-1 downto 0)

         );
end dutTopLevel;

architecture structure of dutTopLevel is
signal data_enb             : std_logic;    -- from dut_contrl
signal key_enb              : std_logic;    -- from dut_contrl
signal cmd_enb              : std_logic; 
signal done_exe             : std_logic;
signal sr_output_enb        : std_logic;    -- from dut_contrl
signal sr_output_load       : std_logic;    -- from dut_contrl
signal start_to_crypto      : std_logic;    -- to crypto_core
signal cmd_buffer           : std_logic_vector(interfaceWidth-1 downto 0);
signal data_to_crypto       : std_logic_vector(maxBlockSize-1   downto 0); -- to crypto_core
signal key_to_crypto        : std_logic_vector(maxKeySize-1     downto 0); -- to crypto_core
signal data_from_crypto     : std_logic_vector(maxBlockSize-1   downto 0); -- from crypto_core
signal stateMachineStatus   : std_logic_vector(7 downto 0);
signal done_init            : std_logic;
signal init                 : std_logic;
signal start                : std_logic;
signal ready                : std_logic;

begin

 ------------------------ Input Shift-Registers-------------------------
 plainText : shiftregDataFromControl 
            generic map (
                            interfaceSize       => interfaceWidth       ,
                            dataSize            => maxBlockSize 
                        )
            port map    (
                            clock               => clock                ,
                            reset               => reset                ,
                            sr_e                => data_enb             ,
                            sr_input            => datain               ,
                            sr_output           => data_to_crypto
                        );

 key : shiftregDataFromControl 
            generic map (
                            interfaceSize       => interfaceWidth       ,
                            dataSize            => maxKeySize 
                        ) 
            port map    (
                            clock               => clock                ,
                            reset               => reset                ,
                            sr_e                => key_enb              ,
                            sr_input            => datain               ,
                            sr_output           => key_to_crypto
                        );
------------------------ Output Shift-Registers-------------------------            
 output  : shiftregDataToControl  
            generic map (
                            interfaceSize       => interfaceWidth       ,
                            dataSize            => maxBlockSize 
                        ) 
            port map    (
                            clock               => clock                ,
                            load                => sr_output_load       , 
                            sr_e                => sr_output_enb        ,
                            sr_input            => data_from_crypto     ,
                            sr_output           => dataout
                        );
------------------------ dut outer-level Controller-------------------       
control: dutController 
            port map    (
                            clock               => clock                ,
                            reset               => reset                ,
                            src_ready           => src_ready            ,
                            dst_ready           => dst_ready            ,
                            done_exe            => done_exe             ,
                            start_to_crypto     => start_to_crypto      ,
                            src_read            => src_read             ,
                            dst_write           => dst_write            ,
                            data_enb            => data_enb             ,
                            key_enb             => key_enb              ,
                            cmd_enb             => cmd_enb              ,
                            stateMachineStatus  => stateMachineStatus   ,
                            sr_output_enb       => sr_output_enb        ,
                            sr_output_load      => sr_output_load
                        );
------------------------ Crypto Core ------------------------- 

--------------------------------------------------------------------------------
-----------------  DUMMY dut ------------------------------------------------
--------------------------------------------------------------------------------
data_from_crypto  <= (data_to_crypto xor key_to_crypto) 
                     when start_to_crypto = '1' else (others => '0');

done_exe <= '1' when start_to_crypto ='1' else '0';

--==FOR I/O LOOP TEST
--===========================
--data_from_crypto  <= (data_to_crypto) when start_to_crypto = '1' 
--                     else (others => '0');



end structure; 
