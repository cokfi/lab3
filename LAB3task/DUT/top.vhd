LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------------------------------
entity top is
	generic (n : positive := 8 );
	port(
		rst,clk : in std_logic;
		DATAin  : in std_logic_vector(n-1 downto 0);
		----------------------------------------------
		DATAout : out std_logic_vector(n-1 downto 0);
		--------------------delete testing--------------------
		counter_out,reg_b_out,reg_c_out: out STD_LOGIC_VECTOR(n-1 downto 0); -- testing
		opc_out : out STD_LOGIC_VECTOR(2 downto 0);
		Input_out,One_out,OPCin_out,OPC2_out,OPC1_out,Ld_out,Bin_out,Cout_out:out std_logic
		------------------------------------------------------
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	signal Input,One : std_logic;
	signal OPCin,OPC2,OPC1,Ld,Bin,Cout : std_logic;
	
begin
	L0 : Control port map(rst,clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout);
	L1 : Datapath generic map (n) port map(clk,OPCin,OPC2,OPC1,Ld,Bin,Cout,DATAin,Input,One,DATAout,counter_out,reg_b_out,reg_c_out,opc_out);
	--------------------delete testing--------------------
	Input_out<=Input;
	One_out <=One;
	OPCin_out<=OPCin;
	OPC2_out<=OPC2;
	OPC1_out<=OPC1;
	Ld_out<= Ld;
	Bin_out<=Bin;
	Cout_out<= Cout;
	------------------------------------------------------


end arc_sys;