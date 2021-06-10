-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit
-- edge-triggered D flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity dffg_Nbit is
  generic(N : integer := 32);
  port (
    i_CLK   : in std_logic;
    i_RST   : in std_logic;
    i_WEn   : in std_logic;
    i_Data  : in std_logic_vector(N-1 downto 0);
    o_Q     : out std_logic_vector(N-1 downto 0)
  );
end dffg_Nbit;

architecture structural of dffg_Nbit is

  component dffg is
    port(
      i_CLK : in std_logic;     -- Clock input
      i_RST : in std_logic;     -- Reset input
      i_WE  : in std_logic;     -- Write enable input
      i_D   : in std_logic;     -- Data value input
      o_Q   : out std_logic
    );
  end component;

begin

  -- Instantiate N dffg instances
  G_NBit_DFF: for i in 0 to N-1 generate
  DFFGI: dffg port map(
    i_CLK   => i_CLK,
    i_RST   => i_RST,
    i_WE    => i_WEn,
    i_D     => i_Data(i),
    o_Q     => o_Q(i)
  );
  end generate G_NBit_DFF;

end structural;

