LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY KeySchedule IS
    PORT ( CLK          : IN    STD_LOGIC;
           RESET        : IN    STD_LOGIC;
           ENABLE       : IN    STD_LOGIC;
           KA           : OUT   STD_LOGIC;
           KB           : OUT   STD_LOGIC;
           KEY          : IN    STD_LOGIC_VECTOR(79 DOWNTO 0));
END KeySchedule;


ARCHITECTURE Structural OF KeySchedule IS
    
    SIGNAL FB0, FB1 : STD_LOGIC;
    SIGNAL STATE    : STD_LOGIC_VECTOR(79 DOWNTO 0);
    
BEGIN

    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF (RESET = '1') THEN
                STATE   <= KEY;
            ELSIF (ENABLE = '1') THEN
                STATE   <= STATE(77 DOWNTO 0) & FB0 & FB1;
            END IF;
        END IF;
    END PROCESS;
   
    -- FEEDBACKS -----------------------------------------------------------------
    FB0 <= STATE(79) XOR STATE(60) XOR STATE(49) XOR STATE(12);
    FB1 <= STATE(78) XOR STATE(59) XOR STATE(48) XOR STATE(11);
    
    -- ROUND KEYS ----------------------------------------------------------------
    KA <= STATE(79);
    KB <= STATE(78);
    
END Structural;