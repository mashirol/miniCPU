
module mem_alig(
 
	input	rst,
	input   clk,
	
	input 	stall,	
	input	flush,
	input[31:0]	except_i,
	input[31:0]	cur_inst_addr,
	input		in_delayslot_i,

	input[7:0]	align_op_i,
	input[3:0]	align_sel_i,
	input[31:0]	mem_rdata_i,
	input[31:0]	reg_i,
	input[31:0]     mem_wdata,
	input[4:0]      mem_waddr,
	input           mem_wreg,

	input[31:0]   	mem_hi,
	input[31:0]   	mem_lo,
	input		mem_hilo_ena,

	input		mem_LL_ena,
	input		mem_LL_data,

	input		mem_cp0_ena,
	input[4:0]	mem_cp0_addr,
	input[31:0]     mem_cp0_data,


	output reg[31:0]	reg_o,
	output reg[7:0]		align_op_o,
	output reg[31:0]	mem_rdata_o,
	output reg[31:0]	except_o,
	output reg[31:0]	cur_inst_addr_o,
	output reg		in_delayslot_o,
	output reg[3:0]		align_sel_o,

	output reg		alig_cp0_ena,
	output reg[4:0]		alig_cp0_addr,
	output reg[31:0]           alig_cp0_data,
	
	output reg		alig_LL_ena,
	output reg		alig_LL_data,
	
	output reg[4:0]    	alig_waddr,
	output reg          	alig_wena,
	output reg[31:0]    	alig_wdata,

	output reg[31:0]    	alig_hi,
	output reg[31:0]    	alig_lo,
	output reg[31:0]    	alig_hilo_ena	


	
);
 

always @ (posedge clk) begin
		if(!rst) begin
			reg_o	 	<= 0;
			align_op_o	<=`EXE_NOP_OP;
			mem_rdata_o	<=0;
			except_o	<=0;
			cur_inst_addr_o	<=0;
			in_delayslot_o	<=0;
			align_sel_o	<=0;
			alig_cp0_ena	<=0;
			alig_cp0_addr	<=0;
			alig_cp0_data	<=0;
			alig_LL_ena	<=0;
			alig_LL_data	<=0;
			alig_hi		<=0;
			alig_lo		<=0;
			alig_hilo_ena	<=0;
			alig_waddr<=0;
			alig_wena<=0;
			alig_wdata<=0;
	  	end 
		else if(flush == 1'b1)begin
			reg_o	 	<= 0;
			align_op_o	<=`EXE_NOP_OP;
			mem_rdata_o	<=0;
			except_o	<=0;
			cur_inst_addr_o	<=0;
			in_delayslot_o	<=0;
			align_sel_o	<=0;
			alig_cp0_ena	<=0;
			alig_cp0_addr	<=0;
			alig_cp0_data	<=0;
			alig_LL_ena	<=0;
			alig_LL_data	<=0;
			alig_hi		<=0;
			alig_lo		<=0;
			alig_hilo_ena	<=0;
			alig_waddr<=0;
			alig_wena<=0;
			alig_wdata<=0;
		end
		else if(stall == `Nostop) begin
			reg_o	 	<= reg_i;
			align_op_o	<=align_op_i;
			mem_rdata_o	<=mem_rdata_i;
			except_o	<=except_i;
			cur_inst_addr_o	<=cur_inst_addr;
			in_delayslot_o	<=in_delayslot_i;
			align_sel_o	<=align_sel_i;
			alig_cp0_ena	<=mem_cp0_ena;
			alig_cp0_addr	<=mem_cp0_addr;
			alig_cp0_data	<=mem_cp0_data;
			alig_LL_ena	<=mem_LL_ena;
			alig_LL_data	<=mem_LL_data;
			alig_hi		<=mem_hi;
			alig_lo		<=mem_lo;
			alig_hilo_ena	<=mem_hilo_ena;
			alig_waddr<= mem_waddr;
			alig_wena<=mem_wreg;
			alig_wdata<=mem_wdata;
	  	end    
	end      
 
	
endmodule
