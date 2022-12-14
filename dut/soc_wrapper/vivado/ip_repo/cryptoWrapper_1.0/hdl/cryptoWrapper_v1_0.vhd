library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cryptoWrapper_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5;

		-- Parameters of Axi Slave Bus Interface S_AXIS_SDI
		C_S_AXIS_SDI_TDATA_WIDTH	: integer	:= 128;

		-- Parameters of Axi Slave Bus Interface S_AXIS_PDI
		C_S_AXIS_PDI_TDATA_WIDTH	: integer	:= 128;

		-- Parameters of Axi Master Bus Interface M_AXIS_DO
		C_M_AXIS_DO_TDATA_WIDTH	: integer	:= 128;
		C_M_AXIS_DO_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here

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

		-- Ports of Axi Slave Bus Interface S_AXIS_SDI
		s_axis_sdi_aclk	: in std_logic;
		s_axis_sdi_aresetn	: in std_logic;
		s_axis_sdi_tready	: out std_logic;
		s_axis_sdi_tdata	: in std_logic_vector(C_S_AXIS_SDI_TDATA_WIDTH-1 downto 0);
		s_axis_sdi_tstrb	: in std_logic_vector((C_S_AXIS_SDI_TDATA_WIDTH/8)-1 downto 0);
		s_axis_sdi_tlast	: in std_logic;
		s_axis_sdi_tvalid	: in std_logic;

		-- Ports of Axi Slave Bus Interface S_AXIS_PDI
		s_axis_pdi_aclk	: in std_logic;
		s_axis_pdi_aresetn	: in std_logic;
		s_axis_pdi_tready	: out std_logic;
		s_axis_pdi_tdata	: in std_logic_vector(C_S_AXIS_PDI_TDATA_WIDTH-1 downto 0);
		s_axis_pdi_tstrb	: in std_logic_vector((C_S_AXIS_PDI_TDATA_WIDTH/8)-1 downto 0);
		s_axis_pdi_tlast	: in std_logic;
		s_axis_pdi_tvalid	: in std_logic;

		-- Ports of Axi Master Bus Interface M_AXIS_DO
		m_axis_do_aclk	: in std_logic;
		m_axis_do_aresetn	: in std_logic;
		m_axis_do_tvalid	: out std_logic;
		m_axis_do_tdata	: out std_logic_vector(C_M_AXIS_DO_TDATA_WIDTH-1 downto 0);
		m_axis_do_tstrb	: out std_logic_vector((C_M_AXIS_DO_TDATA_WIDTH/8)-1 downto 0);
		m_axis_do_tlast	: out std_logic;
		m_axis_do_tready	: in std_logic
	);
end cryptoWrapper_v1_0;

architecture arch_imp of cryptoWrapper_v1_0 is

	-- component declaration
	component cryptoWrapper_v1_0_S_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
		);
		port (
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
	end component cryptoWrapper_v1_0_S_AXI;
	
	---Crypto Accelerator here
	component aes_axi is
        port ( clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        pdi_data : in  STD_LOGIC_VECTOR (127 downto 0);
        pdi_valid : in  STD_LOGIC;
        pdi_ready : out  STD_LOGIC;
        sdi_data : in  STD_LOGIC_VECTOR (127 downto 0);
        sdi_valid : in  STD_LOGIC;
        sdi_ready : out  STD_LOGIC;
        do_data : out  STD_LOGIC_VECTOR (127 downto 0);
        do_valid : out  STD_LOGIC;
        do_ready : in  STD_LOGIC
     );
    end component aes_axi;

    signal rst : std_logic;
	
begin

-- Instantiation of Axi Bus Interface S_AXI
cryptoWrapper_v1_0_S_AXI_inst : cryptoWrapper_v1_0_S_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
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


	-- Add user logic here
    rst <= not s_axis_sdi_aresetn;
aes_axi_inst : aes_axi 
    port map 
        ( clk => s_axis_sdi_aclk,
        rst => rst,
        pdi_data => s_axis_pdi_tdata,
        pdi_valid => s_axis_pdi_tvalid,
        pdi_ready => s_axis_pdi_tready,
        sdi_data => s_axis_sdi_tdata,
        sdi_valid => s_axis_sdi_tvalid,
        sdi_ready => s_axis_sdi_tready,
        do_data => m_axis_do_tdata,
        do_valid => m_axis_do_tvalid,
        do_ready => m_axis_do_tready
	);

end arch_imp;
