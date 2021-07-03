--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
--Date        : Fri Jul  2 17:52:30 2021
--Host        : goedel running 64-bit Ubuntu 20.04.2 LTS
--Command     : generate_target ctrl_top_wrapper.bd
--Design      : ctrl_top_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ctrl_top_wrapper is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    adc : in STD_LOGIC_VECTOR ( 9 downto 0 );
    adc_clk : out STD_LOGIC;
    adc_gain : out STD_LOGIC;
    adc_gain_mode : out STD_LOGIC;
    adc_or : in STD_LOGIC;
    ck_an_n : in STD_LOGIC_VECTOR ( 5 downto 0 );
    ck_an_p : in STD_LOGIC_VECTOR ( 5 downto 0 );
    di_ready : in STD_LOGIC;
    di_valid : out STD_LOGIC;
    din : out STD_LOGIC_VECTOR ( 3 downto 0 );
    do_ready : out STD_LOGIC;
    do_valid : in STD_LOGIC;
    dout : in STD_LOGIC_VECTOR ( 3 downto 0 );
    dut_clk : out STD_LOGIC_VECTOR ( 0 to 0 );
    dut_rst : out STD_LOGIC;
    fc2d_clk : out STD_LOGIC_VECTOR ( 0 to 0 );
    fc2d_hs : out STD_LOGIC;
    fc_dio : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    fc_io : out STD_LOGIC;
    fc_prog : out STD_LOGIC;
    fc_rst : out STD_LOGIC;
    fd2c_clk : in STD_LOGIC;
    fd2c_hs : in STD_LOGIC;
    fd_tf : in STD_LOGIC;
    gain_3v3 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    gain_5v : out STD_LOGIC_VECTOR ( 1 downto 0 );
    gain_var : out STD_LOGIC_VECTOR ( 1 downto 0 );
    glitch : out STD_LOGIC;
    glitch_lp : out STD_LOGIC;
    power_en : out STD_LOGIC;
    power_ok : in STD_LOGIC;
    power : out STD_LOGIC_VECTOR ( 5 downto 0 );
    trigger : out STD_LOGIC
  );
end ctrl_top_wrapper;

architecture STRUCTURE of ctrl_top_wrapper is

  signal pwr_O: std_logic_vector(5 downto 0);
  signal pwr_T: std_logic_vector(5 downto 0);
  
  component ctrl_top is
  port (
    adc : in STD_LOGIC_VECTOR ( 9 downto 0 );
    adc_clk : out STD_LOGIC;
    adc_gain : out STD_LOGIC;
    adc_gain_mode : out STD_LOGIC;
    di_ready : in STD_LOGIC;
    di_valid : out STD_LOGIC;
    din : out STD_LOGIC_VECTOR ( 3 downto 0 );
    do_ready : out STD_LOGIC;
    do_valid : in STD_LOGIC;
    dout : in STD_LOGIC_VECTOR ( 3 downto 0 );
    dut_clk : out STD_LOGIC_VECTOR ( 0 to 0 );
    dut_rst : out STD_LOGIC;
    power_en : out STD_LOGIC;
    power_ok : in STD_LOGIC;
    trigger : out STD_LOGIC;
    ck_an_n : in STD_LOGIC_VECTOR ( 5 downto 0 );
    ck_an_p : in STD_LOGIC_VECTOR ( 5 downto 0 );
    glitch : out STD_LOGIC;
    glitch_lp : out STD_LOGIC;
    adc_or : in STD_LOGIC;
    fc_prog : out STD_LOGIC;
    fc_io : out STD_LOGIC;
    fc_rst : out STD_LOGIC;
    fd_tf : in STD_LOGIC;
    fd2c_clk : in STD_LOGIC;
    fc2d_clk : out STD_LOGIC_VECTOR ( 0 to 0 );
    fc_dio : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    fc2d_hs : out STD_LOGIC;
    fd2c_hs : in STD_LOGIC;
    gain_3v3 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    gain_5v : out STD_LOGIC_VECTOR ( 1 downto 0 );
    gain_var : out STD_LOGIC_VECTOR ( 1 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    pwr_O : out STD_LOGIC_VECTOR ( 5 downto 0 );
    pwr_T : out STD_LOGIC_VECTOR ( 5 downto 0 )
  );
  end component ctrl_top;
begin  

  POWERTRI: for i in 0 to 5 generate
    power(i) <= 'Z' when pwr_T(i) = '1' else pwr_O(i);
  end generate POWERTRI;
  
ctrl_top_i: component ctrl_top
     port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      adc(9 downto 0) => adc(9 downto 0),
      adc_clk => adc_clk,
      adc_gain => adc_gain,
      adc_gain_mode => adc_gain_mode,
      adc_or => adc_or,
      ck_an_n(5 downto 0) => ck_an_n(5 downto 0),
      ck_an_p(5 downto 0) => ck_an_p(5 downto 0),
      di_ready => di_ready,
      di_valid => di_valid,
      din(3 downto 0) => din(3 downto 0),
      do_ready => do_ready,
      do_valid => do_valid,
      dout(3 downto 0) => dout(3 downto 0),
      dut_clk(0) => dut_clk(0),
      dut_rst => dut_rst,
      fc2d_clk(0) => fc2d_clk(0),
      fc2d_hs => fc2d_hs,
      fc_dio(3 downto 0) => fc_dio(3 downto 0),
      fc_io => fc_io,
      fc_prog => fc_prog,
      fc_rst => fc_rst,
      fd2c_clk => fd2c_clk,
      fd2c_hs => fd2c_hs,
      fd_tf => fd_tf,
      gain_3v3(1 downto 0) => gain_3v3(1 downto 0),
      gain_5v(1 downto 0) => gain_5v(1 downto 0),
      gain_var(1 downto 0) => gain_var(1 downto 0),
      glitch => glitch,
      glitch_lp => glitch_lp,
      power_en => power_en,
      power_ok => power_ok,
      pwr_O(5 downto 0) => pwr_O(5 downto 0),
      pwr_T(5 downto 0) => pwr_T(5 downto 0),
      trigger => trigger
    );
end STRUCTURE;
