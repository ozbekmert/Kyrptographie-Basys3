LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Katan32 IS
    PORT ( CLK          : IN    STD_LOGIC;
           RESET        : IN    STD_LOGIC;
           ENABLE       : IN    STD_LOGIC;
           DONE         : OUT   STD_LOGIC;
           KEY          : IN    STD_LOGIC_VECTOR(79 DOWNTO 0);
           PLAINTEXT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
           CIPHERTEXT   : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0));
END Katan32;

ARCHITECTURE Structural OF Katan32 IS

    COMPONENT RoundFunction IS
        PORT ( CLK          : IN    STD_LOGIC;
               RESET        : IN    STD_LOGIC;
               ENABLE       : IN    STD_LOGIC;
               IR           : IN    STD_LOGIC;
               KA           : IN    STD_LOGIC;
               KB           : IN    STD_LOGIC;
               PLAINTEXT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
               CIPHERTEXT   : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT KeySchedule IS
        PORT ( CLK          : IN    STD_LOGIC;
               RESET        : IN    STD_LOGIC;
               ENABLE       : IN    STD_LOGIC;
               KA           : OUT   STD_LOGIC;
               KB           : OUT   STD_LOGIC;
               KEY          : IN    STD_LOGIC_VECTOR(79 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT StateMachine IS
        PORT ( CLK          : IN    STD_LOGIC;
               RESET        : IN    STD_LOGIC;
               ENABLE       : IN    STD_LOGIC;
               DONE         : OUT   STD_LOGIC;
               IR           : OUT   STD_LOGIC;
               RESET_RF     : OUT   STD_LOGIC;
               RESET_KS     : OUT   STD_LOGIC;
               ENABLE_RF    : OUT   STD_LOGIC;
               ENABLE_KS    : OUT   STD_LOGIC);
    END COMPONENT;
    
    SIGNAL RESET_RF, RESET_KS   : STD_LOGIC;
    SIGNAL ENABLE_RF, ENABLE_KS : STD_LOGIC;
    SIGNAL KA, KB, IR           : STD_LOGIC;
 
BEGIN

    RF : RoundFunction
    PORT MAP (
        CLK         => CLK,
        RESET       => RESET_RF,
        ENABLE      => ENABLE_RF,
        IR          => IR,
        KA          => KA,
        KB          => KB,
        PLAINTEXT   => PLAINTEXT,
        CIPHERTEXT  => CIPHERTEXT
    );

    KS : KeySchedule
    PORT MAP (
        CLK         => CLK,
        RESET       => RESET_KS,
        ENABLE      => ENABLE_KS,
        KA          => KA,
        KB          => KB,
        KEY         => KEY
    );
    
    FSM : StateMachine
    PORT MAP (
        CLK         => CLK,
        RESET       => RESET,
        ENABLE      => ENABLE,
        DONE        => DONE,
        IR          => IR,
        RESET_RF    => RESET_RF,
        RESET_KS    => RESET_KS,
        ENABLE_RF   => ENABLE_RF,
        ENABLE_KS   => ENABLE_KS
    );
    
END Structural;