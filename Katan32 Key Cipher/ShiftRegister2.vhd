LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY ShiftRegister2 IS
    GENERIC (SIZE : POSITIVE := 8);
    PORT ( CLK  : IN  STD_LOGIC;
           RES  : IN STD_LOGIC;
           KEY  : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
           EN   : IN  STD_LOGIC;
           D1   : IN  STD_LOGIC;
           D2   : IN STD_LOGIC;
           Q    : OUT STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0));
END ShiftRegister2;

ARCHITECTURE Behavioral OF ShiftRegister2 IS

SIGNAL STATE : STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0) := (OTHERS => '0');

BEGIN
    
    SR : PROCESS(CLK)
    BEGIN 
    if(RES = '1') then
            STATE <= KEY;      
    elsif(RES = '0') then
            IF (clk = '1') THEN
              --if (rising_edge(clk)) then
                IF (EN = '1') THEN
                    --STATE <= STATE((SIZE - 3) DOWNTO 0) & D2 & D1;   
                     STATE <= STATE((SIZE - 2) DOWNTO 0) & D2;          
                END IF;
            ELSIF(clk = '0') THEN
                IF (EN = '1') THEN
                 STATE <= STATE((SIZE - 2) DOWNTO 0) & D1;
                END IF;           
            END IF;
        END IF;        
--      end if;          
    END PROCESS;
    
    Q <= STATE;
    
END Behavioral;