library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity mu12 is Port ( 
       clk : in STD_LOGIC;
       input_mul2 : in STD_LOGIC_VECTOR (7 downto 0);
       output_mul2 : out STD_LOGIC_VECTOR(7 downto 0)
       );
end mu12;

architecture Behavioral of mu12 is

begin
process(clk)
begin
    if rising_edge(clk) then 
    
      if(input_mul2(7) = '0') then
              output_mul2 <= input_mul2( (7 - 1) downto 0) & '0';  
      elsif(input_mul2(7) = '1') then
            -- x^8  = x^4 + x^3 + x^1 + 1
             output_mul2 <=( input_mul2( (7 - 1) downto 0) & '0' ) xor "00011011" ;
      end if;
    
    end if;
end process;


end Behavioral;
