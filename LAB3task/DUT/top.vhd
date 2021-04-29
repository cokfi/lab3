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
		---------------------------------------------
		DATAout : out std_logic_vector(n-1 downto 0)
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	signal Input,One : std_logic;
	signal OPCin,OPC2,OPC1,Ld,Bin,Cout : std_logic;
	
begin
	L0 : Control port map(rst,clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout);
	L1 : Datapath generic map (n) port map(clk,OPCin,OPC2,OPC1,Ld,Bin,Cout,DATAin,Input,One,DATAout);

end arc_sys;