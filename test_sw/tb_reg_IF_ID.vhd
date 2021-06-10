library IEEE;
use IEEE.std_logic_1164.all;

entity tb_reg_IF_ID is
  generic(gCLK_HPER : time := 50 ns);
end tb_reg_IF_ID;

architecture mixed of tb_reg_IF_ID is

constant cCLK_PER : time := gCLK_HPER * 2;

component reg_IF_ID is
  generic(N : integer := 32);
  port(
    i_CLK   : in std_logic;
    i_RST   : in std_logic;
    i_Inst  : in std_logic_vector(N-1 downto 0);
    i_PCp4  : in std_logic_vector(N-1 downto 0);
    o_Inst  : out std_logic_vector(N-1 downto 0);
    o_PCp4  : out std_logic_vector(N-1 downto 0)
  );
end component;

signal s_rdaddr     : std_logic_vector(31 downto 0);
signal s_sPCp4      : std_logic_vector(31 downto 0);
signal s_clk        : std_logic;
signal s_clear      : std_logic;

signal s_addrout    : std_logic_vector(31 downto 0);
signal s_PCp4out    : std_logic_vector(31 downto 0);

begin

  DUT0: reg_IF_ID port map(
    i_Inst  => s_rdaddr,
    i_PCp4  => s_sPCp4,
    i_CLK   => s_clk,
    i_RST   => s_clear,
    o_Inst  => s_addrout,
    o_PCp4  => s_PCp4out
  );


  P_clk: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;


TB: process
begin
  s_rdaddr  <= x"00000000";
  s_sPCp4   <= x"00000000";
  s_clear   <= '0';
  wait for cCLK_PER;

--test 1: should output s_addrout as s_rdaddr and s_PCp4out as s_sPCp4
  s_rdaddr  <= x"00000001";
  s_sPCp4   <= x"00000001";
  s_clear   <= '0';
  wait for cCLK_PER;

--test 2: should output values of s_rdaddr and s_PCp4 again
  s_rdaddr  <= x"0FFFF354";
  s_sPCp4   <= x"00405071";
  s_clear   <= '0';
  wait for cCLK_PER;

--test 3: should output 0s because clear is a 1
  s_rdaddr  <= x"0FFFF354";
  s_sPCp4   <= x"00405071";
  s_clear   <= '1';
  wait for cCLK_PER;
wait for cCLK_PER;
end process;
end mixed;