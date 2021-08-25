


module if_ex(

input rst,
input clk,

input[31:0]	if_pc,
input[31:0]	if_inst,
input		valid_pc_i,
input		al_hav_i,
input		stall,
input		flush,
input[31:0]	except_i,


output reg[31:0]	ex_pc,
output reg[31:0]	ex_inst,
output reg		flush_o,
output reg[31:0]	except_o


);


always @(posedge clk) begin

	if(!rst) begin
		ex_pc   <= 0;
		ex_inst <= 0;
		flush_o <= 1'b0;
		except_o<= 0;	
	end
	else begin
		if(flush == `True) begin
			if((valid_pc_i==`True||al_hav_i ==`True) && stall == `False) begin
				ex_pc   <= 0;
				ex_inst <= 0;
				flush_o <= 1'b0;
				except_o<= 0;	
			end		
			else begin
				ex_pc   <= 0;
				ex_inst <= 0;
				flush_o <= 1'b1;
				except_o<= 0;	
			
			end
		end
		else begin
			if((valid_pc_i ==`True || al_hav_i ==`True) && stall == `False) begin
				ex_pc   <= if_pc;
				ex_inst <= if_inst;
				flush_o <= 1'b0;
				except_o<= except_i;
			end
			else if(stall == `False)begin
				ex_pc   <= 0;
				ex_inst <= 0;
				flush_o <= flush;
				except_o<= 0;
			end
		end
	end



end

endmodule






