`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "axi_uart_pkg.sv"
//`include "global_pkg.sv"
`include "axi_uart_interface.sv"
`include "design.v"
`include "top_axis_uart.sv"


module top;
  import uvm_pkg::*;
  import global_pkg::*;
  import axi_uart_pkg::*;

  bit clk = 0;
  bit reset;

  always #10 clk = ~clk;

  initial
    begin
      reset = 1;
      #5 reset = 0;
    end

  axi_uart_interface intf(clk,reset);

  top_axis_uart dut(.clk(clk),
                    .rst(reset),
                    .axis_data(intf.axis_data),
                    .axis_valid(intf.axis_valid),
                    .axis_last(intf.axis_last),
                    .uart_tx(intf.uart_tx),
                    .rx_valid(intf.rx_valid),
                    .m_axis_ready(intf.m_axis_ready),
                    .rx_data(intf.rx_data));


  initial
    begin
      uvm_config_db #(virtual axi_uart_interface)::set(null,"*","password",intf);
    end
  initial
    begin
      run_test("axi_uart_test");
    end
endmodule

