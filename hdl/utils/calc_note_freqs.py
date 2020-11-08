"""
Calculate notes frequencies and generate vhdl code.
"""
import random

def note_number_to_freq(n):
    return 440.0 * 2.0 ** ((n - 69)/12.0)

def note_number_to_name(n):
    notes=['A', 'A#', 'B', 'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#']
    return notes[(n - 21) % len(notes)] + str(int((n - 12) / 12))

def freq_to_code(f):
    CLK = 100.0 # MHz
    d = 65536.0**2 / 1000000.0
    return int(f * d / CLK + 0.5)

def rand(f, l=0.01):
    x = f
    while (int(x*10.0) == int(f*10.0)):
        x = f * (1.0 + l * (random.random() - 0.5))
    return x



for n in range(12, 91):
    f0 = note_number_to_freq(n)
    f1 = rand(f0)
    f2 = rand(f0)

    note = note_number_to_name(n)

    d0 = freq_to_code(f0)
    d1 = freq_to_code(f1)
    d2 = freq_to_code(f2)

    print('when', n, '=>')
    print('    r_Freq0 <= to_unsigned(' + str(d0) + ', 16);')
    print('    r_Freq1 <= to_unsigned(' + str(d1) + ', 16);')
    print('    r_Freq2 <= to_unsigned(' + str(d2) + ', 16);')
