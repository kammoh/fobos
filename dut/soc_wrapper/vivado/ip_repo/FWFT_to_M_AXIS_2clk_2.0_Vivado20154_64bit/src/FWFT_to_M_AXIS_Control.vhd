
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity FWFT_to_M_AXIS_Control is
--    generic (
--				START_COUNT	            : integer	:= 32
--			);
    port(
        clk             : in  std_logic;
        rstn            : in  std_logic;

        --! Input
        m00_axis_tready         : in std_logic;
        fifo_n_empty            : in std_logic;
		NUMBER_OF_OUTPUT_WORDS  : in std_logic_vector(31 downto 0);
		START_COUNT             : in std_logic_vector(31 downto 0);
		init_done               : in std_logic;

        --! output
        m00_axis_tvalid  : out std_logic;
		m00_axis_tlast   : out std_logic;
        fifo_read        : out std_logic

		);
end FWFT_to_M_AXIS_Control;

-------------------------------------------------------------------------------
--! @brief  Architecture definition of FWFT_to_M_AXIS_Control
-------------------------------------------------------------------------------

architecture behav of FWFT_to_M_AXIS_Control is
    type t_state is (S_RESET, S_WAIT_START, S_TRANSFER);
    signal state        : t_state;
    signal start_count_reg        : std_logic_vector(31 downto 0);
    signal transfer_len_count_reg : std_logic_vector(31 downto 0);
    signal counter_en             : std_logic;
    
begin
    p_fsm: process(clk)
    begin
        if rising_edge(clk) then
            if (rstn = '0') then
                state <= S_RESET;
            else
                if (state = S_RESET) then
                    start_count_reg      	 <= (others => '0'); --std_logic_vector(to_unsigned(1,32));
                    transfer_len_count_reg   <= (others => '0'); --std_logic_vector(to_unsigned(1,32));
                    if ( fifo_n_empty = '1') then
                        state                    <= S_WAIT_START;
                    end if;
                elsif (state = S_WAIT_START) then
                    if (init_done = '1') then
                        if (start_count_reg = START_COUNT) then
                            state             <= S_TRANSFER;
                        else 
                            start_count_reg   <= start_count_reg + 1;
                            state       	  <= S_WAIT_START;
                        end if;
					end if;
					
                elsif (state = S_TRANSFER) then
                    if (transfer_len_count_reg = NUMBER_OF_OUTPUT_WORDS-1) then
                        state        <= S_RESET;
                    elsif (counter_en = '1') then
                        transfer_len_count_reg    <= transfer_len_count_reg + 1;
						state       	          <= S_TRANSFER;
					else
					    state       	          <= S_TRANSFER;   
                    end if;

                end if;
                --done_init <= done_init_s;
                --done      <= done_s;
            end if;
        end if;
    end process;

    p_comb: process(fifo_n_empty, m00_axis_tready, transfer_len_count_reg, state)
    begin
        --! Default values
        m00_axis_tvalid  <= '0';
		m00_axis_tlast   <= '0';
        fifo_read        <= '0';
        counter_en       <= '0';

        if (state = S_RESET) then
        elsif (state = S_WAIT_START) then
		elsif (state = S_TRANSFER) then

            if ((fifo_n_empty = '1') and (m00_axis_tready = '1')) then
                fifo_read <= '1';
                counter_en <= '1';
				if (transfer_len_count_reg = NUMBER_OF_OUTPUT_WORDS-1) then
                      m00_axis_tlast   <= '1';
				end if;
			end if;	
			if (fifo_n_empty = '1') then
				m00_axis_tvalid <= '1';	            
            end if;
        end if;
    end process;
    
end behav;