library ieee;
use ieee.std_logic_1164.all;

entity d_flipflop is 
port (
    d, clk, clear, enable: in std_logic;
    q : out std_logic);
end d_flipflop;

architecture behv of d_flipflop is 
    signal qs : std_logic:= '0';
begin
q <= qs after 6 ns;
process(clk, clear)
    begin
        if clear = '0' then
            qs <= '0';    
        elsif rising_edge(clk) and enable = '1' then 
        qs <= d;
        end if;
end process;
end behv; -- behv arch