-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- onesComp_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of an 
-- N-bit wide ones complementor (negates all N bits of input).
--
--
-- NOTES:
-- 
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity onesComp_N is
    generic(N : integer := 32); -- generic type integer for input/output data width.
	port(i_data     : in std_logic_vector(N-1 downto 0);
         o_data     : out std_logic_vector(N-1 downto 0));
end onesComp_N;

-- Structural architecture of ones complementor
architecture structural of onesComp_N is

	-- NOT gate
	component invg is
		port(i_A	: in std_logic;
			 o_F	: out std_logic);
	end component;

-- Start strucural implementation of ones complementor
begin

    -- Instantiate N not gates
	G_NBit_1Comp: for i in 0 to N-1 generate
        NOTI: invg port map(i_A => i_data(i),
                            o_F => o_data(i));
    end generate G_NBit_1Comp;

end structural;
