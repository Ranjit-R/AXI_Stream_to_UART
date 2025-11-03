package global_pkg;
class global_data;
  static int count;
  static int valid_data_count;
  static int pkt_count;
  static int baud_count;
  static rand int pkt;
  constraint a1{pkt  inside {[6:15]};}
endclass
endpackage

