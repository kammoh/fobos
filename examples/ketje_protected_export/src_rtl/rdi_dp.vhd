----------------------------------------------------------------------------------
-- Company: GMU
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    13:05:32 08/15/2017 
-- Design Name: 
-- Module Name:    rdi_dp - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rdi_dp is
    Generic (G_W : integer := 32;
	          N : integer := 4;
				 M : integer := 4
				 );
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rdi_data : in  STD_LOGIC_VECTOR (G_W -1 downto 0);
           pdi_rdata : out  STD_LOGIC_VECTOR (N * G_W -1 downto 0);
           sdi_rdata : out  STD_LOGIC_VECTOR (M * G_W -1 downto 0);
			  
			  --To ctrl
			  en_pdi_rdata : in STD_LOGIC;
           en_sdi_rdata : in STD_LOGIC;
		     pdi_cnt_rst : in STD_LOGIC;
           sdi_cnt_rst : in STD_LOGIC;
		     pdi_rdata_full : out STD_LOGIC;
		     sdi_rdata_full : out STD_LOGIC);
end rdi_dp;

architecture Behav of rdi_dp is
signal pdi_cnt, sdi_cnt : STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal tmp_pdi_rdata : STD_LOGIC_VECTOR (N * G_W -1 downto 0):=(others => '0');
signal tmp_sdi_rdata : STD_LOGIC_VECTOR (M * G_W -1 downto 0):=(others => '0');

begin
-----------------------------------------------
--pdi_rdata shift register
pdi_rdata_reg : process(clk)

begin
    if (rising_edge(clk)) then 
		if (rst = '1') then
	     tmp_pdi_rdata <= (others=>'0');
	   else if en_pdi_rdata = '1' then
		      tmp_pdi_rdata <= tmp_pdi_rdata( N * G_W - G_W -1 downto 0) & rdi_data;
			  end if;
		end if;	  
	 end if;

--    if rst = '1' then
--	     tmp_pdi_rdata <= (others=>'0');
--	
--   else if rising_edge(clk) and en_pdi_rdata = '1' then
	--	      tmp_pdi_rdata <= tmp_pdi_rdata( N * G_W - G_W -1 downto 0) & rdi_data;
--        end if;
--	 end if;


end process;

pdi_rdata <= tmp_pdi_rdata;
--pdi_rdata_cntr
pdi_rdata_cnt : process(clk)
begin
    if (rising_edge(clk)) then  
		if pdi_cnt_rst = '1' then
			pdi_cnt <= (others => '0');
		else 
	     if en_pdi_rdata = '1' then
	         pdi_cnt <= pdi_cnt + 1; 
		  end if;
		end if;
	 end if;

--    if pdi_cnt_rst = '1' then
--	     pdi_cnt <= (others => '0');
--	 else 
--	     if en_pdi_rdata = '1' and rising_edge(clk) then
--	         pdi_cnt <= pdi_cnt + 1; 
--		  end if;
--	 end if;


end process;

pdi_rdata_full <= '1' when pdi_cnt = N  else '0';
----------------------------------------------
--sdi_rdata shift register
sdi_rdata_reg : process(clk)
begin
    if (rising_edge(clk)) then
		if rst = '1' then
			tmp_sdi_rdata <= (others=>'0');
	
		else if en_sdi_rdata = '1' then
		      tmp_sdi_rdata <= tmp_sdi_rdata( M * G_W - G_W -1 downto 0) & rdi_data;
			  end if;
		end if;
	 end if;

--    if rst = '1' then
--	     tmp_sdi_rdata <= (others=>'0');
	
--    else if rising_edge(clk) and en_sdi_rdata = '1' then
--		      tmp_sdi_rdata <= tmp_sdi_rdata( M * G_W - G_W -1 downto 0) & rdi_data;
--        end if;
--	 end if;

end process;
sdi_rdata <= tmp_sdi_rdata;
--pdi_rdata_cntr
sdi_rdata_cnt : process(clk)
begin
    if (rising_edge(clk)) then
		if sdi_cnt_rst = '1' then
	     sdi_cnt <= (others => '0');
		else 
	     if en_sdi_rdata = '1' then
	         sdi_cnt <= sdi_cnt + 1; 
		  end if;
		end if;
    end if;
--    if sdi_cnt_rst = '1' then
--	     sdi_cnt <= (others => '0');
--	 else 
--	     if en_sdi_rdata = '1' and rising_edge(clk) then
--	         sdi_cnt <= sdi_cnt + 1; 
--		  end if;
--	 end if;

end process;

sdi_rdata_full <= '1' when sdi_cnt = M  else '0';


end Behav;

