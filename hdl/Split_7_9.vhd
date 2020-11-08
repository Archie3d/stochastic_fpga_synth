--------------------------------------------------------------------------------
-- Split_7_9.vhd
--------------------------------------------------------------------------------
-- Split 16-bit intpu into two 7 and 9 bits outputs
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Split_7_9 is
	port(
        Clk    : in std_logic;
        Input  : in std_logic_vector(15 downto 0);
        Q15_9  : out std_logic_vector(6 downto 0);
        Q8_0   : out std_logic_vector(8 downto 0)
    );
end entity;


architecture Behavioral of Split_7_9 is
    
begin

    process (Clk)
    begin

        if rising_edge(Clk) then
            Q15_9 <= Input(15 downto 9);
            Q8_0 <= Input(8 downto 0);
        end if;

    end process;

end Behavioral;