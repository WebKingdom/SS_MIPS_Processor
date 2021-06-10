-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a register file 
-- with 32 register, each 32-bit wide and 1 write port and 2 read ports.
-- 
-- It writes on a falling clock edge and read asynchronously to handle 
-- writes and reads in the same pipeline cycle
--
--
-- NOTES:
-- 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.custom_type_pkg.all;

entity reg_file is
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
end reg_file;

architecture custom of reg_file is

  component decoder5t32_En is
    port(
      i_En    : in std_logic;
      i_Data  : in std_logic_vector(4 downto 0);
      o_Q     : out std_logic_vector(31 downto 0)
    );
  end component;

  component dffg_Nbit is
    -- NOTE: N must match Wr_Data size in reg_file entity
    generic(N : integer := 32);
    port (
      i_CLK   : in std_logic;
      i_RST   : in std_logic;
      i_WEn   : in std_logic;
      i_Data  : in std_logic_vector(N-1 downto 0);
      o_Q     : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component mux32t1_32bit is
    port(
      i_Sel   : in std_logic_vector(4 downto 0);
      i_D     : in data_array_32b32;
      o_Q     : out std_logic_vector(31 downto 0)
    );
  end component;

  -- singals
  signal s_Decoder_Out  : std_logic_vector(31 downto 0);
  signal s_Mux_In       : data_array_32b32;

begin

  -- Instantiate decoder
  g_Decoder: decoder5t32_En port map(
    i_En    => i_Wr_En,
    i_Data  => i_Wr_Addr,
    o_Q     => s_Decoder_Out
  );

  -- Instantiate 32, 32-bit rgisters and connect to mux signal
  -- 0th register is always 0x00000000
  DFFG_NBIT_0: dffg_Nbit port map(
    i_CLK   => i_CLK,
    i_RST   => i_Clear,
    i_WEn   => s_Decoder_out(0),
    i_Data  => x"00000000",
    o_Q     => s_Mux_In(0)
  );

  G_DFFG_NBIT: for i in 1 to 31 generate
    DFFG_NBIT_I: dffg_Nbit port map(
      i_CLK   => i_CLK,
      i_RST   => i_Clear,
      i_WEn   => s_Decoder_out(i),
      i_Data  => i_Wr_Data,
      o_Q     => s_Mux_In(i)
    );
  end generate G_DFFG_NBIT;

  -- Instantiate mux0
  g_Mux0: mux32t1_32bit port map(
    i_Sel   => i_Rd_Addr0,
    i_D     => s_Mux_In,
    o_Q     => o_Rd_Out0
  );

  -- Instantiate mux1
  g_Mux1: mux32t1_32bit port map(
    i_Sel   => i_Rd_Addr1,
    i_D     => s_Mux_In,
    o_Q     => o_Rd_Out1
  );

end custom;
