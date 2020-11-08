--------------------------------------------------------------------------------
-- SC_Mux.vhd
--------------------------------------------------------------------------------
-- Stochastic multiplexer.
-- This is a generic implementation that takes the number of inputs as
-- parameter. The multiplexer uses internal LFSR random sequence generator
-- to switch between the inputs.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SC_Mux is
    generic(
        NUM_INPUTS: integer := 2
    );
    port(
        Clk: in std_logic;
        Input: in std_logic_vector(NUM_INPUTS-1 downto 0);
        Q: out std_logic
    );
end entity;

architecture Behavioral of SC_Mux is
    signal mux: integer := 0;
    
        -- N-bit shift register for random number generation
    constant LFSR_BITS : integer := 24;
    signal lfsr: std_logic_vector(LFSR_BITS-1 downto 0) := std_logic_vector(to_unsigned(6345, LFSR_BITS));

begin

    process (Clk)
        variable output: std_logic := '0';
        variable nextMux: integer := 0;
        
        variable tmp      : std_logic := '0';
        variable nextLFSR : std_logic_vector(lfsr'length-1 downto 0) := (others => '0');

	begin

        if rising_edge(Clk) then
        
            tmp := lfsr(13) xor lfsr(5) xor lfsr(2) xor lfsr(0);
                       
            nextLFSR := tmp & lfsr(lfsr'length-1 downto 1);
            lfsr <= nextLFSR;
                
            output := Input(mux);

            
            if tmp = '1' then
                nextMux := mux + 1;
            
                if nextMux >= NUM_INPUTS then
                    nextMux := 0;
                end if;

                mux <= nextMux;
            end if;
        end if;

        Q <= output;
	end process;

end Behavioral;

