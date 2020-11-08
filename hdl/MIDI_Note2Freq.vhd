--------------------------------------------------------------------------------
-- MIDI_Note2Freq
--------------------------------------------------------------------------------
-- Translace MIDI note number to frequency assuming 100MHz master clock
-- and 16-bit integrator.
-- This unit produces three slightly detuned frequenced.
-- Freq0 is always in tune.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MIDI_Note2Freq is
    port(
        Clk   : in std_logic;
        Note  : in std_logic_vector(6 downto 0);
        Busy  : in std_logic;
        
        Freq0 : out std_logic_vector(15 downto 0);
        Freq1 : out std_logic_vector(15 downto 0);
        Freq2 : out std_logic_vector(15 downto 0)
	);
end entity;


architecture Behavioral of MIDI_Note2Freq is

    signal r_Freq0 : unsigned(15 downto 0) := (others => '0');
    signal r_Freq1 : unsigned(15 downto 0) := (others => '0');
    signal r_Freq2 : unsigned(15 downto 0) := (others => '0');
		
begin
    process (Clk)
        variable note_number : integer;
    begin
        if rising_edge(Clk) then
        
            -- Update the output only when the voice is not busy
            if Busy = '0' then
                note_number := to_integer(unsigned(Note));
            
                case note_number is
                    when 12 =>
                        r_Freq0 <= to_unsigned(702, 16);
                        r_Freq1 <= to_unsigned(705, 16);
                        r_Freq2 <= to_unsigned(705, 16);
                    when 13 =>
                        r_Freq0 <= to_unsigned(744, 16);
                        r_Freq1 <= to_unsigned(741, 16);
                        r_Freq2 <= to_unsigned(741, 16);
                    when 14 =>
                        r_Freq0 <= to_unsigned(788, 16);
                        r_Freq1 <= to_unsigned(792, 16);
                        r_Freq2 <= to_unsigned(784, 16);
                    when 15 =>
                        r_Freq0 <= to_unsigned(835, 16);
                        r_Freq1 <= to_unsigned(838, 16);
                        r_Freq2 <= to_unsigned(832, 16);
                    when 16 =>
                        r_Freq0 <= to_unsigned(885, 16);
                        r_Freq1 <= to_unsigned(881, 16);
                        r_Freq2 <= to_unsigned(882, 16);
                    when 17 =>
                        r_Freq0 <= to_unsigned(937, 16);
                        r_Freq1 <= to_unsigned(942, 16);
                        r_Freq2 <= to_unsigned(941, 16);
                    when 18 =>
                        r_Freq0 <= to_unsigned(993, 16);
                        r_Freq1 <= to_unsigned(990, 16);
                        r_Freq2 <= to_unsigned(992, 16);
                    when 19 =>
                        r_Freq0 <= to_unsigned(1052, 16);
                        r_Freq1 <= to_unsigned(1056, 16);
                        r_Freq2 <= to_unsigned(1055, 16);
                    when 20 =>
                        r_Freq0 <= to_unsigned(1115, 16);
                        r_Freq1 <= to_unsigned(1110, 16);
                        r_Freq2 <= to_unsigned(1109, 16);
                    when 21 =>
                        r_Freq0 <= to_unsigned(1181, 16);
                        r_Freq1 <= to_unsigned(1187, 16);
                        r_Freq2 <= to_unsigned(1186, 16);
                    when 22 =>
                        r_Freq0 <= to_unsigned(1251, 16);
                        r_Freq1 <= to_unsigned(1255, 16);
                        r_Freq2 <= to_unsigned(1248, 16);
                    when 23 =>
                        r_Freq0 <= to_unsigned(1326, 16);
                        r_Freq1 <= to_unsigned(1330, 16);
                        r_Freq2 <= to_unsigned(1331, 16);
                    when 24 =>
                        r_Freq0 <= to_unsigned(1405, 16);
                        r_Freq1 <= to_unsigned(1402, 16);
                        r_Freq2 <= to_unsigned(1402, 16);
                    when 25 =>
                        r_Freq0 <= to_unsigned(1488, 16);
                        r_Freq1 <= to_unsigned(1481, 16);
                        r_Freq2 <= to_unsigned(1491, 16);
                    when 26 =>
                        r_Freq0 <= to_unsigned(1577, 16);
                        r_Freq1 <= to_unsigned(1576, 16);
                        r_Freq2 <= to_unsigned(1572, 16);
                    when 27 =>
                        r_Freq0 <= to_unsigned(1670, 16);
                        r_Freq1 <= to_unsigned(1662, 16);
                        r_Freq2 <= to_unsigned(1674, 16);
                    when 28 =>
                        r_Freq0 <= to_unsigned(1770, 16);
                        r_Freq1 <= to_unsigned(1766, 16);
                        r_Freq2 <= to_unsigned(1766, 16);
                    when 29 =>
                        r_Freq0 <= to_unsigned(1875, 16);
                        r_Freq1 <= to_unsigned(1869, 16);
                        r_Freq2 <= to_unsigned(1878, 16);
                    when 30 =>
                        r_Freq0 <= to_unsigned(1986, 16);
                        r_Freq1 <= to_unsigned(1980, 16);
                        r_Freq2 <= to_unsigned(1996, 16);
                    when 31 =>
                        r_Freq0 <= to_unsigned(2105, 16);
                        r_Freq1 <= to_unsigned(2096, 16);
                        r_Freq2 <= to_unsigned(2095, 16);
                    when 32 =>
                        r_Freq0 <= to_unsigned(2230, 16);
                        r_Freq1 <= to_unsigned(2240, 16);
                        r_Freq2 <= to_unsigned(2227, 16);
                    when 33 =>
                        r_Freq0 <= to_unsigned(2362, 16);
                        r_Freq1 <= to_unsigned(2369, 16);
                        r_Freq2 <= to_unsigned(2368, 16);
                    when 34 =>
                        r_Freq0 <= to_unsigned(2503, 16);
                        r_Freq1 <= to_unsigned(2496, 16);
                        r_Freq2 <= to_unsigned(2499, 16);
                    when 35 =>
                        r_Freq0 <= to_unsigned(2652, 16);
                        r_Freq1 <= to_unsigned(2656, 16);
                        r_Freq2 <= to_unsigned(2649, 16);
                    when 36 =>
                        r_Freq0 <= to_unsigned(2809, 16);
                        r_Freq1 <= to_unsigned(2815, 16);
                        r_Freq2 <= to_unsigned(2806, 16);
                    when 37 =>
                        r_Freq0 <= to_unsigned(2976, 16);
                        r_Freq1 <= to_unsigned(2965, 16);
                        r_Freq2 <= to_unsigned(2971, 16);
                    when 38 =>
                        r_Freq0 <= to_unsigned(3153, 16);
                        r_Freq1 <= to_unsigned(3167, 16);
                        r_Freq2 <= to_unsigned(3143, 16);
                    when 39 =>
                        r_Freq0 <= to_unsigned(3341, 16);
                        r_Freq1 <= to_unsigned(3328, 16);
                        r_Freq2 <= to_unsigned(3341, 16);
                    when 40 =>
                        r_Freq0 <= to_unsigned(3539, 16);
                        r_Freq1 <= to_unsigned(3547, 16);
                        r_Freq2 <= to_unsigned(3536, 16);
                    when 41 =>
                        r_Freq0 <= to_unsigned(3750, 16);
                        r_Freq1 <= to_unsigned(3756, 16);
                        r_Freq2 <= to_unsigned(3747, 16);
                    when 42 =>
                        r_Freq0 <= to_unsigned(3973, 16);
                        r_Freq1 <= to_unsigned(3990, 16);
                        r_Freq2 <= to_unsigned(3966, 16);
                    when 43 =>
                        r_Freq0 <= to_unsigned(4209, 16);
                        r_Freq1 <= to_unsigned(4198, 16);
                        r_Freq2 <= to_unsigned(4212, 16);
                    when 44 =>
                        r_Freq0 <= to_unsigned(4459, 16);
                        r_Freq1 <= to_unsigned(4476, 16);
                        r_Freq2 <= to_unsigned(4475, 16);
                    when 45 =>
                        r_Freq0 <= to_unsigned(4724, 16);
                        r_Freq1 <= to_unsigned(4735, 16);
                        r_Freq2 <= to_unsigned(4733, 16);
                    when 46 =>
                        r_Freq0 <= to_unsigned(5005, 16);
                        r_Freq1 <= to_unsigned(4989, 16);
                        r_Freq2 <= to_unsigned(5008, 16);
                    when 47 =>
                        r_Freq0 <= to_unsigned(5303, 16);
                        r_Freq1 <= to_unsigned(5285, 16);
                        r_Freq2 <= to_unsigned(5280, 16);
                    when 48 =>
                        r_Freq0 <= to_unsigned(5618, 16);
                        r_Freq1 <= to_unsigned(5635, 16);
                        r_Freq2 <= to_unsigned(5591, 16);
                    when 49 =>
                        r_Freq0 <= to_unsigned(5952, 16);
                        r_Freq1 <= to_unsigned(5927, 16);
                        r_Freq2 <= to_unsigned(5923, 16);
                    when 50 =>
                        r_Freq0 <= to_unsigned(6306, 16);
                        r_Freq1 <= to_unsigned(6332, 16);
                        r_Freq2 <= to_unsigned(6318, 16);
                    when 51 =>
                        r_Freq0 <= to_unsigned(6681, 16);
                        r_Freq1 <= to_unsigned(6676, 16);
                        r_Freq2 <= to_unsigned(6659, 16);
                    when 52 =>
                        r_Freq0 <= to_unsigned(7079, 16);
                        r_Freq1 <= to_unsigned(7059, 16);
                        r_Freq2 <= to_unsigned(7105, 16);
                    when 53 =>
                        r_Freq0 <= to_unsigned(7500, 16);
                        r_Freq1 <= to_unsigned(7504, 16);
                        r_Freq2 <= to_unsigned(7463, 16);
                    when 54 =>
                        r_Freq0 <= to_unsigned(7946, 16);
                        r_Freq1 <= to_unsigned(7932, 16);
                        r_Freq2 <= to_unsigned(7975, 16);
                    when 55 =>
                        r_Freq0 <= to_unsigned(8418, 16);
                        r_Freq1 <= to_unsigned(8435, 16);
                        r_Freq2 <= to_unsigned(8393, 16);
                    when 56 =>
                        r_Freq0 <= to_unsigned(8919, 16);
                        r_Freq1 <= to_unsigned(8900, 16);
                        r_Freq2 <= to_unsigned(8936, 16);
                    when 57 =>
                        r_Freq0 <= to_unsigned(9449, 16);
                        r_Freq1 <= to_unsigned(9438, 16);
                        r_Freq2 <= to_unsigned(9405, 16);
                    when 58 =>
                        r_Freq0 <= to_unsigned(10011, 16);
                        r_Freq1 <= to_unsigned(10035, 16);
                        r_Freq2 <= to_unsigned(10004, 16);
                    when 59 =>
                        r_Freq0 <= to_unsigned(10606, 16);
                        r_Freq1 <= to_unsigned(10569, 16);
                        r_Freq2 <= to_unsigned(10580, 16);
                    when 60 =>
                        r_Freq0 <= to_unsigned(11237, 16);
                        r_Freq1 <= to_unsigned(11231, 16);
                        r_Freq2 <= to_unsigned(11291, 16);
                    when 61 =>
                        r_Freq0 <= to_unsigned(11905, 16);
                        r_Freq1 <= to_unsigned(11909, 16);
                        r_Freq2 <= to_unsigned(11926, 16);
                    when 62 =>
                        r_Freq0 <= to_unsigned(12613, 16);
                        r_Freq1 <= to_unsigned(12635, 16);
                        r_Freq2 <= to_unsigned(12656, 16);
                    when 63 =>
                        r_Freq0 <= to_unsigned(13363, 16);
                        r_Freq1 <= to_unsigned(13308, 16);
                        r_Freq2 <= to_unsigned(13359, 16);
                    when 64 =>
                        r_Freq0 <= to_unsigned(14157, 16);
                        r_Freq1 <= to_unsigned(14173, 16);
                        r_Freq2 <= to_unsigned(14099, 16);
                    when 65 =>
                        r_Freq0 <= to_unsigned(14999, 16);
                        r_Freq1 <= to_unsigned(15024, 16);
                        r_Freq2 <= to_unsigned(14930, 16);
                    when 66 =>
                        r_Freq0 <= to_unsigned(15891, 16);
                        r_Freq1 <= to_unsigned(15919, 16);
                        r_Freq2 <= to_unsigned(15864, 16);
                    when 67 =>
                        r_Freq0 <= to_unsigned(16836, 16);
                        r_Freq1 <= to_unsigned(16897, 16);
                        r_Freq2 <= to_unsigned(16879, 16);
                    when 68 =>
                        r_Freq0 <= to_unsigned(17837, 16);
                        r_Freq1 <= to_unsigned(17873, 16);
                        r_Freq2 <= to_unsigned(17765, 16);
                    when 69 =>
                        r_Freq0 <= to_unsigned(18898, 16);
                        r_Freq1 <= to_unsigned(18875, 16);
                        r_Freq2 <= to_unsigned(18824, 16);
                    when 70 =>
                        r_Freq0 <= to_unsigned(20022, 16);
                        r_Freq1 <= to_unsigned(20025, 16);
                        r_Freq2 <= to_unsigned(20081, 16);
                    when 71 =>
                        r_Freq0 <= to_unsigned(21212, 16);
                        r_Freq1 <= to_unsigned(21263, 16);
                        r_Freq2 <= to_unsigned(21316, 16);
                    when 72 =>
                        r_Freq0 <= to_unsigned(22473, 16);
                        r_Freq1 <= to_unsigned(22487, 16);
                        r_Freq2 <= to_unsigned(22477, 16);
                    when 73 =>
                        r_Freq0 <= to_unsigned(23810, 16);
                        r_Freq1 <= to_unsigned(23760, 16);
                        r_Freq2 <= to_unsigned(23801, 16);
                    when 74 =>
                        r_Freq0 <= to_unsigned(25226, 16);
                        r_Freq1 <= to_unsigned(25142, 16);
                        r_Freq2 <= to_unsigned(25275, 16);
                    when 75 =>
                        r_Freq0 <= to_unsigned(26726, 16);
                        r_Freq1 <= to_unsigned(26841, 16);
                        r_Freq2 <= to_unsigned(26821, 16);
                    when 76 =>
                        r_Freq0 <= to_unsigned(28315, 16);
                        r_Freq1 <= to_unsigned(28355, 16);
                        r_Freq2 <= to_unsigned(28251, 16);
                    when 77 =>
                        r_Freq0 <= to_unsigned(29998, 16);
                        r_Freq1 <= to_unsigned(29962, 16);
                        r_Freq2 <= to_unsigned(30131, 16);
                    when 78 =>
                        r_Freq0 <= to_unsigned(31782, 16);
                        r_Freq1 <= to_unsigned(31930, 16);
                        r_Freq2 <= to_unsigned(31793, 16);
                    when 79 =>
                        r_Freq0 <= to_unsigned(33672, 16);
                        r_Freq1 <= to_unsigned(33706, 16);
                        r_Freq2 <= to_unsigned(33692, 16);
                    when 80 =>
                        r_Freq0 <= to_unsigned(35674, 16);
                        r_Freq1 <= to_unsigned(35746, 16);
                        r_Freq2 <= to_unsigned(35531, 16);
                    when 81 =>
                        r_Freq0 <= to_unsigned(37796, 16);
                        r_Freq1 <= to_unsigned(37740, 16);
                        r_Freq2 <= to_unsigned(37962, 16);
                    when 82 =>
                        r_Freq0 <= to_unsigned(40043, 16);
                        r_Freq1 <= to_unsigned(40140, 16);
                        r_Freq2 <= to_unsigned(39948, 16);
                    when 83 =>
                        r_Freq0 <= to_unsigned(42424, 16);
                        r_Freq1 <= to_unsigned(42504, 16);
                        r_Freq2 <= to_unsigned(42604, 16);
                    when 84 =>
                        r_Freq0 <= to_unsigned(44947, 16);
                        r_Freq1 <= to_unsigned(44862, 16);
                        r_Freq2 <= to_unsigned(44809, 16);
                    when 85 =>
                        r_Freq0 <= to_unsigned(47620, 16);
                        r_Freq1 <= to_unsigned(47748, 16);
                        r_Freq2 <= to_unsigned(47799, 16);
                    when 86 =>
                        r_Freq0 <= to_unsigned(50451, 16);
                        r_Freq1 <= to_unsigned(50626, 16);
                        r_Freq2 <= to_unsigned(50379, 16);
                    when 87 =>
                        r_Freq0 <= to_unsigned(53451, 16);
                        r_Freq1 <= to_unsigned(53234, 16);
                        r_Freq2 <= to_unsigned(53323, 16);
                    when 88 =>
                        r_Freq0 <= to_unsigned(56630, 16);
                        r_Freq1 <= to_unsigned(56719, 16);
                        r_Freq2 <= to_unsigned(56383, 16);
                    when 89 =>
                        r_Freq0 <= to_unsigned(59997, 16);
                        r_Freq1 <= to_unsigned(59719, 16);
                        r_Freq2 <= to_unsigned(60138, 16);
                    when 90 =>
                        r_Freq0 <= to_unsigned(63565, 16);
                        r_Freq1 <= to_unsigned(63830, 16);
                        r_Freq2 <= to_unsigned(63361, 16);


                    when others =>
                        r_Freq0 <= to_unsigned(0, 16);
                        r_Freq1 <= to_unsigned(0, 16);
                        r_Freq2 <= to_unsigned(0, 16);

                end case;

                
            end if; -- Busy = '0'
            
        end if;

    end process;

    Freq0 <= std_logic_vector(r_Freq0);
    Freq1 <= std_logic_vector(r_Freq1);
    Freq2 <= std_logic_vector(r_Freq2);
    
end Behavioral;