`timescale 1ns/1ps

module data_syn_tb();

parameter BUS_WIDTH = 2;
parameter NUM_STAGES = 5;

reg [BUS_WIDTH-1:0] Unsync_bus_tb;
reg CLK_tb;
reg RST_tb;
reg bus_enable_tb;
wire [BUS_WIDTH-1:0] sync_bus_tb;
wire enable_pulse_tb;
integer i;

initial
  begin
     $dumpfile("data_syn.txt");
	 $dumpvars;
	 
	 start();
	 reset();
	 op('b11,1'b1);
	 op('b01,1'b0);
	 #100
	 $finish;
  end

task start;
  begin
     Unsync_bus_tb = 'b0;
	 CLK_tb = 1'b0;
	 RST_tb = 1'b1;
	 bus_enable_tb = 1'b0;
  end
endtask

task reset;
  begin
     # 1
	 RST_tb = 1'b0;
	 # 1
	 RST_tb = 1'b1;
  end
endtask

task op;
input [BUS_WIDTH-1:0] data;
input en;
  begin
     Unsync_bus_tb = data;
	 bus_enable_tb = en;
	 check();
  end
endtask

task check;
  begin
     i=0;
	 repeat(NUM_STAGES+1) @ (posedge CLK_tb)
	  begin
	     i=i+1;
		 #1
  	     if ((i== NUM_STAGES+1)&& (sync_bus_tb==Unsync_bus_tb) && enable_pulse_tb)
	     $display("%d clock cycles to reach output",i);
	     else if ((i== NUM_STAGES+1)&& ((sync_bus_tb!=Unsync_bus_tb) || !enable_pulse_tb))
	     $display("output isnt enabled");
	     else
	     $display("%d edge",i);
	  end 
  end
endtask

data_syn d1(
.Unsync_bus(Unsync_bus_tb),
.CLK(CLK_tb),
.RST(RST_tb),
.bus_enable(bus_enable_tb),
.sync_bus(sync_bus_tb),
.enable_pulse(enable_pulse_tb)
);

always #10 CLK_tb=~CLK_tb;

endmodule  