--------------------------------------------------------------------------------
-- SC_Delay.vhd
--------------------------------------------------------------------------------
-- Bit stream delay line
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SC_Delay is
    generic(
        DELAY: integer := 2
    );
    port(
        Clk   : in std_logic;
        Input : in std_logic;
        Q     : out std_logic
    );
end entity;

architecture Behavioral of SC_Delay is
    signal delayLine: std_logic_vector(DELAY-1 downto 0) := (others => '0');
begin

    process (Clk)
        variable output: std_logic := '0';
    begin

        if rising_edge(Clk) then
            output := delayLine(0);
            delayLine <= Input & delayLine(DELAY-1 downto 1);
        end if;

        Q <= output;

    end process;

end Behavioral;
