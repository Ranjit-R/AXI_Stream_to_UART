#####################################################################################################################
AXI Stream to UART Communication System
Designer : Shreenidhi K, Punith Roy
Verification engineers : Vadali kirti Krishna Vamsi, Mutchakala Raja Vardhan, Swathi Rathod, Shama M, Ranjith R
Specification Provided By: Mirafra Technologies
Date: 05-11-2025
#####################################################################################################################

Overview
This project implements a communication system that transfers parallel data from an AXI-Stream interface to a UART serial output. It supports buffering via a synchronous FIFO to handle speed mismatches between AXI Stream master and UART transmitter. The UART receiver deserializes received data, verifies parity, and outputs data in parallel form.

Key Features
Interface between AXI-Stream and UART serial line
Synchronous FIFO buffering for data rate adaptation
Supports AXI Stream handshaking signals: valid, ready, last
UART frame format: 8 data bits, even parity, 1 start bit, 1 stop bit
UART baud rate fixed at 115200 bps
Parallel data width of 8 bits
Clock frequency of 50 MHz
FIFO depth of 8 bytes
Parity check included in UART receive logic

Design Details
| Parameter             | Value      |
| --------------------- | ---------- |
| AXI Stream Data Width | 8 bits     |
| UART Baud Rate        | 115200 bps |
| Clock Frequency       | 50 MHz     |
| FIFO Depth            | 8 bytes    |

Functional Blocks
AXI Stream Input Stage: Accepts data and control signals from AXI Stream master, writes to FIFO when ready.
FIFO Buffer: Handles asynchronous data buffering between AXI Stream and UART.
UART Transmitter: Serializes buffered data with start, data, parity, and stop bits.
UART Receiver: Deserializes incoming UART data, checks parity, outputs parallel data.

Verification Summary
The design has been fully verified with testbenches that confirmed:
Correct AXI Stream handshaking and data acceptance
FIFO operation with read/write and full/empty conditions
UART transmission frame format and timing
UART reception with parity verification and data validity signaling

Signals
| Signal Name | Direction | Description                                              |
| ----------- | --------- | -------------------------------------------------------- |
| clk         | Input     | System clock (50 MHz)                                    |
| rst         | Input     | Active high synchronous reset                            |
| axisdata    | Input     | 8-bit parallel data from AXI Stream master               |
| axisvalid   | Input     | AXI Stream valid signal                                  |
| axislast    | Input     | Last data byte indicator in AXI frame                    |
| maxisready  | Output    | Indicates FIFO is ready to accept data                   |
| uarttx      | Output    | UART serial transmit line                                |
| rxvalid     | Output    | High for 1 clock cycle on successful UART data reception |
| rxdata      | Output    | 8-bit parallel data output from UART reception           |


