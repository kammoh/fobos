library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.fobos_package.all;

entity victimController is 
    port(
         clock             : in  std_logic                    ;
         reset             : in  std_logic                    ;
         src_ready         : in  std_logic                    ;
         dst_ready         : in  std_logic                    ;
         done_exe          : in  std_logic                    ;
         start_to_crypto   : out std_logic                    ;
         src_read          : out std_logic                    ;
         dst_write         : out std_logic                    ;
         data_enb          : out std_logic                    ;
         key_enb           : out std_logic                    ;
         cmd_enb           : out std_logic                    ;
         stateMachineStatus: out std_logic_vector (7 downto 0);
         sr_output_enb     : out std_logic                    ;
         sr_output_load    : out std_logic

         );
end victimController;

architecture structure of victimController is
    type STATE is (S_INIT, SL_KEY, SL_DATA, S_PROCESS, S_OUT_WAIT, S_OUT,
                   ldcmd, init2, start, st1, st6); ---unused states
    signal pr_state,nx_state:state;
    signal buffer_full_key  : std_logic; 
    signal buffer_full_data : std_logic;
    signal load_cnt_data    : std_logic;
    signal load_cnt_key     : std_logic;
    signal load_cnt_output  : std_logic;
    signal buffer_empty     : std_logic;
    signal key_data_bit     : std_logic;
    signal load_cnt         : std_logic;
    signal cnt_out1         : integer RANGE 0 to (maxBlockSize/interfaceWidth); 
    signal cnt_out2         : integer RANGE 0 to (maxBlockSize/interfaceWidth); 
    signal cnt_out3         : integer RANGE 0 to (maxBlockSize/interfaceWidth); 
    signal bytes_check      : std_logic_vector (12 downto 0);
    signal enb_cnt_data     : std_logic;
    signal enb_cnt_key      : std_logic;
    signal enb_cnt_output   : std_logic;
begin
------------------------ Control signals to Victim Controller------------
counterInputKey : integerCounter 
                    port map(
                                clock  => clock, 
                                reset  => reset,
                                load   => load_cnt_key,
                                enable => enb_cnt_key,
                                q      => cnt_out1
                            );
buffer_full_key <= '1' when cnt_out1 >= (maxKeySize/interfaceWidth)  else '0';

counterInputData : integerCounter 
                    port map(
                                clock  => clock,
                                reset  => reset,
                                load   => load_cnt_data,
                                enable => enb_cnt_data,
                                q      => cnt_out2
                            );
buffer_full_data <= '1' when cnt_out2 >= (maxBlockSize/interfaceWidth) else '0';

------------------------ Control signals to Victim Controller------------
counterOutputData : integerCounter 
                    port map(
                                clock  => clock,
                                reset  => reset,
                                load   => load_cnt_output,
                                enable => enb_cnt_output,
                                q      => cnt_out3
                            );  
buffer_empty <= '1' when cnt_out3 >= (maxBlockSize/interfaceWidth) else '0';
-------------------------------------------------------------------------
present_state:  process (reset,clock)
                    begin
                        if(reset='1') then
                            pr_state<=S_INIT;
                        elsif (clock'event and clock='1')then
                            pr_state<=nx_state;
                        end if;
                end process;
-------------------------------------------------------------------------------------
next_state_function: process(pr_state, clock, reset, src_ready, buffer_full_key,                             buffer_full_data, buffer_empty, done_exe, 
                             key_data_bit, dst_ready)
    begin
        case pr_state is
            when S_INIT =>
                if (src_ready = '0') then
                    nx_state <= S_INIT;
                else
                    nx_state<=SL_KEY;
                end if;
            
            when SL_KEY =>
                if (buffer_full_key = '0') then   
                    nx_state <= SL_KEY;
                else
                    nx_state<= SL_DATA;
                end if;
            
            when SL_DATA =>
                if (buffer_full_data = '0') then  
                    nx_state <= SL_DATA;
                else
                    nx_state<= S_PROCESS;
                end if;
            
            when S_PROCESS =>
                if (done_exe = '1') then
                    nx_state <= S_OUT_WAIT;
                else
                    nx_state <= S_PROCESS;
                end if;         
            
            when S_OUT_WAIT=>
                if (dst_ready = '1') then
                    nx_state <= S_OUT;
                else
                    nx_state <= S_OUT_WAIT;
                end if;
            
            when S_OUT=>
                if(buffer_empty='0') then
                    nx_state<= S_OUT;
                else
                    nx_state<=S_INIT;
                end if;       
    
            when others=>
                nx_state<=S_INIT;
 
          
        end case;
    end process; 
------------------------------------------------------------------------
 output_function: process(pr_state)
    begin   
        dst_write<='0'; src_read<='0';
        -- start <= '0';data_enb <= '0';key_enb <= '0';cmd_enb <= '0';
        --sr_output_enb <= '0';sr_output_load <= '0';load_cnt <= '1';
        
        case pr_state is 
            when S_INIT =>
                dst_write          <='0';  
                src_read           <='1'; 
                start_to_crypto    <= '0';
                data_enb           <= '0';
                key_enb            <= '0';
                cmd_enb            <= '0';
                sr_output_enb      <= '0';
                sr_output_load     <= '0';
                load_cnt_key       <= '1'; 
                enb_cnt_key        <= '0';
                load_cnt_data      <= '1'; 
                enb_cnt_data       <= '0';
                load_cnt_output    <= '1';
                enb_cnt_output     <= '0';
                stateMachineStatus <= x"01";
            
--           when ldcmd =>
--           dst_write<='0'; 
--           src_read<='1'; 
--           start_to_crypto <= '1';
--           data_enb <= '0';
--           key_enb <= '0';
--           cmd_enb <= '1';
--           sr_output_enb <= '0';
--           sr_output_load <= '0';
--           load_cnt_key <= '0'; enb_cnt_key <= '0';
--           load_cnt_data <= '0'; enb_cnt_data <= '0';
--           load_cnt_output <= '0';enb_cnt_output <= '0';
            
            when st1 => 
                dst_write          <= '0'; 
                src_read           <= '1'; 
                start_to_crypto    <= '0';
                data_enb           <= '0';
                key_enb            <= '0';
                cmd_enb            <= '0';
                sr_output_enb      <= '0';
                sr_output_load     <= '0';
                load_cnt_key       <= '0'; 
                enb_cnt_key        <= '0';
                load_cnt_data      <= '0'; 
                enb_cnt_data       <= '0';
                load_cnt_output    <= '0';
                enb_cnt_output     <= '0';
                stateMachineStatus <= x"02";
            
            when SL_KEY =>         
                dst_write          <= '0'; 
                src_read           <= '1'; 
                start_to_crypto    <= '0';
                data_enb           <= '0';
                key_enb            <= '1';
                cmd_enb            <= '0';
                sr_output_enb      <= '0';
                sr_output_load     <= '0';
                load_cnt_key       <= '0'; 
                enb_cnt_key        <= '1';
                load_cnt_data      <= '0'; 
                enb_cnt_data       <= '0';
                load_cnt_output    <= '0';
                enb_cnt_output     <= '0';
                stateMachineStatus <= x"03";
    
            when SL_DATA=>
                dst_write          <= '0'; 
                src_read           <= '1'; 
                start_to_crypto    <= '0';
                data_enb           <= '1';
                key_enb            <= '0';
                cmd_enb            <= '0';
                sr_output_enb      <= '0';
                sr_output_load     <= '0';
                load_cnt_key       <= '0'; 
                enb_cnt_key        <= '0';
                load_cnt_data      <= '0'; 
                enb_cnt_data       <= '1';
                load_cnt_output    <= '0';
                enb_cnt_output     <= '0';
                stateMachineStatus <= x"04";
    
--           when init2 =>
--           dst_write<='0'; 
--           src_read<='1'; 
--           start_to_crypto <= '0';
--           data_enb <= '0';
--           key_enb <= '0';
--           cmd_enb <= '1';
--           sr_output_enb <= '0';
--           sr_output_load <= '0';
--           load_cnt <= '1';
--           
            when S_PROCESS=>      --crypto run
                dst_write          <= '0'; 
                src_read           <= '0'; 
                start_to_crypto    <= '1';
                data_enb           <= '0';
                key_enb            <= '0';
                cmd_enb            <= '0';
                sr_output_enb      <= '0';
                sr_output_load     <= '0';
                load_cnt_key       <= '0'; 
                enb_cnt_key        <= '0';
                load_cnt_data      <= '0'; 
                enb_cnt_data       <= '0';
                load_cnt_output    <= '0';
                enb_cnt_output     <= '0';
                stateMachineStatus <= x"05";
    
            when S_OUT_WAIT=>
                dst_write          <= '1'; 
                src_read           <= '0'; 
                start_to_crypto    <= '1';
                data_enb           <= '0';
                key_enb            <= '0';
                cmd_enb            <= '0';
                sr_output_enb      <= '0';
                sr_output_load     <= '1';
                load_cnt_key       <= '0'; 
                enb_cnt_key        <= '0';
                load_cnt_data      <= '0'; 
                enb_cnt_data       <= '0';
                load_cnt_output    <= '0';
                enb_cnt_output     <= '0';
                stateMachineStatus <= x"06";
    
            when S_OUT =>
                dst_write          <= '1'; 
                src_read           <= '0'; 
                start_to_crypto    <= '1';
                data_enb           <= '0';
                key_enb            <= '0';
                cmd_enb            <= '0';
                sr_output_enb      <= '1';
                sr_output_load     <= '0';
                load_cnt_key       <= '0'; 
                enb_cnt_key        <= '0';
                load_cnt_data      <= '0'; 
                enb_cnt_data       <= '0';
                load_cnt_output    <= '0';
                enb_cnt_output     <= '1';
                stateMachineStatus <= x"07";
    
            when others =>
                dst_write          <= '1'; 
                src_read           <= '0'; 
                start_to_crypto    <= '0';
                data_enb           <= '0';
                key_enb            <= '0';
                cmd_enb            <= '0';
                sr_output_enb      <= '1';
                sr_output_load     <= '0';
                load_cnt_key       <= '0'; 
                enb_cnt_key        <= '0';
                load_cnt_data      <= '0'; 
                enb_cnt_data       <= '0';
                load_cnt_output    <= '0';
                enb_cnt_output     <= '1';       
                stateMachineStatus <= x"08";
    
        end case;
    end process;


end structure; 