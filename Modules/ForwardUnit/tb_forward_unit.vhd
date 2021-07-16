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

entity tb_forward_unit is
  generic(gCLK_HPER : time := 50 ns);
end tb_forward_unit;

architecture mixed of tb_forward_unit is

  -- Define the total clock period time
  constant cCLK_PER : time := gCLK_HPER * 2;

  -- Change component declaration as needed. (Type must match signals.)
  component forward_unit is
    port(
      i_RegWr_M     : in std_logic;
      i_RegWr_W     : in std_logic;
      i_InstRs_E    : in std_logic_vector(4 downto 0);
      i_InstRt_E    : in std_logic_vector(4 downto 0);
      i_RegWrAddr_M : in std_logic_vector(4 downto 0);
      i_RegWrAddr_W : in std_logic_vector(4 downto 0);
      o_ForwardA    : out std_logic_vector(1 downto 0);
      o_ForwardB    : out std_logic_vector(1 downto 0)
    );
  end component;

  -- Create/modify signals for all I/O of the file that you are testing
  -- Input signals
  signal s_CLK          : std_logic;

  signal s_iRegWr_M     : std_logic;
  signal s_iRegWr_W     : std_logic;
  signal s_iInstRs_E    : std_logic_vector(4 downto 0);
  signal s_iInstRt_E    : std_logic_vector(4 downto 0);
  signal s_iRegWrAddr_M : std_logic_vector(4 downto 0);
  signal s_iRegWrAddr_W : std_logic_vector(4 downto 0);

  -- Output signals
  signal s_oForwardA    : std_logic_vector(1 downto 0);
  signal s_oForwardB    : std_logic_vector(1 downto 0);


begin
  -- Instantiate the component to test and wire all signals to the corresponding I/O
  -- NOTE: map component to signals
  DUT0: forward_unit
  port map(
    i_RegWr_M     => s_iRegWr_M,
    i_RegWr_W     => s_iRegWr_W,
    i_InstRs_E    => s_iInstRs_E,
    i_InstRt_E    => s_iInstRt_E,
    i_RegWrAddr_M => s_iRegWrAddr_M,
    i_RegWrAddr_W => s_iRegWrAddr_W,
    o_ForwardA    => s_oForwardA,
    o_ForwardB    => s_oForwardB
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
    s_iRegWr_M     <= '0';
    s_iRegWr_W     <= '0';
    s_iInstRs_E    <= "00000";
    s_iInstRt_E    <= "00000";
    s_iRegWrAddr_M <= "00000";
    s_iRegWrAddr_W <= "00000";
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "00000";
    s_iInstRt_E    <= "00000";
    s_iRegWrAddr_M <= "00000";
    s_iRegWrAddr_W <= "00000";
    -- ForwardA = 00, ForwardB = 00
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "00001";
    s_iInstRt_E    <= "00000";
    s_iRegWrAddr_M <= "00001";
    s_iRegWrAddr_W <= "00000";
    -- ForwardA = 01, ForwardB = 00
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "00001";
    s_iInstRt_E    <= "00000";
    s_iRegWrAddr_M <= "00001";
    s_iRegWrAddr_W <= "00001";
    -- ForwardA = 01, ForwardB = 00
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "00001";
    s_iInstRt_E    <= "00011";
    s_iRegWrAddr_M <= "00001";
    s_iRegWrAddr_W <= "00001";
    -- ForwardA = 01, ForwardB = 00
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "00001";
    s_iInstRt_E    <= "00011";
    s_iRegWrAddr_M <= "00011";
    s_iRegWrAddr_W <= "00001";
    -- ForwardA = 10, ForwardB = 01
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "00011";
    s_iInstRt_E    <= "00011";
    s_iRegWrAddr_M <= "00011";
    s_iRegWrAddr_W <= "00011";
    -- ForwardA = 01, ForwardB = 01
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "00111";
    s_iInstRt_E    <= "00011";
    s_iRegWrAddr_M <= "00111";
    s_iRegWrAddr_W <= "00011";
    -- ForwardA = 01, ForwardB = 10
    wait for cCLK_PER;

    s_iRegWr_M     <= '1';
    s_iRegWr_W     <= '1';
    s_iInstRs_E    <= "10001";
    s_iInstRt_E    <= "10001";
    s_iRegWrAddr_M <= "11111";
    s_iRegWrAddr_W <= "10001";
    -- ForwardA = 10, ForwardB = 10
    wait for cCLK_PER;

    wait for cCLK_PER;

  end process;

end mixed;

