----------------------------------------------------------------------------
-- Revision History:
--  06/09/2004(GeneA): created
--	08/10/2004(GeneA): initial public release
--	04/25/2006(JoshP): comment addition  
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity Nexys3_openADC is
    Port (
-- EPP Ports	
		mclk 	: in std_logic;
        pdb		: inout std_logic_vector(7 downto 0);
        astb 	: in std_logic;
        dstb 	: in std_logic;
        pwr 	: in std_logic;
        pwait 	: out std_logic;
		  signal_check : out std_logic;
-- CTRL LED/Switch Ports
		hbLed		: out std_logic; 
		hbLed_off	: in std_logic;
		aes_done	: out std_logic;
-- ADC Ports
		adc_clock : out std_logic;
		amp_gain : out std_logic;
		amp_hilo : out std_logic;
		adc_data : in std_logic_vector(9 downto 0);
		adc_or : in std_logic
-- CTRL-VICTIM Ports
		-- clock2victim		: out std_logic; 
		-- start2victim		: out std_logic; 
		-- datafromvictim  	: in std_logic_vector(7 downto 0);
		-- done_op     		: in std_logic;
		-- trigger             : in std_logic;
		-- data2victim  		: out std_logic_vector(9 downto 0)
		);
end Nexys3_openADC;

architecture Behavioral of Nexys3_openADC is

------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------
	component rege8 is 
		port (	a     : IN  std_logic_vector(7 downto 0);
				clk   : IN  std_logic;
				reset : IN  std_logic;
				en    : IN  std_logic;                         -- enable '1', idle '0'
				b     : OUT std_logic_vector(7 downto 0));
	end component;

    component dcm_core_500KHz is
    port ( 	CLKIN_IN        : in    std_logic;
			RST_IN          : in    std_logic;
			CLK500KHz_OUT   : out   std_logic;
			LOCKED_OUT      : out   std_logic);
    end component;
	
	component dcm_core_100MHz is
	port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLK100MHz_OUT   : out   std_logic; 
          LOCKED_OUT      : out   std_logic);
	end component;

	component counter is
		generic (N : integer := 8);
		port ( 	  
			clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic; 
			counter_out : out std_logic_vector(N-1 downto 0));
	end component;
		
	 component rege32 IS 
		 PORT (a		 : IN  std_logic_vector(31 downto 0);
				 clk   : IN  std_logic;
				 reset : IN  std_logic;
				 en    : IN  std_logic;            
				 b     : OUT std_logic_vector(31 downto 0));
	end component;
	
	component address_gen is  
		generic (N : integer := 4);
			port(clock : in STD_LOGIC;
						l : in STD_LOGIC;
						e : in STD_LOGIC;
						q : out STD_LOGIC_VECTOR(N-1 downto 0));
	end component;
	
	component bram_adc_store is
    Port (clock : in std_logic;
		  addr : in std_logic_vector(14 downto 0);
		  wen : in std_logic;
		  en : in std_logic;
		  din : in std_logic_vector(15 downto 0);
		  dout : out std_logic_vector(15 downto 0));
end component;

	component bram_addr_en is
	 port(
	 clock : in STD_LOGIC;
	 reset : in std_logic;
	 to_store : out std_logic_vector(4 downto 0);
	 trigger : in STD_LOGIC;
	 bram_we_en : out STD_LOGIC
	     );
	end component;
	
	component bram_add_counter is
	generic ( N : integer := 32);
	port ( 	  
		clk : in std_logic;
		reset : in std_logic;
	   enable : in std_logic;
       we_enable : in std_logic;	   
      counter_out : out std_logic_vector(N-1 downto 0));
	end component;
	
	component trigger_module is
	port (	clock : in std_logic;
			reset : in std_logic;
			trigger_out : out std_logic);

	end component; 
------------------------------------------------------------------------
-- Local Type Declarations
------------------------------------------------------------------------

------------------------------------------------------------------------
--  Constant Declarations
------------------------------------------------------------------------

	-- The following constants define state codes for the EPP port interface
	-- state machine. The high order bits of the state number give a unique
	-- state identifier. The low order bits are the state machine outputs for
	-- that state. This type of state machine implementation uses no
	-- combination logic to generate outputs which should produce glitch
	-- free outputs.
	constant	stEppReady	: std_logic_vector(7 downto 0) := "0000" & "0000";
	constant	stEppAwrA	: std_logic_vector(7 downto 0) := "0001" & "0100";
	constant	stEppAwrB	: std_logic_vector(7 downto 0) := "0010" & "0001";
	constant	stEppArdA	: std_logic_vector(7 downto 0) := "0011" & "0010";
	constant	stEppArdB	: std_logic_vector(7 downto 0) := "0100" & "0011";
	constant	stEppDwrA	: std_logic_vector(7 downto 0) := "0101" & "1000";
	constant	stEppDwrB	: std_logic_vector(7 downto 0) := "0110" & "0001";
	constant	stEppDrdA	: std_logic_vector(7 downto 0) := "0111" & "0010";
	constant	stEppDrdB	: std_logic_vector(7 downto 0) := "1000" & "0011";

------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------

	-- State machine current state register
	signal	stEppCur	: std_logic_vector(7 downto 0) := stEppReady;

	signal	stEppNext	: std_logic_vector(7 downto 0);

	signal	clkMain		: std_logic;

	-- Internal control signales
	signal	ctlEppWait	: std_logic;
	signal	ctlEppAstb	: std_logic;
	signal	ctlEppDstb	: std_logic;
	signal	ctlEppDir	: std_logic;
	signal	ctlEppWr	: std_logic;
	signal	ctlEppAwr	: std_logic;
	signal	ctlEppDwr	: std_logic;
	signal	busEppOut	: std_logic_vector(7 downto 0);
	signal	busEppIn	: std_logic_vector(7 downto 0);
	signal	busEppData	: std_logic_vector(7 downto 0);

	-- Registers
	signal	regEppAdr	: std_logic_vector(7 downto 0); -- change here 3 downto 0
	signal	regData0	: std_logic_vector(7 downto 0);
	signal	regData1	: std_logic_vector(7 downto 0);
   signal   regData2	: std_logic_vector(7 downto 0);
   signal   regData3	: std_logic_vector(7 downto 0);
    -- signal  regData4	: std_logic_vector(7 downto 0);
	-- signal	regData5	: std_logic_vector(7 downto 0);
	-- signal	regData6	: std_logic_vector(7 downto 0);
	-- signal	regData7	: std_logic_vector(7 downto 0);
	-- signal	regLed		: std_logic_vector(7 downto 0);

	signal	cntr		: std_logic_vector(23 downto 0);
	
	signal system_reset, clock2ddr, trigger_buf : std_logic;
    signal ref_cnt_load, Z1sec   : std_logic;
	 signal to_store : std_logic_vector(4 downto 0);
    signal ref_clock_counter_out : std_logic_vector(31 downto 0);
	signal DCM_clock_Check500KHz1, DCM_clock_Check100MHz1             : std_logic_vector(31 downto 0); 
	signal DCM_clock_Check, DCM_clock_Check500KHz, DCM_clock_Check100MHz   : std_logic_vector(31 downto 0);

    signal clock_100MHz_BUF, clock_500KHz_BUF, clock_100MHz, clock_500KHz, dcm500KHz_locked, dcm100MHz_locked: std_logic;
	
	signal trigger_cnt500K : std_logic_vector(15 downto 0);
	signal trigger_cnt100M : std_logic_vector(31 downto 0);
	
	signal	data2pc	: std_logic_vector(7 downto 0);
	
	signal victim_start, delay_done, Z1024, cnt_en, bram_wen : std_logic;
	signal delay_count, captured_data, data_from_adc : std_logic_vector(15 downto 0);
	signal addGen, data_address : std_logic_vector(15 downto 0); 
	signal int_addGen : std_logic_vector(17 downto 0);
	signal PWM_Accumulator : std_logic_vector(8 downto 0);
	
	signal GND_BIT  :std_logic := '0';
	signal HIGH_BIT :std_logic := '1';
------------------------------------------------------------------------
-- Module Implementation
------------------------------------------------------------------------

begin

    ------------------------------------------------------------------------
	-- Map basic status and control signals
    ------------------------------------------------------------------------

	clkMain <= mclk;

	ctlEppAstb <= astb;
	ctlEppDstb <= dstb;
	ctlEppWr   <= pwr;
	pwait      <= ctlEppWait;	-- drive WAIT from state machine output

	-- Data bus direction control. The internal input data bus always
	-- gets the port data bus. The port data bus drives the internal
	-- output data bus onto the pins when the interface says we are doing
	-- a read cycle and we are in one of the read cycles states in the
	-- state machine.
	busEppIn <= pdb;
	pdb <= busEppOut when ctlEppWr = '1' and ctlEppDir = '1' else "ZZZZZZZZ";

	-- Select either address or data onto the internal output data bus.
	busEppOut <= regEppAdr when ctlEppAstb = '0' else busEppData; -- change 4m "0000" & regEppAdr


	-- Decode the address register and select the appropriate data register
	busEppData <=	regData0 								when regEppAdr = "00000000" else ---Control Register
					DCM_clock_Check500KHz(31 downto 24) 	when regEppAdr = "00000001" else ---DCM Clock Check from 500KHz
					DCM_clock_Check500KHz(23 downto 16) 	when regEppAdr = "00000010" else ---DCM Clock Check from 500KHz
					DCM_clock_Check500KHz(15 downto 8)  	when regEppAdr = "00000011" else ---DCM Clock Check from 500KHz
					DCM_clock_Check500KHz(7 downto 0)   	when regEppAdr = "00000100" else ---DCM Clock Check from 500KHz
					data2pc						  			when regEppAdr = "00000101" else ---DCM Clock Check from 500KHz
					regData1						  		when regEppAdr = "00000110" else ---Data from Victim
					DCM_clock_Check100MHz(31 downto 24) 	when regEppAdr = "00000111" else ---Switch to ROM OF Victim
					DCM_clock_Check100MHz(23 downto 16) 	when regEppAdr = "00001000" else ---DCM Clock Check from 100MHz
					DCM_clock_Check100MHz(15 downto 8)  	when regEppAdr = "00001001" else ---DCM Clock Check from 100MHz
					DCM_clock_Check100MHz(7 downto 0)   	when regEppAdr = "00001010" else ---DCM Clock Check from 100MHz
					captured_data(15 downto 8)  			when regEppAdr = "00001011" else ---Data from ADC
					captured_data(7 downto 0)   			when regEppAdr = "00001100" else ---Data from ADC
					 "000000" & int_addGen(17 downto 16)    when regEppAdr = "00001101" else ---intAddress to BRAM
					int_addGen (15 downto 8)    			when regEppAdr = "00001110" else ---intAddress to BRAM
					int_addGen (7 downto 0)					when regEppAdr = "00001111" else ---intAddress to BRAM
					trigger_cnt100M(31 downto 24) 			when regEppAdr = "00010000" else ---Trigger Check from 100MHz
					trigger_cnt100M(23 downto 16) 			when regEppAdr = "00010001" else ---Trigger Check from 100MHz
					trigger_cnt100M(15 downto 8)  			when regEppAdr = "00010010" else ---Trigger Check from 100MHz
					trigger_cnt100M(7 downto 0)   			when regEppAdr = "00010011" else ---Trigger Check from 100MHz
					trigger_cnt500K(15 downto 8)  			when regEppAdr = "00010100" else ---Trigger Check from 500KHz
					trigger_cnt500K(7 downto 0)   			when regEppAdr = "00010101" else ---Trigger Check from 500KHz
					"00000000";
					
    ------------------------------------------------------------------------
	-- EPP Interface Control State Machine
    ------------------------------------------------------------------------

	-- Map control signals from the current state
	ctlEppWait <= stEppCur(0);
	ctlEppDir  <= stEppCur(1);
	ctlEppAwr  <= stEppCur(2);
	ctlEppDwr  <= stEppCur(3);

	-- This process moves the state machine to the next state
	-- on each clock cycle
	process (clkMain)
		begin
			if clkMain = '1' and clkMain'Event then
				stEppCur <= stEppNext;
			end if;
		end process;

	-- This process determines the next state machine state based
	-- on the current state and the state machine inputs.
	process (stEppCur, stEppNext, ctlEppAstb, ctlEppDstb, ctlEppWr)
		begin
			case stEppCur is
				-- Idle state waiting for the beginning of an EPP cycle
				when stEppReady =>
					if ctlEppAstb = '0' then
						-- Address read or write cycle
						if ctlEppWr = '0' then
							stEppNext <= stEppAwrA;
						else
							stEppNext <= stEppArdA;
						end if;

					elsif ctlEppDstb = '0' then
						-- Data read or write cycle
						if ctlEppWr = '0' then
							stEppNext <= stEppDwrA;
						else
							stEppNext <= stEppDrdA;
						end if;

					else
						-- Remain in ready state
						stEppNext <= stEppReady;
					end if;											

				-- Write address register
				when stEppAwrA =>
					stEppNext <= stEppAwrB;

				when stEppAwrB =>
					if ctlEppAstb = '0' then
						stEppNext <= stEppAwrB;
					else
						stEppNext <= stEppReady;
					end if;		

				-- Read address register
				when stEppArdA =>
					stEppNext <= stEppArdB;

				when stEppArdB =>
					if ctlEppAstb = '0' then
						stEppNext <= stEppArdB;
					else
						stEppNext <= stEppReady;
					end if;

				-- Write data register
				when stEppDwrA =>
					stEppNext <= stEppDwrB;

				when stEppDwrB =>
					if ctlEppDstb = '0' then
						stEppNext <= stEppDwrB;
					else
 						stEppNext <= stEppReady;
					end if;

				-- Read data register
				when stEppDrdA =>
					stEppNext <= stEppDrdB;
										
				when stEppDrdB =>
					if ctlEppDstb = '0' then
						stEppNext <= stEppDrdB;
					else
				  		stEppNext <= stEppReady;
					end if;

				-- Some unknown state				
				when others =>
					stEppNext <= stEppReady;

			end case;
		end process;
		
    ------------------------------------------------------------------------
	-- EPP Address register
    ------------------------------------------------------------------------

	process (clkMain, ctlEppAwr)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppAwr = '1' then
					regEppAdr <= busEppIn(7 downto 0); -- change here 4, 3 downto 0
				end if;
			end if;
		end process;

    ------------------------------------------------------------------------
	-- EPP Data registers
    ------------------------------------------------------------------------
 	-- The following processes implement the interface registers. These
	-- registers just hold the value written so that it can be read back.
	-- In a real design, the contents of these registers would drive additional
	-- logic.
	-- The ctlEppDwr signal is an output from the state machine that says
	-- we are in a 'write data register' state. This is combined with the
	-- address in the address register to determine which register to write.

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "00000000" then
					regData0 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "00000001" then
					regData1 <= busEppIn;
				end if;
			end if;
		end process;
		
	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "00000010" then
					regData2 <= busEppIn;
				end if;
			end if;
		end process;

	process (clkMain, regEppAdr, ctlEppDwr, busEppIn)
		begin
			if clkMain = '1' and clkMain'Event then
				if ctlEppDwr = '1' and regEppAdr = "00000011" then
					regData3 <= busEppIn;
				end if;
			end if;
		end process;		

	------------------------------------------------------------------------
    -- Heart-beat Counter for fancy LED blinking
	------------------------------------------------------------------------
	process (clkMain)
		begin
			if clkMain = '1' and clkMain'Event then
				cntr <= cntr + 1;
			end if;
		end process;
	hbLed <= hbLed_off and cntr(23);
	
		CLK1_BUFG_INST : BUFG
      port map (I=>clock_100MHz,
                O=>clock_100MHz_BUF);
					 
		CLK2_BUFG_INST : BUFG
      port map (I=>clock_500KHz,
                O=>clock_500KHz_BUF);	
					 

	-------------------------------------------------------------------------
    -- DCM Core for 100MHz Clock Generation
    -------------------------------------------------------------------------
        DCM_inst1 : dcm_core_100MHz port map (CLKIN_IN => mclk,
		RST_IN => regData0(7), CLK100MHz_OUT => clock_100MHz, 
		LOCKED_OUT => dcm100MHz_locked);
	
	
	-----------------------------------------------------------------------
    -- DCM 100 MHz Frequency Checker
    -----------------------------------------------------------------------
		system_reset <= regData0(7) and (not dcm100MHz_locked) and (not dcm500KHz_locked);
		  
		  -- Reference counter for both freq checks
		  
        Ref_Clock_Counter : counter generic map (N=> 32)
		   port map(clk=> mclk, reset => system_reset, enable => ref_cnt_load,
			counter_out => ref_clock_counter_out );
			
		   Z1sec <= '1' when (ref_clock_counter_out >= x"02FAF080") else '0';	--1sec + (1000)d for spartan3 at 50 MHz
		   ref_cnt_load <= not Z1sec;
			
        DCM_Clock_Counter_100MHz : counter generic map (N => 32)
		   port map (clk=> clock_100MHz, reset => system_reset, enable => ref_cnt_load,
			counter_out => DCM_clock_Check100MHz1 );
        
		DCM_Clock_Counter_Reg_100MHz : rege32 port map ( a  => DCM_clock_Check100MHz1, clk => mclk,
		  reset => system_reset, en => Z1sec, b => DCM_clock_Check100MHz);
	
	-------------------------------------------------------------------------
    -- DCM Core for 500KHz Clock Generation
    -------------------------------------------------------------------------
        DCM_inst2 : dcm_core_500KHz port map (CLKIN_IN => mclk,
		RST_IN => regData0(7), CLK500KHz_OUT => clock_500KHz, 
		LOCKED_OUT => dcm500KHz_locked);
	
	-----------------------------------------------------------------------
    -- DCM 500 KHz Frequency Checker
    -----------------------------------------------------------------------			
      DCM_Clock_Counter_500KHz : counter generic map (N => 32)
		   port map (clk=> clock_500KHz, reset => system_reset, enable => ref_cnt_load,
			counter_out => DCM_clock_Check500KHz1 );
        
		DCM_Clock_Counter_Reg_500KHz : rege32 port map ( a  => DCM_clock_Check500KHz1, clk => mclk,
		  reset => system_reset, en => Z1sec, b => DCM_clock_Check500KHz);
		  
	-------------------------------------------------------------------------
    -- ADC Control Signals & PWM Generator for Gain
    -------------------------------------------------------------------------
			process (clkMain, regData1)
				begin
					if clkMain = '1' and clkMain'Event then
						PWM_Accumulator <= ("0" & PWM_Accumulator(7 downto 0))
												 + ("0" & regData2);
					end if;
			end process;
			
			adc_clock <= clock_100MHz; -- 100 MHz
			amp_hilo <= regData0(0); -- HI/LO -> 1/0
			amp_gain <= PWM_Accumulator(8); -- PWM Signal
			data_from_adc <= "00000" & adc_or & adc_data;
	
	-------------------------------------------------------------------------
    -- Trigger/Sample Check Counters & Trigger Signal Generation
    -------------------------------------------------------------------------
	
--		trigger_counter_500KHz : counter generic map (N => 16)
--		   port map (clk=> clock_500KHz_BUF, reset => regData0(7), enable => trigger,
--			counter_out => trigger_cnt500K );
--			
--		trigger_counter_100MHz : counter generic map (N => 32)
--		   port map (clk=> clock_100MHz_BUF, reset => regData0(7), enable => trigger,
--			counter_out => trigger_cnt100M );
--				
--		trigger_gen : trigger_module port map(clock => clock_500KHz_BUF, reset=>regData0(7), 
--											trigger_out=> trigger_buf);


	-------------------------------------------------------------------------
    -- BRAM Address Generation
    -------------------------------------------------------------------------
		victim_start <= '1' when (regData0(6) = '1' and delay_done = '1') else '0';
		
		Delay_Counter : counter generic map (N => 16)
		   port map (clk=> clock_100MHz_BUF, reset => system_reset, enable => '1',
			counter_out => delay_count);
		delay_done <= '0' when delay_count >="0000010111011100" else '1';

		RAM_address_Counter : bram_add_counter generic map (N => 18)
		   port map (clk=> clock_100MHz_BUF, reset => victim_start, enable => delay_done,
			we_enable => delay_done, counter_out => int_addGen);
			                                 
		Z1024 <= '1' when int_addGen >= "000100111000100000" else '0';
		cnt_en <= '1' when Z1024 = '0' else '0';
						
		add_gen_pc_counter : counter generic map (N => 16)
		   port map (clk=> ctlEppDstb, reset => regData0(4), enable => regData0(5),
			counter_out => addGen);
				
		data_address <= int_addGen(15 downto 0) when regData0(5) = '0' else addGen;
	-------------------------------------------------------------------------
    -- BRAM Pins Mapping
    -------------------------------------------------------------------------
--		bram_wr_ctrl   : bram_addr_en port map
--								(clock => clock_100MHz_BUF,
--								 reset => system_reset,
--								 trigger => trigger,
--								 to_store => to_store,
--								 bram_we_en =>bram_wen);
		
		bram_data_store : bram_adc_store port map
								(clock => clock_100MHz_BUF,
								 addr  => data_address(14 downto 0),
								 wen   => cnt_en,
								 en    => '1',
								 din   => data_from_adc,
								 dout  => captured_data);
	-----------------------------------------------------------------------
    -- Victim Port Maps
    -----------------------------------------------------------------------
--		in_vic : rege8 port map(a=> datafromvictim, clk => mclk, reset => system_reset,
--		en => done_op, b => data2pc);
		
		--data2victim <= regData3(7 downto 6) & regData1;
		--aes_done <= done_op;
		--clock2victim <= clock_500KHz;
		--start2victim <= regData0(6);
		--signal_check <= bram_wen;
----------------------------------------------------------------------------

end Behavioral;
