library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MixColumns is
    Port ( clk : in STD_LOGIC;
	       MC_IN : in STD_LOGIC_VECTOR (127 downto 0);
           MC_OUT : out STD_LOGIC_VECTOR (127 downto 0)
         );
end MixColumns;

architecture default of MixColumns is
component SingleColumn is
    Port ( clk : in STD_LOGIC;
	       MC_IN : in STD_LOGIC_VECTOR (31 downto 0);
           MC_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end component;

begin
map1 : SingleColumn port map(clk , MC_IN(127 downto 96),MC_OUT(127 downto 96));
map2 : SingleColumn port map(clk , MC_IN(95 downto 64),MC_OUT(95 downto 64));
map3 : SingleColumn port map(clk , MC_IN(63 downto 32),MC_OUT(63 downto 32));
map4 : SingleColumn port map(clk , MC_IN(31 downto 0),MC_OUT(31 downto 0));

end default;
