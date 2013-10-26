package my_utils is

	function log2(i: natural) return integer;
	
end my_utils;

package body my_utils is
	--
	-- borrowed from http://www.edaboard.com/thread186363.html
	--
	function log2( i : natural) return integer is
		variable temp    : integer := i;
		variable ret_val : integer := 0; 
	  begin					
		while temp > 1 loop
		  ret_val := ret_val + 1;
		  temp    := temp / 2;     
		end loop;
		
		return ret_val;
	  end function;

end my_utils;