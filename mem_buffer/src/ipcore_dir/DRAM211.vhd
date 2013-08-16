LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
LIBRARY XilinxCoreLib;
-- synthesis translate_on
ENTITY DRAM211 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END DRAM211;

ARCHITECTURE DRAM211_a OF DRAM211 IS
-- synthesis translate_off
COMPONENT wrapped_DRAM211
  PORT (
    a : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

-- Configuration specification
  FOR ALL : wrapped_DRAM211 USE ENTITY XilinxCoreLib.dist_mem_gen_v7_1(behavioral)
    GENERIC MAP (
      c_addr_width => 11,
      c_default_data => "0",
      c_depth => 2048,
      c_family => "spartan6",
      c_has_clk => 1,
      c_has_d => 1,
      c_has_dpo => 0,
      c_has_dpra => 0,
      c_has_i_ce => 0,
      c_has_qdpo => 0,
      c_has_qdpo_ce => 0,
      c_has_qdpo_clk => 0,
      c_has_qdpo_rst => 0,
      c_has_qdpo_srst => 0,
      c_has_qspo => 0,
      c_has_qspo_ce => 0,
      c_has_qspo_rst => 0,
      c_has_qspo_srst => 0,
      c_has_spo => 1,
      c_has_spra => 0,
      c_has_we => 1,
      c_mem_init_file => "no_coe_file_loaded",
      c_mem_type => 1,
      c_parser_type => 1,
      c_pipeline_stages => 0,
      c_qce_joined => 0,
      c_qualify_we => 0,
      c_read_mif => 0,
      c_reg_a_d_inputs => 0,
      c_reg_dpra_input => 0,
      c_sync_enable => 1,
      c_width => 16
    );
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_DRAM211
  PORT MAP (
    a => a,
    d => d,
    clk => clk,
    we => we,
    spo => spo
  );
-- synthesis translate_on

END DRAM211_a;
