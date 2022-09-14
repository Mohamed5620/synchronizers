
module data_syn #(parameter BUS_WIDTH = 2,parameter NUM_STAGES = 5) (

input [BUS_WIDTH-1:0] Unsync_bus,
input CLK,
input RST,
input bus_enable,
output reg [BUS_WIDTH-1:0] sync_bus,
output reg enable_pulse

);

wire [BUS_WIDTH-1:0] D_syn;
wire sel;
reg Q_enable_syn;
reg [NUM_STAGES-1:0] q;
integer i;
 
assign D_syn = (sel) ? Unsync_bus:sync_bus;
assign sel = q[NUM_STAGES-1] && !Q_enable_syn;

always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     sync_bus <= 'b0;
	  end
	 else
	  begin
	     sync_bus <= D_syn;	     
	  end
  end

always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     enable_pulse <= 'b0;
	  end
	 else
	  begin
	     enable_pulse <= sel;	     
	  end
  end
  
always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     Q_enable_syn <= 'b0;
	  end
	 else
	  begin
	     Q_enable_syn <= q[NUM_STAGES-1];	     
	  end
  end  

always @ (posedge CLK or negedge RST)
  begin
     if (!RST)
	  begin
	     for (i=0;i<NUM_STAGES;i=i+1)
		  begin
		     q[i] <= 'b0;
		  end
	  end
	 else
	  begin
	     q[0] <= bus_enable;
		 for(i=1;i<NUM_STAGES;i=i+1)
		  begin
		     q[i] <= q[i-1];
		  end
	  end
  end
  

endmodule  