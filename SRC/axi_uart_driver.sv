`include "defines.svh"
import global_pkg::*;

class axi_uart_driver extends uvm_driver #(axi_uart_seq_item);

  `uvm_component_utils(axi_uart_driver)

  virtual axi_uart_interface vif;
  int count;
  int tgl = 0;

  function new(string name = "axi_uart_driver", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual axi_uart_interface) :: get(this,"","password",vif))
      `uvm_fatal("DRV","interface not found");
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
	if (vif.reset == 1) begin
		vif.axis_data <= 0;
		vif.axis_last <= 0;
		vif.axis_valid <= 0;
	
        wait(vif.reset == 0);
	end
        seq_item_port.get_next_item(req);
	 drive();
	seq_item_port.item_done();
 
      end
  endtask

  task drive();
    @(posedge vif.drv_cb);
    if((global_data::count  < global_data::pkt && vif.m_axis_ready && global_data::count < 7))begin
       $display( " global_data::count %0d | global_data::pkt %0d",global_data::count, global_data::pkt);
     vif.axis_valid <= req.axis_valid;
     vif.axis_data <= req.axis_data;
     vif.axis_last <= 0;
      end
    else begin 
       vif.axis_data <= req.axis_data;
        vif.axis_last <= 1;
        @(posedge vif.drv_cb);
      	vif.axis_valid <= 0;
	global_data::count ++;
	 
    end

 `uvm_info("DRIVER_DRIVING",$sformatf("Driving from driver data %d",vif.axis_data),UVM_LOW);
    req.print();
  endtask
endclass

