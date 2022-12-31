library ieee ;
	use ieee.std_logic_1164.all ;
	use ieee.numeric_std.all ;
  use IEEE.std_logic_arith.all;
  
entity SA_Control is
  port (
  		start, clk, clear_sm : in std_logic;
  		control_output : out std_logic_vector(3 downto 0));
  end entity;

architecture behv of SA_Control is
	signal s_control_ouput : std_logic_vector(3 downto 0):= "1100";
	type State_Type is (IDLE, RESET, LOAD, S1, S2, S3, S4, HOLD); 
	signal current_state, next_state : State_Type := IDLE;
begin

next_state_assignment : process (clk, clear_sm) is begin	 
	if rising_edge(clk) then
		if (current_state = IDLE AND start = '1') then
				next_state <= RESET; -- When Idle and Start = 0 go to Reset
		elsif rising_edge(clk) then
			case current_state is
				when RESET => next_state <= LOAD; -- When Reset go to Load
				when LOAD => next_state <= S1; -- When Load go to S1
				when S1 => next_state <= S2; -- When S1 go to S2
				when S2 => next_state <= S3; -- When S3 go t S3
				when S3 => next_state <= S4; -- When S3 go to S4
				when S4 => next_state <= HOLD; -- When S4 go to Hold
				when HOLD => next_state <= IDLE; -- When Hold go to Idle
				when others => next_state <= IDLE; 
			end case ;
		end if;
	end if ;
end process next_state_assignment;

s_control_ouput_assignment : process (clk) is begin
	if rising_edge(clk) then
		case next_state is
			when IDLE => s_control_ouput <= "1100"; -- When Idle convey Idle
			when RESET => s_control_ouput <= "0000"; -- When Reset convey Reset
			when LOAD => s_control_ouput <= "0111"; -- When Load convey Load
			when S1 => s_control_ouput <= "0101"; -- When S1 convey S1
			when S2 => s_control_ouput <= "0101"; -- When S2 convey S2
			when S3 => s_control_ouput <= "0101"; -- When S3 convey S3
			when S4 => s_control_ouput <= "0101"; -- When S4 convey S4
			when HOLD => s_control_ouput <= "0100"; -- When Hold convey Hold
		end case;
	end if; 
end process s_control_ouput_assignment;

process (clk)
  begin
    if clear_sm = '0' then
				current_state <= IDLE; 
	else 
    current_state <= next_state; 															-- Set current state
    control_output <= s_control_ouput after 10 ns; -- Set control_output
end if;
end process;

end architecture; -- behv arch