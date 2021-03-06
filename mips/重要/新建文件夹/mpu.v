`include "define.v"
module mpu(

input rst,
input clk,

input ena_fore_i,

input[63:0] div_result_i,
input div_final_i,

input[31:0] div_op1_o,
input[31:0] div_op2_o,
input div_start_o,
input div_sign_o,

input[31:0] start_entry_cata,
input[31:0] config_i,

input int_i,
output timer_int_o,
output[31:0] regt,
output[31:0] result,
output[31:0] inst,
output[31:0] reg1,
output[31:0] reg2,
output[31:0] regy1,
output[31:0] regy2,
output[31:0] regy3,
output[2:0]  cntt,
output kk,
output[2:0] k,
output[31:0] config_o

);


wire[2:0] cnt;
wire[5:0] flu;
wire[4:0] stal,d7,d10,d13,d32,d35,d38,d42,d44,d48,d50,d60,e1,e7,h8,h12;
wire[7:0] d4,d52,g13,h2;
wire[1:0] d17,d66;
wire[3:0] g17,h6;
wire[63:0] d16,d65;
wire a1,a2,a4,a5,a10,a12,a13,a14,b1,c4,d3,d5,d8,d11,d14,d21,d27,d37,d40;
wire d30,d31,d34,d41,d43,d46,d49,d59,d64,d67,e3,e6,e11,e13,g4,g5,g6,g7,g8;
wire g10,g12,g16,g19,g20,g21,h5,h7,h10,h11,h13,h17,k7;
wire[31:0] a3,a6,a9,a11,a15,c1,c2,c3,c5,d1,d2,d6,d9,d12,d15,d18,d19,d22,d23;
wire[31:0] d25,d26,d28,d29,d33,d36,d39,d45,d47,d51,d53,d54,d61,d62,d63,e2;
wire[31:0] e4,e5,e8,e9,e10,e12,e14,g1,g2,g3,g9,g11,g14,g15,g18,h1,h3,h4,h9;
wire[31:0] h14,h15,h16,k1,k2,k3,k4,k5,k6,a7;


wire	f1;
//assign d5 = 1'b1;
//assign g3 = 32'h0000_0111;
//assign a4 = 1'b1;
//assign c1 = 32'b100011_00000_00001_00000_00000_000000;//32'h0000_0000;

assign inst = c3;
assign f1 = flu[1] |a13 | c4;
assign kk = a4;
assign cntt = cnt;

assign regy1 = a6 ;//dizhi
assign regy2 = b1;//shuju
assign regy3 = c1;

pc s1(
	.rst(rst),
	.clk(clk),
 
	.ena_fore_i(ena_fore_i),
	.valid_branch_i(a1),
	.suc_branch_i(a2),
	.addr_branch_i(a3),
	.inst_addr_i(a7),

	.valid_pc_i(a4),
	.al_hav_i(a5),
	.pc_i(a6),

	.flush_i(flu[0]),
	.stall(stal[0]),
	.except_addr_i(a9),
	.except_pc_i(a10),

	.pc_o(a11),
	.ena_o(a12),
	.flush_o(a13),
	.al_hav_o(a14),
	.except_o(a15)

);


 pc_reg s2(

	.rst(rst),
	.clk(clk),

 	.pc_i(a11),
	.al_hav_i(a14),
	.ce_i(a12),
	.cnt_i(cnt),

	.pc_o(a6),
	.ce_o(b1),
	.cnt_o(cnt),
	.al_hav_o(a5)


);

 if_ex s3(

 	.rst(rst),
 	.clk(clk),

	.if_pc(a6),
	.if_inst(c1),
	.valid_pc_i(a4),
	.al_hav_i(a5),
	.stall(stal[1]),
	.flush(f1),
	.except_i(a15),

	.ex_pc(c2),
	.ex_inst(c3),
	.flush_o(c4),
	.except_o(c5)


);


 ex s4(
	 .rst(rst),
	 .pc_i(c2),
	 .inst_i(c3),
	 .except_i(c5),
	 .reg1_data_i(d1),
	 .reg2_data_i(d2),
	 .in_delayslot_i(d3),
	 .ena_fore_i(ena_fore_i),
	 .mem_op_i(d4),
	 .mem_data_valid_i(d5),

	 .mem_wdata_i(d6),
	 .mem_waddr_i(d7),
	 .mem_wena_i(d8),

	 .alig_wdata_i(d9),
	 .alig_waddr_i(d10),
	 .alig_wena_i(d11),

	 .wb_wdata_i(d12),
	 .wb_waddr_i(d13),
	 .wb_wena_i(d14),



	 .cp0_rdata_i(d15),
	 .hilo_temp_i(d16),
	 .cnt_i(d17),
	 .hi_i(d18),
	 .lo_i(d19),

	 .div_result_i(div_result_i),
	 .div_final_i(div_final_i),
	
	 .mem_hi_i(d22),
	 .mem_lo_i(d23),
	 .mem_whilo_i(d21),

	 .alig_hi_i(d25),
	 .alig_lo_i(d26),
	 .alig_whilo_i(d27),

	 .wb_hi_i(d28),
	 .wb_lo_i(d29),
	 .wb_whilo_i(d30),


	 .mem_wcp0_i(d31),
	 .mem_cp0_addr_i(d32),
	 .mem_cp0_data_i(d33),

	 .alig_wcp0_i(d34),
	 .alig_cp0_addr_i(d35),
	 .alig_cp0_data_i(d36),

	 .wb_wcp0_i(d37),
	 .wb_cp0_addr_i(d38),
	 .wb_cp0_data_i(d39),



	 .next_in_delayslot_o(d40),
	 .valid_branch_o(a1),
	 .suc_branch_o(a2),
	 .addr_branch_o(a3),
	 .inst_addr_o(a7),


	 .reg1_ena_o(d41),
	 .reg1_addr_o(d42),
	 .reg2_ena_o(d43),
	 .reg2_addr_o(d44),



	 .except_o(d45),
	 .in_delayslot_o(d46),
	 .cur_inst_addr_o(d47),


	 .cp0_raddr_o(d48),

	 .cp0_ena_o(d49),
	 .cp0_addr_o(d50),
	 .cp0_data_o(d51),
	
	 .mem_op_o(d52),
	 .mem_addr_o(d53),
	 .mem_data_o(d54),
	

	 .div_op1_o(div_op1_o),
	 .div_op2_o(div_op2_o),
	 .div_start_o(div_start_o),
	 .div_sign_o(div_sign_o),	

	 .wena_o(d59),
	 .waddr_o(d60),
	 .wdata_o(d61),

	 .hi_o(d62),
	 .lo_o(d63),
	 .hilo_ena_o(d64),

	 .hilo_temp_o(d65),
	 .cnt_o(d66),
	 .result(result),
	 .reg1(reg1),
	 .reg2(reg2),
	 .k(k),

	 .stall(d67)

);



 ex_mem s5(

	.clk(clk),
	.rst(rst),
	.flush(flu[2]),
	.stall(stal[2:1]),

	.ex_waddr(d60),
	.ex_wdata(d61),
	.ex_wena(d59),

	.ex_op_i(d52),
	.ex_addr_i(d53),
	.ex_wdata_i(d54),

	.ex_cp0_ena_i(d49),
	.ex_cp0_addr_i(d50),
	.ex_cp0_data_i(d51),

	.ex_hi(d62),
	.ex_lo(d63),
	.ex_hilo_ena_i(d64),


	.ex_except_i(d45),
	.ex_in_delayslot(d46),
	.ex_cur_inst_addr(d47),
	.ex_next_in_delayslot(d40),

	.hilo_i(d65),
	.cnt_i(d66),

	.mem_waddr_o(e1),
	.mem_wdata_o(e2),
	.mem_wena_o(e3),

	.mem_op_o(d4),
	.mem_addr_o(e4),
	.mem_data_o(e5),

	.mem_cp0_ena_o(e6),
	.mem_cp0_addr_o(e7),
	.mem_cp0_data_o(e8),

	.mem_hi_o(e9),
	.mem_lo_o(e10),
	.mem_hilo_ena_o(e11),

	.mem_except_o(e12),
	.mem_in_delayslot(e13),
	.mem_cur_inst_addr(e14),
	.ex_next_in_delayslot_o(d3),


	.hilo_o(d16),
	.cnt_o(d17)



);


 mem s6(

	.rst(rst),

	.except_i(e12),
	.in_delayslot_i(e13),
	.cur_inst_addr(e14),
	.last_except_i(k5),
	.except_mem_i(g2),

	.mem_op_i(d4),
	.mem_wdata_i(e5),
	.mem_addr_i(e4),
	.mem_rdata_i(g3),
	.mem_valid_i(d5),


	.waddr_i(e1),
	.wena_i(e3),
	.wdata_i(e2),

	.hi_i(e9),
	.lo_i(e10),
	.hilo_ena_i(e11),


	.cp0_ena_i(e6),
	.cp0_addr_i(e7),
	.cp0_data_i(e8),
	
	.LL_i(g4),

	.alig_LL_ena_i(g5),
	.alig_LL_data_i(g6),
	.wb_LL_ena_i(g7),
	.wb_LL_data_i(g8),

	.except_o(g9),
	.in_delayslot_o(g10),
	.cur_inst_addr_o(g11),

	.stall(g12),
	.align_op_o(g13),
	.reg_o(g14),

	.mem_addr_o(g15),
	.mem_ena_o(g16),
	.mem_sel_o(g17),
	.mem_data_o(g18),
	.mem_w_r_o(g19),


	.waddr_o(d7),
	.wena_o(d8),
	.wdata_o(d6),

	.hi_o(d22),
	.lo_o(d23),
	.hilo_ena_o(d21),


	.cp0_ena_o(d31),
	.cp0_addr_o(d32),
	.cp0_data_o(d33),


	.LL_ena_o(g20),
	.LL_data_o(g21)



);




 mem_alig s7(


	.rst(rst),
	.clk(clk),

	.stall(stal[3]),
	.flush(flu[3]),
	.except_i(g9),
	.cur_inst_addr(g10),
	.in_delayslot_i(g11),

	.align_op_i(g13),
	.align_sel_i(g17),
	.mem_rdata_i(g3),
	.reg_i(g14),

	.mem_wdata(d6),
	.mem_waddr(d7),
	.mem_wreg(d8),

	.mem_hi(d22),
	.mem_lo(d23),
	.mem_hilo_ena(d21),

	.mem_LL_ena(g20),
	.mem_LL_data(g21),

	.mem_cp0_ena(d31),
	.mem_cp0_addr(d32),
	.mem_cp0_data(d33),


	.reg_o(h1),
	.align_op_o(h2),
	.mem_rdata_o(h3),
	.except_o(g1),
	.cur_inst_addr_o(h4),
	.in_delayslot_o(h5),
	.align_sel_o(h6),

	.alig_cp0_ena(h7),
	.alig_cp0_addr(h8),
	.alig_cp0_data(h9),

	.alig_LL_ena(h10),
	.alig_LL_data(h11),

	.alig_waddr(h12),
	.alig_wena(h13),
	.alig_wdata(h14),

	.alig_hi(h15),
	.alig_lo(h16),
	.alig_hilo_ena(h17)


);

 align s8(
	
	.rst(rst),
	.alig_op_i(h2),
	.alig_data_i(h3),
	.alig_sel_i(h6),
	.reg_i(h1),

	.except_i(g1),
	.cur_inst_addr(h4),
	.in_delayslot_i(h5),


	.cp0_status_i(k1),
	.cp0_cause_i(k2),
	.cp0_EPC_i(k3),

	.wb_wcp0_i(d37),
	.wb_cp0_addr_i(d38),
	.wb_cp0_data_i(d39),

	.waddr_i(h12),
	.wena_i(h13),
	.wdata_i(h14),

	.LL_ena_i(h10),
	.LL_data_i(h11),

	.cp0_ena_i(h7),
	.cp0_addr_i(h8),
	.cp0_data_i(h9),

	.hilo_ena_i(h17),
	.hi_i(h15),
	.lo_i(h16),

	.epc_new_o(k4),
	.except_o(k5),
	.cur_inst_addr_o(k6),
	.in_delayslot_o(k7),


	.waddr_o(d10),
	.wena_o(d11),
	.wdata_o(d9),

	.LL_ena_o(g5),
	.LL_data_o(g6),

	.cp0_ena_o(d34),
	.cp0_addr_o(d35),
	.cp0_data_o(d36),

	.hilo_ena_o(d27),
	.hi_o(d25),
	.lo_o(d26)




);


 align_wb s9(

	.clk(clk),
	.rst(rst),
	.stall(stal[4]),
	.flush(flu[4]),

	.waddr_i(d10),
	.wena_i(d11),
	.wdata_i(d9),

	.LL_ena_i(g5),
	.LL_data_i(g6),

	.cp0_ena_i(d34),
	.cp0_addr_i(d35),
	.cp0_data_i(d36),

	.hilo_ena_i(d27),
	.hi_i(d25),
	.lo_i(d26),

	.waddr_o(d13),
	.wena_o(d14),
	.wdata_o(d12),

	.LL_ena_o(g7),
	.LL_data_o(g8),

	.cp0_ena_o(d37),
	.cp0_addr_o(d38),
	.cp0_data_o(d39),

	.hilo_ena_o(d30),
	.hi_o(d28),
	.lo_o(d29)


);


use_mmu s10(
	.clk(clk),
	.rst(rst),

	.addr_i_i(a6),
	.addr_d_i(g15),
	.w_data_i(g18),
	.w_r_i(g19),
	.ena_i_i(b1),
	.ena_d_i(g16),
	.start_entry_cata(start_entry_cata),
	.configg(config_i),
	.sel_byte_i(g17),



	.data_i_o(c1),
	.data_d_o(g3),
	.except_i_o(a10),
	.except_d_o(g2),
	.valid_i_o(a4),
	.valid_d_o(d5)

);

 

 cp0 s11(

	.rst(clk),
	.clk(rst),


	.ena(d34),
	.waddr_i(d35),
	.raddr_i(d48),
	.wdata_i(d36),

	.except_i(k5),
	.int_i(int_i),
	.cur_inst_addr_i(k6),
	.in_delayslot_i(k7),


	.rdata_o(d15),

	.timer_int_o(timer_int_o),

	.status_o(k1),
	.cause_o(k2),
	.epc_o(k3),
	.config_o(config_o)



);


 ctrl s12(

	.rst(rst),
	.stallreq_from_ex(d67),
	.stallreq_from_mem(g12),

	.except_i(k5),
	.cp0_new(k4),

	.new_pc(a9),
	.flush(flu),

	.stall(stal)


);



 LL_reg s13(

  	.clk(clk),
 	.rst(rst),
	

 	.flush(flu[5]),
	
 	.LL_i(g8),
 	.ena(g7),
	
  
 	.LL_o(g4)

);

 hilo_reg s14(

	.clk(clk),
	.rst(rst),

	.ena(d30),
	.hi_i(d28),
	.lo_i(d29),
	

	.hi_o(d18),
	.lo_o(d19)

);


 regfile s15(

	.clk(clk),
	.rst(rst),

	.ena_i(d14),
	.waddr(d13),
	.wdata(d12),

	.rena1(d41),
	.rena2(d43),
	.raddr1_i(d42),
	.raddr2_i(d44),

	.rdata1_o(d1),
	.rdata2_o(d2),
	.regt(regt)

);






endmodule