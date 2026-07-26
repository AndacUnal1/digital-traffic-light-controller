# Digital Traffic Light Controller

A parameterized traffic light controller written in Verilog HDL and verified through behavioral simulation in Xilinx Vivado.

The design uses a finite-state machine to implement the following sequence:

```text
RED -> YELLOW -> GREEN -> YELLOW -> RED
```

## Features

- Three-block FSM architecture
- Configurable red, yellow, and green durations
- Optional yellow-state bypass
- Configurable reset color
- Synchronous active-high reset
- Automated testbench with duration and mid-cycle reset checks

## Signal interface

| Signal | Direction | Description |
| --- | --- | --- |
| `clk_i` | Input | System clock |
| `rst_i` | Input | Active-high synchronous reset |
| `light_o[1:0]` | Output | Encoded light state: red `00`, yellow `01`, green `10` |

## Parameters

| Parameter | Default | Description |
| --- | ---: | --- |
| `RED_DURATION` | `5` | Number of clock cycles in the red state |
| `YELLOW_DURATION` | `2` | Number of clock cycles in each yellow state |
| `GREEN_DURATION` | `4` | Number of clock cycles in the green state |
| `RESET_COLOR` | `2'b00` | Light state selected by reset |
| `ENABLE_YELLOW` | `1` | Enables or bypasses the yellow states |

## Repository structure

```text
src/
  traffic_light_controller.v
sim/
  tb_traffic_light.v
```

## Run a Vivado simulation

1. Create a Vivado RTL project.
2. Add `src/traffic_light_controller.v` as a design source.
3. Add `sim/tb_traffic_light.v` as a simulation source.
4. Set `tb_traffic_light` as the simulation top.
5. Run behavioral simulation and review the console checks and waveform.

## Tools and target

- Verilog HDL
- Xilinx Vivado
- Kintex-7 FPGA coursework target

## Author

Andaç Ünal

