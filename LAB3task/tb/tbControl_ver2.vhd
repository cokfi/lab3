library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tbControl is
	constant n : integer := 8;
end tbControl;

architecture ctb of tbControl is
	signal rst,clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout : std_logic;
	
begin
    L0 : Control port map(rst,clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout);
        
--------- start of stimulus section ------------------	
        reset_init : process
            begin
            rst <= '1';
            wait for 5 ns;
            rst<='0';
            wait;
            end process;

        gen_clk : process
            begin
            clk <= '1';
            wait for 25 ns;
            clk <= not clk;
            wait for 25 ns;
        end process;

        SwitchInput : process
        begin
            Input <= '0';
            wait for 62.5 ns;--50ns
            Input <= '1'; 
            wait for 500 ns;--550ns
            Input <= '0';
            wait;
        end process;
        
        SwitchOne : process
        begin
            One <= 'U';
            wait for 250 ns;--250ns
            One <= '1';
            wait;
        end process;
end ctb ;