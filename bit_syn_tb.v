`timescale 1ns/1ps

module bit_syn_tb();

parameter BUS_WIDTH = 2;
parameter NUM_STAGES = 5;

reg [BUS_WIDTH-1:0] ASYNC_tb;
reg CLK_tb;
reg RST_tb;
wire [BUS_WIDTH-1:0] SYNC_tb;
integer i;

initial
  begin
     $dumpfile("bit_syn.txt");
	 $dumpvars;
	 
	 start();
	 reset();
	 op('b11);
	 op('b01);
	 #100
	 $finish;
  end

task start;
  begin
     ASYNC_tb = 'b0;
	 CLK_tb = 1'b0;
	 RST_tb = 1'b1;
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
  begin
     ASYNC_tb = data;
	 check();
  end
endtask

task check;
  begin
     i=0;
	 repeat(NUM_STAGES) @ (posedge CLK_tb)
	  begin
	     i=i+1;
		 #1
  	     if ((i== NUM_STAGES)&& (SYNC_tb==ASYNC_tb))
	     $display("%d clock cycles to reach output",NUM_STAGES);
	     else if ((i== NUM_STAGES)&& (SYNC_tb!=ASYNC_tb))
	     $display("case failed");
	     else
	     $display("%d edge",i);
	  end 
  end
endtask

bit_syn b1(
.ASYNC(ASYNC_tb),
.CLK(CLK_tb),
.RST(RST_tb),
.SYNC(SYNC_tb)
);

always #10 CLK_tb=~CLK_tb;

endmodule  