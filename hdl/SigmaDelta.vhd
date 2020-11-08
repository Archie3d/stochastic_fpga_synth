--------------------------------------------------------------------------------
-- SigmaDelta.vhd
--------------------------------------------------------------------------------
-- Generic sigma-delta modulator.
-- This module converts input PCM signal to PDM signal.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SigmaDelta is
    generic(
        BITS : integer := 16
    );
	port(
        Clk   : in std_logic;
        Input : in std_logic_vector(BITS-1 downto 0);        
        Q     : out std_logic
    );
end entity;


architecture Behavioral of SigmaDelta is

    signal integrator : integer := 0;
    signal output_bit : std_logic := '0';
    
    constant Max : integer := 2**BITS - 1;
    
begin

    process (Clk)
        variable x : integer;
        variable next_integrator : integer;        
    begin

        if rising_edge(Clk) then
        
            x := to_integer(unsigned(Input));
            
            if output_bit = '1' then
                x := x - Max;
            end if;
            
            next_integrator := integrator + x;
            
            integrator <= next_integrator;
                        
            
            if next_integrator >= 0 then
                output_bit <= '1';
            else
                output_bit <= '0';
            end if;
            
        end if;

    end process;
    
    Q <= output_bit;

end Behavioral;