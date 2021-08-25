module cache(

input			clk,
input			rst,


input		valid_r_o,
input[5:0]		r_addr_o,
input[6:0]		w_addr_o,
input[26:0]		data_addr_o,
input[127:0]	data_d_o,
input		valid_w_o,
input		chg_o,

output reg[127:0]		data_i1,
output reg[127:0]		data_i2,
output reg[26:0]		addr_i1,
output reg[26:0]		addr_i2




);

reg[154:0] reg1,reg2;


always @(posedge clk) begin

	if(!rst) begin
		reg1<=0;
		reg2<=0;
	end
	else if(valid_w_o)begin
		reg1<={data_addr_o,data_d_o};
		reg2<={data_addr_o,data_d_o};		
	end
	else begin
		reg1<=reg1;
		reg2<=reg2;
	end
end


always @(*) begin
	if(valid_r_o) begin
		data_i1<= reg1[127:0];
		data_i2<= reg2[127:0];
		addr_i1<= reg1[154:128];
		addr_i2<= reg2[154:128];
	end
	else begin
		data_i1<=0;
		data_i2<=0;
		addr_i1<=0;
		addr_i2<=0;
	end
end
endmodule
