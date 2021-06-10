-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 16 to 32 bit 
-- extender capable of doing both sign and zero extension.
-- If i_SelExt is 0 => zero extension
-- If i_SelExt is 1 => sign extension
--
-- NOTES:
-- 
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity
entity ext16t32 is

  port(
    i_SelExt  : in std_logic;
    i_Val16   : in std_logic_vector(15 downto 0);
    o_Val32   : out std_logic_vector(31 downto 0)
  );

end ext16t32;

-- Structural architecture of 2-1 mux
architecture custom of ext16t32 is

begin
  o_Val32	<= std_logic_vector(resize(unsigned(i_Val16), o_Val32'length)) when (i_SelExt = '0') else
             std_logic_vector(resize(signed(i_Val16), o_Val32'length)) when (i_SelExt = '1') else
             x"00000000";

end custom;