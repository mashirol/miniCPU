

module ex(
	input rst,
	input[31:0] pc_i,
	input[31:0] inst_i,
	input[31:0] except_i,
	input[31:0] reg1_data_i,
	input[31:0] reg2_data_i,
	input       in_delayslot_i,
	input	    ena_fore_i,
	
	input[7:0]  mem_op_i,
	input       mem_data_valid_i,

	input[31:0] mem_wdata_i,
	input[4:0]  mem_waddr_i,
	input       mem_wena_i,

	input[31:0] alig_wdata_i,
	input[4:0]  alig_waddr_i,
	input       alig_wena_i,

	input[31:0] wb_wdata_i,
	input[4:0]  wb_waddr_i,
	input       wb_wena_i,



	input[31:0] cp0_rdata_i,
	input[63:0] hilo_temp_i,
	input[1:0]  cnt_i,
	input[31:0] hi_i,
	input[31:0] lo_i,

	input[63:0] div_result_i,
	input       div_final_i,
	
	input[31:0] mem_hi_i,
	input[31:0] mem_lo_i,
	input       mem_whilo_i,

	input[31:0] alig_hi_i,
	input[31:0] alig_lo_i,
	input       alig_whilo_i,

	input[31:0] wb_hi_i,
	input[31:0] wb_lo_i,
	input       wb_whilo_i,


	input       mem_wcp0_i,
	input[4:0]  mem_cp0_addr_i,
	input[31:0] mem_cp0_data_i,

	input       alig_wcp0_i,
	input[4:0]  alig_cp0_addr_i,
	input[31:0] alig_cp0_data_i,

	input       wb_wcp0_i,
	input[4:0]  wb_cp0_addr_i,
	input[31:0] wb_cp0_data_i,



	output       next_in_delayslot_o,
	output       valid_branch_o,
	output	     suc_branch_o,
	output[31:0] addr_branch_o,
	output[31:0] inst_addr_o,

	output       reg1_ena_o,
	output[4:0]  reg1_addr_o,
	output       reg2_ena_o,
	output[4:0]  reg2_addr_o,



	output[31:0] except_o,
	output       in_delayslot_o,
	output[31:0] cur_inst_addr_o,


	output[4:0]  cp0_raddr_o,

	output       cp0_ena_o,
	output[4:0]  cp0_addr_o,
	output[31:0] cp0_data_o,
	
	output[7:0]  mem_op_o,
	output[31:0] mem_addr_o,
	output[31:0] mem_data_o,
	

	output[31:0] div_op1_o,
	output[31:0] div_op2_o,
	output       div_start_o,
	output       div_sign_o,	

	output       wena_o,
	output[4:0]  waddr_o,
	output[31:0] wdata_o,

	output[31:0] hi_o,
	output[31:0] lo_o,
	output       hilo_ena_o,

	output[63:0] hilo_temp_o,
	output[1:0]  cnt_o,
	output[31:0] result,
	output[31:0] reg1,
	output[31:0] reg2,
	output [2:0] k,


	
	output stall

);


wire m1,m2,r2,r8;
wire[31:0] r1,r5,r6,r9,r10,r11;
wire[7:0] r4;
wire[2:0] r3;
wire[4:0] r7;

assign stall = m1 || m2;
assign inst_addr_o = r11;
assign reg1 = r5;
assign reg2 = r6;


id  s1(
	.rst(rst),

	.pc_i(pc_i),
	.inst_i(inst_i),
	.except_i(except_i),
	.reg1_data_i(reg1_data_i),
	.reg2_data_i(reg2_data_i),
	.in_delayslot_i(in_delayslot_i),
	.ena_fore_i(ena_fore_i),
	.mem_op_i(mem_op_i),
	.mem_data_valid_i(mem_data_valid_i),

	.mem_wdata_i(mem_wdata_i),
	.mem_waddr_i(mem_waddr_i),
	.mem_wena_i(mem_wena_i),

	.alig_wdata_i(alig_wdata_i),
	.alig_waddr_i(alig_waddr_i),
	.alig_wena_i(alig_wena_i),

	.wb_wdata_i(wb_wdata_i),
	.wb_waddr_i(wb_waddr_i),
	.wb_wena_i(wb_wena_i),

	.next_in_delayslot_o(next_in_delayslot_o),
	.valid_branch_o(valid_branch_o),
	.addr_branch_o(addr_branch_o),
	.suc_branch_o(suc_branch_o),
	.return_addr_o(r1),
	.in_delayslot_o(r2),
	
	.reg1_ena_o(reg1_ena_o),
	.reg1_addr_o(reg1_addr_o),
	.reg2_ena_o(reg2_ena_o),
	.reg2_addr_o(reg2_addr_o),

	.ex_type_o(r3),
	.ex_op_o(r4),

	.reg1_o(r5),
	.reg2_o(r6),
	.waddr_o(r7),
	.wena_o(r8),
	.inst_o(r9),
	.except_o(r10),
	.cur_inst_addr_o(r11),
	.k(k),

	.stallreq(m1)

);


exc s2(

	.rst(rst),

	.op_i(r4),
	.type_i(r3),
	.reg1_i(r5),
	.reg2_i(r6),
	.waddr_i(r7),
	.wena_i(r8),

	.cp0_rdata_i(cp0_rdata_i),
	.hilo_temp_i(hilo_temp_i),
	.cnt_i(cnt_i),
	.hi_i(hi_i),
	.lo_i(lo_i),

	.div_result_i(div_result_i),
	.div_final_i(div_final_i),
	
	.mem_hi_i(mem_hi_i),
	.mem_lo_i(mem_lo_i),
	.mem_whilo_i(mem_whilo_i),

	.alig_hi_i(alig_hi_i),
	.alig_lo_i(alig_lo_i),
	.alig_whilo_i(alig_whilo_i),

	.wb_hi_i(wb_hi_i),
	.wb_lo_i(wb_lo_i),
	.wb_whilo_i(wb_whilo_i),


	.mem_wcp0_i(mem_wcp0_i),
	.mem_cp0_addr_i(mem_cp0_addr_i),
	.mem_cp0_data_i(mem_cp0_data_i),

	.alig_wcp0_i(alig_wcp0_i),
	.alig_cp0_addr_i(alig_cp0_addr_i),
	.alig_cp0_data_i(alig_cp0_data_i),

	.wb_wcp0_i(wb_wcp0_i),
	.wb_cp0_addr_i(wb_cp0_addr_i),
	.wb_cp0_data_i(wb_cp0_data_i),


	.in_delayslot_i(r2),
	.return_addr_i(r1),

	.inst_i(r9),

	.except_i(r10),
	.cur_inst_addr_i(r11),


	.except_o(except_o),
	.in_delayslot_o(in_delayslot_o),
	.cur_inst_addr_o(cur_inst_addr_o),


	 .cp0_raddr_o(cp0_raddr_o),

	 .cp0_ena_o(cp0_ena_o),
	 .cp0_addr_o(cp0_addr_o),
	 .cp0_data_o(cp0_data_o),
	
	 .mem_op_o(mem_op_o),
	 .mem_addr_o(mem_addr_o),
	 .mem_data_o(mem_data_o),
	

	 .div_op1_o(div_op1_o),
	 .div_op2_o(div_op2_o),
	 .div_start_o(div_start_o),
	 .div_sign_o(div_sign_o),	

	 .wena_o(wena_o),
	 .waddr_o(waddr_o),
	 .wdata_o(wdata_o),

	 .hi_o(hi_o),
	 .lo_o(lo_o),
	 .hilo_ena_o(hilo_ena_o),

	 .hilo_temp_o(hilo_temp_o),
	 .cnt_o(cnt_o),
	 .result(result),
	
	 .stallreq(m2)

);


endmodule