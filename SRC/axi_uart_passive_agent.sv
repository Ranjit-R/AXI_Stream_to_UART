class axi_uart_passive_agent extends uvm_agent;

  axi_uart_passive_monitor mon_p;
  uvm_active_passive_enum mode;

  `uvm_component_utils(axi_uart_passive_agent)

  function new(string name = "axi_uart_passive_agent",uvm_component parent);
    super.new(name,parent);
  endfunction

 /* virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE)
      mon_p = axi_uart_passive_monitor::type_id::create("mon_p",this);
  endfunction*/

virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);

//  uvm_active_passive_enum mode;
  if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active", mode))
    mode = UVM_PASSIVE; // default

  if(mode == UVM_PASSIVE)
    mon_p = axi_uart_passive_monitor::type_id::create("mon_p", this);
endfunction

endclass

