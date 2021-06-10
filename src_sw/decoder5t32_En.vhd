-------------------------------------------------------------------------
-- Soma Szabo
-- B.S. Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 5:32 decoder
-- with active high outputs and an enable input.
--
-- NOTES:
-- 
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity decoder5t32_En is
  port(
    i_En    : in std_logic;
    i_Data  : in std_logic_vector(4 downto 0);
    o_Q     : out std_logic_vector(31 downto 0)
  );
end decoder5t32_En;

architecture custom of decoder5t32_En is

begin
  DECODER: process(i_En, i_Data)
  begin
    if (i_En = '1') then
      case i_Data is
        when "00000" => o_Q <= x"00000001";
        when "00001" => o_Q <= x"00000002";
        when "00010" => o_Q <= x"00000004";
        when "00011" => o_Q <= x"00000008";
        when "00100" => o_Q <= x"00000010";
        when "00101" => o_Q <= x"00000020";
        when "00110" => o_Q <= x"00000040";
        when "00111" => o_Q <= x"00000080";
        when "01000" => o_Q <= x"00000100";
        when "01001" => o_Q <= x"00000200";
        when "01010" => o_Q <= x"00000400";
        when "01011" => o_Q <= x"00000800";
        when "01100" => o_Q <= x"00001000";
        when "01101" => o_Q <= x"00002000";
        when "01110" => o_Q <= x"00004000";
        when "01111" => o_Q <= x"00008000";
        when "10000" => o_Q <= x"00010000";
        when "10001" => o_Q <= x"00020000";
        when "10010" => o_Q <= x"00040000";
        when "10011" => o_Q <= x"00080000";
        when "10100" => o_Q <= x"00100000";
        when "10101" => o_Q <= x"00200000";
        when "10110" => o_Q <= x"00400000";
        when "10111" => o_Q <= x"00800000";
        when "11000" => o_Q <= x"01000000";
        when "11001" => o_Q <= x"02000000";
        when "11010" => o_Q <= x"04000000";
        when "11011" => o_Q <= x"08000000";
        when "11100" => o_Q <= x"10000000";
        when "11101" => o_Q <= x"20000000";
        when "11110" => o_Q <= x"40000000";
        when "11111" => o_Q <= x"80000000";
        when others  => o_Q <= x"00000000";
      end case;
    else
      o_Q <= x"00000000";
    end if;
  end process DECODER;

end custom;
