library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity DM74LS194A is
  port (a, b, c, d : in std_logic;
        clk, clear : in std_logic;
				s0, s1 : in std_logic;
				sL, sR : in std_logic;
				qa, qb, qc, qd : out std_logic);
end entity;

architecture behv of DM74LS194A is
	signal qas, qbs, qcs, qds : std_logic := '0'; 
	signal mode : std_logic_vector(1 downto 0);
begin
mode <= s1 & s0;
qa <= qas after 22 ns;
qb <= qbs after 22 ns;
qc <= qcs after 22 ns;
qd <= qds after 22 ns;

Q_assignment : process (clk, clear) is begin	
	if clear = '0' then
	 qas <= '0';
	 qbs <= '0';
	 qcs <= '0';
	 qds <= '0';
	elsif rising_edge(clk) then
				case(mode) is
					when "11" => qas <= a; qbs <= b; qcs <= c; qds <= d;
					when "01" => qas <= sR; qbs <= qas; qcs <= qbs; qds <= qcs;	
					when "10" => qas <= qbs; qbs <= qcs; qcs <= qds; qds <= sL;
					when others => qas <= qas; qbs <= qbs; qcs <= qcs; qds <= qds;
				end case ;
	end if ;
end process Q_assignment;
 
end architecture; -- behv arch