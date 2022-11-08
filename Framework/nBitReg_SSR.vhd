library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nBitReg_SSR is
	generic (
		BIT_WIDTH	: integer range 1 to 256 := 16				
	);
	port (
		CLK		: in std_logic;									
		SR		: in std_logic;									
		SRINIT	: in std_logic_vector(BIT_WIDTH-1 downto 0);	
		CE		: in std_logic;									
		DIN		: in std_logic_vector(BIT_WIDTH-1 downto 0);	
		DOUT	: out std_logic_vector(BIT_WIDTH-1 downto 0)	
	);
end nBitReg_SSR;

architecture Behavioral of nBitReg_SSR is

	component DFF_SSR is
		port (
			CLK		: in std_logic;					
			SR		: in std_logic;					
			SRINIT	: in std_logic;					
			CE		: in std_logic;					
			D		: in std_logic;					
			Q		: out std_logic					
		);
	end component DFF_SSR;

begin

	Reg : for i in 1 to BIT_WIDTH generate
		FF : DFF_SSR
			port map (
				CLK => CLK,
				SR	=> SR,
				SRINIT => SRINIT(i-1),
				CE	=> CE,
				D	=> DIN(i-1),
				Q	=> DOUT(i-1)
			);
	end generate;

end Behavioral;

