--------------------------------------------------------------------------------
-- SC2B.vhd
--------------------------------------------------------------------------------
-- Convert stochastic signal to its binary representation.
-- This is a generic implementation based on 1s couting
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SC2B is
    generic(
        BITS : integer range 1 to 32 := 8
	);
	port(
        Clk   : in std_logic;
        Input : in std_logic;
        Q     : out std_logic_vector(BITS-1 downto 0);
        Ready : out std_logic
    );
end entity;


architecture Behavioral of SC2B is
    constant MaxCounter: unsigned(BITS-1 downto 0) := (others => '1');

    signal counter : unsigned(BITS-1 downto 0) := to_unsigned(0, BITS);
    signal acc     : unsigned(BITS-1 downto 0) := to_unsigned(0, BITS);
    signal output  : std_logic_vector(BITS-1 downto 0) := (others => '0');
    signal outputReady : std_logic := '0';
begin

    process (Clk, Input)
        variable nextCounter : unsigned(BITS-1 downto 0) := to_unsigned(0, BITS);
        variable nextAcc     : unsigned(BITS-1 downto 0) := to_unsigned(0, BITS);
    begin

        if rising_edge(Clk) then
        
            nextAcc := acc;
            
            if Input = '1' then
                nextAcc := nextAcc + 1;
            end if;
        
            nextCounter := counter + 1;
            
            if nextCounter = MaxCounter then
                counter <= (others => '0');
                output <= std_logic_vector(nextAcc);
                acc <= (others => '0');
                outputReady <= '1';
            else
                counter <= nextCounter;
                acc <= nextAcc;
                outputReady <= '0';
            end if;

        end if;

        Q <= output;
        Ready <= outputReady;

    end process;

end Behavioral;
