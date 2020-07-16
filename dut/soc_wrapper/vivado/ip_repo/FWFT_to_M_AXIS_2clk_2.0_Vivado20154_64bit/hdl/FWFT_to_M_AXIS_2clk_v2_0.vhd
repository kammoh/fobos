library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all; 
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity FWFT_to_M_AXIS_2clk_v2_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here
		fifo_din     	: in std_logic_vector(31 downto 0);
        fifo_write      : in  std_logic;
        fifo_full       : out std_logic;
        custom_ip_clk   : in  std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		--m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic
	);
end FWFT_to_M_AXIS_2clk_v2_0;

architecture arch_imp of FWFT_to_M_AXIS_2clk_v2_0 is

    signal fifo_empty 			    : std_logic;
    signal fifo_n_empty     	    : std_logic;
    signal fifo_read 		    	: std_logic;
    signal axis_tvalid_sig     	    : std_logic;
    signal init_done                : std_logic;
    signal NUMBER_OF_OUTPUT_WORDS   : std_logic_vector(31 downto 0); 
    signal START_COUNT              : std_logic_vector(31 downto 0); 
    
    component FIFO is
    port (
            FIFO_READ_empty : out STD_LOGIC;
            FIFO_READ_rd_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
            FIFO_READ_rd_en : in STD_LOGIC;
            FIFO_WRITE_full : out STD_LOGIC;
            FIFO_WRITE_wr_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
            FIFO_WRITE_wr_en : in STD_LOGIC;
            rd_clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            wr_clk : in STD_LOGIC
    );
    end component FIFO;

begin

-- Instantiation of Axi Bus Interface S00_AXI
FWFT_FIFO_to_M_AXIS_v2_0_S00_AXI_inst : entity work.FWFT_to_M_AXIS_2clk_v2_0_S00_AXI(arch_imp)
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready,
		NUMBER_OF_OUTPUT_WORDS  => NUMBER_OF_OUTPUT_WORDS,
		START_COUNT     => START_COUNT,
		init_done       => init_done
	);

-- Instantiation of FWFT FIFO 
	FIFO_1 : component FIFO
    port map (
        rd_clk            => m00_axis_aclk,
        wr_clk            => custom_ip_clk,
        rst               => not m00_axis_aresetn,
        FIFO_WRITE_wr_en  => fifo_write,
        FIFO_READ_rd_en   => fifo_read,
        FIFO_WRITE_wr_data => fifo_din,
        FIFO_READ_rd_data => m00_axis_tdata,
        FIFO_WRITE_full   => fifo_full,
        FIFO_READ_empty   => fifo_empty
    );
    
    fifo_n_empty      <= not fifo_empty;
    
    -- Instantiation of Control Unit 
    Control: entity work.FWFT_to_M_AXIS_Control(behav)
    port map (
        clk                     => m00_axis_aclk,
        rstn                    => m00_axis_aresetn,
        m00_axis_tready         => m00_axis_tready,
        fifo_n_empty            => fifo_n_empty,
        NUMBER_OF_OUTPUT_WORDS  => NUMBER_OF_OUTPUT_WORDS,
        START_COUNT             => START_COUNT,
        m00_axis_tvalid         => m00_axis_tvalid,
        m00_axis_tlast          => m00_axis_tlast,
        fifo_read               => fifo_read,
        init_done               => init_done
        );
    
	-- User logic ends

end arch_imp;
