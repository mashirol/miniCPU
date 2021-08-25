
module LL_reg(
 
  input		clk,
  input 	rst,
	

  input         flush,
	
  input 	LL_i,
  input         ena,
	
  
  output reg    LL_o
	
);
 
	always @ (posedge clk) begin
    	 	if (!rst) begin
       			LL_o <= 1'b0;
     	 	end 
	 	else if((flush == 1'b1)) begin 
        		LL_o <= 1'b0;
     		end 
		else if((ena)) begin
      	 		 LL_o <= LL_i;
     		end
  	end  	
 

endmodule