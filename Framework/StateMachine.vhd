LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY StateMachine IS
    PORT ( CLK          : IN    STD_LOGIC;
           RESET        : IN    STD_LOGIC;
           ENABLE       : IN    STD_LOGIC;
           DONE         : OUT   STD_LOGIC;
           IR           : OUT   STD_LOGIC;
           RESET_RF     : OUT   STD_LOGIC;
           RESET_KS     : OUT   STD_LOGIC;
           ENABLE_RF    : OUT   STD_LOGIC;
           ENABLE_KS    : OUT   STD_LOGIC);
END StateMachine;

ARCHITECTURE Mealy OF StateMachine IS

    TYPE STATES IS (S_RESET, S_IDLE, S_ENCRYPT, S_DONE);
    SIGNAL STATE, NEXT_STATE : STATES;
    SIGNAL RESET_LFSR, ENABLE_LFSR, FEEDBACK_LFSR   : STD_LOGIC;
    SIGNAL LFSR                                     : STD_LOGIC_VECTOR(7 DOWNTO 0);
 
BEGIN

    PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF (RESET_LFSR = '1') THEN
                LFSR <= (0 => '0', OTHERS => '1');
            ELSIF (ENABLE_LFSR = '1') THEN
                LFSR <= LFSR(6 DOWNTO 0) & FEEDBACK_LFSR;
            END IF;
        END IF;
    END PROCESS;
    
    IR              <= LFSR(7);
    FEEDBACK_LFSR   <= LFSR(7) XOR LFSR(6) XOR LFSR(4) XOR LFSR(2);
	
	StateRegister : PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			IF (RESET = '1') THEN
				STATE	<= S_RESET;
			ELSE
				STATE <= NEXT_STATE;
			END IF;
		END IF;
	END PROCESS;
	
	OutputAndTransition : PROCESS(STATE, ENABLE, LFSR)
	BEGIN
	
        RESET_RF        <= '0';
        RESET_KS        <= '0';
        
        ENABLE_RF       <= '0';
        ENABLE_KS       <= '0';
        
        RESET_LFSR      <= '0';
        ENABLE_LFSR     <= '0';
                
        DONE            <= '0';
        
		NEXT_STATE		<= STATE;
		
		CASE STATE IS
		
			WHEN S_RESET	=>  RESET_RF        <= '1';
			                    RESET_KS        <= '1';
			                    RESET_LFSR      <= '1';
			                    NEXT_STATE      <= S_IDLE;
								
            WHEN S_IDLE     =>  IF (ENABLE = '1') THEN
                                    NEXT_STATE  <= S_ENCRYPT;
                                END IF;
								
            WHEN S_ENCRYPT  =>  ENABLE_RF       <= '1';
                                ENABLE_KS       <= '1';
                                ENABLE_LFSR     <= '1';
                                IF (LFSR = "01111111") THEN
                                    NEXT_STATE  <= S_DONE;
                                END IF;
								
            WHEN S_DONE     =>  DONE            <= '1';
                                IF (ENABLE = '0') THEN
                                    NEXT_STATE  <= S_IDLE;
                                END IF;
		END CASE;		
		
	END PROCESS;
	
END Mealy;