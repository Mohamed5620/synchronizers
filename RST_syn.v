
module RST_syn #(parameter NUM_STAGES=5) (

input RST,
input CLK,
output reg SYNC_RST

);

reg [NUM_STAGES-2:0] q;

always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     SYNC_RST <= 1'b0;
	  end
	 else
	  begin
	     SYNC_RST <= q[NUM_STAGES-2];
	  end 	 
  end
  
always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     q <= 'b0;
	  end
	 else if ( NUM_STAGES == 2'b10)
	  begin	  
	     q[0] <= 1'b1;
	  end
	 else
	  begin
	     q[0] <= 1'b1;
		 q[NUM_STAGES-2:1] <= q[NUM_STAGES-3:0];
	  end    	 	  
  end

endmodule  