LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ShiftRegister IS
    GENERIC (SIZE : POSITIVE := 8);
    PORT ( CLK  : IN  STD_LOGIC;
           RES  : IN STD_LOGIC; 
           EN   : IN  STD_LOGIC;
           D    : IN  STD_LOGIC;
           Q    : OUT STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0);
           PLAINTEXT : IN STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0)
);
END ShiftRegister;
ARCHITECTURE Behavioral OF ShiftRegister IS

SIGNAL STATE : STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0) := (OTHERS => '0');

BEGIN
    
    SR : PROCESS(CLK)
    BEGIN

    if(RES = '1') then
        STATE((SIZE - 1) DOWNTO 0) <= PLAINTEXT;
    elsif(RES = '0') then
        IF RISING_EDGE(CLK) THEN
            IF (EN = '1') THEN
                STATE <= STATE((SIZE - 2) DOWNTO 0) & D;
            END IF;
        END IF;   
     end if;     
    END PROCESS;
    
    Q <= STATE;
    
END Behavioral;
