import global_pkg::*;

`include "defines.svh"
class axi_uart_active_monitor extends uvm_monitor;

  `uvm_component_utils(axi_uart_active_monitor)
 int  pkt_count;
  uvm_analysis_port #(axi_uart_seq_item) mon_act_port;
  virtual axi_uart_interface vif;
  axi_uart_seq_item mon;

  function new(string name = "axi_uart_active_monitor",uvm_component parent);
    super.new(name,parent);
    mon_act_port = new("mon_port_active",this);
    mon = new;
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual axi_uart_interface)::get(this,"","password",vif))
      `uvm_fatal("MON-ACT","no-interface found");
  endfunction

 virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if( vif.reset ) wait( vif.reset == 0);
    @(posedge vif.mon_active_cb);
    global_data::valid_data_count = 0;
    forever begin
      if(global_data::pkt_count <= global_data::pkt ) begin
         if( vif.axis_valid && global_data::valid_data_count <= 7) begin
	 capture();
         global_data::valid_data_count++;
         $display(" valid_data_count %0d ",global_data::valid_data_count);
         end
         global_data::pkt_count ++;
         @(posedge vif.mon_active_cb);
         if(mon.axis_last == 1) begin
           wait_task();
         end
      end
     else begin
      global_data::pkt_count ++;
      @(posedge vif.mon_active_cb);
     end
    end
  endtask

  task capture();
    
    mon.axis_data  = vif.axis_data;
    mon.axis_valid = vif.axis_valid;
    mon.axis_last  = vif.axis_last;
    mon.m_axis_ready = vif.m_axis_ready;

   `uvm_info("ACTIVE_MONITOR",$sformatf("Active monitor driving data %d to scoreboard",mon.axis_data),UVM_LOW);
    mon.print();
    mon_act_port.write(mon); 

  endtask

  task wait_task();
    for(int i = 0; i < 4774 * global_data::valid_data_count ; i++)
      begin
        @(posedge vif.mon_active_cb);
      end
  endtask
endclass

