LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MainControler IS
    PORT ( CLK              : IN    STD_LOGIC;
           UART_RESET       : OUT   STD_LOGIC;
           TX_ENABLE        : OUT   STD_LOGIC;
           TX_IDLE          : IN    STD_LOGIC;
           DATA_VALID       : IN    STD_LOGIC;
           CIPHER_RESET     : OUT   STD_LOGIC;
           CIPHER_ENABLE    : OUT   STD_LOGIC;
           CIPHER_DONE      : IN    STD_LOGIC;
           PT_CONTROL       : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);
           CT_CONTROL       : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);
           K_CONTROL        : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0));
END MainControler;



ARCHITECTURE FSM OF MainControler IS

    TYPE STATES IS (S_RESET, S_IDLE, S_RECEIVE_PLAINTEXT, S_RECEIVE_KEY, S_INIT, S_ENCRYPT, S_SEND_CIPHERTEXT);
    SIGNAL CURRENT_STATE, NEXT_STATE : STATES := S_RESET;
    
    SIGNAL CNT_RST, CNT_EN  : STD_LOGIC;
    SIGNAL COUNT            : UNSIGNED(3 DOWNTO 0);

BEGIN

    Counter : PROCESS(CLK)
    BEGIN
        IF RISING_EDGE(CLK) THEN
            IF (CNT_RST = '1') THEN
                COUNT <= (OTHERS => '0');
            ELSIF (CNT_EN = '1') THEN
                COUNT <= COUNT + 1;
            END IF;
        END IF;
    END PROCESS;
	StateRegister : PROCESS(CLK)
	BEGIN
		IF RISING_EDGE(CLK) THEN
			CURRENT_STATE <= NEXT_STATE;
		END IF;
	END PROCESS;

        OutputAndTransition : PROCESS(CURRENT_STATE, DATA_VALID, COUNT, CIPHER_DONE)
        BEGIN
            PT_CONTROL      <= "000";
            CT_CONTROL      <= "000";
            K_CONTROL       <= "000";
            
            UART_RESET      <= '0';
            TX_ENABLE       <= '0';     
            
            CIPHER_RESET    <= '0';
            CIPHER_ENABLE   <= '0';
            
            CNT_RST         <= '0';
            CNT_EN          <= '0'; 
                  
            NEXT_STATE      <= CURRENT_STATE;
			
            CASE CURRENT_STATE IS
                ----------------------------------------------------------------------
                WHEN S_RESET                =>  UART_RESET          <= '1';
                                                NEXT_STATE          <= S_IDLE;
                ----------------------------------------------------------------------
                WHEN S_IDLE                 =>  CNT_RST             <= '1';
                                                
                                                NEXT_STATE          <= S_RECEIVE_PLAINTEXT;
                ----------------------------------------------------------------------
                WHEN S_RECEIVE_PLAINTEXT    =>  IF (DATA_VALID = '1') THEN
                                                    CNT_EN          <= '1'; 
                                                    PT_CONTROL(1)   <= '1';
                                                END IF;
                                                
                                                IF (COUNT = "0100") THEN
                                                    CNT_RST         <= '1';
                                                    NEXT_STATE      <= S_RECEIVE_KEY;
                                                END IF;
                ----------------------------------------------------------------------
                WHEN S_RECEIVE_KEY          =>  IF (DATA_VALID = '1') THEN
                                                    CNT_EN          <= '1'; 
                                                    K_CONTROL(1)    <= '1';
                                                END IF;
                                                
                                                IF (COUNT = "1010") THEN
                                                    CNT_RST         <= '1';
                                                    NEXT_STATE      <= S_INIT;
                                                END IF;       
                ----------------------------------------------------------------------
                WHEN S_INIT                 =>  CIPHER_RESET        <= '1';
                                                NEXT_STATE          <= S_ENCRYPT;                                                                                                
                ----------------------------------------------------------------------
                WHEN S_ENCRYPT              =>  CIPHER_ENABLE       <= '1';
                                                IF (CIPHER_DONE = '1') THEN
                                                    CT_CONTROL(1)   <= '1';
                                                    CT_CONTROL(2)   <= '1';
                                                    NEXT_STATE      <= S_SEND_CIPHERTEXT;
                                                END IF;
                ----------------------------------------------------------------------
                WHEN S_SEND_CIPHERTEXT      =>  TX_ENABLE           <= '1';
                
                                                IF (TX_IDLE = '1') THEN
                                                    CNT_EN          <= '1'; 
                                                    CT_CONTROL(1)   <= '1';
                                                END IF;
                                                
                                                IF (COUNT = "0100") THEN
                                                    CNT_RST         <= '1';
                                                    NEXT_STATE      <= S_IDLE;
                                                END IF;                                                
            END CASE;        
            --------------------------------------------------------------------------
            
        END PROCESS;
        ------------------------------------------------------------------------------
END FSM;
