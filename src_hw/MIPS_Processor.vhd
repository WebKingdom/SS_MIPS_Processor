-------------------------------------------------------------------------
-- MIPS processor full implementation by Soma Szabo
-- Initial skeleton by Henry Duwe
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a MIPS 5 stage software scheduled
-- pipeline processor.
-- 
-- NOTES:
-- 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(
    iCLK            : in std_logic;
    iRST            : in std_logic;
    iInstLd         : in std_logic;
    iInstAddr       : in std_logic_vector(N-1 downto 0);
    iInstExt        : in std_logic_vector(N-1 downto 0);
    oALUOut         : out std_logic_vector(N-1 downto 0)
  ); -- Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;

architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr_D     : std_logic; -- active high data memory write enable signal, decode
  signal s_DMemWr_E     : std_logic; -- active high data memory write enable signal, execute
  signal s_DMemWr_M     : std_logic; -- the final active high data memory write enable signal, memory

  signal s_DMemAddr_E   : std_logic_vector(N-1 downto 0); -- data memory address input, execute
  signal s_DMemAddr_M   : std_logic_vector(N-1 downto 0); -- the final data memory address input, memory
  signal s_DMemAddr_W   : std_logic_vector(N-1 downto 0); -- data memory address input, write back

  signal s_DMemData_E   : std_logic_vector(N-1 downto 0); -- data memory data input, execute
  signal s_DMemData_M   : std_logic_vector(N-1 downto 0); -- the final data memory data input, memory

  signal s_DMemOut_M    : std_logic_vector(N-1 downto 0); -- data memory output, memory
  signal s_DMemOut_W    : std_logic_vector(N-1 downto 0); -- data memory output, write back

  -- Required register file signals
  signal s_RegWr_D      : std_logic; -- active high write enable input to the register file, decode
  signal s_RegWr_E      : std_logic; -- active high write enable input to the register file, execute
  signal s_RegWr_M      : std_logic; -- active high write enable input to the register file, memory
  signal s_RegWr_W      : std_logic; -- the final active high write enable input to the register file (write back)

  -- Select write address for reg file
  signal s_RegWrAddr_E  : std_logic_vector(4 downto 0);
  signal s_RegWrAddr_M  : std_logic_vector(4 downto 0);
  signal s_RegWrAddr_W  : std_logic_vector(4 downto 0); -- the final destination register address input

  signal s_RegWrData_W  : std_logic_vector(N-1 downto 0); -- the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- use this signal as your intended final instruction memory address input.
  signal s_Inst_F       : std_logic_vector(N-1 downto 0); -- Instruction signal, fetch
  signal s_Inst_D       : std_logic_vector(N-1 downto 0); -- Instruction signal, decode
  signal s_InstRs_E     : std_logic_vector(4 downto 0);   -- Instruction signal for rs, execute
  signal s_InstRt_E     : std_logic_vector(4 downto 0);   -- Instruction signal for rt, execute
  signal s_InstRd_E     : std_logic_vector(4 downto 0);   -- Instruction signal for rd, execute

  -- Required halt signal -- for simulation
  signal s_Halt_D       : std_logic;  -- this signal indicates to the simulation that intended program execution has completed
  signal s_Halt_E       : std_logic;  -- this signal indicates to the simulation that intended program execution has completed
  signal s_Halt_M       : std_logic;  -- this signal indicates to the simulation that intended program execution has completed
  signal s_Halt_W       : std_logic;  -- this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
      clk          : in std_logic;
      addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
      data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
      we           : in std_logic := '1';
      q            : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
  end component;

  -- Add any additional signals or components below this comment

  -- Select between immediate and register file output for ALU input i_B
  signal s_ALUSrc_D     : std_logic;
  signal s_ALUSrc_E     : std_logic;

  -- Select input for mux choosing ALUOut or DMemOut for reg write back
  signal s_MemToReg_D   : std_logic;
  signal s_MemToReg_E   : std_logic;
  signal s_MemToReg_M   : std_logic;
  signal s_MemToReg_W   : std_logic;

  -- Select between sing (1) or zero extended (0) immediate
  signal s_SelExt_D     : std_logic;

  -- Branch enable signal (AND-ed with zero from ALU))
  signal s_Branch_D     : std_logic;
  signal s_Zero_D       : std_logic;

  -- Jump signals
  signal s_Jump_D       : std_logic;
  signal s_JumpAL_D   : std_logic;
  signal s_JumpAL_E   : std_logic;
  signal s_JumpAL_M   : std_logic;
  signal s_JumpAL_W   : std_logic;
  signal s_JumpR_D    : std_logic;
  signal s_JumpRAddr  : std_logic_vector(N-1 downto 0);

  -- Control input for ALU module
  signal s_ALUControl_D : std_logic_vector(4 downto 0);
  signal s_ALUControl_E : std_logic_vector(4 downto 0);

  -- Select write address for reg file
  signal s_RegDst_D 		: std_logic_vector(1 downto 0);
  signal s_RegDst_E 		: std_logic_vector(1 downto 0);

  -- ALU inputs
  signal s_RegRdOut0_D  : std_logic_vector(N-1 downto 0);
  signal s_RegRdOut0_E  : std_logic_vector(N-1 downto 0);
  signal s_RegRdOut1_D  : std_logic_vector(N-1 downto 0);
  signal s_RegRdOut1_E  : std_logic_vector(N-1 downto 0);
  signal s_ALUiB        : std_logic_vector(N-1 downto 0);
  signal s_ALUiA        : std_logic_vector(N-1 downto 0);
  signal s_ImmExt_D     : std_logic_vector(N-1 downto 0);
  signal s_ImmExt_E     : std_logic_vector(N-1 downto 0);

  -- Shifter and ALU signals
  signal s_Shamt_D    : std_logic_vector(4 downto 0);
  signal s_Shamt_E    : std_logic_vector(4 downto 0);
  signal s_LRCtl_D    : std_logic;
  signal s_LRCtl_E    : std_logic;

  -- ALU carry out
  signal s_Cout       : std_logic;

  -- Forwarding Unit signals
  signal s_ForwardA   : std_logic_vector(1 downto 0);
  signal s_ForwardB   : std_logic_vector(1 downto 0);
  signal s_ForwardALU : std_logic_vector(1 downto 0);

  -- PC signals
  signal s_PCin       : std_logic_vector(N-1 downto 0);
  signal s_PCWrite    : std_logic;
  signal s_PCp4_F     : std_logic_vector(N-1 downto 0);
  signal s_PCp4_D     : std_logic_vector(N-1 downto 0);
  signal s_PCp4_E     : std_logic_vector(N-1 downto 0);
  signal s_PCp4_M     : std_logic_vector(N-1 downto 0);
  signal s_PCp4_W     : std_logic_vector(N-1 downto 0);
  -- PC signal for decode to fetch stage loop back
  signal s_PCp4_DF    : std_logic_vector(N-1 downto 0);

  -- Pipeline register flush/reset signals
  signal s_FlushId    : std_logic;
  signal s_FlushEx    : std_logic;
  signal s_IfIdRst    : std_logic;
  signal s_IdExRst    : std_logic;
  -- signal s_EnIfId     : std_logic;


  component control_unit is
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
  end component;

  component hazard_unit is
    port(
      i_MemRead_E   : in std_logic;
      i_Branch      : in std_logic;
      i_Jump        : in std_logic;
      i_JumpR       : in std_logic;
      i_InstRs_D    : in std_logic_vector(4 downto 0);
      i_InstRt_D    : in std_logic_vector(4 downto 0);
      i_InstRt_E    : in std_logic_vector(4 downto 0);
      i_RegWrAddr_E : in std_logic_vector(4 downto 0);
      i_RegWrAddr_M : in std_logic_vector(4 downto 0);
      o_PCWrite     : out std_logic;
      o_FlushId     : out std_logic;
      o_FlushEx     : out std_logic
    );
  end component;

  component reg_file is
    -- NOTE: Can not modify size of Read muxes, so registers must remain 32-bits wide!
    port(
      i_CLK       : in std_logic;
      i_Clear     : in std_logic;  
      i_Wr_En     : in std_logic;
      i_Wr_Addr   : in std_logic_vector(4 downto 0);
      i_Wr_Data   : in std_logic_vector(31 downto 0);
      i_Rd_Addr0  : in std_logic_vector(4 downto 0);
      i_Rd_Addr1  : in std_logic_vector(4 downto 0);
      o_Rd_Out0   : out std_logic_vector(31 downto 0);
      o_Rd_Out1   : out std_logic_vector(31 downto 0)
    );
  end component;

  component ALUCustom is
    generic(N : integer := 32);
    port(
      i_A           : in std_logic_vector(N-1 downto 0);
      i_B           : in std_logic_vector(N-1 downto 0);
      i_ALUControl  : in std_logic_vector(4 downto 0);	-- bit 4 represents signed operation
      i_Shamt       : in std_logic_vector(4 downto 0); -- Instr[10:6] or other
      i_LRCtl       : in std_logic; -- Instr[0] or other

      o_Result      : out std_logic_vector(N-1 downto 0);
      o_Cout        : out std_logic;
      o_Ovfl        : out std_logic
    );
  end component;

  component ext16t32 is
    port(
      i_SelExt  : in std_logic;
      i_Val16   : in std_logic_vector(15 downto 0);
      o_Val32   : out std_logic_vector(31 downto 0)
    );
  end component;

  component forward_unit is
    port(
      i_JumpR       : in std_logic;
      i_RegWr_E     : in std_logic;
      i_RegWr_M     : in std_logic;
      i_RegWr_W     : in std_logic;
      i_InstRs_D    : in std_logic_vector(4 downto 0);
      i_InstRs_E    : in std_logic_vector(4 downto 0);
      i_InstRt_E    : in std_logic_vector(4 downto 0);
      i_RegWrAddr_E : in std_logic_vector(4 downto 0);
      i_RegWrAddr_M : in std_logic_vector(4 downto 0);
      i_RegWrAddr_W : in std_logic_vector(4 downto 0);
      o_ForwardA    : out std_logic_vector(1 downto 0);
      o_ForwardB    : out std_logic_vector(1 downto 0);
      o_ForwardALU  : out std_logic_vector(1 downto 0)
    );
  end component;

  -- Pipeline registers
  component reg_IF_ID is
    generic(N : integer := 32);
    port(
      i_EN    : in std_logic;
      i_CLK   : in std_logic;
      i_RST   : in std_logic;
      i_Inst  : in std_logic_vector(N-1 downto 0);
      i_PCp4  : in std_logic_vector(N-1 downto 0);
      o_Inst  : out std_logic_vector(N-1 downto 0);
      o_PCp4  : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component reg_ID_EX is
    port(
      i_CLK       : in std_logic;
      i_RST       : in std_logic;
      i_RegRd0    : in std_logic_vector(31 downto 0);
      i_RegRd1    : in std_logic_vector(31 downto 0);
      i_ImmExt    : in std_logic_vector(31 downto 0);
      i_InstRs    : in std_logic_vector(4 downto 0);
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
      o_InstRs    : out std_logic_vector(4 downto 0);
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
  end component;

  component reg_EX_MEM is
    port(
      i_CLK       : in std_logic;
      i_RST       : in std_logic;
      i_DMemAddr  : in std_logic_vector(31 downto 0);
      i_DMemData  : in std_logic_vector(31 downto 0);
      i_RegWrAddr : in std_logic_vector(4 downto 0);
      i_DMemWr    : in std_logic;
      i_MemToReg  : in std_logic;
      i_PCp4      : in std_logic_vector(31 downto 0);
      i_JumpAL    : in std_logic;
      i_RegWr     : in std_logic;
      i_Halt      : in std_logic;

      o_DMemAddr  : out std_logic_vector(31 downto 0);
      o_DMemData  : out std_logic_vector(31 downto 0);
      o_RegWrAddr : out std_logic_vector(4 downto 0);
      o_DMemWr    : out std_logic;
      o_MemToReg  : out std_logic;
      o_PCp4      : out std_logic_vector(31 downto 0);
      o_JumpAL    : out std_logic;
      o_RegWr     : out std_logic;
      o_Halt      : out std_logic
    );
  end component;

  component reg_MEM_WB is
    port (
      i_CLK       : in std_logic;
      i_RST       : in std_logic;
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
  end component;

begin

  -- This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
                  iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst_F);

  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr_M(11 downto 2),
             data => s_DMemData_M,
             we   => s_DMemWr_M,
             q    => s_DMemOut_M);

  -- Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- Ensure that s_Ovfl is connected to the overflow output of your ALU
  -- Implement the rest of your processor below this comment!

  -- IF stage:

  PCModule: process(iCLK, iRST, s_PCWrite)
  begin
    if (iRST = '1') then
      s_NextInstAddr <= x"00400000";
    elsif (s_PCWrite = '1') then
      if (rising_edge(iCLK)) then
        s_NextInstAddr <= s_PCin;
      end if;
    end if;
  end process;

  -- Increment PC by 4
  s_PCp4_F <= (s_NextInstAddr + x"00000004");

  s_JumpRAddr <= (s_RegRdOut0_D) when (s_ForwardALU = "00") else  -- No forwarding
                 (s_DMemAddr_E) when (s_ForwardALU = "01") else   -- Forward from EX 
                 (s_DMemAddr_M);  -- Forward from MEM

  -- Determine PC input, take decode stage into account
  s_PCin <= (s_JumpRAddr) when (s_JumpR_D = '1') else -- Jump register asserted
            (s_PCp4_DF) when (s_JumpR_D = '0' and (s_Jump_D = '1' or s_Branch_D = '1')) else  -- Jump or branch asserted
            (s_PCp4_F); -- Increment PC

  s_IfIdRst <= iRST or s_FlushId;

  -- ID stage:
  -- s_EnIfId <= '0' when (s_PCWrite = '0' and s_FlushEx = '1') else '1';

  IF_ID_reg: reg_IF_ID port map(
    i_EN    => s_PCWrite,
    i_CLK   => iCLK,
    i_RST   => s_IfIdRst,
    i_Inst  => s_Inst_F,
    i_PCp4  => s_PCp4_F,
    o_Inst  => s_Inst_D,
    o_PCp4  => s_PCp4_D
  );

  -- PC jump or branch logic in decode stage
  s_PCp4_DF <= (s_PCp4_D(31 downto 28) & (s_Inst_D(25 downto 0) & "00")) when (s_Jump_D = '1') else	-- Jump asserted
               (s_PCp4_D + (s_ImmExt_D(29 downto 0) & "00")) when (s_Branch_D = '1' and s_Zero_D = '1' and s_Jump_D = '0') else	-- Branch asserted
               (s_PCp4_D); -- Keep PC the same (already incremented)

  ControlUnit: control_unit port map(
    i_Opcode      => s_Inst_D(31 downto 26),
    i_Function    => s_Inst_D(5 downto 0),
    i_Reset       => iRST,
    o_ALUSrc      => s_ALUSrc_D,
    o_MemToReg    => s_MemToReg_D,
    o_DMemWr      => s_DMemWr_D,
    o_RegWr       => s_RegWr_D,
    o_SelExt      => s_SelExt_D,
    o_Branch      => s_Branch_D,
    o_Jump        => s_Jump_D,
    o_JumpAL      => s_JumpAL_D,
    o_JumpR       => s_JumpR_D,
    o_Halt        => s_Halt_D,
    o_ALUControl  => s_ALUControl_D,
    o_RegDst      => s_RegDst_D
  );

  HazardUnit: hazard_unit port map(
    i_MemRead_E   => s_MemToReg_E,
    i_Branch      => s_Branch_D,
    i_Jump        => s_Jump_D,
    i_JumpR       => s_JumpR_D,
    i_InstRs_D    => s_Inst_D(25 downto 21),
    i_InstRt_D    => s_Inst_D(20 downto 16),
    i_InstRt_E    => s_InstRt_E,
    i_RegWrAddr_E => s_RegWrAddr_E,
    i_RegWrAddr_M => s_RegWrAddr_M,
    o_PCWrite     => s_PCWrite,
    o_FlushId     => s_FlushId,
    o_FlushEx     => s_FlushEx
  );

  RegFile: reg_file port map(
    i_CLK       => iCLK,
    i_Clear     => iRST,
    i_Wr_En     => s_RegWr_W,
    i_Wr_Addr   => s_RegWrAddr_W,
    i_Wr_Data   => s_RegWrData_W,
    i_Rd_Addr0  => s_Inst_D(25 downto 21),
    i_Rd_Addr1  => s_Inst_D(20 downto 16),
    o_Rd_Out0   => s_RegRdOut0_D, -- rs
    o_Rd_Out1   => s_RegRdOut1_D   -- rt
  );
  -- Data memory write data = reg file read 1
  s_Zero_D <= '1' when ((s_RegRdOut0_D = s_RegRdOut1_D) and (s_ALUControl_D = "00101")) else
            '1' when ((s_RegRdOut0_D /= s_RegRdOut1_D) and (s_ALUControl_D = "00111")) else
            '0';

  Extender16t32: ext16t32 port map(
    i_SelExt  => s_SelExt_D,
    i_Val16   => s_Inst_D(15 downto 0),
    o_Val32   => s_ImmExt_D
  );

  -- Compute shifter control early
  -- shamt is sll by 16-bits during lui
  s_Shamt_D <= "10000" when (s_Inst_D(31 downto 26) = "001111") else s_Inst_D(10 downto 6);

  -- Map ALU shifter operation based on function code
  s_LRCtl_D <= '0' when (s_Inst_D(31 downto 26) = "001111") else s_Inst_D(1);

  s_IdExRst <= iRST or s_FlushEx;

  -- EX stage:

  ID_EX_reg: reg_ID_EX port map(
    i_CLK       => iCLK,
    i_RST       => s_IdExRst,
    i_RegRd0    => s_RegRdOut0_D,
    i_RegRd1    => s_RegRdOut1_D,
    i_ImmExt    => s_ImmExt_D,
    i_InstRs    => s_Inst_D(25 downto 21),
    i_InstRt    => s_Inst_D(20 downto 16),
    i_InstRd    => s_Inst_D(15 downto 11),
    i_ALUSrc    => s_ALUSrc_D,
    i_RegDst    => s_RegDst_D,
    i_ALUCtrl   => s_ALUControl_D,
    i_DMemWr    => s_DMemWr_D,
    i_MemToReg  => s_MemToReg_D,
    i_PCp4      => s_PCp4_D,
    i_JumpAL    => s_JumpAL_D,
    i_RegWr     => s_RegWr_D,
    i_Halt      => s_Halt_D,
    i_Shamt     => s_Shamt_D,
    i_LRCtl     => s_LRCtl_D,

    o_RegRd0    => s_RegRdOut0_E,
    o_RegRd1    => s_RegRdOut1_E,
    o_ImmExt    => s_ImmExt_E,
    o_InstRs    => s_InstRs_E,
    o_InstRt    => s_InstRt_E,
    o_InstRd    => s_InstRd_E,
    o_ALUSrc    => s_ALUSrc_E,
    o_RegDst    => s_RegDst_E,
    o_ALUCtrl   => s_ALUControl_E,
    o_DMemWr    => s_DMemWr_E,
    o_MemToReg  => s_MemToReg_E,
    o_PCp4      => s_PCp4_E,
    o_JumpAL    => s_JumpAL_E,
    o_RegWr     => s_RegWr_E,
    o_Halt      => s_Halt_E,
    o_Shamt     => s_Shamt_E,
    o_LRCtl     => s_LRCtl_E
  );

  -- Forwarding unit
  ForwardUnit: forward_unit port map(
    i_JumpR       => s_JumpR_D,
    i_RegWr_E     => s_regWr_E,
    i_RegWr_M     => s_regWr_M,
    i_RegWr_W     => s_regWr_W,
    i_InstRs_D    => s_Inst_D(25 downto 21),
    i_InstRs_E    => s_InstRs_E,
    i_InstRt_E    => s_InstRt_E,
    i_RegWrAddr_E => s_RegWrAddr_E,
    i_RegWrAddr_M => s_RegWrAddr_M,
    i_RegWrAddr_W => s_RegWrAddr_W,
    o_ForwardA    => s_ForwardA,
    o_ForwardB    => s_ForwardB,
    o_ForwardALU  => s_ForwardALU
  );

  -- Select data memory data to be forwarded
  s_DMemData_E <= s_RegRdOut1_E when (s_ForwardB = "00") else
                  s_DMemAddr_M  when (s_ForwardB = "01") else
                  s_RegWrData_W;

  -- Select input for ALU (i_A)
  s_ALUiA <= s_RegRdOut0_E when (s_ForwardA = "00") else
             s_DMemAddr_M  when (s_ForwardA = "01") else
             s_RegWrData_W;

  -- Select immediate or forwarded data for ALU (i_B)
  s_ALUiB <= s_ImmExt_E when (s_ALUSrc_E = '1') else
             s_DMemData_E;

  -- Select s_RegWrAddr (reg file write addr) based on s_RegDst
  s_RegWrAddr_E <= s_InstRt_E when (s_RegDst_E = "00") else
                   s_InstRd_E when (s_RegDst_E = "01") else
                   "11111";

  -- ALU mapping with shifter embedded
  ALUUnit: ALUCustom port map(
    i_A           => s_ALUiA,
    i_B           => s_ALUiB,
    i_ALUControl  => s_ALUControl_E,
    i_Shamt       => s_Shamt_E,
    i_LRCtl       => s_LRCtl_E,

    o_Result      => s_DMemAddr_E,
    o_Cout        => s_Cout,
    o_Ovfl        => s_Ovfl
  );
  -- oALUOut is s_DMemAddr (execute)
  oALUOut <= s_DMemAddr_E;

  -- MEM stage:

  EX_MEM_reg: reg_EX_MEM port map(
    i_CLK       => iCLK,
    i_RST       => iRST,
    i_DMemAddr  => s_DMemAddr_E,
    i_DMemData  => s_DMemData_E,
    i_RegWrAddr => s_RegWrAddr_E,
    i_DMemWr    => s_DMemWr_E,
    i_MemToReg  => s_MemToReg_E,
    i_PCp4      => s_PCp4_E,
    i_JumpAL    => s_JumpAL_E,
    i_RegWr     => s_RegWr_E,
    i_Halt      => s_Halt_E,

    o_DMemAddr  => s_DMemAddr_M,
    o_DMemData  => s_DMemData_M,
    o_RegWrAddr => s_RegWrAddr_M,
    o_DMemWr    => s_DMemWr_M,
    o_MemToReg  => s_MemToReg_M,
    o_PCp4      => s_PCp4_M,
    o_JumpAL    => s_JumpAL_M,
    o_RegWr     => s_RegWr_M,
    o_Halt      => s_Halt_M
  );

  -- WB stage:

  MEM_WB_reg: reg_MEM_WB port map(
    i_CLK       => iCLK,
    i_RST       => iRST,
    i_DMemAddr  => s_DMemAddr_M,
    i_DMemOut   => s_DMemOut_M,
    i_RegWrAddr => s_RegWrAddr_M,
    i_MemToReg  => s_MemToReg_M,
    i_PCp4      => s_PCp4_M,
    i_JumpAL    => s_JumpAL_M,
    i_RegWr     => s_RegWr_M,
    i_Halt      => s_Halt_M,

    o_DMemAddr  => s_DMemAddr_W,
    o_DMemOut   => s_DMemOut_W,
    o_RegWrAddr => s_RegWrAddr_W,
    o_MemToReg  => s_MemToReg_W,
    o_PCp4      => s_PCp4_W,
    o_JumpAL    => s_JumpAL_W,
    o_RegWr     => s_RegWr_W,
    o_Halt      => s_Halt_W
  );

  -- Select reg write data based on MemToReg and Jump And Link
  s_RegWrData_W <= s_DMemOut_W when (s_MemToReg_W = '1' and s_JumpAL_W = '0') else
                   s_DMemAddr_W when (s_MemToReg_W = '0' and s_JumpAL_W = '0') else
                   s_PCp4_W;

end structure;
