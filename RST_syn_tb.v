`timescale 1ns/1ps

module RST_syn_tb ();

parameter NUM_STAGES=5;

reg RST_tb;
reg CLK_tb;
wire SYNC_RST_tb;
integer i;

initial
  begin
     $dumpfile("RST_syn.txt");
	 $dumpvars;
	 
	 start();
	 #10
	 op(1'b1);
	 op(1'b0);
	 op(1'b1);
	 #100;
	 $finish;
  end

task start;
  begin
     RST_tb = 1'b0;
	 CLK_tb = 1'b0;
  end
endtask

task op;
input de_assr;
  begin
     RST_tb = de_assr;
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
		 if ((i==NUM_STAGES)&&((SYNC_RST_tb&&RST_tb)||(!SYNC_RST_tb && !RST_tb)))
		 $display("case passed");
		 else if ((i==NUM_STAGES)&&((!SYNC_RST_tb && RST_tb)||(SYNC_RST_tb && !RST_tb)))
		 $display("case failed");
		 else
		 $display("%d edge",i);
	  end
  end
endtask

RST_syn r1 (
.RST(RST_tb),
.CLK(CLK_tb),
.SYNC_RST(SYNC_RST_tb)
);

always #10 CLK_tb=~CLK_tb;

endmodule  