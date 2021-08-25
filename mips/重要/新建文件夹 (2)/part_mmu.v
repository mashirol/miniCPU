module part_mmu(

input	clk,
input	rst,

input[31:0]	addr_i_i,
input	ena_i_i,
input[31:0]	start_entry_cata,
input[31:0]	configg,


input[127:0]	idata_i1,
input[127:0]	idata_i2,
input[26:0]	iaddr_i1,
input[26:0]	iaddr_i2,

input[31:0]	ipaddr_r_i,
input	ivalid_r_i,


output[31:0]	data_i_o,
output	except_i_o,
output	valid_i_o,

output	ivalid_r_o,
output[5:0]	ir_addr_o,
output[6:0]	iw_addr_o,
output[26:0]	idata_addr_o,
output[127:0]	idata_d_o,
output	ivalid_w_o,
output	ichg_o,

	
output	iena_r_o,
output[19:0]	ivaddr_o,
output	iena_w_o,
output[3:0]	iaddr_o,
output[19:0]	ipaddr_w_o,


output[2:0] state,
output[1:0] cnt,
output[2:0] state_c,
output[2:0] state_t,

output qsuc_itlb_i,
output qvalid_itlb_i,
output	qvalid_iche_i,		
output 	qsuc_iche_i,
output	qinqur_iche_i,

output qena_itlb_o,
output qena_iche_o,
output qvalid_mem_o,

output[31:0] addr_itlb_f


);
assign addr_itlb_f = i4;

wire m2,m2m,m3,m3m,i2,i3,d2,d3,a2,a3,a6,b2,b3,b6,m6,m6m,m7,m7m,i5,i7,i8,d5,d7,d8,a9,a10,a12,a13,b9,b10,b12,b13;
wire[31:0] m1,m1m,i1,d1,a1,a5,b1,b5,m4,m4m,m5,m5m,i4,i6,d4,d6,a7,a8,b7,b8;
wire[127:0] a4,b4,a11,b11;
wire[3:0] m8,m8m,b14;



mmu mu(
	.clk(clk),
	.rst(rst),
	.addr_i_i(addr_i_i),

	.ena_i_i(ena_i_i),

	.start_entry_cata(start_entry_cata),
	.config_i(configg),

	.data_mem_i(m1),
	.valid_mem_i(m2),
	.busy_mem_i(m3),


	.addr_itlb_i(i1),
	.valid_itlb_i(i2),
	.suc_itlb_i(i3),
	
	
	.data_iche_i(a1),
	.valid_iche_i(a2),		
	.suc_iche_i(a3),
	.data_chg_iche_i(a4),
	.addr_chg_iche_i(a5),
	.inqur_iche_i(a6),

	.data_i_o(data_i_o),

	.except_i_o(except_i_o),

	.valid_i_o(valid_i_o),


	.addr_mem_o(m4),
	.data_mem_o(m5),
	.valid_mem_o(m6),
	.w_r_mem_o(m7),
	.sel_byte_mem_o(m8),


	.addr_itlb_o(i4),
	.ena_itlb_o(i5),
	.addr_chg_itlb_o(i6),
	.valid_chg_itlb_o(i7),
	.suc_chg_itlb_o(i8),



	.addr_iche_o(a7),
	.data_iche_o(a8),
	.w_r_iche_o(a9),
	.ena_iche_o(a10),
	.data_chg_iche_o(a11),
	.valid_chg_iche_o(a12),
	.valid_inq_iche_o(a13),

	
	
	
	.state(state),
	.cnt(cnt),
		.qsuc_itlb_i(qsuc_itlb_i),
.qvalid_itlb_i(qvalid_itlb_i),
.qvalid_iche_i(qvalid_iche_i),		
.qsuc_iche_i(qsuc_iche_i),
.qinqur_iche_i(qinqur_iche_i),

.qena_itlb_o(qena_itlb_o),
.qena_iche_o(qena_iche_o),
.qvalid_mem_o(qvalid_mem_o)

);





meme mm(

	.clk(clk),
	.rst(rst),

	.addr_i(m4),
	.data_i(m5),
	.sel_byte_i(m8),
	.ena_i(m6),
	.w_r_i(m7),

	.data_o(m1),
	.valid_o(m2),
	.busy(m3)
	

);





icache ic(

	.clk(clk),
	.rst(rst),

	.addr_i(a7),
	.data_i(a8),
	.w_r_i(a9),
	.ena_i(a10),
	.data_chg_i(a11),
	.valid_chg_i(a12),
	.valid_inq_i(a13),

	.data_i1(idata_i1),
	.data_i2(idata_i2),
	.addr_i1(iaddr_i1),
	.addr_i2(iaddr_i2),
	
	.valid_r_o(ivalid_r_o),
	.r_addr_o(ir_addr_o),
	.w_addr_o(iw_addr_o),
	.data_addr_o(idata_addr_o),
	.data_d_o(idata_d_o),
	.valid_w_o(ivalid_w_o),
	.chg_o(ichg_o),
	
	.data_o(a1),
	.valid_o(a2),
	.suc_o(a3),
	.data_chg_o(a4),
	.addr_chg_o(a5),
	.inq_o(a6),
	.state(state_c)
);






itlb it(

	.clk(clk),
	.rst(rst),
	
	.vaddr_i(i4),
	.ena_i(i5),
	.paddr_i(i6),
	.valid_i(i7),
	.suc_chg(i8),

	.paddr_r_i(ipaddr_r_i),
	.valid_r_i(ivalid_r_i),

	.ena_r_o(iena_r_o),
	.vaddr_o(ivaddr_o),
	.ena_w_o(iena_w_o),
	.addr_o(iaddr_o),
	.paddr_w_o(ipaddr_w_o),
	
	.paddr_o(i1),
	.valid_o(i2),
	.suc_o(i3),
	.state(state_t)

);







endmodule
