
module ctrl(
 
	input 		rst,
	input           stallreq_from_ex,   
	input           stallreq_from_mem,  

	input[31:0]	except_i,
	input[31:0]	cp0_new,
	
	output reg[31:0]	new_pc,
	output reg[5:0]		flush,
	
	output reg[4:0]     	stall       
	
);
 


	always @ (*) begin
	   	if(!rst) begin
			stall  <= 0;
			flush  <= 0;
			new_pc <= 0;
	  	 end 
		 else if(except_i != 0) begin
			flush <= 6'b111111;	
			stall <= 5'b0;
			case(except_i)
				32'h0000_0001:begin
					new_pc <= 32'h0000_0020;
				end
				
				32'h0000_0008:begin
					new_pc <= 32'h0000_0040;
				end
				
				32'h0000_000a:begin
					new_pc <= 32'h0000_0040;
				end
				
				32'h0000_000d:begin
					new_pc <= 32'h0000_0040;
				end
		
				32'h0000_000c:begin
					new_pc <=32'h0000_0040;
				end
				
				32'h0000_000e:begin
					new_pc <=32'h0000_0040;
				end
	
				default:begin
				end
			endcase	
		 end

		 else if(stallreq_from_mem == `Stop) begin
			stall <= 5'b00111;
			flush <= 6'b001000;
	  	 end 
		 else if(stallreq_from_ex == `Stop) begin
			stall <= 5'b00011;
			flush <= 0;
	  	 end 
		 else begin
			stall <= 0;
			flush <= 0;
			new_pc <= 0;
	  	 end
	end
	
			
endmodule
