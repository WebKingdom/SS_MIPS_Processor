-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the forwarding 
-- unit for the MIPS processor.
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity forward_unit is
  port(
    i_JumpR       : in std_logic;
    i_RegWr_E     : in std_logic;
    i_RegWr_M     : in std_logic;
    i_RegWr_W     : in std_logic;
    i_InstRs_D    : in std_logic_vector(4 downto 0);
    i_InstRs_E    : in std_logic_vector(4 downto 0);
    i_InstRt_E    : in std_logic_vector(4 downto 0);
    i_RegWrAddr_E : in std_logic_vector(4 downto 0);
    i_RegWrAddr_M : in std_logic_vector(4 downto 0);
    i_RegWrAddr_W : in std_logic_vector(4 downto 0);
    o_ForwardA    : out std_logic_vector(1 downto 0);
    o_ForwardB    : out std_logic_vector(1 downto 0);
    o_ForwardALU  : out std_logic_vector(1 downto 0);
  );
end forward_unit;

architecture custom of forward_unit is

begin

  o_ForwardA <= "01" when (i_RegWrAddr_M /= "00000" and i_RegWr_M = '1' and i_RegWrAddr_M = i_InstRs_E) else
                "10" when (i_RegWrAddr_W /= "00000" and i_RegWr_W = '1' and i_RegWrAddr_W = i_InstRs_E) else
                "00";

  o_ForwardB <= "01" when (i_RegWrAddr_M /= "00000" and i_RegWr_M = '1' and i_RegWrAddr_M = i_InstRt_E) else
                "10" when (i_RegWrAddr_W /= "00000" and i_RegWr_W = '1' and i_RegWrAddr_W = i_InstRt_E) else
                "00";

  o_ForwardALU <= "01" when (i_RegWrAddr_E /= "00000" and i_RegWr_E = '1' and i_RegWrAddr_E = i_InstRs_D and i_JumpR = '1') else
                  "10" when (i_RegWrAddr_M /= "00000" and i_RegWr_M = '1' and i_RegWrAddr_M = i_InstRs_D and i_JumpR = '1') else
                  "00";

end custom;
