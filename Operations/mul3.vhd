library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mul3 is port 
(      clk : in STD_LOGIC;
       input_mul3 : in STD_LOGIC_VECTOR (7 downto 0);
       output_mul3 : out STD_LOGIC_VECTOR(7 downto 0)
 );
end mul3;

architecture Behavioral of mul3 is

signal temp : std_logic_vector(7 downto 0);

component mu12 is Port ( 
       clk : in STD_LOGIC;
       input_mul2 : in STD_LOGIC_VECTOR (7 downto 0);
       output_mul2 : out STD_LOGIC_VECTOR(7 downto 0)
       );
end component;



begin
map1: mu12 port map(clk,input_mul3,temp); 

process(clk,input_mul3)
begin
    if rising_edge(clk) then 
            
            -- x^8  = x^4 + x^3 + x^1 + 1
            output_mul3 <=  temp xor input_mul3 ;
    end if;
end process;
end Behavioral;
