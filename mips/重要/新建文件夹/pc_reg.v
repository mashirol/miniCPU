


module pc_reg(

input rst,
input clk,

input[31:0] 	pc_i,
input		al_hav_i,
input		ce_i,
input[2:0]      cnt_i,

output reg[31:0]	pc_o,
output reg		ce_o,
output reg	 	al_hav_o,
output reg[2:0]     cnt_o

);

reg[2:0] cnt;

always @(posedge clk) begin 
	
	if(!rst) begin
		cnt_o <= 0;
		ce_o  <= 0;
		pc_o  <= 0;
		al_hav_o<=0;	
	end
	else if(cnt_i == 4)begin
		cnt_o <= 3'h4;
		ce_o  <= ce_i;
		pc_o  <= pc_i;
		al_hav_o <= al_hav_i;
	end
	else if(cnt_i == 3) begin
		cnt_o <= cnt_i + 1;
		ce_o  <= 1'b1;
		pc_o  <= 0;
		al_hav_o<=0;
	end
	else begin
		cnt_o <= cnt_i + 1;
		ce_o    <= 1'b0;
		al_hav_o<=0;
	end

end

endmodule