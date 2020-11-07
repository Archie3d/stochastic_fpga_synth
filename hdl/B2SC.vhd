--------------------------------------------------------------------------------
-- B2SC.vhd
--------------------------------------------------------------------------------
-- Binary to stochastic convertion implementation.
-- This is a generic implementation that requires the number of binary input
-- bits to be set. The output is stochastic signal at the master clock
-- frequency. This generates a unipolar signal. In order to generate a bipolar
-- stochastic signal the input binary must be offset by the mid value of
-- the input bus width.
-- Along with the input size, the LFSR pseudo-random sequence seed must be
-- provided. The seed cannot be zero otherwise the LFSR will stall.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity B2SC is
    generic(
        BITS : integer range 1 to 32 := 16;
        SEED : integer               := 1
	);
    
	port(
        Clk   : in std_logic;
        Input : in std_logic_vector(BITS-1 downto 0);
        Q     : out std_logic
    );
end entity;


architecture Behavioral of B2SC is
    -- N-bit shift register for random number generation
    constant LFSR_BITS : integer := 64;
    signal lfsr: std_logic_vector(LFSR_BITS-1 downto 0) := std_logic_vector(to_unsigned(SEED, LFSR_BITS));
    
begin

    process (Clk)
        variable tmp      : std_logic := '0';
        variable nextLFSR : std_logic_vector(lfsr'length-1 downto 0) := (others => '0');
        variable rnd      : unsigned(BITS-1 downto 0) := (others => '0');
        variable output   : std_logic := '0';
    begin

        if rising_edge(Clk) then

            -- Generate next random value
            tmp := lfsr(7) xor lfsr(2) xor lfsr(1) xor lfsr(0);

            nextLFSR := tmp & lfsr(lfsr'length-1 downto 1);
            lfsr <= nextLFSR;


            -- Take only BITS part of the random number
			rnd := unsigned(nextLFSR(BITS-1 downto 0));
            
            if rnd < unsigned(Input) then            
                output := '1';
            else
                output := '0';
            end if;

        end if;

        Q <= output;

    end process;

end Behavioral;
