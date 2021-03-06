
module  pc(

input 	rst,
input	clk,
 
input 		ena_fore_i,
input		valid_branch_i,
input 		suc_branch_i,
input[31:0]	addr_branch_i,
input[31:0]	inst_addr_i,

input		valid_pc_i,
input		al_hav_i,
input[31:0]	pc_i,

input 		flush_i,
input		stall,
input[31:0]	except_addr_i,
input		except_pc_i,

output reg[31:0] pc_o,
output reg	 ena_o,
output reg	 flush_o,
output reg	 al_hav_o,
output[31:0] 	 except_o

);

reg[2:0] count;
reg[63:0] branch_temp[0:7];
reg[31:0] temp_pc;
integer i;
wire hit;


assign hit = branch_temp[0][31:0] == inst_addr_i ||
	    branch_temp[1][31:0] == inst_addr_i ||	
	    branch_temp[2][31:0] == inst_addr_i ||	
	    branch_temp[3][31:0] == inst_addr_i ||	
	    branch_temp[4][31:0] == inst_addr_i ||	
	    branch_temp[5][31:0] == inst_addr_i ||	
	    branch_temp[6][31:0] == inst_addr_i ||	
	    branch_temp[7][31:0] == inst_addr_i ;
	


assign except_o = {{15{1'b0}},except_pc_i,{16{1'b0}}};


always @(posedge clk) begin
	if(!rst) begin
			for(i=1'b0; i<8; i=i + 1'b1) begin
				branch_temp[i] <= 0;
			end
		count <= 0;
	end
	else if(ena_fore_i == `Enable) begin
		if(valid_branch_i == `Branch && suc_branch_i == `Suc_Branch && hit == `False)begin
			branch_temp[count] <= {inst_addr_i, addr_branch_i};
			count		   <= count + 1'b1;
		end
		else if(valid_branch_i == `Branch && suc_branch_i == `Nsuc_Branch) begin
			branch_temp[count] <= {inst_addr_i,addr_branch_i};
			count		   <= count + 1'b1;
		end
		else begin
			count <= count + 1'b1;
		end
	end
	else begin
	end

end


always @(*) begin

	if(!rst) begin

		al_hav_o <= 0;
		pc_o <=0;
		flush_o <=0;	
		ena_o <=0;
	end
	
	else if(ena_fore_i == `Disable) begin
		if(stall ==`True && flush_i ==`False && valid_branch_i ==`False ) begin
			if(valid_pc_i)begin
				al_hav_o <= 1'b1;
				pc_o	 <= pc_i + 4'h4;
				ena_o	 <= 1'b0;
				flush_o  <= 1'b0;
			end
			else begin
				al_hav_o <= al_hav_i;
				pc_o	 <= pc_i;
				ena_o	 <= 1'b0;
				flush_o  <= 1'b0;
			end			
		end
		else if(stall==`False && flush_i==`True && valid_branch_i==`False ) begin
			if(valid_pc_i)begin
				pc_o	 <= except_addr_i;
				ena_o<= 1'b1;
				flush_o  <= 1'b0;
			end
			else begin
				pc_o	 <= except_addr_i - 4'h4;
				flush_o  <= 1'b0;
			end	
		end
		else if(stall==`True && flush_i==`True && valid_branch_i==`False ) begin
			if(valid_pc_i)begin
				al_hav_o <= 1'b1;
				pc_o	 <= except_addr_i;
				ena_o<= 1'b0;
				flush_o  <= 1'b0;
			end
			else begin
				if(al_hav_i) begin
					pc_o	 <= except_addr_i;
					ena_o    <= 1'b0;
					al_hav_o <= al_hav_i;
					flush_o  <= 1'b0;
				end
				else begin
					pc_o	 <= except_addr_i - 4'h4;
					ena_o<= 1'b0;
					al_hav_o <= al_hav_i;
					flush_o  <= 1'b0;
				end
			end
		end
		else if(stall==`False && flush_i==`False && valid_branch_i==`True ) begin
			if(valid_pc_i)begin
				pc_o	 <= addr_branch_i;
				ena_o<= 1'b1;
				flush_o  <= 1'b0;
			end
			else begin
				pc_o	 <= addr_branch_i - 4'h4;
				flush_o  <= 1'b0;
			end	
		end
		else if(stall==`False && flush_i==`True && valid_branch_i==`True ) begin
			if(valid_pc_i)begin
				pc_o	 <= except_addr_i;
				ena_o<= 1'b1;
				flush_o  <= 1'b0;
			end
			else begin
				pc_o	 <= except_addr_i - 4'h4;
				flush_o  <= 1'b0;
			end	
		end
		else if(stall==`True && flush_i==`False && valid_branch_i==`True ) begin
			if(valid_pc_i)begin
				al_hav_o <= 1'b1;
				pc_o	 <= addr_branch_i;
				ena_o    <= 1'b0;
				flush_o  <= 1'b0;
			end
			else begin
				pc_o	 <= addr_branch_i - 4'h4;
				flush_o  <= 1'b0;
			end	
		end
		else begin
			if(valid_pc_i) begin
				pc_o <= pc_i + 4'h4;
				ena_o<= 1'b1;
				flush_o  <= 1'b0;
			end
			else begin
				if(al_hav_i) begin
					pc_o  <= pc_i;
					ena_o <= 1'b1;
					al_hav_o<= 1'b0;
					flush_o  <= 1'b0;
				end
				else begin
					pc_o  <= pc_i;
					ena_o <= 1'b0;
					flush_o  <= 1'b0;
				end
 			end			
		end
	end
	else begin

		if(branch_temp[0][31:0] && pc_i ) begin
			temp_pc <= branch_temp[0][63:32] - 4'h4;	
		end
		else if(branch_temp[1][31:0] && pc_i )begin
			temp_pc <= branch_temp[1][63:32] - 4'h4;
		end
		else if(branch_temp[2][31:0] && pc_i )begin
			temp_pc <= branch_temp[2][63:32] - 4'h4;
		end
		else if(branch_temp[3][31:0] && pc_i )begin
			temp_pc <= branch_temp[3][63:32] - 4'h4;
		end
		else if(branch_temp[4][31:0] && pc_i )begin
			temp_pc <= branch_temp[4][63:32] - 4'h4;
		end
		else if(branch_temp[5][31:0] && pc_i )begin
			temp_pc <= branch_temp[5][63:32] - 4'h4;
		end
		else if(branch_temp[6][31:0] && pc_i )begin
			temp_pc <= branch_temp[6][63:32] - 4'h4;
		end
		else if(branch_temp[7][31:0] && pc_i )begin
			temp_pc <= branch_temp[7][63:32] - 4'h4;
		end
		else begin
			temp_pc <= pc_i;
		end


		if(stall==`True && flush_i==`False && valid_branch_i==`False ) begin
			if(valid_pc_i)begin
				al_hav_o <= 1'b1;
				pc_o	 <= temp_pc + 4'h4;
				ena_o	 <= 1'b0;
				flush_o  <= 1'b0;
			end
			else begin
				al_hav_o <= al_hav_i;
				pc_o	 <= temp_pc;
				ena_o	 <= 1'b0;
				flush_o  <= 1'b0;
			end			
		end
		else if(stall==`False && flush_i==`True && valid_branch_i==`False ) begin
			if(valid_pc_i)begin
				pc_o	 <= except_addr_i;
				ena_o<= 1'b1;
				flush_o  <= 1'b0;
			end
			else begin
				pc_o	 <= except_addr_i - 4'h4;
				ena_o	 <= 1'b0;
				flush_o  <= 1'b0;
			end	
		end
		else if(stall==`True && flush_i==`True && valid_branch_i==`False ) begin
			if(valid_pc_i)begin
				al_hav_o <= 1'b1;
				pc_o	 <= except_addr_i;
				ena_o<= 1'b0;
				flush_o  <= 1'b0;
			end
			else begin
				if(al_hav_i) begin
					pc_o	 <= except_addr_i;
					ena_o    <= 1'b0;
					al_hav_o <= al_hav_i;
					flush_o  <= 1'b0;
				end
				else begin
					pc_o	 <= except_addr_i - 4'h4;
					ena_o<= 1'b0;
					al_hav_o <= al_hav_i;
					flush_o  <= 1'b0;
				end
			end
		end
		else if(stall==`False && flush_i==`False && valid_branch_i==`True ) begin		
			if(valid_pc_i)begin
				if(suc_branch_i == `Suc_Branch && hit == `True) begin
					pc_o	 <= temp_pc + 4'h4;
					ena_o	 <= 1'b1;
					flush_o  <= 1'b0;
				end
				else begin	
					pc_o	 <= addr_branch_i;
					flush_o  <= 1'b1;
					ena_o 	 <= 1'b1;
				end
					
			end
			else begin
				if(suc_branch_i == `Suc_Branch && hit == `True) begin
					pc_o	 <= temp_pc;
					ena_o	 <= 1'b0;
					flush_o  <= 1'b0;
				end
				else begin	
					pc_o	 <= addr_branch_i - 4'h4;
					flush_o  <= 1'b1;
					ena_o 	 <= 1'b0;
				end
			end	
		end
		else if(stall==`False && flush_i==`True && valid_branch_i==`True ) begin
			if(valid_pc_i)begin
				pc_o	 <= except_addr_i;
				ena_o<= 1'b1;
			end
			else begin
				pc_o	 <= except_addr_i - 4'h4;
			end	
		end
		else if(stall==`True && flush_i==`False && valid_branch_i==`True ) begin
			if(valid_pc_i)begin
				if(suc_branch_i == `Suc_Branch && hit == `True) begin
					al_hav_o <= 1'b1;
					pc_o	 <= temp_pc + 4'h4;
					ena_o	 <= 1'b0;
					flush_o  <= 1'b0;
				end
				else begin
					al_hav_o <= 1'b1;	
					pc_o	 <= addr_branch_i;
					flush_o  <= 1'b1;
					ena_o 	 <= 1'b0;
				end
			end
			else begin
				if(suc_branch_i == `Suc_Branch && hit == `True) begin
					al_hav_o <= 1'b1;
					pc_o	 <= temp_pc;
					ena_o	 <= 1'b0;
					flush_o  <= 1'b0;
				end
				else begin
					al_hav_o <= 1'b1;	
					pc_o	 <= addr_branch_i - 4'h4;
					flush_o  <= 1'b1;
					ena_o 	 <= 1'b0;
				end
			end	
		end
		else begin
			if(valid_pc_i) begin
				pc_o <= temp_pc + 4'h4;
				ena_o<= 1'b1;
				flush_o  <= 1'b0;
			end
			else begin
				if(al_hav_i) begin
					pc_o  <= temp_pc;
					ena_o <= 1'b1;
					al_hav_o<= 1'b0;
					flush_o  <= 1'b0;
				end
				else begin
					pc_o  <= temp_pc;
					ena_o <= 1'b0;
					flush_o  <= 1'b0;
				end
 			end			
		end
	


	end


end



endmodule



		