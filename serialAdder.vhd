library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;

entity serialAdder is
  port (in_a, in_b  : in std_logic_vector(3 downto 0);
        control : in std_logic_vector(1 downto 0);
        clk, clear : in std_logic;
				
				sum : out std_logic_vector(3 downto 0);
  			carry : out std_logic);
end entity;

architecture behv of serialAdder is
	component DM74LS194A is 
    port (a, b, c, d : in std_logic;
        clk, clear : in std_logic;
				s0, s1 : in std_logic;
				sL, sR : in std_logic;
				qa, qb, qc, qd : out std_logic);
  end component;

  component fadder is 
    port(
  		A, B, Cin : in std_logic;
  		Sum, Cout : out std_logic);
  end component;


	component and2 is 
    port(A, B : in std_logic;
    	Y : out std_logic);
  end component;

component d_flipflop is 
    port (
    	d, clk, clear, enable: in std_logic;
    	q : out std_logic);
  end component;

  component not1 is 
    port(
			A : in std_logic;
			Y : out std_logic);
  end component;

	signal s_sL_a, s_sR_a, s_sL_b, s_sR_b : std_logic := '0';  
	signal s_qd1, s_qd2 : std_logic := '0';
	signal s_cout, s_q : std_logic := '0';
	signal n_con1, en : std_logic := '0';
begin 

sum(0)<= s_qd1;
carry <= s_q;

s_sl_a <= '0';
s_sl_b <= '0';
s_sR_b <= '0';

regA : DM74LS194A port map (a => in_a(3), b => in_a(2), c => in_a(1), d => in_a(0),
				clk => clk, clear => clear, s1 => control(1), s0 => control(0), sL => s_sl_a, sR => s_sR_a,
				qa => sum(3), qb => sum(2), qc => sum(1), qd => s_qd1);
regB : DM74LS194A port map (a => in_b(3), b => in_b(2), c => in_b(1), d => in_b(0),
				clk => clk, clear => clear, s1 => control(1), s0 => control(0), sL => s_sl_b, sR => s_sR_b,
			  qd => s_qd2);

full_adder1 : fadder port map (a => s_qd1, b => s_qd2, cIn => s_q, Sum => s_sR_a, Cout => s_cout);

d_flipflop1 : d_flipflop port map (d => s_cout, clk => clk, clear => clear, enable => en, q => s_q);

and1 : and2 port map(A => control(0), B => n_con1, Y => en);

invert1 : not1 port map(A => control(1), Y => n_con1);

end;