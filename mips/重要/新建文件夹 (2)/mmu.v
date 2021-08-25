module mmu(


input clk,
input rst,

input[31:0]		addr_i_i,
input			ena_i_i,

input[31:0]		start_entry_cata,
input[31:0]		config_i,	

input[31:0]		data_mem_i,
input	  		valid_mem_i,
input			busy_mem_i,		//mem


input[31:0]		addr_itlb_i,
input			valid_itlb_i,
input			suc_itlb_i,		//itlb

input[31:0]		data_iche_i,
input			valid_iche_i,		
input  			suc_iche_i,
input[127:0]		data_chg_iche_i,
input[31:0]		addr_chg_iche_i,
input			inqur_iche_i,		//iche

	
output[31:0]	data_i_o,	
output		except_i_o,
output		valid_i_o,

output[31:0]	addr_mem_o,
output[31:0]	data_mem_o,
output		valid_mem_o,
output		w_r_mem_o,
output[3:0]		sel_byte_mem_o,		//mem


output[31:0]	addr_itlb_o,
output		ena_itlb_o,
output[31:0]	addr_chg_itlb_o,
output		valid_chg_itlb_o,
output		suc_chg_itlb_o,		//itlb


output[31:0]        addr_iche_o,
output[31:0] 	data_iche_o,
output		w_r_iche_o,
output		ena_iche_o,
output[127:0]	data_chg_iche_o,
output		valid_chg_iche_o,
output		valid_inq_iche_o,
output[2:0] state,
output[1:0] cnt,
output qsuc_itlb_i,
output qvalid_itlb_i,
output	qvalid_iche_i,		
output 	qsuc_iche_i,
output	qinqur_iche_i,

output qena_itlb_o,
output qena_iche_o,
output qvalid_mem_o




);


part_i s1(
	.clk(clk),
	.rst(rst),

	.addr_i_i(addr_i_i),
	
	.ena_i_i(ena_i_i),

	.start_entry_cata(start_entry_cata),
	.configg(config_i),


	.data_mem_i(data_mem_i),
	.valid_mem_i(valid_mem_i),
	.busy_mem_i(busy_mem_i),

	.addr_itlb_i(addr_itlb_i),
	.valid_itlb_i(valid_itlb_i),
	.suc_itlb_i(suc_itlb_i),


	.data_iche_i(data_iche_i),
	.valid_iche_i(valid_iche_i),		
	.suc_iche_i(suc_iche_i),
	.data_chg_iche_i(data_chg_iche_i),
	.addr_chg_iche_i(addr_chg_iche_i),
	.inqur_iche_i(inqur_iche_i),


	.data_i_o(data_i_o),
	.except_i_o(except_i_o),
	.valid_i_o(valid_i_o),


	.addr_mem_o(addr_mem_o),
	.data_mem_o(data_mem_o),
	.valid_mem_o(valid_mem_o),
	.w_r_mem_o(w_r_mem_o),
	.sel_byte_mem_o(sel_byte_mem_o),	


	.addr_itlb_o(addr_itlb_o),
	.ena_itlb_o(ena_itlb_o),
	.addr_chg_itlb_o(addr_chg_itlb_o),
	.valid_chg_itlb_o(valid_chg_itlb_o),
	.suc_chg_itlb_o(suc_chg_itlb_o),	

	.addr_iche_o(addr_iche_o),
	.data_iche_o(data_iche_o),
	.w_r_iche_o(w_r_iche_o),
	.ena_iche_o(ena_iche_o),
	.data_chg_iche_o(data_chg_iche_o),
	.valid_chg_iche_o(valid_chg_iche_o),
	.valid_inq_iche_o(valid_inq_iche_o),
	
	
	
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



endmodule
