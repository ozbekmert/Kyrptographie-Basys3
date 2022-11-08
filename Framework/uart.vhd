LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY uart IS
    PORT ( clk                      : IN    STD_LOGIC;
           reset                    : IN    STD_LOGIC;
           data_in                  : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
           tx_enable                : IN    STD_LOGIC;
           tx_idle                  : OUT   STD_LOGIC;
           tx_out                   : OUT   STD_LOGIC;
           data_out                 : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
           data_valid               : OUT   STD_LOGIC;
           rx_in                    : IN    STD_LOGIC);
END uart;

ARCHITECTURE Structural OF uart IS

    COMPONENT pc_uart_receive IS
        PORT ( clk              : IN    STD_LOGIC;
               reset            : IN    STD_LOGIC;
               rs232_bit        : IN    STD_LOGIC;
               data_out         : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
               data_valid       : OUT   STD_LOGIC);
    END COMPONENT;
    
    COMPONENT pc_uart_send IS
        PORT ( clk              : IN    STD_LOGIC;
               reset            : IN    STD_LOGIC;
               data_in          : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
               rs232_bit        : OUT   STD_LOGIC;
               send_enable      : IN    STD_LOGIC;
               ready_for_data   : OUT   STD_LOGIC);
    END COMPONENT;

BEGIN

    uart_receiver : pc_uart_receive
    PORT MAP (
        clk => clk,
        reset => reset,
        rs232_bit => rx_in,
        data_out => data_out,
        data_valid => data_valid
    );
     
    uart_sender : pc_uart_send
    PORT MAP (
        clk => clk,
        reset => reset,
        data_in => data_in,
        rs232_bit => tx_out,
        send_enable => tx_enable,
        ready_for_data => tx_idle
    );

END Structural;

