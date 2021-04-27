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
signal reg_c,reg_b,ALUout:STD_LOGIC_VECTOR(n-1 downto 0); 
signal reg_opc,ALUFN:STD_LOGIC_VECTOR(2 downto 0); 
signal enable_dec,A std_logic;
alias Opcode :std_logic_vector(2 downto 0) is DATAin(2 downto 0);
);
begin
	One<= and DATAin ;
	ALUFN<= reg_opc when(OPC2='1') else "ZZZ";
	A<='1' when (OPC1='1') else 'Z';
	
------------------------counter process--------------------------
d_counter : process(clk)
begin
	if (clk'event and clk='1') then -- rising edge
		if (Ld ='1') then
			counter <=DATAin;
		elsif (Ld ='0') then
			counter <= counter -1;
		end if;	
	end if;
end process;
------------------------Registers process--------------------------
reg_opc_proc : process(clk)
begin
	if (clk'event and clk='1') then -- rising edge
		if (OPCin='1')
			reg_opc <=Opcode;
		end if;
		if (Bin='1')
			reg_b <=ALUout;
	end if;
	end if;
end process;
	


	
	
	
	
end arc_sys;







