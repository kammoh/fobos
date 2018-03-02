-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  use work.AES_pkg.all;


  ENTITY testbench_g IS
  END testbench_g;

  ARCHITECTURE behavior OF testbench_g IS 


          SIGNAL din_state, dout_state :  t_AES_state;
          signal din, dout, expected_output : std_logic_vector(127 downto 0);
          

  BEGIN

  -- Component Instantiation
          uut: entity work.g(struct) PORT MAP(
                  ii => din_state,
                  oo => dout_state,
						alpha => "010"
          );

	--added
	u_map_din: entity work.AES_map(structure)
    port map ( ii => din, 
               oo => din_state);
	
	---
               
    u_map_dout: entity work.AES_invmap(structure)
    port map ( ii => dout_state, 
               oo => dout);
  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes

        -- Add user defined stimulus here
			din <= X"06090c030205080f0e01040b0a0d0007";
			expected_output <= X"0c121806040a101e1c020816141a000e";
			wait for 100 ns; 
			if (dout /= expected_output) then
				report "Test failed";
			else
				report "Test successful";
			end if;
        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
