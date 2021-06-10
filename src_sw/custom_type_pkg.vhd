-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a package of custom data types.
--
--
-- NOTES:
-- 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package custom_type_pkg is

  type data_array_32b32 is array(31 downto 0) of std_logic_vector(31 downto 0);

end package custom_type_pkg;
