-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- adderRipple_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a
-- ripple carry N-bit adder.
--
--
-- NOTES:
--
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity adderRipple_N is
	-- Generic of type integer for input/output data width.
	generic(N : integer := 32);
	port(
		i_A 				: in std_logic_vector(N-1 downto 0);
		i_B					: in std_logic_vector(N-1 downto 0);
		i_C					: in std_logic;
		o_Sum				: out std_logic_vector(N-1 downto 0);
		o_Cout			: out std_logic;
		o_Overflow	: out std_logic
	);
end adderRipple_N;

-- Structural architecture of N-bit full adder
architecture structural of adderRipple_N is

	component fullAdder is
		port(i_Ai	: in std_logic;
			 i_Bi	: in std_logic;
			 i_Ci	: in std_logic;
			 o_Si	: out std_logic;
			 o_Ci	: out std_logic);
	end component;

	signal s_carry	: std_logic_vector(N downto 0);

begin

	-- 0th adder gets initial carry input
	s_carry(0)	<= i_C;

	-- Instantiate N full adders.
	G_NBit_ADDER: for i in 0 to N-1 generate
		ADDERI: fullAdder port map(
				i_Ai 	=> i_A(i),
				i_Bi	=> i_B(i),
				i_Ci	=> s_carry(i),
				o_Si	=> o_Sum(i),
				o_Ci	=> s_carry(i+1));
	end generate G_NBit_ADDER;

	o_Cout			<= s_carry(N);
	o_Overflow	<= (s_carry(N) xor s_carry(N-1));

end structural;
