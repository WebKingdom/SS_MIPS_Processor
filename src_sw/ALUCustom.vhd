-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a custom ALU with
-- for the MIPS single cycle processor.
--
-- NOTES:
--
-------------------------------------------------------------------------

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- entity
entity ALUCustom is
  -- Generic of type integer for input/output data width.
  generic(N : integer := 32);
  port(
    i_A           : in std_logic_vector(N-1 downto 0);
    i_B           : in std_logic_vector(N-1 downto 0);
    i_ALUControl  : in std_logic_vector(4 downto 0);  -- bit 4 represents signed operation
    i_Shamt       : in std_logic_vector(4 downto 0);  -- Instr[10:6] or other
    i_LRCtl       : in std_logic; -- Instr[1] or other

    o_Result      : out std_logic_vector(N-1 downto 0);
    o_Cout        : out std_logic;
    o_Ovfl        : out std_logic
  );
end ALUCustom;

architecture mixed of ALUCustom is

  component barrel_shift is
    port(
      i_data  : in std_logic_vector(31 downto 0);
      i_sel   : in std_logic; -- 0 for left and 1 for right 
      i_logic : in std_logic; -- 0 for logic (unsigned) and 1 for arithmetic (signed)
      i_shift : in std_logic_vector(4 downto 0); --shift amount
      o_data  : out std_logic_vector(31 downto 0)
    );
  end component;

  signal s_AddSubResult : std_logic_vector(N downto 0);
  signal s_SLT, s_Shifted, s_REPLQB : std_logic_vector(N-1 downto 0);
  signal s_OvflAdd, s_OvflSub : std_logic;

begin

  -- Shifter performs operation on i_B
  g_shifter: barrel_shift port map(
    i_data  => i_B,
    i_sel   => i_LRCtl,
    i_logic => i_ALUControl(4),
    i_shift => i_Shamt,
    o_data  => s_Shifted
  );

  -- Compute add/sub
  s_AddSubResult <= (('0' & i_A) + ('0' & i_B)) when (i_ALUControl(3 downto 0) = "0010") else
                    (('0' & i_A) - ('0' & i_B));

  o_Cout <= s_AddSubResult(32);

  -- Set SLT when i_A < i_B
  s_SLT	<= x"00000001" when ((signed(i_A) < signed(i_B)) and (i_ALUControl(4) = '1')) else
           x"00000001" when ((unsigned(i_A) < unsigned(i_B)) and (i_ALUControl(4) = '0')) else
           x"00000000";

  -- Concatenate 4 bytes of sing extended byte immediate
  s_REPLQB <= i_B(7 downto 0) & i_B(7 downto 0) & i_B(7 downto 0) & i_B(7 downto 0);

  -- Select result based on ALU control
  o_Result <= (i_A and i_B) when (i_ALUControl = "00000") else
              (i_A or i_B)  when (i_ALUControl = "00001") else
              (s_AddSubResult(31 downto 0)) when (i_ALUControl(2 downto 0) = "010") else
              (s_SLT) 			when (i_ALUControl(3 downto 0) = "1011") else
              (i_A nor i_B) when (i_ALUControl = "01000") else
              (s_Shifted)  	when (i_ALUControl(3 downto 0) = "0100") else
              (i_A xor i_B) when (i_ALUControl = "00101") else
              (s_REPLQB) 		when (i_ALUControl = "00110") else
              x"00000000";

  -- Compute overflow for addition and subtraction
  s_OvflAdd <= '1' when ( ((i_A(31) = '0' and i_B(31) = '0' and s_AddSubResult(31) = '1') or
                           (i_A(31) = '1' and i_B(31) = '1' and s_AddSubResult(31) = '0')) and
                           (i_ALUControl = "10010")) else '0';

  s_OvflSub <= '1' when ( ((i_A(31) = '1' and i_B(31) = '0' and s_AddSubResult(31) = '0') or
                           (i_A(31) = '0' and i_B(31) = '1' and s_AddSubResult(31) = '1')) and
                           (i_ALUControl = "11010")) else '0';

  -- Set overflow on add, addi, or sub instruction
  o_Ovfl <= '1' when (s_OvflAdd = '1' or s_OvflSub = '1') else
            '0';

end mixed;
