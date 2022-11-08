library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DFF is port 
(
    CLK : in std_logic;
    EN  : in std_logic;
    D   : in std_logic;
    Q   : out std_logic
 );
end DFF;

architecture Behavioral of DFF is
begin
process (CLK)
  begin
   if rising_edge(CLK) then
      if (EN ='1') then
          Q <= D;
      else
          Q <= '0';    
      end if;
    end if;
  end process;
end behavioral;
