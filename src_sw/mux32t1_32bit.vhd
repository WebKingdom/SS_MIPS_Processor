-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32-bit wide
-- 32:1 bus multiplexor with a 5-bit select input
--
--
-- NOTES:
-- 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.custom_type_pkg.all;

entity mux32t1_32bit is
  port(
    i_Sel   : in std_logic_vector(4 downto 0);
    i_D     : in data_array_32b32;
    o_Q     : out std_logic_vector(31 downto 0)
  );
end mux32t1_32bit;

architecture custom of mux32t1_32bit is

begin
  o_Q   <= i_D(to_integer(unsigned(i_Sel)));

end custom;
