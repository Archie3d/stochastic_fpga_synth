--------------------------------------------------------------------------------
-- SC_Integrator.vhd
--------------------------------------------------------------------------------
-- Integrate stochastic signal by counting the number of '1's on input.
-- This is a generic implementation that expects the counter's number of
-- bits to be provided.
-- The integrator provides 'Max' output that turns to '1' upon reaching the
-- maximum. The 'Reset' input resets the counter to zero.
-- 'Max' and 'Reset' can be connected together to reset the integrator
-- back to zero on reaching the maximum.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SC_Integrator is
    generic(
        BITS : integer := 16;
        INIT : integer := 0
    );
    port(
        Clk   : in std_logic;
        Input : in std_logic;
        Reset : in std_logic;
        
        Q     : out std_logic_vector(BITS-1 downto 0);
        Max   : out std_logic
	);
end entity;


architecture Behavioral of SC_Integrator is

    constant MaxCounter: unsigned(BITS-1 downto 0) := (others => '1');
    signal Counter: unsigned(BITS-1 downto 0) := to_unsigned(INIT, BITS);
    signal Saturated: std_logic := '0';
		
begin
    process (Clk, Counter, Saturated)
    begin
        if rising_edge(Clk) then
            if Reset = '1' then
                Counter <= (others => '0');
                Saturated <= '0';
            elsif Counter /= MaxCounter then
                if Input = '1' then
                    Counter <= Counter + 1;
                end if;
                Saturated <= '0';
            else
                Saturated <= '1';
            end if;
        end if;

        Q <= std_logic_vector(Counter);
        Max <= Saturated;
    end process;
end Behavioral;
