--------------------------------------------------------------------------------
-- Voice_Trigger.vhd
--------------------------------------------------------------------------------
-- Voice trigger received note on and off signals and translates them
-- into a voice enablement signal. It also checks whether the voice has already
-- been triggered and in such case passed note on signal to the forwarding
-- output for another voice to be consumed.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Voice_Trigger is
    port(
        Clk            : in std_logic;        
        Note_On        : in std_logic;
        Note_Off       : in std_logic;
        Note           : in std_logic_vector(6 downto 0);
        Velocity       : in std_logic_vector(6 downto 0);
        Busy           : in std_logic;      -- Voice is busy and should not trigger
        
        Vel            : out std_logic_vector(6 downto 0);
        Forward        : out std_logic;
        Trigger        : out std_logic
	);
end entity;


architecture Behavioral of Voice_Trigger is

	signal Note_Number   : std_logic_vector(6 downto 0);
    signal Note_Velocity : std_logic_vector(6 downto 0);
    signal r_Trigger     : std_logic := '0';
    signal r_Forward     : std_logic := '0';

begin
    process (Clk)

    begin
        if rising_edge(Clk) then
        
            if Busy = '0' then
                -- Voice is free - accept note on
                if Note_On = '1' then
                    Note_Number <= Note;
                    Note_Velocity <= Velocity;
                    r_Trigger <= '1';
                end if;
                
                r_Forward <= '0';
                
            else
            
                -- Voice is busy - accept note off
                if Note_Off = '1' then
                    if Note = Note_Number then
                        r_Trigger <= '0';
                    end if;
                end if;
                
                r_Forward <= Note_On; -- Forward note on if this voice is busy
            end if;
                    
            
        end if;

    end process;
    
    Vel     <= Note_Velocity;
    Forward <= r_Forward;
    Trigger <= r_Trigger;

end Behavioral;
