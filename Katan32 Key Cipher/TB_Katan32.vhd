LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TB_Katan32 IS
END TB_Katan32;

ARCHITECTURE Testbench OF TB_Katan32 IS

    COMPONENT Katan32 IS
        PORT ( CLK          : IN    STD_LOGIC;
               RESET        : IN    STD_LOGIC;
               ENABLE       : IN    STD_LOGIC;
               DONE         : OUT   STD_LOGIC;
               KEY          : IN    STD_LOGIC_VECTOR(79 DOWNTO 0);
               PLAINTEXT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
               CIPHERTEXT   : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    -- INPUTS --------------------------------------------------------------------
    SIGNAL CLK          : STD_LOGIC := '0';
    SIGNAL RESET        : STD_LOGIC := '0';
    SIGNAL ENABLE       : STD_LOGIC := '0';
    SIGNAL KEY          : STD_LOGIC_VECTOR(79 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PLAINTEXT    : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    
    -- OUTPUTS -------------------------------------------------------------------
    SIGNAL DONE         : STD_LOGIC;
    SIGNAL CIPHERTEXT   : STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 10 NS;
    
BEGIN

    UUT : Katan32
    PORT MAP (
        CLK         => CLK,
        RESET       => RESET,
        ENABLE      => ENABLE,
        DONE        => DONE,
        KEY         => KEY,
        PLAINTEXT   => PLAINTEXT,
        CIPHERTEXT  => CIPHERTEXT
    );
    ------------------------------------------------------------------------------
    
    -- CLOCK PROCESS -------------------------------------------------------------
    CLK_PROC : PROCESS
    BEGIN
        CLK <= '1'; WAIT FOR CLK_PERIOD/2;
        CLK <= '0'; WAIT FOR CLK_PERIOD/2;
    END PROCESS;
    ------------------------------------------------------------------------------
    
    -- STIMULUS PROCESS ----------------------------------------------------------
    STIM_PROC : PROCESS
    BEGIN
        PLAINTEXT   <= (OTHERS => '0');
        KEY         <= (OTHERS => '1');
            
        RESET       <= '1';
            WAIT FOR 100 NS;
        RESET       <= '0';
        
        ENABLE      <= '1';
            WAIT UNTIL (DONE = '1');
        ENABLE      <= '0';
        
        ASSERT CIPHERTEXT = X"7E1FF945" REPORT "WRONG RESULT" SEVERITY WARNING; -- DONE geht erst nach ca. 2650 ns auf HIGH; Simulation so lange laufen lassen!
        
        WAIT;
    END PROCESS;
    ------------------------------------------------------------------------------
    
END Testbench;
