-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a test bench for the control unit
-- of the MIPS processor
--
-- NOTES:
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control_unit is
	generic(gCLK_HPER : time := 50 ns);
end tb_control_unit;

architecture mixed of tb_control_unit is

	-- Define the total clock period time
	constant cCLK_PER : time := gCLK_HPER * 2;

	-- Change component declaration as needed. (Type must match signals.)
	component control_unit is
		port(
			i_Opcode			: in std_logic_vector(5 downto 0);
			i_Function		: in std_logic_vector(5 downto 0);
			i_Reset				: in std_logic;
			o_ALUSrc			: out std_logic;
			o_MemToReg		: out std_logic;
			o_DMemWr			: out std_logic;
			o_RegWr				: out std_logic;
			o_SelExt			: out std_logic;
			o_Branch			: out std_logic;
			o_Jump				: out std_logic;
			o_JumpAL			: out std_logic;
			o_JumpR				: out std_logic;
			o_Halt				: out std_logic;
			o_ALUControl	: out std_logic_vector(4 downto 0);
			o_RegDst			: out std_logic_vector(1 downto 0)
		);
	end component;

	-- Create/modify signals for all I/O of the file that you are testing
	-- Input signals
	signal s_CLK				  : std_logic;
	signal s_iOpcode     	: std_logic_vector(5 downto 0);
	signal s_iFunction   	: std_logic_vector(5 downto 0);
	signal s_iReset      	: std_logic;

	-- Output signals
	signal s_oALUSrc     	: std_logic;
	signal s_oMemToReg   	: std_logic;
	signal s_oDMemWr     	: std_logic;
	signal s_oRegWr      	: std_logic;
	signal s_oSelExt     	: std_logic;
	signal s_oBranch     	: std_logic;
	signal s_oJump      	: std_logic;
	signal s_oJumpAL     	: std_logic;
	signal s_oJumpR      	: std_logic;
	signal s_oHalt      	: std_logic;
	signal s_oALUControl  : std_logic_vector(4 downto 0);
	signal s_oRegDst      : std_logic_vector(1 downto 0);


begin
	-- Instantiate the component to test and wire all signals to the corresponding I/O
	-- NOTE: map component to signals
	CNTRL_T0: control_unit
	port map(
		i_Opcode		  => s_iOpcode,
		i_Function	  => s_iFunction,
		i_Reset			  => s_iReset,
		o_ALUSrc		  => s_oALUSrc,
		o_MemToReg	  => s_oMemToReg,
		o_DMemWr		  => s_oDMemWr,
		o_RegWr			  => s_oRegWr,
		o_SelExt		  => s_oSelExt,
		o_Branch		  => s_oBranch,
		o_Jump			  => s_oJump,
		o_JumpAL		  => s_oJumpAl,
		o_JumpR			  => s_oJumpR,
		o_Halt			  => s_oHalt,
		o_ALUControl  => s_oALUControl,
		o_RegDst      => s_oRegDst
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
		s_iReset		  <= '1';
		s_iOpcode     <= "000000";
		s_iFunction   <= "000000";
		wait for cCLK_PER;
		s_iReset      <= '0';
		s_iFunction   <= "------";

		-- --------------------------------
		-- Test Opcodes:
		-- --------------------------------
		-- addi
		s_iOpcode     <= "001000";
		wait for cCLK_PER;

		-- addiu
		s_iOpcode     <= "001001";
		wait for cCLK_PER;

		-- andi
		s_iOpcode     <= "001100";
		wait for cCLK_PER;

		-- lui
		s_iOpcode     <= "001111";
		wait for cCLK_PER;

		-- lw
		s_iOpcode     <= "100011";
		wait for cCLK_PER;

		-- xori
		s_iOpcode     <= "001110";
		wait for cCLK_PER;

		-- ori
		s_iOpcode     <= "001101";
		wait for cCLK_PER;

		-- slti
		s_iOpcode     <= "001010";
		wait for cCLK_PER;

		-- sltiu
		s_iOpcode     <= "001011";
		wait for cCLK_PER;

		-- sw
		s_iOpcode     <= "101011";
		wait for cCLK_PER;

		-- beq
		s_iOpcode     <= "000100";
		wait for cCLK_PER;

		-- bne
		s_iOpcode     <= "000101";
		wait for cCLK_PER;

		-- j
		s_iOpcode     <= "000010";
		wait for cCLK_PER;

		-- jal
		s_iOpcode     <= "000011";
		wait for cCLK_PER;

		-- repl.qb
		s_iOpcode     <= "011111";
		wait for cCLK_PER;

		-- HALT
		s_iOpcode     <= "010100";
		wait for cCLK_PER;


		-- --------------------------------
		-- Test functions:
		-- --------------------------------
		s_iReset		  <= '1';
		wait for cCLK_PER;
		s_iReset      <= '0';
		s_iOpcode   <= "000000";

		-- add
		s_iFunction   <= "100000";
		wait for cCLK_PER;

		-- addu
		s_iFunction   <= "100001";
		wait for cCLK_PER;

		-- and
		s_iFunction   <= "100100";
		wait for cCLK_PER;

		-- nor
		s_iFunction   <= "100111";
		wait for cCLK_PER;

		-- xor
		s_iFunction   <= "100110";
		wait for cCLK_PER;

		-- or
		s_iFunction   <= "100101";
		wait for cCLK_PER;

		-- slt
		s_iFunction   <= "101010";
		wait for cCLK_PER;

		-- slt
		s_iFunction   <= "101011";
		wait for cCLK_PER;

		-- sll
		s_iFunction   <= "000000";
		wait for cCLK_PER;

		-- srl
		s_iFunction   <= "000010";
		wait for cCLK_PER;

		-- sra
		s_iFunction   <= "000011";
		wait for cCLK_PER;

		-- sub
		s_iFunction   <= "100010";
		wait for cCLK_PER;

		-- subu
		s_iFunction   <= "100011";
		wait for cCLK_PER;

		-- jr
		s_iFunction   <= "001000";
		wait for cCLK_PER;


		-- --------------------------------
		-- Test opcode/function condition
		-- --------------------------------
		s_iOpcode   <= "001000";
		wait for cCLK_PER;
		-- should perform addi

		s_iFunction   <= "000000";
		s_iOpcode   <= "000011";
		wait for cCLK_PER;
		-- should perform jal

		s_iFunction   <= "100000";
		s_iOpcode   <= "000000";
		wait for cCLK_PER;
		-- should perform add


		wait for cCLK_PER;

	end process;

end mixed;
