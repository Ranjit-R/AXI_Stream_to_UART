interface axi_uart_interface(input logic clk,input logic reset);

  logic [7:0] axis_data;
  logic axis_valid;
  logic axis_last;
  logic [7:0] rx_data;
  logic uart_tx;
  logic rx_valid;
  logic m_axis_ready;

  clocking drv_cb @(posedge clk);
    default input #0 output #0;
    output axis_data;
    output axis_valid;
    output axis_last;
    input m_axis_ready;
  endclocking

  clocking mon_active_cb @(posedge clk);
    default input #0 output #0;
    input axis_data;
    input axis_valid;
    input axis_last;
    input m_axis_ready;
  endclocking

  clocking mon_passive_cb @(posedge clk);
    default input #0 output #0;
    input rx_data;
    input uart_tx;
    input rx_valid;
  endclocking

  modport drv(clocking drv_cb, input clk,reset);
    modport mon_active(clocking mon_active_cb, input clk,reset);
      modport mon_passive(clocking mon_passive_cb, input clk,reset);



 /*
property p1;

  @(posedge clk) disable iff (reset)

    axis_valid |-> !$isunknown(axis_data);

endproperty

assert property(p1) 
     else $error("p1 failed: axis_data has unknown values when axis_valid is high");



property p2;

  @(posedge clk) disable iff (!reset) 

  (!rx_data && uart_tx && !rx_valid && m_axis_ready);

endproperty 

assert property (p2)
     else $error("p2 failed: Signals not in expected state during reset");
 
 


 
property p3;

  @(posedge clk) disable iff (reset)

    axis_valid && !m_axis_ready |=> $stable(axis_data);

endproperty

assert property(p3)  
else $error("p3 failed: axis_data changed while axis_valid high and m_axis_ready low");
 

property p4;

  @(posedge clk) disable iff (reset)

    $fell(uart_tx)|->##(11*434) $rose(uart_tx)|-> ##(434) $rose(rx_valid);

endproperty

assert property (p4) $display(" P4 PASS");
 	else $error("p4 failed: uart_tx has unknown values 4774 cycles after axis_valid");
 
property p4;

  @(posedge clk) disable iff (reset)

    (axis_valid && m_axis_ready) |-> ##434 (!$unknown(uart_tx))[*11];

endproperty

assert property (p4) else $error("p4 failed: uart_tx not stable for 11 cycles starting 434 cycles after AXI transaction");
 
property p5;

  @(posedge clk) disable iff (reset)

    axis_valid |-> ##4774 !$unknown(rx_data);

endproperty

assert property (p5) else $error("p5 failed: rx_data has unknown values 4774 cycles after axis_valid");

 


property p6;

  @(posedge clk) disable iff (reset)

    rx_valid |-> !$unknown(rx_data);

endproperty

assert property (p6) else $error("p6 failed: rx_data has unknown values when rx_valid is high");
 */
 

endinterface

