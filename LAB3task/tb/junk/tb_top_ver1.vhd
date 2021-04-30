library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
USE work.aux_package.all;

entity top_tb is
	generic ( T : time := 50 ns);--Period time (switching every 25 ns)
    constant n : integer := 8 ;
end top_tb;
----------------inputs/outputs---------------------------------------
architecture ttb of top_tb is
	signal clk,rst : std_logic;
	signal DATAin, DATAout : std_logic_vector(n-1 downto 0); 
    --signal Cout_spy : std_logic :='0'; --signal to follow Cout inside top
----------------read/write signals-----------------------------------
    signal TrigR : boolean := true;--triggers reading from input file
    signal done : boolean := false;--turns true when reaching end of input file
    constant read_file_location : string(1 to 56) :="C:\Users\kfir\Documents\VHDL\lab3\LAB3task\inputFile.txt";
    constant write_file_location : string(1 to 57) :="C:\Users\kfir\Documents\VHDL\lab3\LAB3task\outputFile.txt";
    --variable idx_counter : integer :=0;
    --variable number_of_numbers : integer;  
    begin
    L0 : top generic map (n) port map(clk,rst,DATAin,DATAout);
    --Cout_spy <= <<signal .top_tb.top.Control.Cout : std_logic>>; -- '<< >>' calls for internal signals
    
    reset : process
        begin
		  rst <= '1';
		  wait for 5 ns ; --T/2 = 25 ns
		  rst <= not rst;
		  wait;
        end process;
    gen_clk : process
        begin
		  clk <= '0';
		  wait for T/2 ; --T/2 = 25 ns
		  clk <= not clk;
		  wait for T/2 ;
        end process;
    
    gen_TrigR : process --TrigR= clk(t-T/4), T=100ns => T/4=25 ns => TrigR=clk(t-25)
        begin
            TrigR<= true;
            wait for T/4 ; --T/4 = 12.5 ns
            TrigR<=not(TrigR); -- =0
            wait for T/2 ; -- T/2 = 25 ns
            TrigR<=not(TrigR); -- =1
            wait for T/4 ; --T/4 = 12.5 ns
        end process;
    
    ReadTrigger : process -- reading is triggered by TrigR rising edge
        file infile : text open read_mode is read_file_location;
        variable L : line;
        variable datainV : integer;
    begin
        --if (TrigR'event and TrigR='1') then -- rising edge
            --wait for 25 ns;
                readline(infile,L); -- save line   
                while (not endfile(infile)) loop--check if reached the end of input file
                    read(L,datainV); -- read element from line to datain
                    wait until (TrigR'event and TrigR=true);--Triggered by TrigR
                    DATAin<=conv_std_logic_vector(datainV, n);
                end loop;
                --if (datainV/=0) then
                --    idx_counter:= idx_counter+1;
                --    if (idx_counter=2) then
                --        number_of_numbers:= datainV;
                --    elsif (idx_counter>2) then
                --        number_of_numbers = number_of_numbers-1;
                --    end if;
                --end if;
            if (endfile(infile)) then   -- if reached the end of file
                done <= true;
                file_close(infile);
                report "end of input file" severity note;
                wait;
            end if;

        --end if;
    end process;

   
    
    WriteTrigger : process(DATAout)--triggered by DATAout 
        file outfile : text open write_mode is write_file_location;
        variable outline : line;
        begin
        write(outline, conv_integer(signed(DATAout)));
        writeline(outfile,outline);
            if (done = true) then
                file_close(outfile);
                report "finished writing to output file" severity note;
            end if;
        end process;
end ttb;