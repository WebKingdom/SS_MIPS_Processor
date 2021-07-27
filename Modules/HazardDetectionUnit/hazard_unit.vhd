-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the hazard 
-- detection unit.
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity hazard_unit is
  port(
    i_MemRead_E   : in std_logic;
    i_Branch      : in std_logic;
    i_Jump        : in std_logic;
    i_JumpR       : in std_logic;
    i_InstRs_D    : in std_logic_vector(4 downto 0);
    i_InstRt_D    : in std_logic_vector(4 downto 0);
    i_InstRt_E    : in std_logic_vector(4 downto 0);
    i_RegWrAddr_E : in std_logic_vector(4 downto 0);
    i_RegWrAddr_M : in std_logic_vector(4 downto 0);
    o_PCWrite     : out std_logic;
    o_FlushId     : out std_logic;
    o_FlushEx     : out std_logic
  );
end hazard_unit;

architecture custom of hazard_unit is

  signal s_StallBranchJr  : std_logic;
  signal s_LoadUse        : std_logic;

begin

  -- Determines when to stall pipeline for branch or jump register (prevent PC update, do not flush ID, flush EX)
  s_StallBranchJr <= '1' when (((i_InstRs_D = i_RegWrAddr_E or i_InstRt_D = i_RegWrAddr_E) and (i_RegWrAddr_E /= "00000")) or
                              ((i_InstRs_D = i_RegWrAddr_M or i_InstRt_D = i_RegWrAddr_M) and (i_RegWrAddr_M /= "00000"))) else
                     '0';

  -- Determines when there is a load use data hazard (prevent PC update, do not flush ID, flush EX)
  s_LoadUse <= '1' when ((i_MemRead_E = '1') and ((i_InstRt_E = i_InstRs_D) or (i_InstRt_E = i_InstRt_D))) else
               '0';

  -- 2nd OR condition is to ensure the register(s) get written prior to accessing them for branching/jumping to register
  o_PCWrite <= '0' when ((s_LoadUse = '1') or ((i_Branch = '1' or i_JumpR = '1') and (s_StallBranchJr = '1'))) else '1';

  -- Sets IF/ID register to 0
  o_FlushId <= '1' when (i_Jump = '1' or ((i_Branch = '1' or i_JumpR = '1') and (s_StallBranchJr /= '1'))) else '0';

  -- Sets ID/EX register to 0
  o_FlushEx <= '1' when ((s_LoadUse = '1') or ((i_Branch = '1' or i_JumpR = '1') and (s_StallBranchJr = '1'))) else '0';

end custom;
