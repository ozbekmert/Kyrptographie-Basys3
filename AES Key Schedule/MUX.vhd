library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX is port 
(
    clk : in std_logic;
    key : in std_logic_vector(127 downto 0);
    cipher :  in std_logic_vector(127 downto 0);
    reset : in std_logic;
    dout : out std_logic_vector(127 downto 0)
);
end MUX;

architecture Behavioral of MUX is
signal mux_out : std_logic_vector(127 downto 0);
begin





MUX:process(clk,reset)
begin
if rising_edge(clk) then
    
    if reset = '1' then
        mux_out <= key;
    elsif reset = '0' then
        mux_out <= cipher;
    
    end if;
end if;
end process;

dout <= mux_out;

end Behavioral;
