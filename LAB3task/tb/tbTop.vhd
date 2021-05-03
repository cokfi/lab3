library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;
USE work.aux_package.all;

entity top_tb is
	generic ( T : time := 50 ns);--Period time (switching every 25 ns)
    constant n : integer := 32 ;
end top_tb;
architecture ttb of top_tb is

--inputs/outputs:
	signal rst : std_logic;
    signal clk:std_logic:='0';
	signal DATAin, DATAout : std_logic_vector(n-1 downto 0); 
--read/write signals:


    signal TrigR : std_logic;                       --triggers reading from input file
    signal done : std_logic:='0';                 --turns '1' when reaching end of input file
    constant read_file_location : string(1 to 56) :=
    "C:\Users\kfir\Documents\VHDL\lab3\LAB3task\inputFile.txt";
    constant write_file_location : string(1 to 57) :=
    "C:\Users\kfir\Documents\VHDL\lab3\LAB3task\outputFile.txt"; 
   
begin
    L0 : top generic map (n) port map(rst,clk,DATAin,DATAout);
    
    clk <= not(clk) after T/2;    --infinite clock generation (Page 17 'file based sim')
    TrigR <= clk'delayed(T/4);    --TrigR defined as a delayed version of clk

--initialize and switch reset:
    reset : process         
    begin
		  rst <= '1';
		  wait for 5 ns ; 
		  rst <= not rst;
		  wait;
    end process;

-------------------------------------------------------------------------------------------        
-- Read Trigger Explenation: if there is only one line then endfile is true immediatly
-- so we make a loop checking the length of the current line (line is of access string
-- type so it changes dynamically) and it has 0 length when reaching the end of current line.
--(see VHDL Golden ref page 117 Tips)
------------------------------------------------------------------------------------------

--Read:
    ReadTrigger : process 
        file infile : text open read_mode is read_file_location;
        variable L : line;
        variable datainV : integer;
        variable temp_endfile: boolean;                 -- testing wire              
        variable temp_length: integer;                  -- testing wire
        variable check_state_read :integer;             -- testing wire
    begin
        readline(infile,L);                             -- Save line   
                                                        --Read through current line:
        check_state_read:=1; 
        temp_length := L'length;  
        
        while (L'length > 1) loop                       -- Check if reached the end of L
            read(L,datainV);                            -- Read element from line to datainV
            temp_length := L'length;
            wait until (TrigR'event and TrigR='1');     -- Triggered by TrigR
            DATAin<=conv_std_logic_vector(datainV, n);  -- Insert reading
            check_state_read:=2;
        end loop;
        
        check_state_read:=3;
        temp_endfile := endfile(infile);
        wait for 1.5 ns;                                -- wait to see locals state in modelsim
        if (endfile(infile)) then                       -- Check if reached the end of file
        done <= '1';                                    -- Used in WriteTrigger
        check_state_read:=4;
        file_close(infile);                             -- Close input file
        report "end of input file" severity note;       -- "End" message
        wait;                                           -- Don't continue
        end if;
    
    end process;

-------------------------------------------------------------------------------------------        
-- Write Trigger Explenation: A 'transaction' is made everytime a signal is assigned to 
-- DATAout. When that happens time first we open a new line and then the loop writes elements
-- one at a time to that line. The loop breaks when we are finished with the input file,
-- We right the entire line to the output file and then close the file and give out a message.
-------------------------------------------------------------------------------------------
    
    WriteTrigger : process                              
        file outfile : text open write_mode is write_file_location;
        variable outline : line;
        variable check_stage_write : integer;               -- testing wire
        variable dataoutV : integer;                        
        variable space_num : integer ;                      -- the number of spaces for each result writing 
        variable divider : integer ; 
        variable space_enable : boolean := true;            -- keep counting increasing number of spaces           
        variable transaction_pre_value : bit;
    begin
        check_stage_write :=1;
        transaction_pre_value:= DATAout'transaction;
        
        while (done /= '1') loop                            -- See if we are still going through infile
            check_stage_write :=2;
            space_num :=2;
            divider := 10;
            
            wait until (DATAout'transaction /=transaction_pre_value or done ='1');        -- Wait until a signal is assigned to DATAout
            if (done ='1') then
                exit;                                       -- Exit loop
            end if;
            transaction_pre_value := DATAout'transaction;
            dataoutV :=conv_integer(signed(DATAout));
            check_stage_write :=3;
            wait for 1 ns;                                  -- wait to see locals state in modelsim
            if (dataoutV<0) then                            -- negative , "-"  require an extra spot
                space_num := space_num+1;                           
                dataoutV:= dataoutV*(-1);
            end if;
            
            while  (space_enable) loop                      -- increase number of spaces
                if (divider>dataoutV) then
                    exit;
                end if;
                divider:=divider*10;
                space_num := space_num+1;
            end loop;
            
            write(outline, conv_integer(signed(DATAout)),left,space_num);  -- Write current DATAout to line
        end loop;

        writeline(outfile,outline);                         -- Write line to file
        check_stage_write :=4;
        wait for 1 ns;                                      -- wait to see locals state in modelsim
        file_close(outfile);                                -- Close file
        report "finished writing to output file" severity note;
        wait;    
    
    end process;
end ttb;

-------------------------------------------------------------------------------------------
-- Main Differences from "tb_top_ver1try" (and justifications):
-- 1. Definition of clk as concurrent state - makes codes cleaner and easier to change
-- 2. Definition of TrigR as std_logic using "'delayed" attribute - cleaner code and i want to see if it works

-- Chnges to WriteTrigger: the way we do it in "tb_top_ver1try" means everytime we get a change in DATAout
-- we write DATAout to a line and load the line to the file, that means we will get a line for each argument.
-- The second thing is we dont know if when DATAout is changes to the same value we get an event and the
-- 'transaction attribute should solve that. In this version the loop is only loading elements to the same 
-- lines and only when we exit the loop the full line is loaded to the outfile.
-- Notice that with the new definition of ReadTrigger Done won't be changed until we are done loading all the
-- elements of the last line (even if there is only one).

-- The idea of ReadTrigger and WriteTrigger :

-- Only 1 line:
-- Endfile is true from the start but Done isn't, we enter the loop until line is finished (length=0), 
-- during the "read loop", WriteTrigger is  writing the result values in outline in his loop because Done is still FALSE.
-- when we finished reading the elements of that only line we exit the loop and change Done to TRUE, now the writing 
-- loop stops and uploads that line to the file.

-- Multiple lines:
-- Endfile is False so we enter read loop and write first line, in that time the writing loop 
-- writes results to a line and cannot exit because Done is FALSE when reading loop is still working.
-- when reading loop is finished we dont change Done because Endfile is still FALSE (we have another line).
-- When we start last line Endfile turns TRUE but only when we finished reading through the last line and exit 
-- the reading loop we change Done to TRUE so the writing loop can exit and write the line to the file. 
-- NOTE: this way no matter how much input we get the output will be one line, maybe a very long one.

-------------------------------------------------------------------------------------------