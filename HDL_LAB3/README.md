# VHDL Counter and Seven-Segment Display

This lab combines parameterized sequential logic with display interfacing on the DE1-SoC FPGA platform. It includes a generic counter, clock-driven blink design, binary-coded display logic, and simulation testbenches.

## Highlights

- Implements a configurable synchronous counter
- Divides or counts clock cycles to create a visible blink rate
- Converts binary values for seven-segment display output
- Uses testbenches and ModelSim waveform configuration
- Includes Quartus pin assignments for DE1-SoC hardware

## Key Sources

- `generic_counter.vhd` — configurable counter
- `generic_adder_beh.vhd` — reusable arithmetic component
- `blink/src/` — FPGA blink design and top-level entity
- `BCD/src/seven_seg.vhd` — seven-segment decoder
- `seven_seg_tb.vhd` and `blink/sim/src/blink_tb.vhd` — simulation testbenches

## Tools and Skills

VHDL, sequential logic, counters, clock division, seven-segment displays, ModelSim, Intel Quartus Prime, and DE1-SoC FPGA development.
