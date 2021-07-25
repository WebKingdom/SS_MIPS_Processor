-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-- mux2t1_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a 
-- 2 to 1 mux
--
--
-- NOTES:
-- 
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity mux2t1_df is

  port(
    i_S   : in std_logic;
    i_D0  : in std_logic;
    i_D1  : in std_logic;
    o_O   : out std_logic);

end mux2t1_df;

-- Structural architecture of 2-1 mux
architecture dataflow of mux2t1_df is
begin
    o_O <= i_D0 when (i_S = '0') else
           i_D1 when (i_S = '1') else
           '0';

end dataflow;