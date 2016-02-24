--------------------------------------------------------------------------------
-- File name    :   tb_victim.vhd
-- Author       :   Panasayya Yalla
-- Description  :   Test bench to test the fobos setup 
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_victim IS
END tb_victim;
 
ARCHITECTURE behavior OF tb_victim IS 
 
    COMPONENT victimTopLevel
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
                                    x"2B7E151628AED2A6ABF7158809CF4F3C";
   signal plaintext1: std_logic_vector(127 downto 0):=
                                    x"3243F6A8885A308D313198A2E0370734";
   signal plaintext2: std_logic_vector(127 downto 0):=
                                    x"abcdef0123456789abcdef0123456789";                                    
   signal cmd_key       : std_logic_vector(15 downto 0);                                   
   signal cmd_plaintext : std_logic_vector(15 downto 0);                                   
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
    uut: victimTopLevel PORT MAP (
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
      wait for clock_period*16;
      
    wait;
    end process;
    cmd_key         <= "00" & x"010" & "10";
    cmd_plaintext   <= "00" & x"010" & "11";
    
END;
