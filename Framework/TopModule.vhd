LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity TopModule is
PORT (      
           CLK      : IN    STD_LOGIC;
           --BUTTON   : IN    STD_LOGIC_VECTOR( 4 DOWNTO 0);
           SWITCH   : IN    STD_LOGIC;
           LED      : OUT   STD_LOGIC;
           UART_RX  : IN    STD_LOGIC;
           UART_TX  : OUT   STD_LOGIC
           );
end TopModule;

architecture Behavioral of TopModule is

component Basys3Framework is
    PORT ( CLK      : IN    STD_LOGIC;
         
           BUTTON   : IN    STD_LOGIC_VECTOR( 4 DOWNTO 0);
           SWITCH   : IN    STD_LOGIC_VECTOR(15 DOWNTO 0);
           LED      : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0);
           UART_RX  : IN    STD_LOGIC;
           UART_TX  : OUT   STD_LOGIC;
           enable_counter : in std_logic;
           CIPHER_SIGNAL_FOR_COUNTER : out    STD_LOGIC);
END component;


component ClockDivider is port 
(
    clk: in std_logic;
    enable : in std_logic;
    clk_out_1Hz : out std_logic
 );
end component;

signal enable : std_logic;
signal counter : unsigned(2 downto 0) := "000";
signal CIPHER_SIGNAL_FOR_COUNTER : std_logic;
signal enable_counter :  std_logic := '1';

signal bt_unused   : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal sw_unused   : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal led_unused  : STD_LOGIC_VECTOR(15 DOWNTO 0);


begin

led1Hz: ClockDivider port map(clk,enable,LED);
map_Basys3Framework: Basys3Framework port map(
                                               CLK =>CLK,
                                               BUTTON => bt_unused,
                                               SWITCH => sw_unused,
                                               LED => led_unused,
                                               UART_RX => UART_RX,
                                               UART_TX => UART_TX,
                                               enable_counter => enable_counter,
                                               CIPHER_SIGNAL_FOR_COUNTER => CIPHER_SIGNAL_FOR_COUNTER
                                               );
                                               
                                               


sw_unused <= ("000000000000000" & SWITCH);



process(CIPHER_SIGNAL_FOR_COUNTER)
begin
    if(rising_edge(CIPHER_SIGNAL_FOR_COUNTER))then
    
        if(counter <= 5) then
                enable <= '0';
                enable_counter <= '1';
                counter <= counter +1;  
            else
                enable <= '1';
                enable_counter <= '0';
            end if;
    end if;
end process;






end Behavioral;
