-------------------------------------------------------------------------
-- Kevin Nguyen
-- Iowa State University
-------------------------------------------------------------------------
-- reg_MEM_WB.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Software scheduled pipeline for Project 2 Part 1
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity reg_MEM_WB is
  port (
    i_CLK       : in std_logic; -- Clock input
    i_RST       : in std_logic; -- Reset
    i_DMemAddr  : in std_logic_vector(31 downto 0);
    i_DMemOut   : in std_logic_vector(31 downto 0);
    i_RegWrAddr : in std_logic_vector(4 downto 0);
    i_MemToReg  : in std_logic;
    i_PCp4      : in std_logic_vector(31 downto 0);
    i_JumpAL    : in std_logic;
    i_RegWr     : in std_logic;
    i_Halt      : in std_logic;

    o_DMemAddr  : out std_logic_vector(31 downto 0);
    o_DMemOut   : out std_logic_vector(31 downto 0);
    o_RegWrAddr : out std_logic_vector(4 downto 0);
    o_MemToReg  : out std_logic;
    o_PCp4      : out std_logic_vector(31 downto 0);
    o_JumpAL    : out std_logic;
    o_RegWr     : out std_logic;
    o_Halt      : out std_logic
  );
end reg_MEM_WB;

architecture custom of reg_MEM_WB is

begin

  process (i_CLK, i_RST)
  begin 
    if (rising_edge(i_CLK)) then
      if (i_RST = '1') then
        -- All outputs 0
        o_DMemAddr  <= x"00000000";
        o_DMemOut   <= x"00000000";
        o_RegWrAddr <= "00000";
        o_MemToReg  <= '0';
        o_PCp4      <= x"00000000";
        o_JumpAL    <= '0';
        o_RegWr     <= '0';
        o_Halt      <= '0';
      else
        -- All outputs assigned to current input
        o_DMemAddr  <= i_DMemAddr;
        o_DMemOut   <= i_DMemOut;
        o_RegWrAddr <= i_RegWrAddr;
        o_MemToReg  <= i_MemToReg;
        o_PCp4      <= i_PCp4;
        o_JumpAL    <= i_JumpAL;
        o_RegWr     <= i_RegWr;
        o_Halt      <= i_Halt;
      end if;
    end if;
  end process;

end custom;
