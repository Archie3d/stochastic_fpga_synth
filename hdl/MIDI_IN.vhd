--------------------------------------------------------------------------------
-- MIDI_IN.vhd
--------------------------------------------------------------------------------
-- MIDI input translation.
-- This unit takes MIDI input data and translates it to note on and off events.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIDI_IN is
    port(
        Clk        : in std_logic;
        Data_Ready : in std_logic;
        Data_In    : in std_logic_vector(7 downto 0);
        
        Note_On  : out std_logic;
        Note_Off : out std_logic;
        Note     : out std_logic_vector(6 downto 0);
        Velocity : out std_logic_vector(6 downto 0)
    );
end MIDI_IN;

architecture Behavioral of MIDI_IN is

    type State is (
        State_Status,
        State_Data0,
        State_Data1,
        State_Process,
        State_Finish
    );
    
    signal msg_status : std_logic_vector(7 downto 0);   -- MIDI status byte
    signal msg_data0  : std_logic_vector(6 downto 0);
    signal msg_data1  : std_logic_vector(6 downto 0);
    
    signal midi_state : State := State_Status;
    
    signal r_Note_On  : std_logic := '0';
    signal r_Note_Off : std_logic := '0';
    
begin

    process (Clk)
    begin
        if rising_edge(Clk) then
                
            ---------
            -- FSM --
            ---------
            case midi_state is
            
                when State_Status =>
                    if Data_Ready = '1' then
                        if Data_In(7) = '1' then
                            -- Ignore active sense
                            if Data_In /= "11111110" and Data_In /= "11111000" then
                                msg_status <= Data_In;
                                midi_state <= State_Data0;
                            end if;
                        else
                            -- Data thinning, tread as Data0
                            msg_data0 <= Data_In(6 downto 0);
                            midi_state <= State_Data1;
                        end if;
                    end if;
                    
                    r_Note_On <= '0';
                    r_Note_Off <= '0';
                 
                when State_Data0 =>
                    if Data_Ready = '1' then
                        msg_data0 <= Data_In(6 downto 0);
                        midi_state <= State_Data1;
                    end if;
                
                when State_Data1 =>
                    if Data_Ready = '1' then
                        msg_data1 <= Data_In(6 downto 0);
                        midi_state <= State_Process;
                    end if;
                
                when State_Process =>
                    if msg_status(7 downto 4) = "1000" then
                        -- NOTE OFF
                        r_Note_Off <= '1';
                        Note <= msg_data0;
                        Velocity <= msg_data1;
                    elsif msg_status(7 downto 4) = "1001" then
                        -- NOTE ON
                        r_Note_On <= '1';
                        Note <= msg_data0;
                        Velocity <= msg_data1;
                    elsif msg_status(7 downto 4) = "1011" then
                        -- CONTROL CHANGE
                        r_Note_On <= '0';
                        r_Note_Off <= '0';
                    else
                        r_Note_On <= '0';
                        r_Note_Off <= '0';
                    end if;
                    
                    midi_state <= State_Finish;
                    
                when State_Finish =>
                    midi_state <= State_Status;
                
            end case;
                
        end if;    
            
    end process;
    
    Note_On  <= r_Note_On;
    Note_Off <= r_Note_Off;

end Behavioral;
