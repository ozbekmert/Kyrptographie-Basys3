LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Katan32 IS
    PORT ( CLK  : IN  STD_LOGIC;
           EN   : IN  STD_LOGIC;
           IR   : IN  STD_LOGIC;
           K1   : IN  STD_LOGIC; -- K_(2i)
           K2   : IN  STD_LOGIC  -- K_(2i+1)
	);
END Katan32;

ARCHITECTURE defaultArchitecture OF Katan32 IS
signal Q1,Q2 : std_logic;

signal Qx,Qy : std_logic;
signal L1 : std_logic_vector(12 downto 0);
signal L2 : std_logic_vector(18 downto 0);

COMPONENT shift_ref IS
        GENERIC (SIZE : POSITIVE :=8 );
        PORT ( CLK  : IN  STD_LOGIC;
               EN   : IN  STD_LOGIC;
               D    : IN  STD_LOGIC;
               Q    : OUT STD_LOGIC;
               reg_data: out std_logic_vector(SIZE-1 downto 0));
    END COMPONENT;
BEGIN

UUT1 : entity work.shift_ref(Behavioral)
    GENERIC MAP (SIZE => 13)
    PORT MAP (CLK,EN,Q1,Qx,L1);
UUT2 : entity work.shift_ref(Behavioral)
        GENERIC MAP (SIZE => 19)
    PORT MAP (CLK,EN,Q2,Qy,L2);
    

 
 Q1 <= (((L2(3)and L2(8))xor L2(7)) xor (L2(10)and L2(12)) xor L2(18)) xor K1;
 Q2 <= ((L1(3) and IR)  xor (((L1(5) and L1(8)) xor L1(7)) xor L1(12) )) xor K2;
 
 

END defaultArchitecture;
