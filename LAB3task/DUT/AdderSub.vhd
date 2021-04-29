LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
---------------AdderSubtractor----------------------
ENTITY AdderSub IS
  GENERIC (n : INTEGER := 8);
  PORT (    sctr: IN STD_LOGIC; -- subtractor control, '1' SUB , '0' ADD
			x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            --cout: OUT STD_LOGIC;-- carry out
            s: OUT STD_LOGIC_VECTOR(n-1 downto 0));-- Result
END AdderSub;
--------------------------------------------------------------
ARCHITECTURE dfl OF AdderSub IS
SIGNAL reg,xsigned,result : std_logic_vector(n-1 DOWNTO 0); -- reg for carries, xsigned = x if Adder / not(x) if Substractor 

BEGIN		
	Sign:	for i in 0 to n-1 generate
			xsigned(i) <= x(i) XOR sctr;
	end generate;
	
	first : FA port map(
			xi => xsigned(0),
			yi => y(0),
			cin => sctr,
			s => result(0),
			cout => reg(0)
	);
	
	
	rest : for i in 1 to n-1 generate
		chain : FA port map(
			xi => xsigned(i),
			yi => y(i),
			cin => reg(i-1),
			s => result(i),
			cout => reg(i)
		);
	end generate;
	s<= result;
	--cout <= ((reg(n-1))and not(sctr))or(sctr and result(n-1)); -- msb if subtractor, carry from the last FA if Adder

END dfl;

