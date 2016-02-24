library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.fobos_package.all;

entity victimTopLevel is 
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
end victimTopLevel;

architecture structure of victimTopLevel is
signal data_enb             : std_logic;    -- from victim_contrl
signal key_enb              : std_logic;    -- from victim_contrl
signal cmd_enb              : std_logic; 
signal done_exe             : std_logic;
signal sr_output_enb        : std_logic;    -- from victim_contrl
signal sr_output_load       : std_logic;    -- from victim_contrl
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
---======STATE DECLARATIONS
type STATE is (S_INIT, SL_KEY_SR, SL_KEY, SL_DATA_SR, SL_DATA, S_WAIT, S_GEN_RNDKEY); ---unused states
    signal pr_state,nx_state:state;
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
------------------------ Victim outer-level Controller-------------------       
control: victimController 
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
-----------------  DUMMY VICTIM ------------------------------------------------
--------------------------------------------------------------------------------
--data_from_crypto  <= (data_to_crypto xor key_to_crypto) 
--                     when start_to_crypto = '1' else (others => '0');
--data_from_crypto  <= (data_to_crypto) when start_to_crypto = '1' 
--                     else (others => '0');
--done_exe <= '1' when start_to_crypto ='1' else '0';

--------------------------------------------------------------------------------
-----------------  AES 128 -----------------------------------------------------
--------------------------------------------------------------------------------


-- victimAES : aes_non_pipe 
            -- port map    ( 
                            -- clock               => clock              ,
                            -- start               => not start_to_crypto, -- active low
                            -- data_in             => data_to_crypto     ,
                            -- key_in              => key_to_crypto      ,
                            -- data_out            => data_from_crypto   ,   
                            -- done                => done_exe
                        -- );

Inst_AES_Enc: AES_Enc 
            PORT MAP(
                            clk       => clock,
                            rst       => reset,
                            din       => data_to_crypto,
                            key       => key_to_crypto,
                            dout      => data_from_crypto,
                            init      => init,
                            start     => start,
                            ready     => ready,
                            done      => done_exe,
                            done_init => done_init
                    );

--======Generation of control signals for AES_Enc
present_state:  process (reset,clock)
                    begin
                        if(reset='1') then
                            pr_state<=S_INIT;
                        elsif (clock'event and clock='1')then
                            pr_state<=nx_state;
                        end if;
                end process;

next_state_function: process(pr_state, key_enb, data_enb,done_exe,done_init)
    begin
        case pr_state is
            when S_INIT =>
                if (key_enb = '1') then
                    nx_state <= SL_KEY_SR;
                else
                    nx_state<=S_INIT;
                end if;
            
            when SL_KEY_SR =>
                if (key_enb = '0') then   
                    nx_state <= SL_DATA_SR;
                else
                    nx_state<= SL_KEY_SR;
                end if;
            
            
            when SL_DATA_SR =>
                if (data_enb = '0') then   
                    nx_state <= SL_KEY;
                else
                    nx_state<= SL_DATA_SR;
                end if;
            
            when SL_KEY =>
                nx_state <= S_GEN_RNDKEY;
                
            when S_GEN_RNDKEY=>
                if(done_init='1')then
                    nx_state <= SL_DATA;
                else
                    nx_state <= S_GEN_RNDKEY;
                end if;
            
            when SL_DATA =>
                nx_state <= S_WAIT;
            
            when S_WAIT  =>
                if(done_exe='1')then
                    nx_state <= S_INIT;
                else
                    nx_state <= S_WAIT;
                end if;
                
            when others=>
                nx_state<=S_INIT;
        end case;
    end process; 
    
output_function: process(pr_state)
    begin   
        INIT  <= '0';
        START <= '0';
        case pr_state is 
            when S_INIT =>
            
            when SL_KEY_SR =>
                
            when SL_KEY =>
                INIT <='1';
            
            when SL_DATA_SR =>
            
            when SL_DATA =>
                START <= '1';
                
            when S_GEN_RNDKEY=>
            
            when S_WAIT  =>
            
            when others=>
            
        end case;
    end process;        
                
                
    

end structure; 
