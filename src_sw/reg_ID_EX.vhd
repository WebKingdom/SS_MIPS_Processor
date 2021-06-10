-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the ID/EX 
-- pipeline register.
--
-- NOTES:
--
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;

entity reg_ID_EX is
  port(
    i_CLK       : in std_logic;
    i_RST       : in std_logic;
    i_RegRd0    : in std_logic_vector(31 downto 0);
    i_RegRd1    : in std_logic_vector(31 downto 0);
    i_ImmExt    : in std_logic_vector(31 downto 0);
    i_InstRt    : in std_logic_vector(4 downto 0);
    i_InstRd    : in std_logic_vector(4 downto 0);
    i_ALUSrc    : in std_logic;
    i_RegDst    : in std_logic_vector(1 downto 0);
    i_ALUCtrl   : in std_logic_vector(4 downto 0);
    i_DMemWr    : in std_logic;
    i_MemToReg  : in std_logic;
    i_PCp4      : in std_logic_vector(31 downto 0);
    i_JumpAL    : in std_logic;
    i_RegWr     : in std_logic;
    i_Halt      : in std_logic;
    i_Shamt     : in std_logic_vector(4 downto 0);
    i_LRCtl     : in std_logic;

    o_RegRd0    : out std_logic_vector(31 downto 0);
    o_RegRd1    : out std_logic_vector(31 downto 0);
    o_ImmExt    : out std_logic_vector(31 downto 0);
    o_InstRt    : out std_logic_vector(4 downto 0);
    o_InstRd    : out std_logic_vector(4 downto 0);
    o_ALUSrc    : out std_logic;
    o_RegDst    : out std_logic_vector(1 downto 0);
    o_ALUCtrl   : out std_logic_vector(4 downto 0);
    o_DMemWr    : out std_logic;
    o_MemToReg  : out std_logic;
    o_PCp4      : out std_logic_vector(31 downto 0);
    o_JumpAL    : out std_logic;
    o_RegWr     : out std_logic;
    o_Halt      : out std_logic;
    o_Shamt     : out std_logic_vector(4 downto 0);
    o_LRCtl     : out std_logic
  );
end reg_ID_EX;

architecture custom of reg_ID_EX is

begin

  process (i_CLK, i_RST)
  begin 
    if (i_RST = '1') then
      -- All outputs 0
      o_RegRd0    <= x"00000000";
      o_RegRd1    <= x"00000000";
      o_ImmExt    <= x"00000000";
      o_InstRt    <= "00000";
      o_InstRd    <= "00000";
      o_ALUSrc    <= '0';
      o_RegDst    <= "00";
      o_ALUCtrl   <= "00000";
      o_DMemWr    <= '0';
      o_MemToReg  <= '0';
      o_PCp4      <= x"00000000";
      o_JumpAL    <= '0';
      o_RegWr     <= '0';
      o_Halt      <= '0';
      o_Shamt     <= "00000";
      o_LRCtl     <= '0';
    elsif (rising_edge(i_CLK)) then
      -- All outputs assigned to current input
      o_RegRd0    <= i_RegRd0;
      o_RegRd1    <= i_RegRd1;
      o_ImmExt    <= i_ImmExt;
      o_InstRt    <= i_InstRt;
      o_InstRd    <= i_InstRd;
      o_ALUSrc    <= i_ALUSrc;
      o_RegDst    <= i_RegDst;
      o_ALUCtrl   <= i_ALUCtrl;
      o_DMemWr    <= i_DMemWr;
      o_MemToReg  <= i_MemToReg;
      o_PCp4      <= i_PCp4;
      o_JumpAL    <= i_JumpAL;
      o_RegWr     <= i_RegWr;
      o_Halt      <= i_Halt;
      o_Shamt     <= i_Shamt;
      o_LRCtl     <= i_LRCtl;
    end if;
  end process;

end custom;
