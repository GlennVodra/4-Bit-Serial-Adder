library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity not1 is
	port(
	A : in std_logic;
	Y : out std_logic);
end entity ;

architecture behv of not1 is
begin
Y <= not A after 2 ns;
end architecture ; -- behv arch