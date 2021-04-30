LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-----------------------------------------------------------------------
entity Control is
	port(
		rst,clk : in std_logic;
		Input,One : in std_logic;
		
		OPCin,OPC2,OPC1,Ld,Bin,Cout : out std_logic
	);
end Control;
------------- complete the Control Unit Architecture code --------------
architecture arc_sys of Control is
	type state is (Idle,SetN,First,Operate,Last,Done); 
	signal state: state;
begin
----Lower Section:-------------
	process(rst,clk)
	begin
		if (rst='1') then
			pr_state <= Idle;
		elsif (clk'event and clk='1') then
			pr_state <= nx_state;
		end if;
	end process;
----Upper Section:-------------
	process(Input,One,pr_state)
	begin 
			case pr_state is 
				when Idle =>
					OPCin<='1';
					OPC2<='0';
					OPC1<='0';
					Ld<='1';
					Bin<='0';
					Cout<='0';
					if (Input='1') then
						nx_state <= SetN;	
					else
						nx_state <= Idle;
					end if;
				
				when SetN =>
					OPCin<='0';
					OPC2<='0';
					OPC1<='0';
					Ld<='1';
					Bin<='0';
					Cout<='0';
					nx_state <= First;
							
				when First =>
					OPCin<='0';
					OPC2<='0';
					OPC1<='1';
					Ld<='0';
					Bin<='1';
					Cout<='0';
					if (One='0') then
						nx_state<=Operate;
					else
						nx_state<=Last;
					end if;

				when Operate =>
					OPCin<='0';
					OPC2<='1';
					OPC1<='0';
					Ld<='0';
					Bin<='1';
					Cout<='0';
					if (One='0') then
						nx_state<=Operate;
					else
						nx_state<=Last;
					end if;
				
                    when Last => 
                    OPCin<='0';
					OPC2<='1';
					OPC1<='0';
					Ld<='0';
					Bin<='1';
					Cout<='0';
                    nx_state <= Done;

                    when Done =>
					OPCin<='1';
					OPC2<='0';
					OPC1<='0';
					Ld<='0';
					Bin<='0';
					Cout<='1';
					if (Input='1') then
						nx_state<=SetN;
					else
						nx_state<=Idle;
					end if;
			end case;
	end process;
end arc_sys;







