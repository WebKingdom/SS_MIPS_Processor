library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrel_shift is

end tb_barrel_shift;

architecture structure of tb_barrel_shift is

	component barrel_shift is
	port(i_data : in std_logic_vector(31 downto 0);
		i_sel 	: in std_logic; --1 for left and 0 for right 
		i_logic	: in std_logic; --1 for logic (unsigned) and 0 for arithmetic (signed)
		i_shift	: in std_logic_vector(4 downto 0); --shift amount
		o_data	: out std_logic_vector(31 downto 0));

	end component;
	
	signal i_data, o_data : std_logic_vector(31 downto 0);
	signal Logical_Arithmatic, Left_Right : std_logic;
	signal i_shamt : std_logic_vector (4 downto 0);
	begin
	
	barrelShift : barrel_shift
	port map(i_data => i_data,
			i_logic => Logical_Arithmatic,
			i_sel => Left_Right,
			i_shift => i_shamt,
			o_data => o_data
			);
			
	P_TB: process
	begin
	
	--wait for 50 ns;
	-- sra by 0: Expect 0x1
	Left_Right <= '0';
	i_data <= x"00000001";
	Logical_Arithmatic <= '0';
	i_shamt <= "00000";
	wait for 20 ns;

	-- sra by 1: Expect 0x0
	i_shamt <= "00001";
	wait for 20 ns;

	-- sll by 1: Expect 0x2
	i_data <= x"00000001";
	Left_Right <= '1';
	Logical_Arithmatic <= '1';
	i_shamt <= "00001";
	wait for 20 ns;

	-- sll by 3: Expect 0x8
	i_data <= x"80000001";
	Left_Right <= '1';
	Logical_Arithmatic <= '1';
	i_shamt <= "00011";
	wait for 20 ns;

	-- srl by 3: Expect 0x10000001
	i_data <= x"80000008";
	Left_Right <= '0';
	Logical_Arithmatic <= '1';
	i_shamt <= "00011";
	wait for 20 ns;

	-- sra by 3: Expect 0xF0000001
	i_data <= x"80000008";
	Left_Right <= '0';
	Logical_Arithmatic <= '0';
	i_shamt <= "00011";
	wait for 20 ns;

	-- sll by 1: Expect 0xF55555E at the end
	i_data <= x"FAAAAAAF";
	Logical_Arithmatic <= '1';
	Left_Right <= '1';
	i_shamt <= "00001";
	wait for 20 ns;

	-- srl by 1: Expect 0x7D555557
	Left_Right <= '0';
	Logical_Arithmatic <= '1';
	i_data <= x"FAAAAAAF";
	i_shamt <= "00001";
	wait for 20 ns;

	-- srl by 31: Expect 0x00000001
	Left_Right <= '0';
	Logical_Arithmatic <= '1';
	i_data <= x"FAAAAAAF";
	i_shamt <= "11111";
	wait for 20 ns;
	
	-- sll by 31: Expect 0x80000000
	Left_Right <= '1';
	Logical_Arithmatic <= '1';
	i_data <= x"00000001";
	i_shamt <= "11111";
	wait for 20 ns;

	-- sra by 31: Expect 0xFFFFFFFF
	Left_Right <= '0';
	Logical_Arithmatic <= '0';
	i_data <= x"80000001";
	i_shamt <= "11111";
	wait for 20 ns;
	
	-- srl by 30: Expect 0x00000001
	Left_Right <= '0';
	Logical_Arithmatic <= '1';
	i_shamt <= "11110";
	i_data <= x"7555AF98";
	wait for 20 ns;
	
	
	
	wait for 20 ns;
	end process;
	
end structure;