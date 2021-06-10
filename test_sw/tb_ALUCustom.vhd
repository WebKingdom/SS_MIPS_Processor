-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench for the custom ALU for
-- the single cycle MIPS processor.
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ALUCustom is
  generic(gCLK_HPER : time := 50 ns);
end tb_ALUCustom;

architecture mixed of tb_ALUCustom is

  -- Define the total clock period time
  constant cCLK_PER : time := gCLK_HPER * 2;

  -- TODO: change component declaration as needed. TYPE MUST MATCH SIGNALS!
  component ALUCustom is
    generic(N : integer := 32);
    port(
      i_A           : in std_logic_vector(N-1 downto 0);
      i_B           : in std_logic_vector(N-1 downto 0);
      i_ALUControl  : in std_logic_vector(4 downto 0);
      i_Shamt       : in std_logic_vector(4 downto 0); -- Instr[10:6] or other
      i_LRCtl       : in std_logic; -- Instr[0] or other

      o_Result      : out std_logic_vector(N-1 downto 0);
      o_Cout        : out std_logic;
      o_Ovfl        : out std_logic
    );
  end component;

  -- TODO: Create/modify signals for all I/O of the file that you are testing
  -- Input signals
  signal s_CLK          : std_logic;

  signal s_iA           : std_logic_vector(31 downto 0);
  signal s_iB           : std_logic_vector(31 downto 0);
  signal s_iALUControl  : std_logic_vector(4 downto 0);
  signal s_iShamt       : std_logic_vector(4 downto 0);
  signal s_iLRCtl       : std_logic;

  -- Output signals
  signal s_oResult  : std_logic_vector(31 downto 0);
  signal s_oCout    : std_logic;
  signal s_oOvfl    : std_logic;


begin
  -- TODO: Instantiate the component to test and wire all signals to the corresponding I/O
  -- NOTE: map component to signals
  DUT0: ALUCustom
  port map(
    i_A           => s_iA,
    i_B           => s_iB,
    i_ALUControl  => s_iALUControl,
    i_Shamt       => s_iShamt,
    i_LRCtl       => s_iLRCtl,

    o_Result      => s_oResult,
    o_Cout        => s_oCout,
    o_Ovfl        => s_oOvfl
  );

  -- This process sets the clock value (low for gCLK_HPER, then high for gCLK_HPER).
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

  -- TODO: create/modify test cases
  p_TB: process
  begin
    -- Initialize inputs
    s_iA					<= x"00000000";
    s_iB					<= x"00000000";
    s_iShamt			<= "00000";
    s_iLRCtl      <= '0';
    s_iALUControl	<= "00000";
    wait for cCLK_PER;

    -- s_iA and s_iB
    s_iA					<= x"80000001";
    s_iB					<= x"00000000";
    s_iALUControl	<= "00000";
    wait for cCLK_PER;

    -- s_iA and s_iB
    s_iA					<= x"80000001";
    s_iB					<= x"7FFFFFFE";
    s_iALUControl	<= "00000";
    wait for cCLK_PER;

    -- s_iA and s_iB
    s_iA					<= x"80000001";
    s_iB					<= x"FFFFFFFF";
    s_iALUControl	<= "00000";
    wait for cCLK_PER;

    -- s_iA or s_iB
    s_iA					<= x"80000001";
    s_iB					<= x"FFFFFFFF";
    s_iALUControl	<= "00001";
    wait for cCLK_PER;

    -- s_iA or s_iB
    s_iA					<= x"80000001";
    s_iB					<= x"7FFFFFFE";
    s_iALUControl	<= "00001";
    wait for cCLK_PER;

    -- s_iA + s_iB (with overflow)
    s_iA					<= x"AAAAAAAA";
    s_iB					<= x"55555555";
    s_iALUControl	<= "10010";
    wait for cCLK_PER;

    -- s_iA + s_iImm (with overflow)
    s_iA					<= x"AAAAAAAA";
    s_iB					<= x"FFFFFFFF";
    s_iALUControl	<= "10010";
    wait for cCLK_PER;

    -- s_iA + s_iImm (with overflow)
    s_iA					<= x"0000000F";
    s_iB					<= x"7FFFFFF0";
    s_iALUControl	<= "10010";
    wait for cCLK_PER;

    -- s_iA + s_iB (with overflow)
    s_iA					<= x"0000000F";
    s_iB					<= x"00000001";
    s_iALUControl	<= "10010";
    -- result = 0x00000010
    wait for cCLK_PER;

    -- s_iA + s_iB (with overflow)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"7FFFFFFF";
    s_iALUControl	<= "10010";
    -- result = 0xFFFFFFFE and ovfl = 1
    wait for cCLK_PER;

    -- s_iA + s_iB (no overflow)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"7FFFFFFF";
    s_iALUControl	<= "00010";
    -- result = 0xFFFFFFFE and ovfl = 0
    wait for cCLK_PER;

    -- s_iA - s_iB (with overflow)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"80000000";
    s_iALUControl	<= "11010";
    -- result = 0xFFFFFFFF and ovfl = 1
    wait for cCLK_PER;

    -- s_iA - s_iB (no overflow)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"80000000";
    s_iALUControl	<= "01010";
    -- result = 0xFFFFFFFF and ovfl = 0
    wait for cCLK_PER;

    -- s_iA + s_iImm (with overflow)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"00000001";
    s_iALUControl	<= "10010";
    -- result = 0x8000000 and ovfl = 1
    wait for cCLK_PER;

    -- s_iA + s_iImm (no overflow)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"00000001";
    s_iALUControl	<= "00010";
    -- result = 0x8000000 and ovfl = 0
    wait for cCLK_PER;

    -- s_iA < s_iB (signed)
    s_iA					<= x"80000000";
    s_iB					<= x"7FFFFFFF";
    s_iALUControl	<= "11011";
    -- result = 0x00000001
    wait for cCLK_PER;

    -- s_iA < s_iB (signed)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"7FFFFFFF";
    s_iALUControl	<= "11011";
    -- result = 0x00000000
    wait for cCLK_PER;

    -- s_iA < s_iB (signed)
    s_iA					<= x"80000001";
    s_iB					<= x"80000002";
    s_iALUControl	<= "11011";
    -- result = 0x00000001
    wait for cCLK_PER;

    -- s_iA < s_iB (signed)
    s_iA					<= x"80000004";
    s_iB					<= x"80000002";
    s_iALUControl	<= "11011";
    -- result = 0x00000000
    wait for cCLK_PER;

    -- sll by 4
    s_iA					<= x"00000000";
    s_iB					<= x"7FFFFFFF";
    s_iShamt			<= "00100";
    s_iLRCtl		<= '0';
    s_iALUControl	<= "00100";
    -- result = 0xFFFFFFF0
    wait for cCLK_PER;

    -- sll by 31
    s_iA					<= x"00000000";
    s_iB					<= x"7FFFFFFF";
    s_iShamt			<= "11111";
    s_iLRCtl		<= '0';
    s_iALUControl	<= "00100";
    -- result = 0x80000000
    wait for cCLK_PER;

    -- sra by 30
    s_iA					<= x"00000000";
    s_iB					<= x"7FFFFFFF";
    s_iShamt			<= "11110";
    s_iLRCtl		<= '1';
    s_iALUControl	<= "10100";
    -- result = 0x00000001
    wait for cCLK_PER;

    -- sra by 30
    s_iA					<= x"00000000";
    s_iB					<= x"80000000";
    s_iShamt			<= "11110";
    s_iLRCtl		<= '1';
    s_iALUControl	<= "10100";
    -- result = 0xFFFFFFFE
    wait for cCLK_PER;

    -- srl by 30
    s_iA					<= x"00000000";
    s_iB					<= x"80000000";
    s_iShamt			<= "11110";
    s_iLRCtl		<= '1';
    s_iALUControl	<= "00100";
    -- result = 0x00000002
    wait for cCLK_PER;

    -- s_iA XOR s_iB (also test beq)
    s_iA					<= x"7FFFFFFF";
    s_iB					<= x"7FFFFFFF";
    s_iALUControl	<= "00101";
    -- result = 0x00000000
    wait for cCLK_PER;

    -- s_iA XOR s_iB (also test beq)
    s_iA					<= x"80000001";
    s_iB					<= x"80000001";
    s_iALUControl	<= "00101";
    -- result = 0x00000000
    wait for cCLK_PER;

    -- else case of o_Result (also test bne)
    s_iA					<= x"80000001";
    s_iB					<= x"80000001";
    s_iALUControl	<= "00111";
    -- result = 0x00000000 with zero = 0
    wait for cCLK_PER;

    -- else case of o_Result (also test bne)
    s_iA					<= x"8000000F";
    s_iB					<= x"80000001";
    s_iALUControl	<= "00111";
    -- result = 0x00000000 with zero = 1
    wait for cCLK_PER;


    wait for cCLK_PER;

  end process;

end mixed;
