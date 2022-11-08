LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Basys3Framework is
    PORT ( CLK      : IN    STD_LOGIC;
	
           BUTTON   : IN    STD_LOGIC_VECTOR( 4 DOWNTO 0);
           SWITCH   : IN    STD_LOGIC_VECTOR(15 DOWNTO 0);
           LED      : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0);
           UART_RX  : IN    STD_LOGIC;
           UART_TX  : OUT   STD_LOGIC;
           enable_counter : in std_logic;
           CIPHER_SIGNAL_FOR_COUNTER : out std_logic );
END Basys3Framework;


ARCHITECTURE Structural OF Basys3Framework IS

    
    COMPONENT Katan32 IS
        PORT ( CLK          : IN    STD_LOGIC;
               RESET        : IN    STD_LOGIC;
               ENABLE       : IN    STD_LOGIC;
               DONE         : OUT   STD_LOGIC;
               KEY          : IN    STD_LOGIC_VECTOR(79 DOWNTO 0);
               PLAINTEXT    : IN    STD_LOGIC_VECTOR(31 DOWNTO 0);
               CIPHERTEXT   : OUT   STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT;

    COMPONENT RegisterSerPar is
        GENERIC ( SIZE_SER : POSITIVE := 8; SIZE_PAR : POSITIVE := 32);
        PORT ( CLK    : IN  STD_LOGIC;
               RST    : IN  STD_LOGIC;
               EN     : IN  STD_LOGIC;
               SEL    : IN  STD_LOGIC;
               DS     : IN  STD_LOGIC_VECTOR((SIZE_SER - 1) DOWNTO 0);
               DP     : IN  STD_LOGIC_VECTOR((SIZE_PAR - 1) DOWNTO 0);
               QS     : OUT STD_LOGIC_VECTOR((SIZE_SER - 1) DOWNTO 0);
               QP     : OUT STD_LOGIC_VECTOR((SIZE_PAR - 1) DOWNTO 0));
    END COMPONENT;
    
    COMPONENT uart IS
        PORT ( CLK          : IN    STD_LOGIC;
               RESET        : IN    STD_LOGIC;
               DATA_IN      : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
               TX_ENABLE    : IN    STD_LOGIC;
               TX_IDLE      : OUT   STD_LOGIC;
               TX_OUT       : OUT   STD_LOGIC;
               DATA_OUT     : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
               DATA_VALID   : OUT   STD_LOGIC;
               RX_IN        : IN    STD_LOGIC);
    END COMPONENT;
    
    COMPONENT MainControler IS
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
    END COMPONENT;
    
   SIGNAL PT_CONTROL, CT_CONTROL, K_CONTROL : STD_LOGIC_VECTOR( 2 DOWNTO 0);
   
   SIGNAL PLAINTEXT, CIPHERTEXT             : STD_LOGIC_VECTOR(31 DOWNTO 0);
   SIGNAL KEY                               : STD_LOGIC_VECTOR(79 DOWNTO 0);
   
   SIGNAL DATA_IN, DATA_OUT                 : STD_LOGIC_VECTOR( 7 DOWNTO 0);
   SIGNAL TX_ENABLE, TX_IDLE                : STD_LOGIC;
   SIGNAL DATA_VALID                        : STD_LOGIC;
   SIGNAL UART_RESET                        : STD_LOGIC;
   
   SIGNAL KATAN_ENABLE : STD_LOGIC;
  -- SIGNAL KATAN_RESET : STD_LOGIC;
   SIGNAL CIPHER_RESET, CIPHER_ENABLE, CIPHER_DONE  : STD_LOGIC;
   
BEGIN

    UARTInstance : uart
    PORT MAP (
        clk         => clk,
        reset       => UART_RESET,
        data_in     => DATA_IN,
        tx_enable   => TX_ENABLE,
        tx_idle     => TX_IDLE,
        tx_out      => UART_TX,
        data_out    => DATA_OUT,
        data_valid  => DATA_VALID,
        rx_in       => UART_RX
    );
	
    Register_Plaintext : RegisterSerPar
    GENERIC MAP (SIZE_SER => 8, SIZE_PAR => 32)
    PORT MAP (
        CLK => CLK,
        RST => PT_CONTROL(0),
        EN  => PT_CONTROL(1),
        SEL => PT_CONTROL(2),
        DS  => DATA_OUT,
        DP  => (OTHERS => '0'),
        QS  => OPEN,
        QP  => PLAINTEXT
    );
    
    Register_Key : RegisterSerPar
    GENERIC MAP (SIZE_SER => 8, SIZE_PAR => 80)
    PORT MAP (
        CLK => CLK,
        RST => K_CONTROL(0),
        EN  => K_CONTROL(1),
        SEL => K_CONTROL(2),
        DS  => DATA_OUT,
        DP  => (OTHERS => '0'),
        QS  => OPEN,
        QP  => KEY
    );
    
    Register_Ciphertext : RegisterSerPar
    GENERIC MAP (SIZE_SER => 8, SIZE_PAR => 32)
    PORT MAP (
        CLK => CLK,
        RST => CT_CONTROL(0),
        EN  => CT_CONTROL(1),
        SEL => CT_CONTROL(2),
        DS  => (OTHERS => '0'),
        DP  => CIPHERTEXT,
        QS  => DATA_IN,
        QP  => OPEN
    );
	
   KATAN_ENABLE <= CIPHER_ENABLE and SWITCH(0) and enable_counter;
   CIPHER_SIGNAL_FOR_COUNTER <= CIPHER_DONE;
   katanmap: Katan32 port map(
                              CLK=> CLK,
                              RESET => CIPHER_RESET,
                              ENABLE => KATAN_ENABLE,
                              DONE => CIPHER_DONE,
                              KEY =>KEY,
                              PLAINTEXT => PLAINTEXT,
                              CIPHERTEXT => CIPHERTEXT);

                
    FSM : MainControler
    PORT MAP (
        CLK             => CLK,
        UART_RESET      => UART_RESET,
        TX_ENABLE       => TX_ENABLE,
        TX_IDLE         => TX_IDLE,
        DATA_VALID      => DATA_VALID,
        CIPHER_RESET    => CIPHER_RESET,
        CIPHER_ENABLE   => CIPHER_ENABLE,
        CIPHER_DONE     => CIPHER_DONE,
        PT_CONTROL      => PT_CONTROL,
        CT_CONTROL      => CT_CONTROL,
        K_CONTROL       => K_CONTROL        
    );
    
END Structural;
