library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dutcomm_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4;

		-- Parameters of Axi Master Bus Interface M_AXIS
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_AXIS_START_COUNT	: integer	:= 32;

		-- Parameters of Axi Slave Bus Interface S_AXIS
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Users to add ports here
        din             : out std_logic_vector(3 downto 0);
        di_valid        : out std_logic;
        di_ready        : in std_logic;
        dout            : in std_logic_vector(3 downto 0);
        do_valid        : in std_logic;
        do_ready        : out std_logic;
        --dut_rst         : out std_logic;
        --
        snd_start       : out std_logic; --tell other that sending data to dut started.
        rst             : in std_logic; --also resets the dut.
        op_done         : out std_logic; --tell others that operation (i.e. encryption) is done.
        dut_working     : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line
		-- Ports of Axi Slave Bus Interface S_AXI
		s_axi_aclk	: in std_logic;
		s_axi_aresetn	: in std_logic;
		s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		s_axi_wdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bresp	: out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp	: out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M_AXIS
		m_axis_aclk	: in std_logic;
		m_axis_aresetn	: in std_logic;
		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		--m_axis_tstrb	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m_axis_tlast	: out std_logic;
		m_axis_tready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S_AXIS
		s_axis_aclk	: in std_logic;
		s_axis_aresetn	: in std_logic;
		s_axis_tready	: out std_logic;
		s_axis_tdata	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		--s_axis_tstrb	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		--s_axis_tlast	: in std_logic;
		s_axis_tvalid	: in std_logic
	);
end dutcomm_v1_0;

architecture arch_imp of dutcomm_v1_0 is
    
	-- component declaration
	component dutcomm_v1_0_S_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		--user defined
		start        : out std_logic;
		status       : in std_logic_vector(7 downto 0);
		--end user defined
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component dutcomm_v1_0_S_AXI;

--	component dutcomm_v1_0_M_AXIS is
--		generic (
--		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
--		C_M_START_COUNT	: integer	:= 32
--		);
--		port (
--		M_AXIS_ACLK	: in std_logic;
--		M_AXIS_ARESETN	: in std_logic;
--		M_AXIS_TVALID	: out std_logic;
--		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
--		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
--		M_AXIS_TLAST	: out std_logic;
--		M_AXIS_TREADY	: in std_logic
--		);
--	end component dutcomm_v1_0_M_AXIS;

--	component dutcomm_v1_0_S_AXIS is
--		generic (
--		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
--		);
--		port (
--		S_AXIS_ACLK	: in std_logic;
--		S_AXIS_ARESETN	: in std_logic;
--		S_AXIS_TREADY	: out std_logic;
--		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
--		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
--		S_AXIS_TLAST	: in std_logic;
--		S_AXIS_TVALID	: in std_logic
--		);
--	end component dutcomm_v1_0_S_AXIS;
	
	--user defined component
	component dutComm is
        port ( 
            clk         : in STD_LOGIC;
            rst         : in STD_LOGIC;
            tx_data     : in STD_LOGIC_VECTOR (31 downto 0);
            tx_valid    : in STD_LOGIC;
            tx_ready    : out STD_LOGIC;
            rx_data     : out STD_LOGIC_VECTOR (31 downto 0);
            rx_valid    : out STD_LOGIC;
            rx_ready    : in STD_LOGIC;
            din         : out STD_LOGIC_VECTOR (3 downto 0);
            di_valid    : out STD_LOGIC;
            di_ready    : in STD_LOGIC;        
            dout        : in STD_LOGIC_VECTOR (3 downto 0);
            do_valid    : in STD_LOGIC;
            do_ready    : out STD_LOGIC;
            --dut_rst     : out std_logic;
            start       : in std_logic;
            status      : out std_logic_vector(7 downto 0)
         );
    end component dutComm;
    --user defined signals
    signal start        : std_logic;
    signal status       : std_logic_vector(7 downto 0);

begin

-- Instantiation of Axi Bus Interface S_AXI
dutcomm_v1_0_S_AXI_inst : dutcomm_v1_0_S_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
	    --user defined 
	    start => start,
	    status => status,
	    --end user defined
		S_AXI_ACLK	=> s_axi_aclk,
		S_AXI_ARESETN	=> s_axi_aresetn,
		S_AXI_AWADDR	=> s_axi_awaddr,
		S_AXI_AWPROT	=> s_axi_awprot,
		S_AXI_AWVALID	=> s_axi_awvalid,
		S_AXI_AWREADY	=> s_axi_awready,
		S_AXI_WDATA	=> s_axi_wdata,
		S_AXI_WSTRB	=> s_axi_wstrb,
		S_AXI_WVALID	=> s_axi_wvalid,
		S_AXI_WREADY	=> s_axi_wready,
		S_AXI_BRESP	=> s_axi_bresp,
		S_AXI_BVALID	=> s_axi_bvalid,
		S_AXI_BREADY	=> s_axi_bready,
		S_AXI_ARADDR	=> s_axi_araddr,
		S_AXI_ARPROT	=> s_axi_arprot,
		S_AXI_ARVALID	=> s_axi_arvalid,
		S_AXI_ARREADY	=> s_axi_arready,
		S_AXI_RDATA	=> s_axi_rdata,
		S_AXI_RRESP	=> s_axi_rresp,
		S_AXI_RVALID	=> s_axi_rvalid,
		S_AXI_RREADY	=> s_axi_rready
	);

---- Instantiation of Axi Bus Interface M_AXIS
--dutcomm_v1_0_M_AXIS_inst : dutcomm_v1_0_M_AXIS
--	generic map (
--		C_M_AXIS_TDATA_WIDTH	=> C_M_AXIS_TDATA_WIDTH,
--		C_M_START_COUNT	=> C_M_AXIS_START_COUNT
--	)
--	port map (
--		M_AXIS_ACLK	=> m_axis_aclk,
--		M_AXIS_ARESETN	=> m_axis_aresetn,
--		M_AXIS_TVALID	=> m_axis_tvalid,
--		M_AXIS_TDATA	=> m_axis_tdata,
--		M_AXIS_TSTRB	=> m_axis_tstrb,
--		M_AXIS_TLAST	=> m_axis_tlast,
--		M_AXIS_TREADY	=> m_axis_tready
--	);

-- Instantiation of Axi Bus Interface S_AXIS
--dutcomm_v1_0_S_AXIS_inst : dutcomm_v1_0_S_AXIS
--	generic map (
--		C_S_AXIS_TDATA_WIDTH	=> C_S_AXIS_TDATA_WIDTH
--	)
--	port map (
--		S_AXIS_ACLK	=> s_axis_aclk,
--		S_AXIS_ARESETN	=> s_axis_aresetn,
--		S_AXIS_TREADY	=> s_axis_tready,
--		S_AXIS_TDATA	=> s_axis_tdata,
--		S_AXIS_TSTRB	=> s_axis_tstrb,
--		S_AXIS_TLAST	=> s_axis_tlast,
--		S_AXIS_TVALID	=> s_axis_tvalid
--	);

	-- Add user logic here
	
    ---dutcomm instance
    dutcm: entity work.dutComm(behav)
    port map ( 
            clk => m_axis_aclk,
            rst => rst,
            tx_data => s_axis_tdata,
            tx_valid    => s_axis_tvalid,
            tx_ready    => s_axis_tready,
            rx_data => m_axis_tdata,
            rx_valid => m_axis_tvalid,
            rx_last => m_axis_tlast,
            rx_ready    => m_axis_tready,
            din        => din,
            di_valid => di_valid,
            di_ready  => di_ready,        
            dout => dout,
            do_valid => do_valid,
            do_ready => do_ready,
            --dut_rst => dut_rst,
            start => start,
            status => status,
            snd_start => snd_start,
            op_done => op_done,
            dut_working => dut_working
        );
	-- User logic ends

end arch_imp;
