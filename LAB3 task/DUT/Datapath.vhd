LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity Datapath is
	generic (
		n : positive := 8 
	);
	port(
		clk : in std_logic;
		OPCin,OPC2,OPC1,Ld,Bin,Cout : in std_logic;
		DATAin  : in std_logic_vector(n-1 downto 0);
		---------------------------------------------
		Input,One : out std_logic;
		DATAout : out std_logic_vector(n-1 downto 0)
	);
end Datapath;
------------- complete the Datapath Unit Architecture code --------------
architecture arc_sys of Datapath is
signal reg_c,reg_b:STD_LOGIC_VECTOR(n-1 downto 0); 
signal reg_opc:STD_LOGIC_VECTOR(2 downto 0); 
begin
	One<= and DATAin ;


	


	
	
	
	
end arc_sys;







