


module hilo_reg(

	input clk,
	input rst,
	
	input 	ena,
	input[31:0]   hi_i,
	input[31:0]   lo_i,
	

	output reg[31:0] hi_o,
	output reg[31:0] lo_o


);

	always@( posedge clk) begin
		if(!rst ) begin
			hi_o <= 0;
			lo_o <= 0;
		end
		else if(ena) begin
			hi_o <= hi_i;
			lo_o <= lo_i;
		end
	end


endmodule