library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ClockDivider is port 
(
    clk: in std_logic;
    enable : in std_logic;
    clk_out_1Hz : out std_logic
 );
end ClockDivider;

architecture Behavioral of ClockDivider is
signal clk_div_pos: unsigned (27 downto 0) := x"0000000";
signal clock_out : std_logic;


begin
process(clk)
begin
    if rising_edge(clk) then
        if(clk_div_pos <= x"5F5E100") then  
            clock_out <= '1';
            clk_div_pos <= clk_div_pos +1;
        elsif(clk_div_pos >= x"5F5E101" and  clk_div_pos <= x"BEBC200" ) then
       
            clock_out <= '0';
            clk_div_pos <= clk_div_pos +1;
       
        else
            clk_div_pos <=  x"0000000";
        end if;
    end if;
end process;

clk_out_1Hz <= clock_out when enable = '1' else '0';





end Behavioral;
