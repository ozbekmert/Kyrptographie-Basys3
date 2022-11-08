library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity AESStateMachine_3PROC is port ( 
           CLK          : IN    STD_LOGIC;
           -- EXTERNAL CONTROL SIGNAL PORTS ------------------
           RESET        : IN    STD_LOGIC;
           ENABLE       : IN    STD_LOGIC;
           DONE         : OUT   STD_LOGIC;
           -- INTERNAL CONTROL SIGNAL PORTS ------------------
           RESET_RF     : OUT   STD_LOGIC;
           RESET_KS     : OUT   STD_LOGIC;
           ENABLE_RF    : OUT   STD_LOGIC;
           ENABLE_KS    : OUT   STD_LOGIC;
           FINAL_RF     : OUT   STD_LOGIC;
           -- ROUND COUNTER ----------------------------------
           ROUND        : OUT   STD_LOGIC_VECTOR (3 DOWNTO 0)
);
end AESStateMachine_3PROC;

architecture Behavioral of AESStateMachine_3PROC is
type STATES is (S_IDLE,S_INIT,S_KEYSCHEDULE,S_RUNDENFUNKTION,S_FINAL,S_DONE);
signal current_s, next_s : STATES;  
signal cnt_unsigned: unsigned (3 downto 0);

begin
-- STATE REGISTER PROCESS --------------------------------------
STATE_REGISTER_PROCESS:process (CLK,ENABLE)  
begin
if (ENABLE = '1') then
     if (reset='1') then -- Synchronous Reset and ENABLE
            current_s <= S_INIT;  --default state on reset see above state info.              
    elsif (rising_edge(clk)) then
      current_s <= next_s;   --state change.
    end if;
 elsif(ENABLE = '0') then   
     current_s <= S_IDLE;  --IDLE State
end if;
end process;

-- STATE TRANSITION PROCESS ------------------------------------
STATE_TRANSITION_PROCESS: process(current_s)
begin 
     next_s <=  current_s ;
 case current_s is
     when S_INIT =>
            next_s <= S_KEYSCHEDULE;
     when S_KEYSCHEDULE => 
                 next_s <= S_RUNDENFUNKTION;                
     when S_RUNDENFUNKTION => 
            if (cnt_unsigned < 10) then        
                 next_s <= S_KEYSCHEDULE;
             elsif(cnt_unsigned = 10) then
                 next_s <= S_FINAL;  
             end if;
     when S_FINAL =>         
             next_s <= S_DONE; 
     when S_DONE =>
             next_s <=S_INIT;     
     when others =>
             next_s <=S_INIT;                                                  
end case;
end process;

-- OUTPUT SIGNAL PROCESS ---------------------------------------
OUTPUT_SIGNAL_PROCESS: process(current_s)
begin
case current_s is
when S_IDLE => 
            ENABLE_RF <= '0';
            ENABLE_KS <= '0';   
when S_INIT =>
            ENABLE_RF <= '0';
            ENABLE_KS <= '0';   
            RESET_RF <= '1';
            RESET_KS <= '1';
            FINAL_RF <= '0';
            cnt_unsigned <= x"0";
            DONE<= '0';

when S_KEYSCHEDULE => 
           ENABLE_RF <= '0';
           ENABLE_KS <= '1';   
           RESET_RF <= '0';
           RESET_KS <= '0'; 

 --  Key-Schedule is not available
when S_RUNDENFUNKTION => 
           ENABLE_RF <= '1';
           ENABLE_KS <= '1';   
           RESET_RF <= '0';
           RESET_KS <= '0';
           cnt_unsigned <= cnt_unsigned +1;                 
 --  AES-Rundenfunction is not available 
 when S_FINAL =>
            FINAL_RF <= '1';  
           
when S_DONE =>
        
         DONE <= '1';                 
end case;
end process;


ROUND <= std_logic_vector (cnt_unsigned);

end Behavioral;