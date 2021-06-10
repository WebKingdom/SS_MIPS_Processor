-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- fullAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a 
-- full adder.
--
--
-- NOTES:
-- 
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity fullAdder is
	port(i_Ai   : in std_logic;
		 i_Bi   : in std_logic;
		 i_Ci   : in std_logic;
		 o_Si   : out std_logic;
         o_Ci	: out std_logic);
end fullAdder;

-- Structural architecture of full adder
architecture structural of fullAdder is

	-- AND gate
	component andg2 is
		port(i_A	: in std_logic;
			 i_B 	: in std_logic;
			 o_F	: out std_logic);
	end component;

	-- OR gate
	component org2 is
		port(i_A	: in std_logic;
			 i_B 	: in std_logic;
			 o_F	: out std_logic);
	end component;

	-- XOR gate
	component xorg2 is
		port(i_A	: in std_logic;
			 i_B 	: in std_logic;
			 o_F	: out std_logic);
	end component;

	-- Signals to carry intermediate data
	signal s_xorS0, s_andC0, s_andC1, s_orC0 : std_logic;

-- Start strucural implementation of full adder
begin

    -- Instantiate and map gates with correct signals
	xorS0: xorg2
		port map(i_A	=> i_Ai,
				 i_B	=> i_Bi,
				 o_F	=> s_xorS0);

	xorS1: xorg2
		port map(i_A	=> s_xorS0,
				 i_B 	=> i_Ci,
				 o_F	=> o_Si);

	andC0: andg2
		port map(i_A	=> i_Ai,
				 i_B	=> i_Bi,
				 o_F	=> s_andC0);
	
	orC0: org2
		port map(i_A	=> i_Ai,
				 i_B	=> i_Bi,
				 o_F	=> s_orC0);
	 
	andC1: andg2
		port map(i_A	=> s_orC0,
				 i_B	=> i_Ci,
				 o_F	=> s_andC1);
	
	orC1: org2
		port map(i_A	=> s_andC0,
			 	 i_B	=> s_andC1,
				 o_F	=> o_Ci);

end structural;
