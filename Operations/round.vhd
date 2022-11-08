LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Round IS
	PORT ( CLK 		: IN  STD_LOGIC;
			 RST 		: IN  STD_LOGIC;
			 VALID 	: OUT STD_LOGIC;
			 H0IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H1IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H2IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H3IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H4IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H0OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H1OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H2OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H3OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 H4OUT 	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W0IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W1IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W2IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W3IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W4IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W5IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W6IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W7IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W8IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W9IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W10IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W11IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W12IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W13IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W14IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W15IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0));
END Round;



ARCHITECTURE Behavioral OF Round IS

COMPONENT Functions IS
	PORT ( CLK	: IN  STD_LOGIC;
         RST    : IN  STD_LOGIC;
         A  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
         B     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         B_SHIFT : out   STD_LOGIC_VECTOR (31 DOWNTO 0);
         C     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         D     : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
         F     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         F1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         K     : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         K1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
         SEL    : IN  STD_LOGIC_VECTOR ( 1 DOWNTO 0);
         SEL1    : IN  STD_LOGIC_VECTOR ( 1 DOWNTO 0)
                  
         );
END COMPONENT;

COMPONENT Shift IS
	PORT ( CLK 		: IN  STD_LOGIC;
			 RST 		: IN  STD_LOGIC;
			 W0IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W1IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W2IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W3IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W4IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W5IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W6IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W7IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W8IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W9IN 	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W10IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W11IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W12IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W13IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W14IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 W15IN	: IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
			 WOUT		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			 WOUT1		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));
END COMPONENT;


-- CONSTANTS
----------------------------------------------------------------------------------
CONSTANT CH0 : UNSIGNED(31 DOWNTO 0):=X"67452301";
CONSTANT CH1 : UNSIGNED(31 DOWNTO 0):=X"EFCDAB89";
CONSTANT CH2 : UNSIGNED(31 DOWNTO 0):=X"98BADCFE";
CONSTANT CH3 : UNSIGNED(31 DOWNTO 0):=X"10325476";
CONSTANT CH4 : UNSIGNED(31 DOWNTO 0):=X"C3D2E1F0";



-- SIGNALS
----------------------------------------------------------------------------------
SIGNAL A, B, C, D, E	: UNSIGNED(31 DOWNTO 0);
SIGNAL CNT				: UNSIGNED( 6 DOWNTO 0);

SIGNAL B_SHIFT : STD_LOGIC_VECTOR(31 DOWNTO 0);

SIGNAL F,F1, W,W1,K ,K1			: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL SEL,SEL1				: STD_LOGIC_VECTOR( 1 DOWNTO 0);


-- BEHAVIORAL
----------------------------------------------------------------------------------
BEGIN

	FunctionsInst : Functions
	PORT MAP(
		CLK	=> CLK,
		RST	=> RST,
		A       => STD_LOGIC_VECTOR(A),      
		B		=> STD_LOGIC_VECTOR(B),
		B_SHIFT => B_SHIFT,
		C		=> STD_LOGIC_VECTOR(C),
		D		=> STD_LOGIC_VECTOR(D),
		F		=> F,
		F1      => F1,  
		K		=> K,
		K1      => K1,  
		SEL	=> SEL,
		SEL1 => SEL1 
	);
	

	
	ShiftInst : Shift
	PORT MAP(
		CLK	=> CLK,
		RST	=> RST,
		W0IN	=> W0IN,
		W1IN	=> W1IN,
		W2IN	=> W2IN,
		W3IN	=> W3IN,
		W4IN	=> W4IN,
		W5IN	=> W5IN,
		W6IN	=> W6IN,
		W7IN	=> W7IN,
		W8IN	=> W8IN,
		W9IN	=> W9IN,
		W10IN => W10IN,
		W11IN => W11IN,
		W12IN => W12IN,
		W13IN => W13IN,
		W14IN => W14IN,
		W15IN => W15IN,
		WOUT	=> W,
		WOUT1	=> W1
	);

	SHA : PROCESS(CLK, RST)
	BEGIN
		IF RISING_EDGE(clk) THEN
			IF (RST = '1') THEN
				CNT	<= (OTHERS => '0');
				SEL	<= "00";
				A		<= CH0;
				B		<= CH1;
				C		<= CH2;
				D		<= CH3;
				E		<= CH4;
				VALID	<= '0';
			ELSE
				
				IF (CNT < 19) THEN
					SEL <= "00";
					SEL1 <="01";
				ELSIF (CNT < 39) THEN
					SEL <= "01";
					SEL1 <="10";
				ELSIF (CNT < 59) THEN
					SEL <= "10";
					SEL1 <="11";
				ELSE
					SEL <= "11";
					SEL1 <="00";
				END IF;
				
				IF (CNT < 80) THEN
				  A		   <=  (((A srl 5) + UNSIGNED(F)) srl 5) + (UNSIGNED(F1)+UNSIGNED(K1) + UNSIGNED(W1));
                  B        <=  (A srl 5) +UNSIGNED(F) + UNSIGNED(K) + UNSIGNED(W);
                  C        <=  (A srl 30);
                  D        <=  (B srl 30);
                  E        <=  C;
                  CNT    <= CNT +2;
                  					
				ELSE
					CNT	<= (OTHERS => '0');
					VALID	<= '1';
					H0OUT	<= STD_LOGIC_VECTOR(UNSIGNED(CH0) + A);
					H1OUT	<= STD_LOGIC_VECTOR(UNSIGNED(CH1) + B);
					H2OUT	<= STD_LOGIC_VECTOR(UNSIGNED(CH2) + C);
					H3OUT	<= STD_LOGIC_VECTOR(UNSIGNED(CH3) + D);
					H4OUT	<= STD_LOGIC_VECTOR(UNSIGNED(CH4) + E);
				END IF;
			END IF; -- RST
		END IF; -- CLK
	END PROCESS;

END Behavioral;

