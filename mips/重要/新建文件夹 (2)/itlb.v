module itlb(

input		clk,
input		rst,
input[31:0]	vaddr_i,
input 		ena_i,
input[31:0]	paddr_i,
input		valid_i,
input		suc_chg,

input[19:0]	paddr_r_i,
input		valid_r_i,



output reg[31:0]	paddr_o,
output reg		valid_o,
output reg		suc_o,

output reg		ena_r_o,
output reg[19:0]	vaddr_o,

output reg		ena_w_o,
output reg[3:0]		addr_o,
output reg[19:0]	paddr_w_o,

output[1:0] state


);


parameter s0=1'b0;
parameter s1=1'b1;


reg[1:0] cur_state, next_state;
reg[3:0] cnt;


reg[31:0]	paddr_o_i;
reg		valid_o_i;
reg		suc_o_i;

reg		ena_r_o_i;
reg[19:0]	vaddr_o_i;

reg		ena_w_o_i;
reg[3:0]	addr_o_i;
reg[19:0]	paddr_w_o_i;

assign state = cur_state;

always @(posedge clk) begin
	if(!rst) begin
		cur_state <= 0;
		cnt <= 0;
		paddr_o_i<=0;
		valid_o_i<=0;
		suc_o_i<=0;
		ena_r_o_i<=0;
		vaddr_o_i<=0;
		ena_w_o_i<=0;
		addr_o_i<=0;
		paddr_w_o_i<=0;
	end
	else begin
		paddr_o_i<=paddr_o;
		valid_o_i<=valid_o;
		suc_o_i<=suc_o;
		ena_r_o_i<=ena_r_o;
		vaddr_o_i<=vaddr_o;
		ena_w_o_i<=ena_w_o;
		addr_o_i<=addr_o;
		paddr_w_o_i<=paddr_w_o;

		cur_state <= next_state;
		cnt	  <= cnt + 1;
	end
end


always @(*) begin
	if(!rst) begin
		next_state <= 0;
	end else begin

	case(cur_state)
		s0:begin
			if(!ena_i) begin
				next_state <= s0;	
			end
			else begin
				if(!valid_r_i) begin
					next_state <= s1;
				end
				else begin
					next_state <= s0;
				end
			end
		end
	
		s1:begin
			if(!valid_i)begin
				next_state <= s1;
			end
			else begin
				next_state <= s0;
			end

		end
		
		default:begin
			next_state <= s0;
		end	
	endcase
	end

end


always @(*) begin
	if(!rst) begin
		ena_w_o 	<= 0;
		addr_o 		<= 0;
		paddr_w_o 	<= 0;
		valid_o  	<= 0;
		suc_o		<= 0;
		vaddr_o		<= 0;
		paddr_o <=0;
		ena_r_o <=0;
	end
	else begin
		paddr_o<=paddr_o_i;
		valid_o<=valid_o_i;
		suc_o  <=suc_o_i;
		ena_r_o<=ena_r_o_i;
		vaddr_o<=vaddr_o_i;
		ena_w_o<=ena_w_o_i;
		addr_o <=addr_o_i;
		paddr_w_o<=paddr_w_o_i;

	case(cur_state)
		s0:begin
			if(!ena_i) begin
				valid_o <= 0;
				suc_o   <= 0;
				ena_r_o <= 0;
				ena_w_o <= 0;				
			end
			else begin
				vaddr_o <= vaddr_i[31:12];
				ena_r_o <= ena_i;
				ena_w_o <= 0;
				if(valid_r_i) begin
					valid_o <= 1'b1;
					suc_o   <= 1'b1;
					paddr_o <= {paddr_r_i,vaddr_i[11:0]};
				end
				else begin					
					valid_o <= 1'b1;
					suc_o   <= 1'b0;
				end
			end
		end
	
		s1:begin
			if(valid_i && suc_chg)begin
				addr_o   <= cnt;
				paddr_w_o<= paddr_i[31:12];
				paddr_o <= {paddr_i[31:12],vaddr_i[11:0]};
				ena_w_o  <= 1'b1;
				suc_o    <= 1'b1;
				valid_o <= 1'b1;
			end
			else begin
				ena_w_o  <= 1'b0;
			end

		end
		
		default:begin
			ena_w_o  <= 1'b0;
		end	
	endcase
	end

end



endmodule