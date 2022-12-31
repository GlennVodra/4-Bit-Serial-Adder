library ieee;
use ieee.std_logic_1164.all;

entity fadder is
  port(
  A, B, Cin : in std_logic;
  Sum, Cout : out std_logic);
end fadder;

architecture behv of fadder is
  signal s_1, s_2, s_3 : std_logic:= '0';
  begin
    s_1 <= A AND B;
    s_2 <= A AND Cin;
    s_3 <= B AND Cin;
    Sum <= A xor B xor Cin after 8 ns;
    Cout <= s_1 OR s_2 OR s_3 after 8 ns;
end; 