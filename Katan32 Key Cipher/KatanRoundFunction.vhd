LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY KatanRoundFunction IS
    PORT ( CLK  : IN  STD_LOGIC;
           RES  : IN STD_LOGIC;  
           EN   : IN  STD_LOGIC;
           IR   : IN  STD_LOGIC;
           K1   : IN  STD_LOGIC; -- K_(2i)
           K2   : IN  STD_LOGIC;  -- K_(2i+1)
           ROUND_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
           PT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END KatanRoundFunction;



-- ARCHITECTURE: DEFAULTARCHITECTURE
----------------------------------------------------------------------------------
ARCHITECTURE defaultArchitecture OF KatanRoundFunction IS

-- COMPONENTS
----------------------------------------------------------------------------------
COMPONENT ShiftRegister IS
    GENERIC (SIZE : POSITIVE := 8);
    PORT ( CLK  : IN  STD_LOGIC;
           RES  : IN STD_LOGIC; 
           EN   : IN  STD_LOGIC;
           D    : IN  STD_LOGIC;
           Q    : OUT STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0);
           PLAINTEXT : IN    STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0)
           );
END COMPONENT;

-- SIGNALS
----------------------------------------------------------------------------------
SIGNAL L1 : STD_LOGIC_VECTOR(12 DOWNTO 0) := (OTHERS => '0');
SIGNAL L2 : STD_LOGIC_VECTOR(18 DOWNTO 0) := (OTHERS => '0');
SIGNAL FB_L1, FB_L2 : STD_LOGIC;

BEGIN

    -- 13-BIT LINEAR FEEDBACK SHIFT REGISTER L1 ----------------------------------
    LFSR1 : ShiftRegister
    GENERIC MAP (SIZE => 13)
    PORT MAP (
    
        CLK => CLK,
        RES => RES,
        EN  => EN,
        D   => FB_L1,
        Q   => L1,
        PLAINTEXT =>PT(31 downto 19)
    );
    ------------------------------------------------------------------------------

    -- 19-BIT LINEAR FEEDBACK SHIFT REGISTER L2 ----------------------------------
    LFSR2 : ShiftRegister
    GENERIC MAP (SIZE => 19)
    PORT MAP (
        CLK => CLK,
        RES => RES,
        EN  => EN,
        D   => FB_L2,
        Q   => L2,
        PLAINTEXT =>PT(18 downto 0)
    );
    ------------------------------------------------------------------------------
   
    FB_L1 <=  ((((L2(12) xor L2(10)) xor L2(18))xor L2(7)) xor (L2(8) xor L2(3))) xor K2;  
    
    FB_L2 <=  (((L1(12) xor L1(7)) xor (L1(8) xor L1(5))) xor (L1(3) xor IR)) xor K1;
    
    ---------------------------------------------------------------------
    
    ROUND_OUT <=  L1&L2;
    
    
    
END defaultArchitecture;
