-------------------------------------------------------------------------
-- Kevin Nguyen
-- Iowa State University
-------------------------------------------------------------------------


-- barrel_shift.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the barrel 
-- shifter for ALU in the MIPS processor
--
-- The barrel shifter supports 2^5-1 shifts left or right logical or
-- arithmetic
--
-- NOTES:
-- 03/11/21 by JB::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shift is
  port(
    i_data  : in std_logic_vector(31 downto 0);
    i_sel   : in std_logic; -- 0 for left and 1 for right 
    i_logic : in std_logic; -- 0 for logic (unsigned) and 1 for arithmetic (signed)
    i_shift : in std_logic_vector(4 downto 0); --shift amount
    o_data  : out std_logic_vector(31 downto 0)
  );
end barrel_shift;

architecture structural of barrel_shift is

signal s_oData        : std_logic_vector(31 downto 0); --intermetiate wire
signal switched_bits  : std_logic_vector(31 downto 0); --switch bits so that I can do right shift
signal reset_bits     : std_logic_vector(31 downto 0);
signal logicOrArith   : std_logic; --used for making of if is logic or arithmetic
signal signedVal      : std_logic;
signal unsignedVal    : std_logic := '0'; --hard coded for sign or unsigned to add 1 or 0 for sign or unsigned
signal shiftLorR      : std_logic_vector(31 downto 0); -- Shift Left or Right
signal shamt1to2      : std_logic_vector(31 downto 0); -- Shift1to2
signal shamt2to4      : std_logic_vector(31 downto 0); -- Shift2to4
signal shamt4to8      : std_logic_vector(31 downto 0); -- Shift4to8
signal shamt8to16     : std_logic_vector(31 downto 0); -- Shift8to16

component mux2t1_df is
    port(i_S         : in std_logic;
         i_D0        : in std_logic;
         i_D1        : in std_logic;
         o_O         : out std_logic);
  end component;

component mux2t1_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
end component;

begin
--o_data <= s_oData;
-------------------------------------------------------
--switching of intial bits and checking if right or left
-------------------------------------------------------
switch_bits32 : for i in 0 to 31 generate
  switched_bits(i) <= i_Data(31 - i); --this is done so that i can shift right on same mux logics
end generate switch_bits32;

shiftleftorRight : mux2t1_N --mux for it it is to be shift left or right
  port map(i_S => i_sel,
    i_D0 => i_Data,
    i_D1 => switched_bits,
    o_O  => shiftLorR);

signedVal <= i_Data(31);

---------------------------------------------------------------------------------------------------
--logic for the 1 bit 2to1 mux for if arithmetic or logic and chooses which to add to shifting bits
---------------------------------------------------------------------------------------------------
logicOrArthimetic : mux2t1_df
  port map(i_S => i_logic,
    i_D0 => unsignedVal,
    i_D1 => signedVal,
    o_O => logicOrArith);
    
------------------------------
--shifting of the intial 1 bit
------------------------------
bitmuxshift_1 : for i in 31 downto 1 generate
shiftlogic_1 : mux2t1_df port map(
  i_S => i_Shift(0), 
  i_D0 => shiftLorR(i),	-- No shift
  i_D1 => shiftLorR(i-1), -- Yes shift
  o_O => shamt1to2(i));  
end generate bitmuxshift_1;


shift_1 : mux2t1_df port map( --setting of intial bits
  i_S => i_Shift(0), --shift amount LSB
  i_D1 => logicOrArith, -- Take MSB (Yes shift)
  i_D0 => shiftLorR(0), -- Starting Bit (No shift)
  o_O => shamt1to2(0));

--------------------
--shifting of 2 bits
--------------------
bitmuxshift_2_A : for i in 31 downto 2 generate
shiftlogic_2 : mux2t1_df port map(
  i_S => i_Shift(1), 
  i_D0 => shamt1to2(i),
  i_D1 => shamt1to2(i-2),
  o_O => shamt2to4(i));
end generate bitmuxshift_2_A;

bitmuxshift_2_B : for i in 1 downto 0 generate
shift_2 : mux2t1_df port map( --setting of intial bits
  i_S => i_Shift(1), --shift amount LSB
  i_D1 => logicOrArith,
  i_D0 => shamt1to2(i),
  o_O => shamt2to4(i));
end generate bitmuxshift_2_B;

----------------
--shifting 4 bits
-----------------
bitmuxshift_4_A : for i in 31 downto 4 generate
shiftlogic_4 : mux2t1_df port map(
  i_S => i_Shift(2), 
  i_D0 => shamt2to4(i),
  i_D1 => shamt2to4(i-4),
  o_O => shamt4to8(i));
end generate bitmuxshift_4_A;

bitmuxshift_4_B : for i in 3 downto 0 generate
shift_4 : mux2t1_df port map( --setting of intial bits
  i_S => i_Shift(2), --shift amount LSB
  i_D1 => logicOrArith,
  i_D0 => shamt2to4(i),
  o_O => shamt4to8(i));
end generate bitmuxshift_4_B;

-----------------
--shifting 8 bits
-----------------
bitmuxshift_8_A : for i in 31 downto 8 generate
shiftlogic_8 : mux2t1_df port map(
  i_S => i_Shift(3), 
  i_D0 => shamt4to8(i),
  i_D1 => shamt4to8(i-8),
  o_O => shamt8to16(i));
end generate bitmuxshift_8_A;

bitmuxshift_8_B : for i in 7 downto 0 generate
shift_8 : mux2t1_df port map( --setting of intial bits
  i_S => i_Shift(3), --shift amount LSB
  i_D1 => logicOrArith,
  i_D0 => shamt4to8(i),
  o_O => shamt8to16(i));
end generate bitmuxshift_8_B;

-----------------
--shifting 16 bits
-----------------
bitmuxshift_16_A : for i in 31 downto 16 generate
shiftlogic_16 : mux2t1_df port map(
  i_S => i_Shift(4), 
  i_D0 => shamt8to16(i),
  i_D1 => shamt8to16(i-16),
  o_O => s_oData(i));
end generate bitmuxshift_16_A;

bitmuxshift_16_B : for i in 15 downto 0 generate
shift_16 : mux2t1_df port map( --setting of intial bits
  i_S => i_Shift(4), --shift amount LSB
  i_D1 => logicOrArith,
  i_D0 => shamt8to16(i),
  o_O => s_oData(i));
end generate bitmuxshift_16_B;

-------------------------------------
--switching back to the original bits
-------------------------------------
bitswitchback : for i in 0 to 31 generate
  reset_bits(i) <= s_oData(31 - i); --switch back to normal
end generate bitswitchback;

shiftleftorRight_2 : mux2t1_N --mux for it it is to be shift left or right
  port map(i_S => i_sel,
    i_D0 => s_oData,
    i_D1 => reset_bits,
    o_O  => o_data);

end structural;