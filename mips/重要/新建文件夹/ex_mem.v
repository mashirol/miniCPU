

module ex_mem(
	
	input clk,
	input rst,
	input flush,
	input[1:0] stall,
	
	input[4:0]  ex_waddr,		
	input[31:0] ex_wdata,
	input       ex_wena,

	input[7:0]  	 ex_op_i,
	input[31:0]	 ex_addr_i,
	input[31:0]	 ex_wdata_i,

	input 		ex_cp0_ena_i,
	input[4:0]	ex_cp0_addr_i,
	input[31:0]   	ex_cp0_data_i,

	input[31:0] 	ex_hi,
	input[31:0] 	ex_lo,
	input 		ex_hilo_ena_i,


  	input[31:0]     ex_except_i,
	input           ex_in_delayslot,
	input[31:0]     ex_cur_inst_addr,
	input		ex_next_in_delayslot,

	input[63:0]  	hilo_i,
	input[1:0]	cnt_i,

	output reg[4:0]  mem_waddr_o,
	output reg[31:0] mem_wdata_o,
	output reg	 mem_wena_o,

	output reg[7:0]		mem_op_o,
	output reg[31:0]	mem_addr_o,
	output reg[31:0]	mem_data_o,

	output reg			mem_cp0_ena_o,
	output reg[4:0]		mem_cp0_addr_o,
	output reg[31:0]  	mem_cp0_data_o,

	output reg[31:0] 	mem_hi_o,
	output reg[31:0] 	mem_lo_o,
	output reg			mem_hilo_ena_o,
	
	output reg[31:0]        mem_except_o,
  	output reg              mem_in_delayslot,
	output reg[31:0]        mem_cur_inst_addr,
	output reg		ex_next_in_delayslot_o,
	

	output reg[63:0]  	hilo_o,
	output reg[1:0]	        cnt_o

	


);



	always@(posedge clk) begin
		if(!rst) begin
			mem_waddr_o 	<=0;
			mem_wena_o  	<=0;
			mem_wdata_o 	<=0;
			mem_op_o 	<= `EXE_NOP_OP;
			mem_addr_o	<=0;
			mem_data_o   	<=0;
			mem_cp0_ena_o	<=0;
			mem_cp0_addr_o 	<=0;
			mem_cp0_data_o 	<=0;
			mem_hi_o    	<=0;
			mem_lo_o    	<=0;
			mem_hilo_ena_o 	<=0;
			hilo_o    <= 0;
			cnt_o     <= 0;
			mem_except_o	<= 0;
			mem_in_delayslot <= `NotInDelaySlot;
	   		mem_cur_inst_addr <= 0;
			ex_next_in_delayslot_o<=0;
		end
		else if(flush == 1'b1)begin
			mem_waddr_o 	<=0;
			mem_wena_o  	<=0;
			mem_wdata_o 	<=0;
			mem_op_o 	<= `EXE_NOP_OP;
			mem_addr_o	<=0;
			mem_data_o   	<=0;
			mem_cp0_ena_o	<=0;
			mem_cp0_addr_o 	<=0;
			mem_cp0_data_o 	<=0;
			mem_hi_o    	<=0;
			mem_lo_o    	<=0;
			mem_hilo_ena_o 	<=0;
			hilo_o    <= 0;
			cnt_o     <= 0;
			mem_except_o	<= 0;
			mem_in_delayslot <= `NotInDelaySlot;
	   		mem_cur_inst_addr <= 0;
			ex_next_in_delayslot_o<=0;
		end
		else if(stall[1] == `Nostop && stall[0] == `Stop)begin
			mem_waddr_o 	<=0;
			mem_wena_o  	<=0;
			mem_wdata_o 	<=0;
			mem_op_o 	<= `EXE_NOP_OP;
			mem_addr_o	<=0;
			mem_data_o   	<=0;
			mem_cp0_ena_o	<=0;
			mem_cp0_addr_o 	<=0;
			mem_cp0_data_o 	<=0;
			mem_hi_o    	<=0;
			mem_lo_o    	<=0;
			mem_hilo_ena_o 	<=0;
			hilo_o    <= hilo_i;
			cnt_o     <= cnt_i;
			mem_except_o	<= 0;
			mem_in_delayslot <= `NotInDelaySlot;
	   	mem_cur_inst_addr <= 0;
			ex_next_in_delayslot_o<=0;
		end
		else if(stall[1] == `Nostop)begin
			mem_waddr_o 	<= ex_waddr;
			mem_wena_o  	<= ex_wena;
			mem_wdata_o 	<= ex_wdata;
			mem_op_o 	<= ex_op_i;
			mem_addr_o	<= ex_addr_i;
			mem_data_o   	<= ex_wdata_i;
			mem_cp0_ena_o	<= ex_cp0_ena_i;
			mem_cp0_addr_o 	<= ex_cp0_addr_i;
			mem_cp0_data_o 	<= ex_cp0_data_i;
			mem_hi_o    	<= ex_hi;
			mem_lo_o    	<= ex_lo;
			mem_hilo_ena_o 	<= ex_hilo_ena_i;
			hilo_o    <= hilo_i;
			cnt_o     <= cnt_i;
			mem_except_o	<= ex_except_i;
			mem_in_delayslot <= ex_in_delayslot;
	   	mem_cur_inst_addr <= ex_cur_inst_addr;
			ex_next_in_delayslot_o<= ex_next_in_delayslot;
		end
	end

	


endmodule

