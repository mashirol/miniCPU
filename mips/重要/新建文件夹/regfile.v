

module regfile(

input clk,
input rst,

input           ena_i,
input[4:0]  	waddr,
input[31:0]  	wdata,

input           rena1,
input           rena2,
input[31:0] 	raddr1_i,
input[31:0] 	raddr2_i,

output reg[31:0] rdata1_o,
output reg[31:0] rdata2_o,
output[31:0] regt

);

reg[31:0] regs[0:31];
integer i;

assign regt = regs[1];


	always@ (posedge clk) begin
		if(!rst) begin
			for(i=1;i<32;i=i+1) 
				regs[i] <= 0;
			regs[0] <= 5;
		end
		else begin
		 	 if((ena_i)&&(waddr != 0)) begin
				regs[waddr] <= wdata;
		  	end
		  	else begin
				for(i=0;i<32;i=i+1) 
					regs[i] <= regs[i];
		  	end
		end
	end



	always @(*) begin
		if(!rst) begin
			rdata1_o <=0;
		end
		/*else if(raddr1_i == 0) begin
			rdata1_o <=0;
		end*/
		else if (rena1 == `Enable_read) begin
			rdata1_o <= regs[raddr1_i];
		end
		else begin
			rdata1_o <=0;
		end
	end






	always @(*) begin
		if(!rst) begin
			rdata2_o <= 0;
		end
		/*else if(raddr2_i == 0 ) begin
			rdata2_o <=0;
		end*/
		else if (rena2 == `Enable_read) begin
			rdata2_o <= regs[raddr2_i];
		end
		else begin
			rdata2_o <=0;
		end
	end



endmodule







