module part(

input	clk,
input	rst,

input[31:0]	addr_i_i,
input[31:0]	addr_d_i,
input[31:0]	w_data_i,
input	w_r_i,
input	ena_i_i,
input	ena_d_i,
input[31:0]	start_entry_cata,
input[31:0]	configg,
input[3:0]	sel_byte_i,


output[31:0]	data_i_o,
output	except_i_o,
output	valid_i_o,

output[2:0] state,
output[1:0] cnt,
output[2:0] state_c,
output[1:0] state_t,

output   qsuc_itlb_i,
output   qvalid_itlb_i,

output	qvalid_iche_i,		
output 	qsuc_iche_i,

output	qinqur_iche_i,

output qena_itlb_o,
output qena_iche_o,
output qvalid_mem_o,

output[31:0] addr_itlb_f,
output[19:0] addr_itlb_a,
output ena_itlb_a

);
assign addr_itlb_a = c2;
assign ena_itlb_a = c1;


wire[127:0] a1,a2,b1,b2,a11,b11;
wire[26:0]  a3,a4,b3,b4,a10,b10;
wire[31:0]  a5,b5;
wire a6,b6,a7,b7,a12,b12,a13,b13,c1,d1,c3,d3;
wire[5:0] a8,b8;
wire[6:0] a9,b9;
wire[19:0] c2,d2,c5,d5;
wire[3:0] c4,d4;


part_mmu s1(
	.clk(clk),
	.rst(rst),

	.addr_i_i(addr_i_i),
	.ena_i_i(ena_i_i),
	.start_entry_cata(start_entry_cata),
	.configg(configg),


	.idata_i1(a1),
	.idata_i2(a2),
	.iaddr_i1(a3),
	.iaddr_i2(a4),

	.ipaddr_r_i(a5),
	.ivalid_r_i(a6),


	.data_i_o(data_i_o),
	.except_i_o(except_i_o),
	.valid_i_o(valid_i_o),

	.ivalid_r_o(a7),
	.ir_addr_o(a8),
	.iw_addr_o(a9),
	.idata_addr_o(a10),
	.idata_d_o(a11),
	.ivalid_w_o(a12),
	.ichg_o(a13),

	
	.iena_r_o(c1),
	.ivaddr_o(c2),
	.iena_w_o(c3),
	.iaddr_o(c4),
	.ipaddr_w_o(c5),

	.state(state),
	.cnt(cnt),
	.state_c(state_c),
	.state_t(state_t),
	
.qsuc_itlb_i(qsuc_itlb_i),
.qvalid_itlb_i(qvalid_itlb_i),
.qvalid_iche_i(qvalid_iche_i),		
.qsuc_iche_i(qsuc_iche_i),
.qinqur_iche_i(qinqur_iche_i),

.qena_itlb_o(qena_itlb_o),
.qena_iche_o(qena_iche_o),
.qvalid_mem_o(qvalid_mem_o),

.addr_itlb_f(addr_itlb_f)

);




cache s2(
	.clk(clk),
	.rst(rst),


	.valid_r_o(a7),
	.r_addr_o(a8),
	.w_addr_o(a9),
	.data_addr_o(a10),
	.data_d_o(a11),
	.valid_w_o(a12),
	.chg_o(a13),

	.data_i1(a1),
	.data_i2(a2),
	.addr_i1(a3),
	.addr_i2(a4)

);




tlb s5(

	.clk(clk),
	.rst(rst),


	.ena_r_o(c1),
	.vaddr_o(c2),

	.ena_w_o(c3),
	.addr_o(c4),
	.paddr_w_o(c5),


	.paddr_r_i(a5),
	.valid_r_i(a6)

);





endmodule