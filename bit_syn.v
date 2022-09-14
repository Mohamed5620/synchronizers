
module bit_syn #(parameter BUS_WIDTH = 2,parameter NUM_STAGES = 5) (

input [BUS_WIDTH-1:0] ASYNC,
input CLK,
input RST,
output reg [BUS_WIDTH-1:0] SYNC

);

integer i;
reg [BUS_WIDTH-1:0] q [NUM_STAGES-2:0]; 

always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     SYNC <= 'b0;
	  end
	 else
	  begin
	     SYNC <= q[NUM_STAGES-2];	     
	  end
  end

always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     for (i=0;i<NUM_STAGES-1;i=i+1)
		  begin
		     q[i] <= 'b0;
		  end
	  end
	 else
	  begin
	     q[0] <= ASYNC;
		 for(i=1;i<NUM_STAGES-1;i=i+1)
		  begin
		     q[i] <= q[i-1];
		  end
	  end
  end
  

endmodule