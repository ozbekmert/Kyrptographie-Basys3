----------------------------------------------------------------------------------
-- COPYRIGHT (c) 2016 ALL RIGHT RESERVED
--
-- KRYPTOGRAPHIE AUF PROGRAMMIERBARER HARDWARE: UEBUNG 2
-- AUTHOR: TOBIAS ODER
----------------------------------------------------------------------------------



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY Katan32_TB IS
END Katan32_TB;



-- ARCHITECTURE: TESTBENCH
----------------------------------------------------------------------------------
ARCHITECTURE Testbench OF Katan32_TB IS

    -- COMPONENTS ----------------------------------------------------------------
    COMPONENT Katan32 IS
        PORT ( CLK  : IN  STD_LOGIC;
               EN   : IN  STD_LOGIC;
               IR   : IN  STD_LOGIC;
               K1   : IN  STD_LOGIC; -- K_(2i)
               K2   : IN  STD_LOGIC  -- K_(2i+1)
        );
    END COMPONENT;
    
    -- INPUTS --------------------------------------------------------------------
    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL EN : STD_LOGIC := '0';
    SIGNAL IR : STD_LOGIC := '0';
    SIGNAL K1 : STD_LOGIC := '0';
    SIGNAL K2 : STD_LOGIC := '0';
    
    -- CLOCK PERIOD --------------------------------------------------------------
    CONSTANT CLK_PERIOD : TIME := 10 NS;
    
    -- AUX. SIGNAL ---------------------------------------------------------------
    SIGNAL DONE : STD_LOGIC := '0';
        
BEGIN

    UUT : Katan32 PORT MAP (CLK, EN, IR, K1, K2);
    
    CLK_PROC : PROCESS
    BEGIN
        CLK <= '1'; WAIT FOR CLK_PERIOD/2;
        CLK <= '0'; WAIT FOR CLK_PERIOD/2;
    END PROCESS;
    
    STIM : PROCESS
    BEGIN
        WAIT FOR 100 NS;
        
        EN <= '1';
        IR <= '1';
        K1 <= '1';
        K2 <= '1';
        
        WAIT FOR 80*CLK_PERIOD;
        
        DONE <= '1';
                
        --Der Ciphertext ist der Zustand der Schieberegister und diese sollten nach 80 Taktzyklen den Wert 0x17F5 bzw. 0x216C9 haben.
        
        WAIT;
    END PROCESS;


end Testbench;
