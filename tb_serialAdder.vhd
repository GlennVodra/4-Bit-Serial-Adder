library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity tb_serialAdder is
end tb_serialAdder;

architecture behav of tb_serialAdder is

component serialAdder_w_Con is
  port (in_a, in_b  : in std_logic_vector(3 downto 0);
        start : in std_logic;
        clk, clear_sm : in std_logic;
                
        sum : out std_logic_vector(3 downto 0);
        carry, ready : out std_logic);
end component;

constant clk_period : time := 50 ns;
    -- Inputs
	signal in_a, in_b : std_logic_vector(3 downto 0);
	signal clk : std_logic := '0';
	signal clear_sm : std_logic := '0';
	signal start : std_logic:= '0';
    -- Outputs
	signal sum : std_logic_vector(3 downto 0);
   	signal carry : std_logic;
    signal ready : std_logic; 

	function vec2str(vec: std_logic_vector) return string is
        variable stmp: string(vec'high+1 downto 1);
        variable counter : integer := 1;
    begin
        for i in vec'reverse_range loop
            stmp(counter) := std_logic'image(vec(i))(2); -- image returns '1' (with quotes)
            counter := counter + 1;
        end loop;
        return stmp;
    end vec2str;


    type ttestRecord is record
        inin_a, inin_b : std_logic_vector(3 downto 0);
        outsum : std_logic_vector (3 downto 0);
        outcarry : std_logic;
    end record;

    type testRecordArray is array (natural range <>) of ttestRecord;

    constant test : testRecordArray:= (
        (X"0", X"4", X"4", '0'),(X"C", X"E", X"A", '1'),(X"8", X"A", X"2", '1'),
        (X"F", X"F", X"E", '1'),(X"F", X"1", X"0", '1'),(X"A", X"5", X"2", '0'),
        (X"8", X"7", X"F", '0')
        );

begin

	UUT: serialAdder_w_Con
    port map (
		in_a => in_a,
		in_b => in_b,
		start => start,
		clk => clk,
		clear_sm => clear_sm,
		sum => sum,
		carry => carry,
        ready => ready
	);

clk_process: process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process clk_process;


 stim_process: process begin
    for i in test'range loop
    clear_sm <= '0';
    wait for 100 ns;
    clear_sm <= '1';
    start <= '1';
    wait for 100 ns;
    in_a <= test(i).inin_a;
    in_b <= test(i).inin_b;
    wait until ready = '1';
    assert(sum = test(i).outsum and carry = test(i).outcarry)
                 report("Serial Adder failed to Add at: " & time'image(now) & 
                 ". Expected: " & vec2str(test(i).outsum) & " and Carry: "& std_logic'image(test(i).outcarry) &". Got: " & vec2str(sum) & " and " & std_logic'image(carry)) severity error;
    wait for 50 ns;
    end loop;
  
  assert false
			report "Simulation finished"
			severity failure;
end process;

end behav;