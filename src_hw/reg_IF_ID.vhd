--make testbench--
library ieee;
use ieee.std_logic_1164.all;

entity reg_IF_ID is
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
end reg_IF_ID;

architecture description of reg_IF_ID is
begin
  process(i_RST, i_CLK, i_EN)
  begin
    if (i_EN = '1') then
      if rising_edge(i_CLK) then
        if (i_RST = '1') then
          o_PCp4 <= x"00000000";
          o_Inst <= x"00000000";
        else
          o_PCp4 <= i_PCp4;
          o_Inst <= i_Inst;
        end if;
      end if;
    end if;
  end process;
end description;
