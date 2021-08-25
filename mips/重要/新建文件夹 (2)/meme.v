module meme(

input			rst,
input			clk,
input [31:0]		addr_i,
input [31:0]		data_i,
input [3:0]		sel_byte_i,
input 			ena_i,
input			w_r_i,

output reg[31:0]	data_o,
output reg	valid_o,
output reg	busy

);

reg[31:0] reg1,reg2;

//reg valid_o1,valid_o2;

//assign valid_o = valid_o1 || valid_o2;

always @(posedge clk) begin

	if(!rst) begin
		//valid_o1<=0;
		reg1<=32'h1000_0001;
		reg2<=32'h0000_0002;
	end
	else if(ena_i) begin 
		if(w_r_i) begin
			if(addr_i == 0) begin
				reg1<=data_i;
				valid_o<=1'b1;
				//valid_o1 <= 1'b1;
			end
			else if(addr_i == 1) begin
				reg2<=data_i;
				valid_o <=1'b1;
				//valid_o1 <= 1'b1;
			end
		end
		else if(!w_r_i) begin
			if(addr_i[0] == 0) begin
				data_o<= reg1;
				valid_o<=1'b1;
			end
			else if(addr_i[0] == 1) begin
				data_o<= reg2;
				valid_o<=1'b1;
			end	
		end
	end
	else begin
		valid_o <= 0;
	end
end



/*always @(*) begin
	if(!rst) begin
		valid_o2 <= 0;
		data_o<=0;
	end
	else begin
		if(!w_r_i) begin
			if(addr_i[0] == 0 && ena_i) begin
				data_o<= reg1;
				valid_o2<=1'b1;
			end
			else if(addr_i[0] == 1 && ena_i) begin
				data_o<= reg2;
				valid_o2<=1'b1;
			end
			else begin
				data_o<=0;
				valid_o2<=1'b0;
			end
		end
		else begin
				data_o<=0;
				valid_o2<=1'b0;
		end
	end

end*/
endmodule