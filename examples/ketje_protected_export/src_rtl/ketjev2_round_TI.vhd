--The Ketje authenticated encryption scheme, designed by Guido Bertoni,
--Joan Daemen, Michal Peeters, Gilles Van Assche and Ronny Van Keer.
--For more information, feedback or questions, please refer to our website:
--http://ketje.noekeon.org/

-- Implementation by the designers,
-- hereby denoted as "the implementer".

-- To the extent possible under law, the implementer has waived all copyright
-- and related or neighboring rights to the source code in this file.
-- http://creativecommons.org/publicdomain/zero/1.0/


library work;
	use work.ketjev2_globals.all;
	
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;	


entity ketjev2_round_TI is

port (

    round_in_a, round_in_b     : in  k_state;
	 remask : in std_logic_vector(199 downto 0);
    round_constant_signal    : in std_logic_vector(N-1 downto 0);
    round_out_a, round_out_b    : out k_state);

end ketjev2_round_TI;

architecture rtl of ketjev2_round_TI is


  ----------------------------------------------------------------------------
  -- Internal signal declarations
  ----------------------------------------------------------------------------

 
  signal theta_in_a, theta_in_b, theta_out_a, theta_out_b, pi_in_a, pi_in_b, pi_out_a, pi_out_b, 
         rho_in_a, rho_in_b, rho_out_a, rho_out_b ,chi_in, chi_out, iota_in_a, iota_in_b, iota_out_a, iota_out_b : k_state;
  signal sum_sheet_a, sum_sheet_b: k_plane;
  signal a1, a2, a3, nchi_in_a, nchi_in_b, nchi_in_c, chi_in_a, chi_in_b, chi_in_c, chi_out_a, chi_out_b, chi_out_c : k_state;
  signal mask1 : k_state;
--  signal mask1, mask2, round_in_a, round_in_b, round_out_a, round_out_b : k_state;
--  signal m1, m2 : std_logic_vector(199 downto 0);
  
begin  -- Rtl

--connecitons

--order theta, pi, rho, chi, iota
theta_in_a<=round_in_a;
theta_in_b<=round_in_b;
pi_in_a<=rho_out_a;
pi_in_b<=rho_out_b;
rho_in_a<=theta_out_a;
rho_in_b<=theta_out_b;
round_out_a<=iota_out_a;
round_out_b<=iota_out_b;

--m1 <= x"934bc8d9ef3748598dcb92bdcafed63740293bdcbcaaed3374";
--m2 <= x"deadbeefdeadbabedeafbeeffefebabeeadb029384758bbdcc";

--mask generate
  m0000: for y in 0 to 4 generate
	m0001: for x in 0 to 4 generate
		m0002: for i in 0 to N-1 generate
            mask1(y)(x)(i) <=remask(y*40 + x*N + i);
--            mask2(y)(x)(i) <=m2(y*40 + x*N + i);
--				round_in_a(y)(x)(i) <= round_in(y)(x)(i) xor mask1(y)(x)(i);
--				round_in_b(y)(x)(i) <= mask1(y)(x)(i);
--				round_out(y)(x)(i) <= round_out_a(y)(x)(i) xor round_out_b(y)(x)(i);	
		end generate;	
	end generate;
end generate;

--reshare generate
  re0000: for y in 0 to 4 generate
	re0001: for x in 0 to 4 generate
		re0002: for i in 0 to N-1 generate
				chi_in_a(y)(x)(i) <= pi_out_a(y)(x)(i);
				chi_in_b(y)(x)(i) <= pi_out_b(y)(x)(i) xor mask1(y)(x)(i);
				chi_in_c(y)(x)(i) <= mask1(y)(x)(i);
				iota_in_a(y)(x)(i) <= chi_out_a(y)(x)(i) xor chi_out_b(y)(x)(i);
				iota_in_b(y)(x)(i) <= chi_out_c(y)(x)(i);
		end generate;	
	end generate;
end generate;

--chi
--i0000: for y in 0 to 4 generate
--	i0001: for x in 0 to 2 generate
--		i0002: for i in 0 to N-1 generate
--			chi_out(y)(x)(i)<=chi_in(y)(x)(i) xor  ( not(chi_in (y)(x+1)(i))and chi_in (y)(x+2)(i));
		
--		end generate;	
--	end generate;
--end generate;

--	i0011: for y in 0 to 4 generate
--		i0021: for i in 0 to N-1 generate
--			chi_out(y)(3)(i)<=chi_in(y)(3)(i) xor  ( not(chi_in (y)(4)(i))and chi_in (y)(0)(i));
		
--		end generate;	
--	end generate;
	
--	i0012: for y in 0 to 4 generate
--		i0022: for i in 0 to N-1 generate
--			chi_out(y)(4)(i)<=chi_in(y)(4)(i) xor  ( not(chi_in (y)(0)(i))and chi_in (y)(1)(i));
		
--		end generate;	
--	end generate;


--chi
i0000: for y in 0 to 4 generate
	i0001: for x in 0 to 2 generate
		i0002: for i in 0 to N-1 generate

            nchi_in_a(y)(x+1)(i) <= not chi_in_a (y)(x+1)(i);
            nchi_in_b(y)(x+1)(i) <= not chi_in_b (y)(x+1)(i);
            nchi_in_c(y)(x+1)(i) <= not chi_in_c (y)(x+1)(i);

            chianda0: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_b(y)(x+1)(i),
                xb => nchi_in_c(y)(x+1)(i),
                ya => chi_in_b(y)(x+2)(i),
                yb => chi_in_c(y)(x+2)(i),
                o =>  a1(y)(x)(i)
            );

            chiandb0: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_c(y)(x+1)(i),
                xb => nchi_in_a(y)(x+1)(i),
                ya => chi_in_c(y)(x+2)(i),
                yb => chi_in_a(y)(x+2)(i),
                o =>  a2(y)(x)(i)
            );

            chiandc0: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_a(y)(x+1)(i),
                xb => nchi_in_b(y)(x+1)(i),
                ya => chi_in_a(y)(x+2)(i),
                yb => chi_in_b(y)(x+2)(i),
                o =>  a3(y)(x)(i)
            );

			chi_out_a(y)(x)(i)<=chi_in_a(y)(x)(i) xor a1(y)(x)(i); -- ( not(chi_in (y)(x+1)(i))and chi_in (y)(x+2)(i));
		    chi_out_b(y)(x)(i)<=chi_in_b(y)(x)(i) xor a2(y)(x)(i); -- ( not(chi_in (y)(x+1)(i))and chi_in (y)(x+2)(i));
            chi_out_c(y)(x)(i)<=chi_in_c(y)(x)(i) xor a3(y)(x)(i); -- ( not(chi_in (y)(x+1)(i))and chi_in (y)(x+2)(i));

		end generate;	
	end generate;
end generate;

	i0011: for y in 0 to 4 generate
		i0021: for i in 0 to N-1 generate

            nchi_in_a(y)(4)(i) <= not chi_in_a (y)(4)(i);
            nchi_in_b(y)(4)(i) <= not chi_in_b (y)(4)(i);
            nchi_in_c(y)(4)(i) <= not chi_in_c (y)(4)(i);

            chianda1: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_b(y)(4)(i),
                xb => nchi_in_c(y)(4)(i),
                ya => chi_in_b(y)(0)(i),
                yb => chi_in_c(y)(0)(i),
                o =>  a1(y)(3)(i)
            );

            chiandb1: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_c(y)(4)(i),
                xb => nchi_in_a(y)(4)(i),
                ya => chi_in_c(y)(0)(i),
                yb => chi_in_a(y)(0)(i),
                o =>  a2(y)(3)(i)
            );

            chiandc1: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_a(y)(4)(i),
                xb => nchi_in_b(y)(4)(i),
                ya => chi_in_a(y)(0)(i),
                yb => chi_in_b(y)(0)(i),
                o =>  a3(y)(3)(i)
            );


			--chi_out(y)(3)(i)<=chi_in(y)(3)(i) xor  ( not(chi_in (y)(4)(i))and chi_in (y)(0)(i));
            chi_out_a(y)(3)(i)<=chi_in_a(y)(3)(i) xor  a1(y)(3)(i);
            chi_out_b(y)(3)(i)<=chi_in_b(y)(3)(i) xor  a2(y)(3)(i);
            chi_out_c(y)(3)(i)<=chi_in_c(y)(3)(i) xor  a3(y)(3)(i);    

		end generate;	
	end generate;
	
	i0012: for y in 0 to 4 generate
		i0022: for i in 0 to N-1 generate

            nchi_in_a(y)(0)(i) <= not chi_in_a (y)(0)(i);
            nchi_in_b(y)(0)(i) <= not chi_in_b (y)(0)(i);
            nchi_in_c(y)(0)(i) <= not chi_in_c (y)(0)(i);

            chianda2: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_b(y)(0)(i),
                xb => nchi_in_c(y)(0)(i),
                ya => chi_in_b(y)(1)(i),
                yb => chi_in_c(y)(1)(i),
                o =>  a1(y)(4)(i)
            );

            chiandb2: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_c(y)(0)(i),
                xb => nchi_in_a(y)(0)(i),
                ya => chi_in_c(y)(1)(i),
                yb => chi_in_a(y)(1)(i),
                o =>  a2(y)(4)(i)
            );

            chiandc2: entity work.and_3TI(dataflow)
            port map(
                xa => nchi_in_a(y)(0)(i),
                xb => nchi_in_b(y)(0)(i),
                ya => chi_in_a(y)(1)(i),
                yb => chi_in_b(y)(1)(i),
                o =>  a3(y)(4)(i)
            );

			--chi_out(y)(4)(i)<=chi_in(y)(4)(i) xor  ( not(chi_in (y)(0)(i))and chi_in (y)(1)(i));
            chi_out_a(y)(4)(i)<=chi_in_a(y)(4)(i) xor a1(y)(4)(i);
            chi_out_b(y)(4)(i)<=chi_in_b(y)(4)(i) xor a2(y)(4)(i);
            chi_out_c(y)(4)(i)<=chi_in_c(y)(4)(i) xor a3(y)(4)(i);

		end generate;	
	end generate;


--theta a

--compute sum of columns

i0101_a: for x in 0 to 4 generate
	i0102_a: for i in 0 to N-1 generate
		sum_sheet_a(x)(i)<=theta_in_a(0)(x)(i) xor theta_in_a(1)(x)(i) xor theta_in_a(2)(x)(i) xor theta_in_a(3)(x)(i) xor theta_in_a(4)(x)(i);
	
	end generate;	
end generate;


i0200_a: for y in 0 to 4 generate
	i0201_a: for x in 1 to 3 generate
		theta_out_a(y)(x)(0)<=theta_in_a(y)(x)(0) xor sum_sheet_a(x-1)(0) xor sum_sheet_a(x+1)(N-1);
		i0202_a: for i in 1 to N-1 generate
			theta_out_a(y)(x)(i)<=theta_in_a(y)(x)(i) xor sum_sheet_a(x-1)(i) xor sum_sheet_a(x+1)(i-1);
		end generate;	
	end generate;
end generate;

i2001_a: for y in 0 to 4 generate
	theta_out_a(y)(0)(0)<=theta_in_a(y)(0)(0) xor sum_sheet_a(4)(0) xor sum_sheet_a(1)(N-1);
	i2021_a: for i in 1 to N-1 generate
		theta_out_a(y)(0)(i)<=theta_in_a(y)(0)(i) xor sum_sheet_a(4)(i) xor sum_sheet_a(1)(i-1);
	end generate;	

end generate;

i2002_a: for y in 0 to 4 generate
	theta_out_a(y)(4)(0)<=theta_in_a(y)(4)(0) xor sum_sheet_a(3)(0) xor sum_sheet_a(0)(N-1);
	i2022_a: for i in 1 to N-1 generate
		theta_out_a(y)(4)(i)<=theta_in_a(y)(4)(i) xor sum_sheet_a(3)(i) xor sum_sheet_a(0)(i-1);
	end generate;	

end generate;

--theta b

--compute sum of columns

i0101_b: for x in 0 to 4 generate
	i0102_b: for i in 0 to N-1 generate
		sum_sheet_b(x)(i)<=theta_in_b(0)(x)(i) xor theta_in_b(1)(x)(i) xor theta_in_b(2)(x)(i) xor theta_in_b(3)(x)(i) xor theta_in_b(4)(x)(i);
	
	end generate;	
end generate;


i0200_b: for y in 0 to 4 generate
	i0201_b: for x in 1 to 3 generate
		theta_out_b(y)(x)(0)<=theta_in_b(y)(x)(0) xor sum_sheet_b(x-1)(0) xor sum_sheet_b(x+1)(N-1);
		i0202_b: for i in 1 to N-1 generate
			theta_out_b(y)(x)(i)<=theta_in_b(y)(x)(i) xor sum_sheet_b(x-1)(i) xor sum_sheet_b(x+1)(i-1);
		end generate;	
	end generate;
end generate;

i2001_b: for y in 0 to 4 generate
	theta_out_b(y)(0)(0)<=theta_in_b(y)(0)(0) xor sum_sheet_b(4)(0) xor sum_sheet_b(1)(N-1);
	i2021_b: for i in 1 to N-1 generate
		theta_out_b(y)(0)(i)<=theta_in_b(y)(0)(i) xor sum_sheet_b(4)(i) xor sum_sheet_b(1)(i-1);
	end generate;	

end generate;

i2002_b: for y in 0 to 4 generate
	theta_out_b(y)(4)(0)<=theta_in_b(y)(4)(0) xor sum_sheet_b(3)(0) xor sum_sheet_b(0)(N-1);
	i2022_b: for i in 1 to N-1 generate
		theta_out_b(y)(4)(i)<=theta_in_b(y)(4)(i) xor sum_sheet_b(3)(i) xor sum_sheet_b(0)(i-1);
	end generate;	

end generate;


-- pi a
i3001_a: for y in 0 to 4 generate
	i3002_a: for x in 0 to 4 generate
		i3003_a: for i in 0 to N-1 generate
			--pi_out(y)(x)(i)<=pi_in((y +2*x) mod 5)(((4*y)+x) mod 5)(i);
			pi_out_a((2*x+3*y) mod 5)(0*x+1*y)(i)<=pi_in_a(y) (x)(i);
		end generate;	
	end generate;
end generate;


-- pi b
i3001_b: for y in 0 to 4 generate
	i3002_b: for x in 0 to 4 generate
		i3003_b: for i in 0 to N-1 generate
			--pi_out(y)(x)(i)<=pi_in((y +2*x) mod 5)(((4*y)+x) mod 5)(i);
			pi_out_b((2*x+3*y) mod 5)(0*x+1*y)(i)<=pi_in_b(y) (x)(i);
		end generate;	
	end generate;
end generate;

--rho a


i4001_a: for i in 0 to N-1 generate
	rho_out_a(0)(0)(i)<=rho_in_a(0)(0)(i);
end generate;	
i4002_a: for i in 0 to N-1 generate
	rho_out_a(0)(1)(i)<=rho_in_a(0)(1)((i-1)mod N);
end generate;
i4003_a: for i in 0 to N-1 generate
	rho_out_a(0)(2)(i)<=rho_in_a(0)(2)((i-62)mod N);
end generate;
i4004_a: for i in 0 to N-1 generate
	rho_out_a(0)(3)(i)<=rho_in_a(0)(3)((i-28)mod N);
end generate;
i4005_a: for i in 0 to N-1 generate
	rho_out_a(0)(4)(i)<=rho_in_a(0)(4)((i-27)mod N);
end generate;

i4011_a: for i in 0 to N-1 generate
	rho_out_a(1)(0)(i)<=rho_in_a(1)(0)((i-36)mod N);
end generate;	
i4012_a: for i in 0 to N-1 generate
	rho_out_a(1)(1)(i)<=rho_in_a(1)(1)((i-44)mod N);
end generate;
i4013_a: for i in 0 to N-1 generate
	rho_out_a(1)(2)(i)<=rho_in_a(1)(2)((i-6)mod N);
end generate;
i4014_a: for i in 0 to N-1 generate
	rho_out_a(1)(3)(i)<=rho_in_a(1)(3)((i-55)mod N);
end generate;
i4015_a: for i in 0 to N-1 generate
	rho_out_a(1)(4)(i)<=rho_in_a(1)(4)((i-20)mod N);
end generate;

i4021_a: for i in 0 to N-1 generate
	rho_out_a(2)(0)(i)<=rho_in_a(2)(0)((i-3)mod N);
end generate;	
i4022_a: for i in 0 to N-1 generate
	rho_out_a(2)(1)(i)<=rho_in_a(2)(1)((i-10)mod N);
end generate;
i4023_a: for i in 0 to N-1 generate
	rho_out_a(2)(2)(i)<=rho_in_a(2)(2)((i-43)mod N);
end generate;
i4024_a: for i in 0 to N-1 generate
	rho_out_a(2)(3)(i)<=rho_in_a(2)(3)((i-25)mod N);
end generate;
i4025_a: for i in 0 to N-1 generate
	rho_out_a(2)(4)(i)<=rho_in_a(2)(4)((i-39)mod N);
end generate;

i4031_a: for i in 0 to N-1 generate
	rho_out_a(3)(0)(i)<=rho_in_a(3)(0)((i-41)mod N);
end generate;	
i4032_a: for i in 0 to N-1 generate
	rho_out_a(3)(1)(i)<=rho_in_a(3)(1)((i-45)mod N);
end generate;
i4033_a: for i in 0 to N-1 generate
	rho_out_a(3)(2)(i)<=rho_in_a(3)(2)((i-15)mod N);
end generate;
i4034_a: for i in 0 to N-1 generate
	rho_out_a(3)(3)(i)<=rho_in_a(3)(3)((i-21)mod N);
end generate;
i4035_a: for i in 0 to N-1 generate
	rho_out_a(3)(4)(i)<=rho_in_a(3)(4)((i-8)mod N);
end generate;

i4041_a: for i in 0 to N-1 generate
	rho_out_a(4)(0)(i)<=rho_in_a(4)(0)((i-18)mod N);
end generate;	
i4042_a: for i in 0 to N-1 generate
	rho_out_a(4)(1)(i)<=rho_in_a(4)(1)((i-2)mod N);
end generate;
i4043_a: for i in 0 to N-1 generate
	rho_out_a(4)(2)(i)<=rho_in_a(4)(2)((i-61)mod N);
end generate;
i4044_a: for i in 0 to N-1 generate
	rho_out_a(4)(3)(i)<=rho_in_a(4)(3)((i-56)mod N);
end generate;
i4045_a: for i in 0 to N-1 generate
	rho_out_a(4)(4)(i)<=rho_in_a(4)(4)((i-14)mod N);
end generate;

--rho b


i4001_b: for i in 0 to N-1 generate
	rho_out_b(0)(0)(i)<=rho_in_b(0)(0)(i);
end generate;	
i4002_b: for i in 0 to N-1 generate
	rho_out_b(0)(1)(i)<=rho_in_b(0)(1)((i-1)mod N);
end generate;
i4003_b: for i in 0 to N-1 generate
	rho_out_b(0)(2)(i)<=rho_in_b(0)(2)((i-62)mod N);
end generate;
i4004_b: for i in 0 to N-1 generate
	rho_out_b(0)(3)(i)<=rho_in_b(0)(3)((i-28)mod N);
end generate;
i4005_b: for i in 0 to N-1 generate
	rho_out_b(0)(4)(i)<=rho_in_b(0)(4)((i-27)mod N);
end generate;

i4011_b: for i in 0 to N-1 generate
	rho_out_b(1)(0)(i)<=rho_in_b(1)(0)((i-36)mod N);
end generate;	
i4012_b: for i in 0 to N-1 generate
	rho_out_b(1)(1)(i)<=rho_in_b(1)(1)((i-44)mod N);
end generate;
i4013_b: for i in 0 to N-1 generate
	rho_out_b(1)(2)(i)<=rho_in_b(1)(2)((i-6)mod N);
end generate;
i4014_b: for i in 0 to N-1 generate
	rho_out_b(1)(3)(i)<=rho_in_b(1)(3)((i-55)mod N);
end generate;
i4015_b: for i in 0 to N-1 generate
	rho_out_b(1)(4)(i)<=rho_in_b(1)(4)((i-20)mod N);
end generate;

i4021_b: for i in 0 to N-1 generate
	rho_out_b(2)(0)(i)<=rho_in_b(2)(0)((i-3)mod N);
end generate;	
i4022_b: for i in 0 to N-1 generate
	rho_out_b(2)(1)(i)<=rho_in_b(2)(1)((i-10)mod N);
end generate;
i4023_b: for i in 0 to N-1 generate
	rho_out_b(2)(2)(i)<=rho_in_b(2)(2)((i-43)mod N);
end generate;
i4024_b: for i in 0 to N-1 generate
	rho_out_b(2)(3)(i)<=rho_in_b(2)(3)((i-25)mod N);
end generate;
i4025_b: for i in 0 to N-1 generate
	rho_out_b(2)(4)(i)<=rho_in_b(2)(4)((i-39)mod N);
end generate;

i4031_b: for i in 0 to N-1 generate
	rho_out_b(3)(0)(i)<=rho_in_b(3)(0)((i-41)mod N);
end generate;	
i4032_b: for i in 0 to N-1 generate
	rho_out_b(3)(1)(i)<=rho_in_b(3)(1)((i-45)mod N);
end generate;
i4033_b: for i in 0 to N-1 generate
	rho_out_b(3)(2)(i)<=rho_in_b(3)(2)((i-15)mod N);
end generate;
i4034_b: for i in 0 to N-1 generate
	rho_out_b(3)(3)(i)<=rho_in_b(3)(3)((i-21)mod N);
end generate;
i4035_b: for i in 0 to N-1 generate
	rho_out_b(3)(4)(i)<=rho_in_b(3)(4)((i-8)mod N);
end generate;

i4041_b: for i in 0 to N-1 generate
	rho_out_b(4)(0)(i)<=rho_in_b(4)(0)((i-18)mod N);
end generate;	
i4042_b: for i in 0 to N-1 generate
	rho_out_b(4)(1)(i)<=rho_in_b(4)(1)((i-2)mod N);
end generate;
i4043_b: for i in 0 to N-1 generate
	rho_out_b(4)(2)(i)<=rho_in_b(4)(2)((i-61)mod N);
end generate;
i4044_b: for i in 0 to N-1 generate
	rho_out_b(4)(3)(i)<=rho_in_b(4)(3)((i-56)mod N);
end generate;
i4045_b: for i in 0 to N-1 generate
	rho_out_b(4)(4)(i)<=rho_in_b(4)(4)((i-14)mod N);
end generate;

--iota a
i5001_a: for y in 1 to 4 generate
	i5002_a: for x in 0 to 4 generate
		i5003_a: for i in 0 to N-1 generate
			iota_out_a(y)(x)(i)<=iota_in_a(y)(x)(i);
		end generate;	
	end generate;
end generate;


	i5012_a: for x in 1 to 4 generate
		i5013_a: for i in 0 to N-1 generate
			iota_out_a(0)(x)(i)<=iota_in_a(0)(x)(i);
		end generate;	
	end generate;



		i5103_a: for i in 0 to N-1 generate
			iota_out_a(0)(0)(i)<=iota_in_a(0)(0)(i) xor round_constant_signal(i);
		end generate;	

--iota b
i5001_b: for y in 1 to 4 generate
	i5002_b: for x in 0 to 4 generate
		i5003_b: for i in 0 to N-1 generate
			iota_out_b(y)(x)(i)<=iota_in_b(y)(x)(i);
		end generate;	
	end generate;
end generate;


	i5012_b: for x in 1 to 4 generate
		i5013_b: for i in 0 to N-1 generate
			iota_out_b(0)(x)(i)<=iota_in_b(0)(x)(i);
		end generate;	
	end generate;



		i5103_b: for i in 0 to N-1 generate
			iota_out_b(0)(0)(i)<=iota_in_b(0)(0)(i);
		end generate;	



end rtl;
