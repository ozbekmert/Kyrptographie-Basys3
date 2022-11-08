library ieee;
use ieee.std_logic_1164.all;

entity shift_ref is
  generic
  (
     SIZE : POSITIVE :=8
  );
  port   
  (
     CLK  : IN  STD_LOGIC;
     EN   : IN  STD_LOGIC;
     D    : IN  STD_LOGIC;
     Q    : OUT STD_LOGIC;
     reg_data : out std_logic_vector(SIZE-1 downto 0) 
    );
end shift_ref;

architecture behavioral of shift_ref is
  signal temp_reg_behv: std_logic_vector(SIZE-1 downto 0) := (Others => '0');
begin
  process (CLK)
  begin
   if rising_edge(CLK) then
      if (EN ='1') then
          temp_reg_behv(0) <= D;
          Q <= temp_reg_behv(SIZE-1);
          temp_reg_behv(SIZE-1 downto 1) <= temp_reg_behv(SIZE-2 downto 0 );
       else
           temp_reg_behv(0) <= '0';
           Q <= temp_reg_behv(SIZE-1);
           temp_reg_behv(SIZE-1 downto 1) <= temp_reg_behv(SIZE-2 downto 0 );
      end if;
    end if;
  end process;
  
  reg_data <= temp_reg_behv;
  
end behavioral;

architecture Structural of shift_ref is
signal temp_reg_str: std_logic_vector(SIZE-1 downto 0) := (Others => '0') ;

component DFF port
(
    CLK : in std_logic;
    EN  : in std_logic;
    D   : in std_logic;
    Q   : out std_logic
);
end component;

begin


temp_reg_str(0) <= D;

Q1:for I in 0 to SIZE-1 generate
       
       
        Q2:if I=0 generate
                    DFFfirst:DFF port map(CLK,EN,temp_reg_str(0),temp_reg_str(1));
        end generate;
        Q3:if I=SIZE-1 generate
                    DFFlast:DFF port map(CLK,EN,temp_reg_str(I-1),temp_reg_str(I));
        end generate;
        Q4:if I>0 and I<SIZE-1 generate
                 DFFx:DFF port map(CLK,EN,temp_reg_str(I),temp_reg_str(I+1));
        end generate;
end generate;

Q <= temp_reg_str(SIZE-1);
reg_data <= temp_reg_str;



 
end Structural;
