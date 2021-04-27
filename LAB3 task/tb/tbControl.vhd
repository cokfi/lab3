library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tbControl is
	constant n : integer := 8;
end tbControl;

architecture rtb of tb is
	signal rst,clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout : std_logic;
	
begin
    L0 : top generic map (n) port map(rst,clk,Input,One,OPCin,OPC2,OPC1,Ld,Bin,Cout);
--------- start of stimulus section ------------------	
        gen_clk : process
            begin
            clk <= '0';
            wait for 50 ns;
            clk <= not clk;
            wait for 50 ns;
        end process;

        SwitchInput : process
        begin
            Input <= '0';
            wait for 50 ns;--50ns
            Input <= '1'; 
            wait for 100 ns;--150ns
            Input <= '0';
            wait for 50 ns;--200ns
            Input <= '1';
        end process
        
        SwitchOne : process
        begin
            wait for 100 ns;--100ns
            One <= '1';
            wait for 150 ns;--250ns
            One <= '0';
            wait for 50 ns;--300
            One <= '1';
            wait for 100 ns;--400
            One <= '0';
            wait for 150 ns;--550ns
            One <= '1';