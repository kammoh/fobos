--The Ketje authenticated encryption scheme, designed by Guido Bertoni,
--Joan Daemen, Micha�l Peeters, Gilles Van Assche and Ronny Van Keer.
--For more information, feedback or questions, please refer to our website:
--http://ketje.noekeon.org/

-- Implementation by the designers,
-- hereby denoted as "the implementer".

-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/

library STD;
 use STD.textio.all;


  library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_misc.all;
    use IEEE.std_logic_arith.all;
    

library work;


package ketjev2_globals is

constant rst_active : std_logic := '1';

constant num_plane : integer := 5;
constant num_sheet : integer := 5;
constant logD : integer :=4;
--ketje jr
constant N : integer := 8;
constant key_pack_size : std_logic_vector(7 downto 0) := "00001110";
constant key_pack_padding : std_logic_vector(7 downto 0) := "00000001";
constant start_padding : std_logic_vector(7 downto 0) := "00000001";
constant end_padding : std_logic_vector(7 downto 0) := "10000000";


--ketje sr
--constant N : integer := 16;



--types
type k_lane        is  array ((N-1) downto 0)  of std_logic;    
type k_plane        is array ((num_sheet-1) downto 0)  of k_lane;    
type k_state        is array ((num_plane-1) downto 0)  of k_plane;  
 
constant k_seq_dly : Time := 1 ns; 
  
constant        c_G_NPUB_SIZE              : integer := 64;  
-- not used
constant        c_G_NSEC_SIZE              : integer := 96;   

constant        c_G_DBLK_SIZE              : integer := 32;  
constant        c_G_KEY_SIZE               : integer := 96;  
-- not used
constant        c_G_RDKEY_SIZE             : integer := 96;  

constant        c_G_TAG_SIZE               : integer := 64;  
constant        c_G_BS_BYTES               : integer := 2;    
constant        c_G_CTR_AD_SIZE            : integer := 64;   
constant        c_G_CTR_D_SIZE             : integer := 64   ;
 
 
end package;