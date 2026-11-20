# Generic VHDL Adder

This lab develops a parameterized binary adder in VHDL and compares behavioral and hierarchical architectural approaches. The design extends a verified one-bit full adder into a reusable multi-bit component.

## Highlights

- Uses VHDL generics to configure operand width
- Implements behavioral and structural/architectural versions
- Reuses a one-bit full adder in a hierarchical design
- Includes testbenches for functional simulation
- Includes Intel Quartus project files for FPGA synthesis

## Repository Layout

- `full_adder_single_bit_arch/` — reusable one-bit full adder
- `generic_adder_arch/` — hierarchical generic adder
- `generic_adder_beh/` — behavioral generic adder
- `lab2.pdf` — original lab reference

## Tools and Skills

VHDL, generics, component instantiation, ripple-carry arithmetic, ModelSim simulation, Intel Quartus Prime, and FPGA synthesis.
