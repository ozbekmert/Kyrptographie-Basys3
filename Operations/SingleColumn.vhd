library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SingleColumn is
    Port ( clk : in STD_LOGIC;
	       MC_IN : in STD_LOGIC_VECTOR (31 downto 0);
           MC_OUT : out STD_LOGIC_VECTOR (31 downto 0));
end SingleColumn;
architecture default of SingleColumn is
-- #########################################################################
-- Components 
component mu12 is Port 
( 
       clk : in STD_LOGIC;
       input_mul2 : in STD_LOGIC_VECTOR (7 downto 0);
       output_mul2 : out STD_LOGIC_VECTOR(7 downto 0)
);
end component;

component mul3 is port 
(      
       clk : in STD_LOGIC;
       input_mul3 : in STD_LOGIC_VECTOR (7 downto 0);
       output_mul3 : out STD_LOGIC_VECTOR(7 downto 0)
);
end component;

-- #########################################################################
-- Signals

signal col1_1 : std_logic_vector(7 downto 0);
signal col1_2 : std_logic_vector(7 downto 0);

signal col2_2 : std_logic_vector(7 downto 0);
signal col2_3 : std_logic_vector(7 downto 0);

signal col3_3 : std_logic_vector(7 downto 0);
signal col3_4 : std_logic_vector(7 downto 0);

signal col4_1 : std_logic_vector(7 downto 0);
signal col4_4 : std_logic_vector(7 downto 0);


begin
-- port mapping for matrix multiplication

map1 : mu12 port map(clk , MC_IN(31 downto 24),col1_1);
map2 : mul3 port map(clk , MC_IN(23 downto 16),col1_2);

map3 : mu12 port map(clk , MC_IN(23 downto 16),col2_2);
map4 : mul3 port map(clk , MC_IN(15 downto 8),col2_3);

map5 : mu12 port map(clk , MC_IN(15 downto 8),col3_3);
map6 : mul3 port map(clk , MC_IN(7 downto 0),col3_4);

map7 : mu12 port map(clk , MC_IN(7 downto 0),col4_1);
map8 : mul3 port map(clk , MC_IN(31 downto 24),col4_4);


        

process(clk)
begin
   if rising_edge(clk) then 
        
      
        MC_OUT(31 downto 24) <= (((col1_1 xor col1_2) xor MC_IN(15 downto 8)) xor MC_IN(7 downto 0));
        MC_OUT(23 downto 16) <= (((MC_IN(31 downto 24) xor col2_2) xor col2_3) xor MC_IN(7 downto 0));
        MC_OUT(15 downto 8) <= (((MC_IN(31 downto 24) xor MC_IN(23 downto 16)) xor col3_3) xor col3_4);
        MC_OUT(7 downto 0) <= (((col4_1) xor MC_IN(23 downto 16)) xor MC_IN(15 downto 8) xor col4_4); 

    end if;
end process;





end default;
