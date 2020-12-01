# Applying Stochastic Computing to Audio Synthesis

This project is an attempt to use stochastic computing to build an audio synthesizer on FPGA.

All the experiments has been performed on Altera Cyclone IV FPGA (EP4CE15F23C8) with master clock at 100MHz (via PLL). HDL code is compiled with Quartus Prime 20.1.0.

- [Stochastic computing](docs/stochastic_computing.md)
- [Synthesizer architecture](docs/synth_architecture.md)
- [Dealing with the noise](docs/synth_noise.md)

### Sound example

- :speaker: [3 oscilators raw](docs/audio/sc_3osc_6poly.mp3)
- :speaker: [6 oscillators with modulated filter](docs/audio/sc_6osc_6poly_eqd.mp3)
