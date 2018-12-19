--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
--Date        : Thu Mar 31 02:16:55 2016
--Host        : DESKTOP-7SCA40G running 64-bit major release  (build 9200)
--Command     : generate_target FIFO.bd
--Design      : FIFO
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity FIFO is
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
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of FIFO : entity is "FIFO,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=FIFO,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of FIFO : entity is "FIFO.hwdef";
end FIFO;

architecture STRUCTURE of FIFO is
  component FIFO_fifo_generator_0_0 is
  port (
    rst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC
  );
  end component FIFO_fifo_generator_0_0;
  signal FIFO_READ_1_EMPTY : STD_LOGIC;
  signal FIFO_READ_1_RD_DATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal FIFO_READ_1_RD_EN : STD_LOGIC;
  signal FIFO_WRITE_1_FULL : STD_LOGIC;
  signal FIFO_WRITE_1_WR_DATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal FIFO_WRITE_1_WR_EN : STD_LOGIC;
  signal rd_clk_1 : STD_LOGIC;
  signal rst_1 : STD_LOGIC;
  signal wr_clk_1 : STD_LOGIC;
begin
  FIFO_READ_1_RD_EN <= FIFO_READ_rd_en;
  FIFO_READ_empty <= FIFO_READ_1_EMPTY;
  FIFO_READ_rd_data(31 downto 0) <= FIFO_READ_1_RD_DATA(31 downto 0);
  FIFO_WRITE_1_WR_DATA(31 downto 0) <= FIFO_WRITE_wr_data(31 downto 0);
  FIFO_WRITE_1_WR_EN <= FIFO_WRITE_wr_en;
  FIFO_WRITE_full <= FIFO_WRITE_1_FULL;
  rd_clk_1 <= rd_clk;
  rst_1 <= rst;
  wr_clk_1 <= wr_clk;
fifo_generator_0: component FIFO_fifo_generator_0_0
     port map (
      din(31 downto 0) => FIFO_WRITE_1_WR_DATA(31 downto 0),
      dout(31 downto 0) => FIFO_READ_1_RD_DATA(31 downto 0),
      empty => FIFO_READ_1_EMPTY,
      full => FIFO_WRITE_1_FULL,
      rd_clk => rd_clk_1,
      rd_en => FIFO_READ_1_RD_EN,
      rst => rst_1,
      wr_clk => wr_clk_1,
      wr_en => FIFO_WRITE_1_WR_EN
    );
end STRUCTURE;
