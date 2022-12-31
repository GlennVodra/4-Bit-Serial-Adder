library ieee;
use ieee.std_logic_1164.all;

entity and2 is 
port (
    A, B: in std_logic;
    Y : out std_logic);
end and2;

architecture behv of and2 is 
begin
Y <= A and B after 4 ns;

end behv; -- behv arch