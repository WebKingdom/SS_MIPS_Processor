-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench for the forwarding unit.
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_hazard_unit is
  generic(gCLK_HPER : time := 50 ns);
end tb_hazard_unit;

architecture mixed of tb_hazard_unit is

  -- Define the total clock period time
  constant cCLK_PER : time := gCLK_HPER * 2;

  -- Change component declaration as needed. (Type must match signals.)
  component hazard_unit is
    port(
      i_MemRead_E   : in std_logic;
      i_Branch      : in std_logic;
      i_Jump        : in std_logic;
      i_JumpR       : in std_logic;
      i_InstRs_D    : in std_logic_vector(4 downto 0);
      i_InstRt_D    : in std_logic_vector(4 downto 0);
      i_RegWrAddr_E : in std_logic_vector(4 downto 0);
      i_RegWrAddr_M : in std_logic_vector(4 downto 0);
      o_PCWrite     : out std_logic;
      o_FlushId     : out std_logic;
      o_FlushEx     : out std_logic
    );
  end component;

  -- Create/modify signals for all I/O of the file that you are testing
  -- Input signals
  signal s_CLK          : std_logic;

  signal s_iMemRead_E   : std_logic;
  signal s_iBranch      : std_logic;
  signal s_iJump        : std_logic;
  signal s_iJumpR       : std_logic;
  signal s_iInstRs_D    : std_logic_vector(4 downto 0);
  signal s_iInstRt_D    : std_logic_vector(4 downto 0);
  signal s_iRegWrAddr_E : std_logic_vector(4 downto 0);
  signal s_iRegWrAddr_M : std_logic_vector(4 downto 0);

  -- Output signals
  signal s_oPCWrite     : std_logic;
  signal s_oFlushId     : std_logic;
  signal s_oFlushEx     : std_logic;


begin
  -- Instantiate the component to test and wire all signals to the corresponding I/O
  -- NOTE: map component to signals
  DUT0: hazard_unit
  port map(
    i_MemRead_E   => s_iMemRead_E,
    i_Branch      => s_iBranch,
    i_Jump        => s_iJump,
    i_JumpR       => s_iJumpR,
    i_InstRs_D    => s_iInstRs_D,
    i_InstRt_D    => s_iInstRt_D,
    i_RegWrAddr_E => s_iRegWrAddr_E,
    i_RegWrAddr_M => s_iRegWrAddr_M,
    o_PCWrite     => s_oPCWrite,
    o_FlushId     => s_oFlushId,
    o_FlushEx     => s_oFlushEx
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
    -- Initialize inputs
    s_iMemRead_E   <= '0';
    s_iBranch      <= '0';
    s_iJump        <= '0';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00000";
    s_iInstRt_D    <= "00000";
    s_iRegWrAddr_E <= "00000";
    s_iRegWrAddr_M <= "00000";
    wait for cCLK_PER;

    s_iMemRead_E   <= '1';
    s_iBranch      <= '0';
    s_iJump        <= '0';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00000";
    s_iInstRt_D    <= "00000";
    s_iRegWrAddr_E <= "00000";
    s_iRegWrAddr_M <= "00000";
    -- o_PCWrite = 0, o_FlushId = 0, o_FlushEx = 1
    wait for cCLK_PER;


    s_iMemRead_E   <= '0';
    s_iBranch      <= '1';
    s_iJump        <= '0';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00000";
    s_iInstRt_D    <= "00000";
    s_iRegWrAddr_E <= "00000";
    s_iRegWrAddr_M <= "00000";
    -- o_PCWrite = 1, o_FlushId = 1, o_FlushEx = 0
    wait for cCLK_PER;

    s_iMemRead_E   <= '0';
    s_iBranch      <= '0';
    s_iJump        <= '1';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00000";
    s_iInstRt_D    <= "00000";
    s_iRegWrAddr_E <= "00000";
    s_iRegWrAddr_M <= "00000";
    -- o_PCWrite = 1, o_FlushId = 1, o_FlushEx = 0
    wait for cCLK_PER;

    s_iMemRead_E   <= '0';
    s_iBranch      <= '1';
    s_iJump        <= '0';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00001";
    s_iInstRt_D    <= "00010";
    s_iRegWrAddr_E <= "00000";
    s_iRegWrAddr_M <= "00000";
    -- o_PCWrite = 1, o_FlushId = 1, o_FlushEx = 0
    wait for cCLK_PER;

    s_iMemRead_E   <= '0';
    s_iBranch      <= '1';
    s_iJump        <= '0';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00001";
    s_iInstRt_D    <= "00010";
    s_iRegWrAddr_E <= "00100";
    s_iRegWrAddr_M <= "01000";
    -- o_PCWrite = 1, o_FlushId = 1, o_FlushEx = 0
    wait for cCLK_PER;

    s_iMemRead_E   <= '0';
    s_iBranch      <= '1';
    s_iJump        <= '0';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00001";
    s_iInstRt_D    <= "00010";
    s_iRegWrAddr_E <= "00010";
    s_iRegWrAddr_M <= "01000";
    -- o_PCWrite = 0, o_FlushId = 1, o_FlushEx = 0
    wait for cCLK_PER;

    s_iMemRead_E   <= '0';
    s_iBranch      <= '1';
    s_iJump        <= '0';
    s_iJumpR       <= '0';
    s_iInstRs_D    <= "00001";
    s_iInstRt_D    <= "00010";
    s_iRegWrAddr_E <= "00011";
    s_iRegWrAddr_M <= "00001";
    -- o_PCWrite = 0, o_FlushId = 1, o_FlushEx = 0
    wait for cCLK_PER;


    wait for cCLK_PER;

  end process;

end mixed;
