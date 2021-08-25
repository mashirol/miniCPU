module tlb(

input clk,
input rst,


input		ena_r_o,
input[19:0]	vaddr_o,

input		ena_w_o,
input[3:0]	addr_o,
input[19:0]	paddr_w_o,


output reg[19:0]	paddr_r_i,
output reg		valid_r_i
);


reg[39:0] reg1;


always @(posedge clk) begin
	if(!rst) begin
		reg1 <= 0;
	end
	else if(ena_w_o) begin
		reg1 <={vaddr_o,paddr_w_o};
	end
	else begin
		reg1 <= reg1 ;
		
	end
	
end

always @(*) begin
	if(!rst) begin
		paddr_r_i <= 0;
		valid_r_i <= 0;
	end
	else if(ena_r_o) begin
		if(vaddr_o == reg1[39:20] ) begin
			paddr_r_i <= reg1[19:0];
			valid_r_i <= 1;
		end
		else begin
			valid_r_i <= 0;
		end
	end
	else begin
		paddr_r_i <= 0;
		valid_r_i <= 0;
	end
	
end



endmodule