----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:19:25 03/29/2018 
-- Design Name: 
-- Module Name:    aes_wrapper - behav 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aes_axi is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           pdi_data : in  STD_LOGIC_VECTOR (127 downto 0);
           pdi_valid : in  STD_LOGIC;
           pdi_ready : out  STD_LOGIC;
           --sdi_data : in  STD_LOGIC_VECTOR (127 downto 0);
           --sdi_valid : in  STD_LOGIC;
           --sdi_ready : out  STD_LOGIC;
           do_data : out  STD_LOGIC_VECTOR (127 downto 0);
           do_valid : out  STD_LOGIC;
           do_ready : in  STD_LOGIC
			  );
end aes_axi;

architecture behav of aes_axi is
    type state is (IDLE, GET_SDI, GET_PDI, RUN, SND_DO);
    signal current_state : state;
    signal next_state : state;
	 ---
	 signal key_reg_en, data_reg_en, do_reg_en : std_logic;
	 constant key : std_logic_vector(127 downto 0) := x"00112233445566778899AABBCCDDEEFF";
	 ---aes signals
	 signal start, done : std_logic;
	 signal key_in, data_in, data_out : std_logic_vector(127 downto 0);
begin

ctrl: process(clk)
begin

IF (rising_edge(clk)) THEN
	if (rst = '1') then
		current_state <= IDLE;
	else
	   current_state <= next_state;
	END if;
	  
END IF;

end process;

comb: process(current_state, pdi_valid, do_ready, done)
begin
	 -- defaults

pdi_ready <= '0';
--sdi_ready <= '0';
do_valid <= '0';
--key_reg_en <= '0';
data_reg_en <= '0';
do_reg_en <= '0';
start <= '1'; --active-low

case current_state is
		 		 
	 when IDLE =>
	 
		  pdi_ready <= '1';
	
		  if (pdi_valid = '1') then
		      data_reg_en <= '1';
		      next_state <= RUN;

				
		  else
			    next_state <= IDLE;  
		  end if;
        
	   when RUN =>
        if (done = '1') then
		      do_reg_en <= '1';
		      next_state <= SND_DO;
		  else
     	      start <= '0';
		      next_state <= RUN;
		  end if;
		  
		when SND_DO =>
		  do_valid <= '1';
        if (do_ready = '1') then
		      next_state <= IDLE;
		  else
		      next_state <= SND_DO;
		  end if;

	WHEN OTHERS =>
		  next_state <= IDLE;
			  
	end case; 

END process;

---key register

--data block register

data_reg : process(clk)
begin
   if (rising_edge(clk)) then
      if data_reg_en = '1' then
          data_in <= pdi_data;
      end if;
   end if;
end process;

---do register
do_reg : process(clk)
begin
   if (rising_edge(clk)) then
      if do_reg_en = '1' then
          do_data <= data_out ;
      end if;
   end if;
end process;

-- AES-128
uut: entity work.aes_non_pipe(aes_non_pipe_arch) PORT MAP (
          clock => clk,
          start => start,
          data_in => data_in,
          key_in => key,
          data_out => data_out,
          done => done
 );


end behav;

