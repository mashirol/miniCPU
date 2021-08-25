

module align_wb(


input	clk,
input	rst,
input	stall,
input	flush,

input[4:0]	waddr_i,
input		wena_i,
input[31:0]	wdata_i,

input		LL_ena_i,
input		LL_data_i,

input		cp0_ena_i,
input[4:0]	cp0_addr_i,
input[31:0]	cp0_data_i,

input		hilo_ena_i,
input[31:0]	hi_i,
input[31:0]	lo_i,

output reg[4:0]		waddr_o,
output reg		wena_o,
output reg[31:0]	wdata_o,

output reg	LL_ena_o,
output reg	LL_data_o,

output reg		cp0_ena_o,
output reg[4:0]		cp0_addr_o,
output reg[31:0]	cp0_data_o,

output reg		hilo_ena_o,
output reg[31:0]	hi_o,
output reg[31:0]	lo_o


);


always @ (posedge clk) begin
		if(!rst) begin
	  		waddr_o    	<=0;
	    		wena_o  	<=0;
	    		wdata_o 	<=0;
			LL_ena_o    	<=0;
      			LL_data_o 	<=0;
			cp0_ena_o	<=0;
			cp0_addr_o 	<=0;
			cp0_data_o	<=0;
			hilo_ena_o    	<=0;
			hi_o    	<=0;
			lo_o 		<=0;
     	
	  	end 
		else if(flush == 1'b1)begin
	  		waddr_o    	<=0;
	    		wena_o  	<=0;
	    		wdata_o 	<=0;
			LL_ena_o    	<=0;
      			LL_data_o 	<=0;
			cp0_ena_o	<=0;
			cp0_addr_o 	<=0;
			cp0_data_o	<=0;
			hilo_ena_o    	<=0;
			hi_o    	<=0;
			lo_o 		<=0;
	  	end 
		else if(stall == `Nostop) begin
	  		waddr_o    	<= waddr_i;
	    		wena_o  	<= wena_i;
	    		wdata_o 	<= wdata_i;
			LL_ena_o    	<= LL_ena_i;
      			LL_data_o 	<= LL_data_i;
			cp0_ena_o	<= cp0_ena_i;
			cp0_addr_o 	<= cp0_addr_i;
			cp0_data_o	<= cp0_data_i;
			hilo_ena_o    	<= hilo_ena_i;
			hi_o    	<= hi_i;
			lo_o 		<= lo_i;
	  	end    
	end      

endmodule