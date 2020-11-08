--------------------------------------------------------------------------------
-- PWM8.vhd
--------------------------------------------------------------------------------
-- PWM 8-bit DAC
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity PWM8 is
    port(
        Clk    : in std_logic;
        Input  : in std_logic_vector(7 downto 0);
        Sample : in std_logic;
        Q      : out std_logic
    );
end PWM8;

architecture Behavioral of PWM8 is

    signal out_1 : std_logic_vector(19 downto 0);

    signal Sampled_Input : std_logic_vector(7 downto 0) := (others => '0');
    signal counter : std_logic_vector(7 downto 0) := (others => '0');

begin
    process(Clk, Input, Sample)
        variable input_0 : std_logic_vector(19 downto 0);
        variable sum : std_logic_vector(19 downto 0);
    begin
        if rising_edge(Clk) then
        
            if Sample = '1' then
            
                -- Additional IIR low pass filter on incoming singal
                input_0 := "000000000000" & Input;
                sum := input_0 + (out_1 - ("000000000000" & out_1(19 downto 12)));
                out_1 <= sum;

                Sampled_Input <= sum(19 downto 12);
                --Sampled_Input <= Input;
            end if;
        
            if Sampled_Input > counter then
                Q <= '1';
            else
                Q <= '0';
            end if;
        
            counter <= counter + 1;
        end if;
    end process;

end Behavioral;