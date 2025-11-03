class axi_uart_environment extends uvm_env;

  `uvm_component_utils(axi_uart_environment)

  axi_uart_active_agent active_agent;
  axi_uart_passive_agent passive_agent;
  axi_uart_scoreboard scb;
  axi_uart_subscriber sub;

  function new(string name = "axi_uart_environment", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    active_agent = axi_uart_active_agent::type_id::create("active_agent",this);
    passive_agent = axi_uart_passive_agent::type_id::create("passive_agent",this);
    scb = axi_uart_scoreboard::type_id::create("scb",this);
    sub = axi_uart_subscriber::type_id::create("sub",this);
    uvm_config_db #(uvm_active_passive_enum)::get(null,"env.passive_agent","is_active",UVM_PASSIVE);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
`uvm_info("BUILD_CHECK",
  $sformatf(
    "active_agent=%s, active_agent.mon_a=%s, passive_agent=%s, passive_agent.mon_p=%s, scb=%s, scb.scb_act_port=%s, scb.scb_pas_port=%s, sub=%s",
    (active_agent != null) ? "OK" : "NULL",
    (active_agent != null && active_agent.mon_a != null) ? "OK" : "NULL",
    (passive_agent != null) ? "OK" : "NULL",
    (passive_agent != null && passive_agent.mon_p != null) ? "OK" : "NULL",
    (scb != null) ? "OK" : "NULL",
    (scb != null && scb.scb_act_port != null) ? "OK" : "NULL",
    (scb != null && scb.scb_pas_port != null) ? "OK" : "NULL",
    (sub != null) ? "OK" : "NULL"
  ),
  UVM_LOW
)

    active_agent.mon_a.mon_act_port.connect(scb.scb_act_port.analysis_export);
    active_agent.mon_a.mon_act_port.connect(sub.cov_act_port.analysis_export);
    passive_agent.mon_p.mon_pas_port.connect(scb.scb_pas_port.analysis_export);
    passive_agent.mon_p.mon_pas_port.connect(sub.cov_pas_port.analysis_export);
  endfunction
endclass


