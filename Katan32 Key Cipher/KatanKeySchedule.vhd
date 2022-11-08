library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity KatanKeySchedule is  port 
(
           CLK  : IN  STD_LOGIC;
           EN   : IN  STD_LOGIC;
           RES  : IN STD_LOGIC;
           KEY  : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
           Q    : OUT STD_LOGIC_VECTOR(79 DOWNTO 0) 

 );
end KatanKeySchedule;

architecture Behavioral of KatanKeySchedule is
COMPONENT ShiftRegister2 IS
    GENERIC (SIZE : POSITIVE := 80);
    PORT ( CLK  : IN  STD_LOGIC;
           RES  : IN STD_LOGIC;
           KEY  : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
           EN   : IN  STD_LOGIC;
           D1   : IN  STD_LOGIC;
           D2   : IN STD_LOGIC;
           Q    : OUT STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0));
END COMPONENT;

signal FB_0 : std_logic;
signal FB_1 : std_logic;
SIGNAL L80 : STD_LOGIC_VECTOR(79 DOWNTO 0) := (OTHERS => '0');

begin
LFSR_80BIT : ShiftRegister2
    GENERIC MAP (SIZE => 80)
    PORT MAP (
        CLK => CLK,
        RES => RES,
        KEY => KEY,
        EN  => EN,
        D1   => FB_0,
        D2   => FB_1,
        Q   => L80
    );        
FB_1 <= (((L80(79) xor L80(60)) XOR L80(49)) XOR L80(12));
FB_0 <= (((L80(78) xor L80(59)) XOR L80(48)) XOR L80(11));

Q <= L80;
end Behavioral;
