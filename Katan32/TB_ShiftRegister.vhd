LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TB_ShiftRegister IS
END TB_ShiftRegister;

ARCHITECTURE Behavioral OF TB_ShiftRegister IS

    COMPONENT shift_ref IS
        GENERIC (SIZE : POSITIVE :=8 );
        PORT ( CLK  : IN  STD_LOGIC;
               EN   : IN  STD_LOGIC;
               D    : IN  STD_LOGIC;
               Q    : OUT STD_LOGIC);
    END COMPONENT;
    
    -- INPUTS --------------------------------------------------------------------
    SIGNAL CLK  : STD_LOGIC := '0';
    SIGNAL EN   : STD_LOGIC := '0';
    SIGNAL D    : STD_LOGIC := '0';
    
    -- OUTPUTS -------------------------------------------------------------------
    SIGNAL Q1,Q2    : STD_LOGIC;
    
    -- CLOCK PERIOD --------------------------------------------------------------
    CONSTANT CLK_PERIOD : TIME := 10 NS;
    
BEGIN

    UUT : entity work.shift_ref(Behavioral)
    GENERIC MAP (SIZE => 16)
    PORT MAP (CLK,EN,D,Q1);
    
    UUT2 : entity work.shift_ref(Structural)
        GENERIC MAP (SIZE => 16)
        PORT MAP (CLK,EN,D,Q2        );

    CLK_PROC : PROCESS
    BEGIN
        CLK <= '1'; WAIT FOR CLK_PERIOD/2;
        CLK <= '0'; WAIT FOR CLK_PERIOD/2;
    END PROCESS;
    
    STIM_PROC : PROCESS
    BEGIN
        WAIT FOR 100 NS;
        
        D <= '1';
        EN <= '1';
        
        WAIT;
    END PROCESS;

end Behavioral;
