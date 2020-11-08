--------------------------------------------------------------------------------
-- SC_Add.vhd
--------------------------------------------------------------------------------
-- Stochastic weighted adder
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--

entity SC_Add is
    port(
        Clk : in std_logic;
        A   : in std_logic;
        B   : in std_logic;
        W   : in std_logic;
        Q   : out std_logic
    );
end entity;

architecture Behavioral of SC_Add is
begin

    process (Clk)
        variable output: std_logic := '0';
    begin

        if rising_edge(Clk) then
            if W = '0' then
                output := A;
            else
                output := B;
            end if;
        end if;

        Q <= output;

    end process;

end Behavioral;
