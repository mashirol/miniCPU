module part_i(

input clk,
input rst,


input [31:0]		addr_i_i,
	
input			ena_i_i,


input  [31:0]		start_entry_cata,
input  [31:0]		configg,	


input  [31:0]		data_mem_i,
input	  		valid_mem_i,
input			busy_mem_i,

input  [31:0]		addr_itlb_i,
input			valid_itlb_i,
input			suc_itlb_i,


input  [31:0]		data_iche_i,
input			valid_iche_i,		
input  			suc_iche_i,
input  [127:0]		data_chg_iche_i,
input  [31:0]		addr_chg_iche_i,
input			inqur_iche_i,


output reg[31:0]	data_i_o,
output reg		except_i_o,
output reg		valid_i_o,


output reg[31:0]	addr_mem_o,
output reg[31:0]	data_mem_o,
output reg		valid_mem_o,
output reg		w_r_mem_o,
output reg[3:0]		sel_byte_mem_o,	


output reg[31:0]	addr_itlb_o,
output reg		ena_itlb_o,
output reg[31:0]	addr_chg_itlb_o,
output reg		valid_chg_itlb_o,
output reg		suc_chg_itlb_o,	

output reg[31:0]        addr_iche_o,
output reg[31:0] 	data_iche_o,
output reg		w_r_iche_o,
output reg		ena_iche_o,
output reg[127:0]	data_chg_iche_o,
output reg		valid_chg_iche_o,
output reg		valid_inq_iche_o,

output[1:0] cnt,
output[2:0] state,


output qsuc_itlb_i,
output qvalid_itlb_i,
output	qvalid_iche_i,		
output 	qsuc_iche_i,
output	qinqur_iche_i,

output qena_itlb_o,
output qena_iche_o,
output qvalid_mem_o


);

parameter s0=3'b000;
parameter s1=3'b001;
parameter s2=3'b010;
parameter s3=3'b011;
parameter s4=3'b100;
parameter s5=3'b101;

reg[31:0] data_i_o_i;
reg 	  except_i_o_i;
reg 	  valid_i_o_i;

reg[31:0] addr_mem_o_i;
reg[31:0] data_mem_o_i;
reg 	  valid_mem_o_i;
reg 	  w_r_mem_o_i;
reg[3:0]  sel_byte_mem_o_i;


reg[31:0] addr_itlb_o_i;
reg 	  ena_itlb_o_i;
reg[31:0] addr_chg_itlb_o_i;
reg 	  valid_chg_itlb_o_i;
reg 	  suc_chg_itlb_o_i;


reg[31:0] addr_iche_o_i;
reg[31:0] data_iche_o_i;
reg 	  w_r_iche_o_i;
reg 	  ena_iche_o_i;
reg[127:0] data_chg_iche_o_i;
reg	  valid_chg_iche_o_i;
reg 	  valid_inq_iche_o_i;





reg[1:0]   cnt_i,cnt_o;
reg[127:0] temp_i,temp_o;


wire[31:0]   w_data_i = 0;
wire	     w_r_i = 0;
wire[3:0]    sel_byte_i = 0;



reg[2:0]  cur_state,next_state;  

assign cnt = cnt_o;
assign state= cur_state;

assign qsuc_itlb_i=		suc_itlb_i;
assign qvalid_itlb_i=	valid_itlb_i;
assign	qvalid_iche_i=	valid_iche_i;		
assign 	qsuc_iche_i=	suc_iche_i;
assign	qinqur_iche_i=	inqur_iche_i;

assign qena_itlb_o=	ena_itlb_o;
assign qena_iche_o=	ena_iche_o;
assign qvalid_mem_o=	valid_mem_o;


always @(posedge clk) begin
	
	if(!rst) begin
		cur_state <= 0;
		cnt_i  <= 0;
		temp_i <=0;

	end
	else begin
		data_i_o_i	<=data_i_o;
		except_i_o_i	<= except_i_o;
		valid_i_o_i	<= valid_i_o;

		addr_mem_o_i	<= addr_mem_o;
		data_mem_o_i	<= data_mem_o;
		valid_mem_o_i	<= valid_mem_o;
		w_r_mem_o_i	<= w_r_mem_o;
		sel_byte_mem_o_i<= sel_byte_mem_o;

		addr_itlb_o_i	<= addr_itlb_o;
		ena_itlb_o_i	<= ena_itlb_o;
		addr_chg_itlb_o_i <= addr_chg_itlb_o;
		valid_chg_itlb_o_i<= valid_chg_itlb_o;
		suc_chg_itlb_o_i  <= suc_chg_itlb_o;

		addr_iche_o_i	  <= addr_iche_o;
		data_iche_o_i	<= data_iche_o;
		w_r_iche_o_i	<= w_r_iche_o;
		ena_iche_o_i	<= ena_iche_o;
		data_chg_iche_o_i  <= data_chg_iche_o;
		valid_chg_iche_o_i <= valid_chg_iche_o;
		valid_inq_iche_o_i <= valid_inq_iche_o;

		cnt_i	  <= cnt_o;
		temp_i 	  <= temp_o;
		cur_state <= next_state;
	end

end


always @(*) begin
	
	if(!rst) begin
		data_i_o	<=0;
		except_i_o	<= 0;
		valid_i_o	<= 0;
		addr_mem_o	<= 0;
		data_mem_o	<=0;
		valid_mem_o	<= 0;
		w_r_mem_o	<= 0;
		sel_byte_mem_o	<=0;
		addr_chg_itlb_o	<= 0;
		valid_chg_itlb_o<= 0;
		suc_chg_itlb_o	<= 0;
		data_chg_iche_o	<= 0;
		valid_chg_iche_o<= 0;
		valid_inq_iche_o<= 0;
		temp_o <=0;
		cnt_o <= 0;
		next_state <= 0;
	end
	else begin
		data_i_o	<=  data_i_o_i;
		except_i_o	<= except_i_o_i;
		valid_i_o	<= valid_i_o_i;

		addr_mem_o	<= addr_mem_o_i;
		data_mem_o	<= data_mem_o_i;
		valid_mem_o	<= valid_mem_o_i;
		w_r_mem_o	<= w_r_mem_o_i;
		sel_byte_mem_o	<= sel_byte_mem_o_i;

		addr_chg_itlb_o	<= addr_chg_itlb_o_i;
		valid_chg_itlb_o<= valid_chg_itlb_o_i;
		suc_chg_itlb_o	<= suc_chg_itlb_o_i;

		data_chg_iche_o	<= data_chg_iche_o_i;
		valid_chg_iche_o<= valid_chg_iche_o_i;
		valid_inq_iche_o<= valid_inq_iche_o_i;
		cnt_o  <= cnt_i;

		if(addr_i_i >= 32'h0000_0010) begin
			case(cur_state)
			s0:begin
				valid_i_o  <= 1'b0;
				next_state <= s0;
				except_i_o  <=0;
				valid_mem_o<= 1'b0;
				if(!ena_i_i) begin
					valid_i_o  <= 1'b0;
					next_state <= s0;
					except_i_o  <=0;
					valid_mem_o<= 1'b0;
				end
				else begin
					if(w_r_i) begin
						addr_mem_o<= addr_i_i;
						data_mem_o<= w_data_i;
						valid_mem_o<= 1'b1;
						w_r_mem_o<= 1'b1;
						sel_byte_mem_o<=sel_byte_i;
					end
					else begin
						addr_mem_o<= addr_i_i;
						valid_mem_o<= 1'b1;
						w_r_mem_o<= 1'b0;
					end
					next_state <= s5;
				end
			end
			s5:begin
				if(!valid_mem_i) begin
					valid_i_o  <= 1'b0;
					//valid_mem_o    <= 1'b0;
					next_state <= s5;
				end
				else begin
					valid_mem_o<= 1'b0;
					data_i_o   <= data_mem_i;
					except_i_o <= 1'b0;
					valid_i_o  <= 1'b1;
					next_state <=s0;
				end
			end
			default:begin
			end
			endcase
		end
		else if(addr_i_i >= 32'h0000_0005)begin

			case(cur_state)
			s0: begin
				except_i_o  <=0;
				valid_mem_o <=0;
				valid_i_o   <= 0;
			if(!ena_i_i) begin
				next_state <= s0;
				valid_i_o   <= 0;
			end
			else begin
				if(valid_iche_i && suc_iche_i) begin
					next_state <= s0;
					valid_i_o   <= 1'b1;
				end
				else begin
					if(!w_r_i)begin
							cnt_o <=2'b01;
							addr_mem_o  <= addr_itlb_i;
							valid_mem_o <= 1'b1;
							w_r_mem_o   <= 1'b0;
							valid_chg_iche_o <=1'b0;			
					  		next_state <=  s3;
					end
					else begin
							if(inqur_iche_i) begin
								data_mem_o  <= data_chg_iche_i[31:0];
								cnt_o 	    <= 2'b01;
								addr_mem_o  <= addr_chg_iche_i;
								valid_mem_o <= 1'b1;
								w_r_mem_o   <= 1'b1;
								valid_inq_iche_o<= 0;
					  			next_state  <= s4;
							end
							else begin
								cnt_o 	    <= 2'b01;
								addr_mem_o  <= addr_itlb_i;
								valid_mem_o <= 1'b1;
								w_r_mem_o   <= 1'b0;
								valid_inq_iche_o<= 0;
					  			next_state  <= s3;
							end
					end
				end
			end
			end
			s3:begin
				if(!valid_mem_i) begin
					next_state <= s3;
					//valid_mem_o <= 1'b0;
				end
				else begin
					if(cnt_i == 2'b01) begin
						cnt_o       <=2'b10;
						temp_o <= {temp_i[127:32],data_mem_i};
						addr_mem_o  <= addr_iche_o + 4'h4;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b0;
						next_state  <= s3;
					end
					else if(cnt_i == 2'b10) begin
						cnt_o       <=2'b11;
						temp_o <= {temp_i[95:0],data_mem_i};
						addr_mem_o  <= addr_iche_o + 4'h8;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b0;
						next_state  <= s3;
					end
					else if(cnt_i == 2'b11)begin
						cnt_o       <=2'b00;
						temp_o <= {temp_i[95:0],data_mem_i};
						addr_mem_o  <= addr_iche_o + 4'hc;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b0;
						next_state  <= s3;
					end
					else begin
						data_chg_iche_o <= {temp_i[95:0],data_mem_i};
						//valid_mem_o <= 1'b0;
						valid_chg_iche_o <=1'b1;
						if(!inqur_iche_i && suc_iche_i) begin
					  		valid_i_o   	<= 1'b1;
							data_i_o  	<= data_iche_i;
							except_i_o	<= 1'b0;		
							valid_mem_o 	<= 1'b0;
							next_state  	<= s0;
						end
						else begin
							valid_i_o   	<= 1'b0;																					
							valid_mem_o <= 1'b1;
							cnt_o 	    <= 2'b01;
							addr_mem_o  <= addr_chg_iche_i;
							data_mem_o  <= data_chg_iche_i[31:0];
							w_r_mem_o   <= 1'b1;
							valid_inq_iche_o <= 1'b0;
							next_state  	 <= s4;
						end
					end
				end
			end
			s4:begin
				if(!valid_mem_i) begin
					next_state <= s4;
					//valid_mem_o <= 1'b0;
				end
				else begin
					if(cnt_i == 2'b01) begin
						cnt_o       <=2'b10;
						data_mem_o  <= data_chg_iche_i[63:32];
						addr_mem_o  <= addr_chg_iche_i + 4'h4;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b1;
						next_state  <= s4;
					end
					else if(cnt_i == 2'b10) begin
						cnt_o       <=2'b11;
						data_mem_o  <= data_chg_iche_i[95:64];
						addr_mem_o  <= addr_chg_iche_i + 4'h8;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b1;
						next_state  <= s4;
					end
					else if(cnt_i == 2'b11)begin
						cnt_o       <=2'b00;
						data_mem_o  <= data_chg_iche_i[127:96];
						addr_mem_o  <= addr_chg_iche_i + 4'hc;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b1;
						next_state  <= s4;
					end
					else begin
						if(!w_r_i) begin
							valid_mem_o     <= 1'b0;
							valid_inq_iche_o <=1'b1;
					  		valid_i_o   	<= 1'b1;
							data_i_o  	<= data_iche_i;
							except_i_o 	<= 1'b0;
							next_state  	<= s0;
						end
						else begin
							valid_mem_o <= 1'b1;
							cnt_o 	    <= 2'b01;
							addr_mem_o  <= addr_iche_o;
							w_r_mem_o   <= 1'b0;
							valid_inq_iche_o <=1'b1;
							next_state  	 <= s3;                                                                                                               
						end
					end
				end
			end
			default:begin
			end
			endcase
		end
		else begin
			case(cur_state)
			s0:begin
				valid_mem_o <= 0;
				valid_i_o   <= 0;
				except_i_o  <= 0;
				if(!ena_i_i) begin
					next_state <= s0;
					valid_i_o  <= 0;
					except_i_o  <=0;
				end
				else begin
					if(valid_itlb_i && suc_itlb_i && valid_iche_i && suc_iche_i) begin
					 	data_i_o <= data_iche_i;
					  	valid_i_o <= 1'b1;
					  	next_state <= s0;
					end
					else if(valid_itlb_i && !suc_itlb_i) begin
					  	valid_i_o   <= 1'b0;
						addr_mem_o  <= {start_entry_cata[31:12],addr_i_i[31:22],2'b00};
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b0;
					  	next_state  <= s1;

					end
					else if(valid_itlb_i && suc_itlb_i && valid_iche_i && !suc_iche_i)begin
					  	valid_i_o <= 1'b0;
						if(!w_r_i) begin
							cnt_o<=2'b01;
							addr_mem_o  <= addr_itlb_i;
							valid_mem_o <= 1'b1;
							w_r_mem_o   <= 1'b0;
							valid_chg_iche_o <=1'b0;			
					  		next_state <=  s3;
						end
						else begin
							if(inqur_iche_i) begin
								data_mem_o  <= data_chg_iche_i[31:0];
								cnt_o 	    <= 2'b01;
								addr_mem_o  <= addr_chg_iche_i;
								valid_mem_o <= 1'b1;
								w_r_mem_o   <= 1'b1;
								valid_inq_iche_o<= 0;
					  			next_state  <= s4;
							end
							else begin
								cnt_o 	    <= 2'b01;
								addr_mem_o  <= addr_itlb_i;
								valid_mem_o <= 1'b1;
								w_r_mem_o   <= 1'b0;
								valid_inq_iche_o<= 0;
					  			next_state  <= s3;
							end
						end
					end
					else begin
					  	valid_i_o <= 1'b0;
					  	next_state <= s0;			
					end
				end

			end
		
			s1:begin
				if(!valid_mem_i) begin
					next_state <= s1;
					//valid_mem_o <=1'b0;
				end
				else begin
					if(!data_mem_i[31]) begin
						valid_chg_itlb_o <= 1'b1;
						suc_chg_itlb_o   <= 1'b0;
						except_i_o	 <= 1'b1;
						valid_i_o	 <= 1'b1;
						data_i_o 	 <= 0;
						valid_mem_o 	 <= 1'b0;
						next_state 	 <= s0;
					end
					else begin
						valid_mem_o <= 1'b1;
						addr_mem_o  <= {data_mem_i[30:11],addr_i_i[21:12],2'b00};
						data_mem_o  <= 1'b0;
						w_r_mem_o   <= 1'b0;
						next_state  <= s2;
					end
				end				
			end
			
			s2:begin
				if(!valid_mem_i) begin
					next_state <= s2;
					//valid_mem_o <=1'b0;
				end
				else begin
					if(!data_mem_i[31]) begin
						valid_chg_itlb_o <= 1'b1;
						suc_chg_itlb_o   <= 1'b0;
						except_i_o	 <= 1'b1;
						valid_i_o	 <= 1'b1;
						data_i_o 	 <= 0;
						valid_mem_o 	 <= 1'b0;
						next_state 	 <= s0;
					end
					else begin
						valid_chg_itlb_o <= 1'b1;
						suc_chg_itlb_o   <= 1'b1;
						addr_chg_itlb_o      <= {data_mem_i[30:11],addr_i_i[11:0]};
						if(valid_iche_i && suc_iche_i) begin
							valid_i_o 	<= 1'b1;
							data_i_o  	<= data_iche_i;
							except_i_o	<= 1'b0;		
						   valid_mem_o 	<= 1'b0;
							next_state 	<= s0;
						end
						else begin
							if(!w_r_i) begin
								valid_mem_o <= 1'b1;
								cnt_o 	    <= 2'b01;
								addr_mem_o  <= {data_mem_i[30:11],addr_i_i[11:0]};
								w_r_mem_o   <= 1'b0;
								valid_chg_iche_o <=1'b0;
								next_state  <= s3;
							end
							else begin
								if(inqur_iche_i) begin
									valid_mem_o <= 1'b1;
									cnt_o 	    <= 2'b01;
									addr_mem_o  <= addr_chg_iche_i;
									data_mem_o  <= data_chg_iche_i[31:0];
									w_r_mem_o   <= 1'b1;
									valid_inq_iche_o <= 1'b0;
									next_state  <= s4;
								end
								else begin																								
								   valid_mem_o <= 1'b1;
									cnt_o 	    <= 2'b01;
									addr_mem_o  <= {data_mem_i[30:11],addr_i_i[11:0]};
									w_r_mem_o   <= 1'b0;
									next_state  <= s3;
								end
							end
						end
					end
				end
			end
		
			s3:begin
				if(!valid_mem_i) begin
					next_state <= s3;
					//valid_mem_o <= 0;
					data_i_o <= 111;
				end
				else begin

					if(cnt_i == 2'b01) begin
						cnt_o       <=2'b10;
						temp_o <= {data_mem_i??temp_i[127:32]};
						addr_mem_o  <= addr_iche_o + 4'h4;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b0;
						next_state  <= s3;
					end
					else if(cnt_i == 2'b10) begin
						cnt_o       <=2'b11;
						temp_o <= {data_mem_i??temp_i[127:32]};
						addr_mem_o  <= addr_iche_o + 4'h8;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b0;
						next_state  <= s3;
					end
					else if(cnt_i == 2'b11)begin
						cnt_o       <=2'b00;
						temp_o <= {data_mem_i??temp_i[127:32]};
						addr_mem_o  <= addr_iche_o + 4'hc;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b0;
						next_state  <= s3;
					end
					else begin
						data_chg_iche_o <= {data_mem_i??temp_i[127:32]};
						//valid_mem_o <= 1'b0;
						valid_chg_iche_o <=1'b1;
						    //next_state  	<= s0;
						if(!inqur_iche_i && suc_iche_i) begin
					  		valid_i_o   	<= 1'b1;
							data_i_o  	<= data_iche_i;
							except_i_o	<= 1'b0;		
							valid_mem_o 	<= 1'b0;
							next_state  	<= s0;
						end
						else begin
							valid_i_o   	<= 1'b0;
							valid_mem_o  <= 1'b1;
							cnt_o 	    <= 2'b01;
							addr_mem_o  <= addr_chg_iche_i;
							data_mem_o  <= data_chg_iche_i[31:0];
							w_r_mem_o   <= 1'b1;
							valid_inq_iche_o <= 1'b0;
							next_state  	 <= s4;
						end
					end
				end
			end
	
			s4:begin
				if(!valid_mem_i) begin
					next_state <= s4;
					//valid_mem_o <= 1'b0;
				end
				else begin
					if(cnt_i == 2'b01) begin
						cnt_o       <=2'b10;
						data_mem_o  <= data_chg_iche_i[63:32];
						addr_mem_o  <= addr_chg_iche_i + 4'h4;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b1;
						next_state  <= s4;
					end
					else if(cnt_i == 2'b10) begin
						cnt_o       <=2'b11;
						data_mem_o  <= data_chg_iche_i[95:64];
						addr_mem_o  <= addr_chg_iche_i + 4'h8;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b1;
						next_state  <= s4;
					end
					else if(cnt_i == 2'b11)begin
						cnt_o       <=2'b00;
						data_mem_o  <= data_chg_iche_i[127:96];
						addr_mem_o  <= addr_chg_iche_i + 4'hc;
						valid_mem_o <= 1'b1;
						w_r_mem_o   <= 1'b1;
						next_state  <= s4;
					end
					else begin
						if(!w_r_i) begin
							valid_mem_o     <= 1'b0;
							valid_inq_iche_o <=1'b1;
					  		valid_i_o   	<= 1'b1;
							data_i_o  	<= data_iche_i;
							except_i_o 	<= 1'b0;
							next_state  	<= s0;
						end
						else begin
							valid_mem_o <= 1'b1;
							cnt_o 	    <= 2'b01;
							addr_mem_o  <= addr_iche_o;
							w_r_mem_o   <= 1'b0;
							valid_inq_iche_o <=1'b1;
							next_state  	 <= s3;                                                                                                               
						end
					end
				end

			end
			s5:begin
				if(!valid_mem_i) begin
					//valid_mem_o     <= 1'b0;
					next_state <= s5;
				end
				else begin
					valid_mem_o     <= 1'b0;
					data_i_o   <= data_mem_i;
					except_i_o <= 1'b0;
					valid_i_o  <= 1'b1;
					next_state <=s0;
				end
			end
			default:begin
			end
			endcase
		end
	end

end

always @(*) begin
	
	if(!rst) begin
		data_iche_o	<= 0;
		addr_itlb_o <= 0;
		ena_itlb_o	<= 0;
		ena_iche_o	<=0;
		w_r_iche_o	<= 0;
		addr_iche_o	<= 0;
	end
	else begin
		addr_itlb_o 	<= addr_itlb_o_i;
		ena_itlb_o	<= ena_itlb_o_i;

		ena_iche_o	<= ena_iche_o_i;
		w_r_iche_o	<= w_r_iche_o_i;
		addr_iche_o	<= addr_iche_o_i;
		data_iche_o	<= data_iche_o_i;
		
		if(addr_i_i >= 32'h0000_0010) begin
		end
		else if(addr_i_i >= 32'h0000_0005)begin
			if(ena_i_i) begin
				ena_iche_o <= 1'b1;
				if(w_r_i)begin
					data_iche_o <= w_data_i;
					addr_iche_o <= addr_i_i;
					w_r_iche_o  <= 1'b1;
				end
				else begin
					addr_iche_o <= addr_i_i;
					w_r_iche_o <= 1'b0;
				end
			end
			else begin
				ena_iche_o <= 0;
			end
			
		end
		else begin
		
		case(cur_state)
			s0:begin
				ena_itlb_o <=0;
				ena_iche_o <=0;
				if(ena_i_i) begin
					ena_itlb_o  <= 1'b1;
					addr_itlb_o <= addr_i_i;
					w_r_iche_o  <= w_r_i;
					if(valid_itlb_i && suc_itlb_i) begin
						ena_iche_o <= 1'b1;
						w_r_iche_o <= 1'b0;
						addr_iche_o<= addr_itlb_i;
					end
					else begin
						ena_iche_o <= 1'b0;
					end			
				end
				else begin
					ena_itlb_o  <= 1'b0;
				end
					
			end
		
			s1:begin
			end
			
			s2:begin
				if(!suc_itlb_i) begin
					ena_iche_o <= 1'b0;
				end
				else begin
					ena_iche_o <= 1'b1;
					addr_iche_o <= {data_mem_i[30:11],addr_i_i[11:0]};
					data_iche_o <= w_data_i;
				end
			end
		
			s3:begin
			end
	
			s4:begin
			end

			s5:begin
			end
			default:begin
			end
			endcase
		end
	end
end

endmodule
