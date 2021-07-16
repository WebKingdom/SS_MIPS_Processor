-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a custom ALU with
-- for the MIPS processor.
--
-- NOTES:
--
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity
entity ALUCustom_old is
  -- Generic of type integer for input/output data width.
  generic(N : integer := 32);
  port(
    i_A 				 : in std_logic_vector(N-1 downto 0);
    i_B					 : in std_logic_vector(N-1 downto 0);
    i_Imm				 : in std_logic_vector(N-1 downto 0);
    i_Shifted		 : in std_logic_vector(N-1 downto 0);
    i_ALUSrc		 : in std_logic;
    i_ALUControl : in std_logic_vector(4 downto 0);	-- bit 4 represents signed operation

    o_Result		 : out std_logic_vector(N-1 downto 0);
    o_Zero 			 : out std_logic;
    o_Cout   	   : out std_logic;
    o_Ovfl   	   : out std_logic
  );
end ALUCustom_old;

architecture mixed of ALUCustom_old is

  component onesComp_N is
    generic(N : integer := 32);
    port(
      i_data	: in std_logic_vector(N-1 downto 0);
      o_data	: out std_logic_vector(N-1 downto 0)
    );
  end component;

  component mux2t1_N is
    generic(N : integer := 32);
    port(
      i_S		: in std_logic;
      i_D0	: in std_logic_vector(N-1 downto 0);
      i_D1	: in std_logic_vector(N-1 downto 0);
      o_O 	: out std_logic_vector(N-1 downto 0)
    );
  end component;

  component adderRipple_N is
    generic(N : integer := 32);
    port(
      i_A					: in std_logic_vector(N-1 downto 0);
      i_B					: in std_logic_vector(N-1 downto 0);
      i_C					: in std_logic;
      o_Sum				: out std_logic_vector(N-1 downto 0);
      o_Cout			: out std_logic;
      o_Overflow	: out std_logic
    );
  end component;

  signal s_oMuxSrc, s_oCompB, s_oMuxB : std_logic_vector(N-1 downto 0);
  signal s_SLT, s_REPLQB	: std_logic_vector(N-1 downto 0);
  signal s_AddOut	: std_logic_vector(N-1 downto 0);
  signal s_oOvfl	: std_logic;

begin

  -- select between immediate or i_B
  g_mux2t1_Src: mux2t1_N port map(
    i_S		=> i_ALUSrc,
    i_D0	=> i_B,
    i_D1	=> i_Imm,
    o_O		=> s_oMuxSrc
  );

  -- B invert
  g_onesCompB: onesComp_N port map(
    i_data	=> s_oMuxSrc,
    o_data 	=> s_oCompB
  );

  -- Select B or B inv
  g_mux2t1_B: mux2t1_N port map(
    i_S		=> i_ALUControl(3),
    i_D0	=> s_oMuxSrc,
    i_D1	=> s_oCompB,
    o_O		=> s_oMuxB
  );

  -- Add/sub A, B
  g_adderRipple: adderRipple_N port map(
    i_A					=> i_A,
    i_B					=> s_oMuxB,
    i_C					=> (i_ALUControl(1) and i_ALUControl(3)),
    o_Sum				=> s_AddOut,
    o_Cout			=> o_Cout,
    o_Overflow	=> s_oOvfl
  );

  -- Set SLT when i_A < s_oMuxSrc (i_B or i_Imm)
  s_SLT	<= x"00000001" when ((signed(i_A) < signed(s_oMuxSrc)) and (i_ALUControl(4) = '1')) else
           x"00000001" when ((unsigned(i_A) < unsigned(s_oMuxSrc)) and (i_ALUControl(4) = '0')) else
           x"00000000";

  -- Concatenate 4 bytes of sing extended byte immediate
  s_REPLQB <= s_oMuxSrc(7 downto 0) & s_oMuxSrc(7 downto 0) & s_oMuxSrc(7 downto 0) & s_oMuxSrc(7 downto 0);

  -- Select result based on ALU control
  o_Result <= (i_A and s_oMuxSrc) when (i_ALUControl = "00000") else
              (i_A or s_oMuxSrc)  when (i_ALUControl = "00001") else
              (s_AddOut) 			 	  when (i_ALUControl(2 downto 0) = "010") else
              (s_SLT) 					 	when (i_ALUControl(3 downto 0) = "1011") else
              (i_A nor s_oMuxSrc) when (i_ALUControl = "01000") else
              (i_Shifted)  			  when (i_ALUControl = "00100") else
              (i_A xor s_oMuxSrc) when (i_ALUControl = "00101") else
              (s_REPLQB) 				  when (i_ALUControl = "00110") else
              x"00000000";

  -- Set to 1 when inputs equal and beq
  -- Set to 1 when inputs not equal and bne
  -- Otherwise set to 0
  o_Zero <= '1' when ((i_A = s_oMuxSrc) and (i_ALUControl = "00101")) else
            '1' when ((i_A /= s_oMuxSrc) and (i_ALUControl = "00111")) else
            '0';

  -- Set overflow on add, addi, or sub instruction
  o_Ovfl <= '1' when ((i_ALUControl = "10010" or i_ALUControl = "11010") and (s_oOvfl = '1')) else
            '0';

end mixed;
