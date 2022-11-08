library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFF_SSR is
	port (
		CLK		: in std_logic;					
		SR		: in std_logic;					
		SRINIT	: in std_logic;					
		CE		: in std_logic;					
		D		: in std_logic;					
		Q		: out std_logic					
	);
end DFF_SSR;

architecture Behavioral of DFF_SSR is
begin
	FlipFlop : process(clk)
	begin
		if rising_edge(clk) then
			if SR = '1' then
				Q <= SRINIT;
			else
				if CE = '1' then
					Q <= D;
				end if;
			end if;					 
		end if;						 
	end process FlipFlop;

end Behavioral;

