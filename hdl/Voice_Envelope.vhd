--------------------------------------------------------------------------------
-- Voice_Envelope.vhd
--------------------------------------------------------------------------------
-- Generate voice envelope as a bipolar stochastic signal.
-- Currently only attack and release are implemented.
-- The values for attack and release are provided as stochastic inputs.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Voice_Envelope is
    generic(
        BITS : integer := 16
    );
    port(
        Clk     : in std_logic;
        Attack  : in std_logic;
        Release : in std_logic;
        
        Trigger : in std_logic;
        
        EnvB    : out std_logic_vector(BITS-1 downto 0);
        Env     : out std_logic;
        Busy    : out std_logic
	);
end entity;


architecture Behavioral of Voice_Envelope is

    type State is (State_Idle, State_Attack, State_Sustain, State_Release);
    
    signal adsr_state : State := State_Idle;
    signal adsr_busy : std_logic;

    constant MaxCounter: unsigned(BITS-1 downto 0) := (others => '1');
    constant MidCounter: unsigned(BITS-1 downto 0) := (BITS-1 => '1', others => '0');
    
    signal Counter: unsigned(BITS-1 downto 0) := MidCounter;
    
    constant LFSR_BITS : integer := 64;
    constant LFSR_SEED : integer := 57;
    signal lfsr: std_logic_vector(LFSR_BITS-1 downto 0) := std_logic_vector(to_unsigned(LFSR_SEED, LFSR_BITS));
    signal lfsr_reseed : std_logic_vector(15 downto 0);

begin
    process (Clk, adsr_busy)
        variable tmp      : std_logic;
        variable nextLFSR : std_logic_vector(lfsr'length-1 downto 0) := (others => '0');
        variable rnd      : unsigned(BITS-1 downto 0) := (others => '0');
        variable output   : std_logic := '0';
        
    begin
        if rising_edge(Clk) then
        
            -- Capture attack stochastic stream to be used to reseed the envelope
            lfsr_reseed <= Attack & lfsr_reseed(lfsr_reseed'length-1 downto 1);
        
            case adsr_state is
                when State_Idle =>
                    Counter <= MidCounter;
                    
                    if Trigger = '1' then
                        adsr_state <= State_Attack;
                        -- Re-seed the LFSR
                        lfsr(lfsr'length - 1 downto lfsr'length - lfsr_reseed'length) <= lfsr_reseed;
                        adsr_busy <= '1';
                    else
                        adsr_busy <= '0';
                    end if;
                   
                when State_Attack =>
                    if Trigger = '0' then
                        adsr_state <= State_Release;
                    else
                        if Attack = '1' then
                            if Counter = MaxCounter then
                                adsr_state <= State_Sustain;
                            else
                                Counter <= Counter + 1;
                            end if;
                        end if;                                                 
                    end if;
                    
                when State_Sustain =>
                    Counter <= MaxCounter;
                    
                    if Trigger = '0' then
                        adsr_state <= State_Release;
                    end if;
                                        
                when State_Release =>
                    if Counter = MidCounter then
                        adsr_state <= State_Idle;
                        adsr_busy <= '0';
                    else
                        if Release = '1' then
                            Counter <= Counter - 1;
                        else
                            Counter <= Counter;
                        end if;
                    end if;
                    
            end case;
            

            tmp := lfsr(7) xor lfsr(2) xor lfsr(1) xor lfsr(0);
            nextLFSR := tmp & lfsr(lfsr'length-1 downto 1);
            lfsr <= nextLFSR;

            -- Take only BITS part of the random number
			rnd := unsigned(nextLFSR(BITS-1 downto 0));
            

            if rnd < Counter then
                output := '1';
            else
                output := '0';
            end if;
            
        end if;
        
        EnvB <= std_logic_vector(Counter);
        Env <= output;
        Busy <= adsr_busy;

    end process;

end Behavioral;