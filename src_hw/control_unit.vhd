-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the control unit
-- for the MIPS processor.
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
  port(
    i_Opcode      : in std_logic_vector(5 downto 0);
    i_Function    : in std_logic_vector(5 downto 0);
    i_Reset       : in std_logic;
    o_ALUSrc      : out std_logic;
    o_MemToReg    : out std_logic;
    o_DMemWr      : out std_logic;
    o_RegWr       : out std_logic;
    o_SelExt      : out std_logic;
    o_Branch      : out std_logic;
    o_Jump        : out std_logic;
    o_JumpAL      : out std_logic;
    o_JumpR       : out std_logic;
    o_Halt        : out std_logic;
    o_ALUControl  : out std_logic_vector(4 downto 0);
    o_RegDst      : out std_logic_vector(1 downto 0)
  );
end control_unit;

architecture custom of control_unit is

begin
  CONTROL: process(i_Opcode, i_Function, i_Reset)
  begin
    if(i_Reset = '1') then
      o_ALUSrc 				<= '0';
      o_ALUControl 		<= "00000";
      o_MemToReg			<= '0';
      o_DMemWr				<= '0';
      o_RegWr					<= '0';
      o_RegDst				<= "00";
      o_SelExt				<= '0';
      o_Branch				<= '0';
      o_Jump					<= '0';
      o_JumpAL				<= '0';
      o_JumpR					<= '0';
      o_Halt					<= '0';
      -- Set everything to 0 on reset. (and operation without any writes)
    elsif (i_Opcode = "000000") then
      -- Opcode IS 0, must be R-format, control based on function.
      case(i_Function) is
        -- add
        when "100000" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "10010";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- addu
        when "100001" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00010";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- and
        when "100100" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00000";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- nor
        when "100111" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "01000";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- xor
        when "100110" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00101";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- or
        when "100101" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00001";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- slt
        when "101010" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "11011";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- sltu
        when "101011" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "01011";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- NOTE: sll, srl, sra are all same. Shifter and ALU wil have to determine shifts
        -- sll
        when "000000" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00100";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- srl
        when "000010" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00100";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- sra
        when "000011" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "10100";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- sub
        when "100010" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "11010";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- subu
        when "100011" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "01010";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "01";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- jr
        when "001000" =>
          o_ALUSrc 				<= '-';
          o_ALUControl 		<= "-----";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '0';
          o_RegDst				<= "--";
          o_SelExt				<= '-';
          o_Branch				<= '-';
          o_Jump					<= '-';
          o_JumpAL				<= '-';
          o_JumpR					<= '1';
          o_Halt					<= '0';

        -- no matches
        when others =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00000";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '0';
          o_RegDst				<= "00";
          o_SelExt				<= '0';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';
          -- Same as reset, but set HALT bit to 1
      end case;
    else
      -- Opcode IS NOT 0, control based on opcode.
      case(i_Opcode) is
        -- addi
        when "001000" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "10010";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '1';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- addiu (no overflow)
        when "001001" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00010";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '1';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- andi
        when "001100" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00000";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '0';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- lui
        when "001111" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00100";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '0';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- lw
        when "100011" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00010";
          o_MemToReg			<= '1';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '1';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- xori
        when "001110" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00101";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '0';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- ori
        when "001101" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00001";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '0';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- slti
        when "001010" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "11011";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '1';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- sltiu
        when "001011" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "01011";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '1';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- sw
        when "101011" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00010";
          o_MemToReg			<= '0';
          o_DMemWr				<= '1';
          o_RegWr					<= '0';
          o_RegDst				<= "--";
          o_SelExt				<= '1';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- beq
        when "000100" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00101";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '0';
          o_RegDst				<= "--";
          o_SelExt				<= '1';
          o_Branch				<= '1';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- bne
        when "000101" =>
          o_ALUSrc 				<= '0';
          o_ALUControl 		<= "00111";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '0';
          o_RegDst				<= "--";
          o_SelExt				<= '1';
          o_Branch				<= '1';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- j
        when "000010" =>
          o_ALUSrc 				<= '-';
          o_ALUControl 		<= "-----";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '0';
          o_RegDst				<= "--";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '1';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- jal
        when "000011" =>
          o_ALUSrc 				<= '-';
          o_ALUControl 		<= "-----";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "10";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '1';
          o_JumpAL				<= '1';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- repl.qb (uses I-format instruction)
        when "011111" =>
          o_ALUSrc 				<= '1';
          o_ALUControl 		<= "00110";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '1';
          o_RegDst				<= "00";
          o_SelExt				<= '1';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '0';

        -- HALT
        when "010100" =>
          o_ALUSrc 				<= '-';
          o_ALUControl 		<= "-----";
          o_MemToReg			<= '0';
          o_DMemWr				<= '0';
          o_RegWr					<= '0';
          o_RegDst				<= "--";
          o_SelExt				<= '-';
          o_Branch				<= '0';
          o_Jump					<= '0';
          o_JumpAL				<= '0';
          o_JumpR					<= '0';
          o_Halt					<= '1';

        -- no matches
        when others =>
          o_ALUSrc        <= '0';
          o_ALUControl    <= "00000";
          o_MemToReg      <= '0';
          o_DMemWr        <= '0';
          o_RegWr         <= '0';
          o_RegDst        <= "00";
          o_SelExt        <= '0';
          o_Branch        <= '0';
          o_Jump          <= '0';
          o_JumpAL        <= '0';
          o_JumpR         <= '0';
          o_Halt          <= '0';
          -- Same as reset, but set HALT bit to 1
      end case;
    end if;
  end process;

end custom;
