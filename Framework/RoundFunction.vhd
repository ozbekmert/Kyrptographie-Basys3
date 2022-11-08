LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY RoundFunction IS
    PORT ( CLK          : IN    STD_LOGIC;
           RESET        : IN    STD_LOGIC;
           ENABLE       : IN    STD_LOGIC;
           IR           : IN    STD_LOGIC;
           KA           : IN    STD_LOGIC;
           KB           : IN    STD_LOGIC;
           PLAINTEXT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
           CIPHERTEXT   : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0));
END RoundFunction;



ARCHITECTURE Structural OF RoundFunction IS
    
    SIGNAL FB_L1, FB_L2 : STD_LOGIC;
    SIGNAL L1           : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL L2           : STD_LOGIC_VECTOR(18 DOWNTO 0);
 
BEGIN
    
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF (RESET = '1') THEN
                L1   <= PLAINTEXT(31 DOWNTO 19);
            ELSIF (ENABLE = '1') THEN
                L1  <= L1(11 DOWNTO 0) & FB_L1;
            END IF;
        END IF;
    END PROCESS;
    
    FB_L1 <= KB XOR (L2(3) AND L2(8)) XOR (L2(10) AND L2(12)) XOR L2(7) XOR L2(18);
    
    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF (RESET = '1') THEN
                L2   <= PLAINTEXT(18 DOWNTO 0);
            ELSIF (ENABLE = '1') THEN
                L2  <= L2(17 DOWNTO 0) & FB_L2;
            END IF;
        END IF;
    END PROCESS;

    FB_L2 <= KA XOR (L1(3) AND IR) XOR (L1(5) AND L1(8)) XOR L1(7) XOR L1(12);
    
    CIPHERTEXT <= L1 & L2;
    
END Structural;