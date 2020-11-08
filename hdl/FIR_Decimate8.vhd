--------------------------------------------------------------------------------
-- FIR_Decimate8.vhd
--------------------------------------------------------------------------------
-- 8-bit unsigned input, 16-bit unsigned output
-- FIR filter with decimation by 8.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity FIR_Decimate8 is
    port(
        Clk    : in std_logic;
        Input  : in std_logic_vector(7 downto 0);
        Sample : in std_logic;
        
        Q      : out std_logic_vector(15 downto 0);
        Ready  : out std_logic
    );
end entity;

architecture Behavioral of FIR_Decimate8 is

    -- Decimation=8 gives us 49019.6078Hz sampling rate at 16 bit output.
    -- We can increase the sampling rate using shorter decimation, but this will also
    -- limit the length of the FIR kernel
    constant Decimation : integer := 8;

    -- Maximum kernel length is Input'length * Decimation = 2048
    constant Kernel_Length : integer := 679;
    type Kernel_Type is array (0 to Kernel_Length - 1) of integer;
    

    -- Filter coefficients are premultiplied by 0x80000 (524288)
    constant kernel : Kernel_Type := (
        -1, -1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, -1, -2,
        -2, -2, -2, -1, 0, 0, 1, 2, 3, 3, 3, 2, 0, 0, -2, -3,
        -4, -5, -4, -3, -1, 0, 3, 5, 6, 7, 6, 5, 2, 0, -3, -6,
        -9, -10, -9, -7, -4, 0, 4, 8, 11, 13, 13, 11, 6, 1, -4, -10,
        -15, -18, -18, -15, -10, -3, 4, 12, 19, 23, 24, 21, 14, 5, -4, -15,
        -24, -29, -31, -28, -20, -9, 3, 17, 29, 37, 40, 37, 28, 15, -1, -19,
        -34, -46, -51, -48, -38, -22, -1, 20, 41, 56, 64, 62, 51, 32, 6, -21,
        -47, -67, -79, -79, -67, -44, -13, 20, 53, 80, 96, 98, 86, 60, 24, -17,
        -59, -93, -115, -121, -109, -80, -37, 12, 64, 108, 137, 148, 137, 105, 55, -4,
        -67, -122, -162, -179, -170, -135, -78, -6, 68, 137, 188, 214, 208, 171, 106, 23,
        -67, -151, -217, -253, -252, -214, -142, -45, 61, 164, 247, 296, 303, 265, 186, 75,
        -51, -175, -278, -344, -361, -325, -238, -113, 34, 183, 310, 396, 426, 394, 301, 160,
        -10, -186, -341, -452, -499, -473, -376, -219, -23, 184, 372, 511, 580, 565, 464, 291,
        67, -174, -400, -574, -669, -668, -567, -378, -125, 155, 424, 639, 767, 786, 688, 483,
        199, -124, -442, -706, -875, -919, -827, -609, -292, 79, 454, 775, 992, 1069, 990, 760,
        408, -17, -456, -843, -1119, -1239, -1178, -939, -551, -67, 446, 911, 1259, 1432, 1398, 1154,
        729, 178, -419, -978, -1413, -1654, -1657, -1414, -949, -325, 372, 1042, 1584, 1911, 1966, 1730,
        1225, 517, -298, -1103, -1778, -2216, -2341, -2122, -1576, -770, 187, 1159, 2003, 2586, 2809, 2622,
        2033, 1111, -23, -1210, -2277, -3056, -3417, -3284, -2651, -1584, -219, 1255, 2627, 3685, 4251, 4211,
        3533, 2278, 594, -1293, -3117, -4601, -5496, -5625, -4909, -3386, -1219, 1323, 3896, 6116, 7617, 8102,
        7390, 5453, 2436, -1345, -5432, -9262, -12230, -13760, -13374, -10755, -5799, 1358, 10346, 20577, 31300, 41672,
        50838, 58022, 62600, 64172, 62600, 58022, 50838, 41672, 31300, 20577, 10346, 1358, -5799, -10755, -13374, -13760,
        -12230, -9262, -5432, -1345, 2436, 5453, 7390, 8102, 7617, 6116, 3896, 1323, -1219, -3386, -4909, -5625,
        -5496, -4601, -3117, -1293, 594, 2278, 3533, 4211, 4251, 3685, 2627, 1255, -219, -1584, -2651, -3284,
        -3417, -3056, -2277, -1210, -23, 1111, 2033, 2622, 2809, 2586, 2003, 1159, 187, -770, -1576, -2122,
        -2341, -2216, -1778, -1103, -298, 517, 1225, 1730, 1966, 1911, 1584, 1042, 372, -325, -949, -1414,
        -1657, -1654, -1413, -978, -419, 178, 729, 1154, 1398, 1432, 1259, 911, 446, -67, -551, -939,
        -1178, -1239, -1119, -843, -456, -17, 408, 760, 990, 1069, 992, 775, 454, 79, -292, -609,
        -827, -919, -875, -706, -442, -124, 199, 483, 688, 786, 767, 639, 424, 155, -125, -378,
        -567, -668, -669, -574, -400, -174, 67, 291, 464, 565, 580, 511, 372, 184, -23, -219,
        -376, -473, -499, -452, -341, -186, -10, 160, 301, 394, 426, 396, 310, 183, 34, -113,
        -238, -325, -361, -344, -278, -175, -51, 75, 186, 265, 303, 296, 247, 164, 61, -45,
        -142, -214, -252, -253, -217, -151, -67, 23, 106, 171, 208, 214, 188, 137, 68, -6,
        -78, -135, -170, -179, -162, -122, -67, -4, 55, 105, 137, 148, 137, 108, 64, 12,
        -37, -80, -109, -121, -115, -93, -59, -17, 24, 60, 86, 98, 96, 80, 53, 20,
        -13, -44, -67, -79, -79, -67, -47, -21, 6, 32, 51, 62, 64, 56, 41, 20,
        -1, -22, -38, -48, -51, -46, -34, -19, -1, 15, 28, 37, 40, 37, 29, 17,
        3, -9, -20, -28, -31, -29, -24, -15, -4, 5, 14, 21, 24, 23, 19, 12,
        4, -3, -10, -15, -18, -18, -15, -10, -4, 1, 6, 11, 13, 13, 11, 8,
        4, 0, -4, -7, -9, -10, -9, -6, -3, 0, 2, 5, 6, 7, 6, 5,
        3, 0, -1, -3, -4, -5, -4, -3, -2, 0, 0, 2, 3, 3, 3, 2,
        1, 0, 0, -1, -2, -2, -2, -2, -1, 0, 0, 0, 1, 1, 1, 1,
        0, 0, 0, 0, 0, -1, -1
    );

    type Queue_Type is array (0 to Kernel_Length + Decimation) of integer;
    signal queue : Queue_Type := (others => 0);

    signal queue_index : integer := 0;
    signal samples_received : integer := 0;
    
    signal processing_left : integer := 0;
    signal processing_index : integer := 0;
    
    signal accumulator : integer := 0;
    
    signal output : std_logic_vector(15 downto 0);
    
begin
    process(Clk)
        variable queue_index_next : integer;
        variable samples_received_so_far : integer;
        
        variable next_accumulator : integer;
        variable next_processing_left : integer;
        
        variable accumulator_unsigned : unsigned (31 downto 0);
        
    begin
    
        if rising_edge(Clk) then

            if processing_left > 0 then
                next_processing_left := processing_left - 1;

                next_accumulator := accumulator + queue(processing_index) * kernel(next_processing_left);
                                
                if processing_index = 0 then
                    processing_index <= queue'length - 1;
                else
                    processing_index <= processing_index - 1;
                end if;
                
                if next_processing_left = 0 then
                    -- Processing is over
                    if next_accumulator < 0 then
                        output <= (others => '0');
                    elsif next_accumulator > 134217727 then
                        output <= (others => '1');
                    else
                        -- Divide output by 256
                        accumulator_unsigned := to_unsigned(next_accumulator, accumulator_unsigned'length);
                        output <= std_logic_vector(accumulator_unsigned)(26 downto 11);
                    end if;
                    
                    Ready <= '1';
                else
                    Ready <= '0';
                    
                end if;
                
                processing_left <= next_processing_left;
                accumulator <= next_accumulator;            
            end if;
        
            -- Receive incoming sample
            if Sample = '1' then                
                queue(queue_index) <= to_integer(unsigned(Input));
                queue_index_next := queue_index + 1;
                
                if (queue_index_next = queue'length) then
                    queue_index_next := 0;
                end if;
                
                queue_index <= queue_index_next;
                samples_received_so_far := samples_received + 1;
                
                if samples_received_so_far = Decimation then
                    samples_received <= 0;
                    processing_left <= kernel'length;
                    processing_index <= queue_index;
                    accumulator <= 0;
                else
                    samples_received <= samples_received_so_far;
                end if;
            end if;

        end if;
        
        Q <= output;
        
    end process;

end Behavioral;