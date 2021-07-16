-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench for the ID/EX pipeline
-- register.
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg_ID_EX is
  generic(gCLK_HPER : time := 50 ns);
end tb_reg_ID_EX;

architecture mixed of tb_reg_ID_EX is

  -- Define the total clock period time
  constant cCLK_PER : time := gCLK_HPER * 2;

  -- Change component declaration as needed. (Type must match signals.)
  component reg_ID_EX is
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
    o_Shamt     : in std_logic_vector(4 downto 0);
    o_LRCtl     : in std_logic
  );
  end component;

  -- Create/modify signals for all I/O of the file that you are testing
  -- Input signals
  signal s_CLK        : std_logic;
  signal s_iRST       : std_logic;

  signal s_iRegRd0    : std_logic_vector(31 downto 0);
  signal s_iRegRd1    : std_logic_vector(31 downto 0);
  signal s_iImmExt    : std_logic_vector(31 downto 0);
  signal s_iInstRt    : std_logic_vector(4 downto 0);
  signal s_iInstRd    : std_logic_vector(4 downto 0);
  signal s_iALUSrc    : std_logic;
  signal s_iRegDst    : std_logic_vector(1 downto 0);
  signal s_iALUCtrl   : std_logic_vector(4 downto 0);
  signal s_iDMemWr    : std_logic;
  signal s_iMemToReg  : std_logic;
  signal s_iPCp4      : std_logic_vector(31 downto 0);
  signal s_iJumpAL    : std_logic;
  signal s_iRegWr     : std_logic;
  signal s_iHalt      : std_logic;
  signal s_iShamt     : std_logic_vector(4 downto 0);
  signal s_iLRCtl     : std_logic;

  -- Output signals
  signal s_oRegRd0    : std_logic_vector(31 downto 0);
  signal s_oRegRd1    : std_logic_vector(31 downto 0);
  signal s_oImmExt    : std_logic_vector(31 downto 0);
  signal s_oInstRt    : std_logic_vector(4 downto 0);
  signal s_oInstRd    : std_logic_vector(4 downto 0);
  signal s_oALUSrc    : std_logic;
  signal s_oRegDst    : std_logic_vector(1 downto 0);
  signal s_oALUCtrl   : std_logic_vector(4 downto 0);
  signal s_oDMemWr    : std_logic;
  signal s_oMemToReg  : std_logic;
  signal s_oPCp4      : std_logic_vector(31 downto 0);
  signal s_oJumpAL    : std_logic;
  signal s_oRegWr     : std_logic;
  signal s_oHalt      : std_logic;
  signal s_oShamt     : std_logic_vector(4 downto 0);
  signal s_oLRCtl     : std_logic;


begin
  -- Instantiate the component to test and wire all signals to the corresponding I/O
  -- NOTE: map component to signals
  DUT0: reg_ID_EX
  port map(
    i_CLK       => s_CLK,
    i_RST       => s_iRST,

    i_RegRd0    => s_iRegRd0,
    i_RegRd1    => s_iRegRd1,
    i_ImmExt    => s_iImmExt,
    i_InstRt    => s_iInstRt,
    i_InstRd    => s_iInstRd,
    i_ALUSrc    => s_iALUSrc,
    i_RegDst    => s_iRegDst,
    i_ALUCtrl   => s_iALUCtrl,
    i_DMemWr    => s_iDMemWr,
    i_MemToReg  => s_iMemToReg,
    i_PCp4      => s_iPCp4,
    i_JumpAL    => s_iJumpAL,
    i_RegWr     => s_iRegWr,
    i_Halt      => s_iHalt,
    i_Shamt     => s_iShamt,
    i_LRCtl     => s_iLRCtl,

    o_RegRd0    => s_oRegRd0,
    o_RegRd1    => s_oRegRd1,
    o_ImmExt    => s_oImmExt,
    o_InstRt    => s_oInstRt,
    o_InstRd    => s_oInstRd,
    o_ALUSrc    => s_oALUSrc,
    o_RegDst    => s_oRegDst,
    o_ALUCtrl   => s_oALUCtrl,
    o_DMemWr    => s_oDMemWr,
    o_MemToReg  => s_oMemToReg,
    o_PCp4      => s_oPCp4,
    o_JumpAL    => s_oJumpAL,
    o_RegWr     => s_oRegWr,
    o_Halt      => s_oHalt,
    o_Shamt     => s_oShamt,
    o_LRCtl     => s_oLRCtl
  );

  -- This process sets the clock value (low for gCLK_HPER, then high for gCLK_HPER).
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  -- Test cases
  p_TB: process
  begin
    -- Initialize/reset inputs
    s_iRST      <= '1';
    s_iRegRd0   <= x"00000000";
    s_iRegRd1   <= x"00000000";
    s_iImmExt   <= x"00000000";
    s_iInstRt   <= "00000";
    s_iInstRd   <= "00000";
    s_iALUSrc   <= '0';
    s_iRegDst   <= "00";
    s_iALUCtrl  <= "00000";
    s_iDMemWr   <= '0';
    s_iMemToReg <= '0';
    s_iPCp4     <= x"00000000";
    s_iJumpAL   <= '0';
    s_iRegWr    <= '0';
    s_iHalt     <= '0';
    s_iShamt    <= "00000";
    s_iLRCtl    <= '0';
    wait for cCLK_PER;

    -- Output should not change when reset == 1
    s_iRegRd0   <= x"AAAAAAAA";
    s_iRegRd1   <= x"AAAAAAAA";
    s_iImmExt   <= x"AAAAAAAA";
    s_iInstRt   <= "11111";
    s_iInstRd   <= "11111";
    s_iALUSrc   <= '1';
    s_iRegDst   <= "11";
    s_iALUCtrl  <= "11111";
    s_iDMemWr   <= '1';
    s_iMemToReg <= '1';
    s_iPCp4     <= x"AAAAAAAA";
    s_iJumpAL   <= '1';
    s_iRegWr    <= '1';
    s_iHalt     <= '1';
    s_iShamt    <= "11111";
    s_iLRCtl    <= '1';
    wait for 30 ns;


    s_iRegRd0   <= x"55555555";
    s_iRegRd1   <= x"55555555";
    s_iImmExt   <= x"55555555";
    s_iInstRt   <= "01010";
    s_iInstRd   <= "01010";
    s_iALUSrc   <= '0';
    s_iRegDst   <= "01";
    s_iALUCtrl  <= "01010";
    s_iDMemWr   <= '0';
    s_iMemToReg <= '0';
    s_iPCp4     <= x"55555555";
    s_iJumpAL   <= '0';
    s_iRegWr    <= '0';
    s_iHalt     <= '0';
    s_iShamt    <= "01010";
    s_iLRCtl    <= '0';
    wait for 50 ns;

    -- Output should equal input on rising clock edge
    s_iRST      <= '0';
    wait for 50 ns;

    s_iRegRd0   <= x"AAAAAAAA";
    s_iRegRd1   <= x"AAAAAAAA";
    s_iImmExt   <= x"AAAAAAAA";
    s_iInstRt   <= "11111";
    s_iInstRd   <= "11111";
    s_iALUSrc   <= '1';
    s_iRegDst   <= "11";
    s_iALUCtrl  <= "11111";
    s_iDMemWr   <= '1';
    s_iMemToReg <= '1';
    s_iPCp4     <= x"AAAAAAAA";
    s_iJumpAL   <= '1';
    s_iRegWr    <= '1';
    s_iHalt     <= '1';
    s_iShamt    <= "11111";
    s_iLRCtl    <= '1';
    wait for 50 ns;

    -- Asynchronoous reset
    s_iRST      <= '1';
    wait for 10 ns;
    s_iRST      <= '0';

    -- output should equal below on rising edge
    s_iRegRd0   <= x"FFFFFFFF";
    s_iRegRd1   <= x"FFFFFFFF";
    s_iImmExt   <= x"FFFFFFFF";
    s_iInstRt   <= "10001";
    s_iInstRd   <= "10001";
    s_iALUSrc   <= '0';
    s_iRegDst   <= "10";
    s_iALUCtrl  <= "10001";
    s_iDMemWr   <= '0';
    s_iMemToReg <= '0';
    s_iPCp4     <= x"FFFFFFFF";
    s_iJumpAL   <= '0';
    s_iRegWr    <= '0';
    s_iHalt     <= '0';
    s_iShamt    <= "10001";
    s_iLRCtl    <= '0';
    wait for 80 ns;

    s_iRegRd0   <= x"55555555";
    s_iRegRd1   <= x"55555555";
    s_iImmExt   <= x"55555555";
    s_iInstRt   <= "01010";
    s_iInstRd   <= "01010";
    s_iALUSrc   <= '0';
    s_iRegDst   <= "01";
    s_iALUCtrl  <= "01010";
    s_iDMemWr   <= '0';
    s_iMemToReg <= '0';
    s_iPCp4     <= x"55555555";
    s_iJumpAL   <= '0';
    s_iRegWr    <= '0';
    s_iHalt     <= '0';
    s_iShamt    <= "01010";
    s_iLRCtl    <= '0';
    wait for 50 ns;

    wait for cCLK_PER;

  end process;

end mixed;
