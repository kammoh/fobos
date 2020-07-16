----------------------------------------------------------------------------------
-- Company:GMU 
-- Engineer: Bakry Abdulgadir
-- 
-- Create Date:    11:02:23 01/26/2016 
-- Design Name: 
-- Module Name:    DBC_Round_tb - Behavioral 
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
use work.AES_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DBC_Round_tb is
end DBC_Round_tb;

architecture Behavioral of DBC_Round_tb is
 SIGNAL din_state, dout_state, rkey_state :  t_AES_state;
 signal din, dout, rkey, expected_output : std_logic_vector(127 downto 0);
begin
-- Component Instantiation
          uut: entity work.DBC_Round(basic) PORT MAP(
                  din => din_state,
                  dout => dout_state,
						rkey => rkey_state
			);

	
	u_map_din: entity work.AES_map(structure)
    port map ( ii => din, 
               oo => din_state);
					
	u_map_rkey: entity work.AES_map(structure)
    port map ( ii => rkey, 
               oo => rkey_state);
	
	---
               
    u_map_dout: entity work.AES_invmap(structure)
    port map ( ii => dout_state, 
               oo => dout);
  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes

        -- Add user defined stimulus here
			din <= X"0f0e0d0c0b0a090828292a2b0b060301";
			rkey <= X"0a1b1405060f18114c5d524316130208";
			expected_output <= X"9bb2c3e1866a1848b89d6c39fcde70d5";
			wait for 100 ns; 
			if (dout /= expected_output) then
				report "Test failed";
			else
				report "Test successful";
			end if;
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 


end Behavioral;

