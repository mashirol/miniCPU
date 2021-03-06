
module align(

input rst,
input[7:0]	alig_op_i,
input[31:0]	alig_data_i,
input[3:0]	alig_sel_i,
input[31:0]	reg_i,

input[31:0]	except_i,
input[31:0]	cur_inst_addr,
input		in_delayslot_i,


input[31:0]	cp0_status_i,
input[31:0]	cp0_cause_i,
input[31:0]	cp0_EPC_i,

input		wb_wcp0_i,
input[31:0]	wb_cp0_addr_i,
input[31:0]	wb_cp0_data_i,

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

output[31:0]	epc_new_o,
output	reg[31:0]	except_o,
output	reg[31:0]	cur_inst_addr_o,
output	reg		in_delayslot_o,


output reg[4:0]		waddr_o,
output reg		wena_o,
output reg[31:0]	wdata_o,

output reg		LL_ena_o,
output reg		LL_data_o,

output reg		cp0_ena_o,
output reg[4:0]		cp0_addr_o,
output reg[31:0]	cp0_data_o,

output reg		hilo_ena_o,
output reg[31:0]	hi_o,
//output reg[2:0] k,
output reg[31:0]	lo_o

);


reg[31:0]	cp0_status;
reg[31:0]	cp0_epc;
reg[31:0]	cp0_cause;


	assign epc_new_o  = cp0_epc;

	always@(*)begin
		if(!rst) begin
			cp0_epc <= 0;
		end
		else if((wb_wcp0_i == 1'b1) && 
			(wb_cp0_addr_i == `CP0_REG_EPC	))begin
			cp0_epc <= wb_cp0_data_i;
		end
		else begin
			cp0_epc <= cp0_EPC_i;
		end	
	end



	always@(*)begin
		if(!rst) begin
			cp0_status <= 0;
		end
		else if((wb_wcp0_i == `Enable_write) && 
			(wb_cp0_addr_i == `CP0_REG_STATUS))begin
			cp0_status <= wb_cp0_data_i;
		end
		else begin
			cp0_status <= cp0_status_i;
		end	
	end



	always@(*)begin
		if(!rst) begin
			cp0_cause <= 0;
		end
		else if((wb_wcp0_i == `Enable_write) && 
			(wb_cp0_addr_i == `CP0_REG_CAUSE))begin

			cp0_cause[9:8] 	<= wb_cp0_data_i[9:8];
			cp0_cause[22] 	<= wb_cp0_data_i[22];
			cp0_cause[23] 	<= wb_cp0_data_i[23];
		end
		else begin
			cp0_cause <= cp0_cause_i;
		end	
	end




	always @(*) begin
		if(!rst) begin
			except_o  <= 0;
		end	
		else begin
			if(cur_inst_addr != 0) begin
				if(((cp0_cause[15:8] & (cp0_status[15:8])) != 8'h00) &&
					(cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1))  begin	
					
					except_o <= 32'h00000001;
				end
				else if(except_i[8] == 1'b1) begin
					except_o <= 32'h00000008;
				end
				else if(except_i[9] == 1'b1) begin
					except_o <= 32'h0000000a;
				end
				else if(except_i[10] == 1'b1) begin
					except_o <= 32'h0000000d;
				end
				else if(except_i[11] == 1'b1) begin
					except_o <= 32'h0000000c;
				end
				else if(except_i[12] == 1'b1) begin
					except_o <= 32'h0000000e;
				end
			end
		end
	end


	
	always @(*) begin
		if(!rst) begin
			cur_inst_addr_o<=0;
			in_delayslot_o<=0;
 	  		waddr_o <= 0;
	    	wena_o  <= 0;
	    	wdata_o <= 0;
			hi_o    <= 0;
			lo_o    <= 0;
			hilo_ena_o <= 0;
			LL_ena_o 	<=1'b0;
			LL_data_o  	<=1'b0;
			cp0_ena_o	<=0;
			cp0_addr_o 	<=5'b0;
			cp0_data_o	<=0;

	  	end 
		else begin
			cur_inst_addr_o <=cur_inst_addr;
			in_delayslot_o <=in_delayslot_i;
	    	waddr_o  <= waddr_i;
	    	wena_o   <= wena_i;
	    	wdata_o  <= wdata_i;
			hi_o     <= hi_i;
			lo_o     <= lo_i;
			hilo_ena_o <= hilo_ena_i;
			LL_ena_o 	<=1'b0;
			LL_data_o  	<=1'b0;
			cp0_ena_o	<=cp0_ena_i;
			cp0_addr_o 	<=cp0_addr_i;
			cp0_data_o	<=cp0_data_i;

			case(alig_op_i)
				`EXE_LB_OP:begin
					case(alig_sel_i)
						4'b1000:begin
							wdata_o		<={{24{alig_data_i[31]}},alig_data_i[31:24]};
						end
						4'b0100:begin
							wdata_o		<={{24{alig_data_i[23]}},alig_data_i[23:16]};
						end
						4'b0010:begin
							wdata_o		<={{24{alig_data_i[15]}},alig_data_i[15:8]};
						end
						4'b0001:begin
							wdata_o		<={{24{alig_data_i[7]}},alig_data_i[7:0]};
						end
						default:begin
							wdata_o		<=0;
						end
					endcase
				end
				`EXE_LBU_OP:begin
					case(alig_sel_i)
						4'b00:begin
							wdata_o		<={{24{1'b0}},alig_data_i[31:24]};
						end
						4'b01:begin
							wdata_o		<={{24{1'b0}},alig_data_i[23:16]};
						end
						4'b10:begin
							wdata_o		<={{24{1'b0}},alig_data_i[15:8]};
						end
						4'b11:begin
							wdata_o		<={{24{1'b0}},alig_data_i[7:0]};
						end
						default:begin
							wdata_o		<=0;
						end
					endcase
				end
				`EXE_LH_OP:begin
					case(alig_sel_i)
						4'b1100:begin
               						wdata_o   <= {{16{alig_data_i[31]}},alig_data_i[31:16]};
						end

						4'b0011:begin
            						wdata_o   <= {{16{alig_data_i[15]}},alig_data_i[15:0]};
						end
						default:begin
							wdata_o		<=0;
						end
					endcase
				end
				`EXE_LHU_OP:begin
					case(alig_sel_i)
						4'b1100:begin
              				 		wdata_o   <= {{16{1'b0}},alig_data_i[31:16]};
     						end
						4'b0011:begin
           				 		wdata_o   <= {{16{1'b0}},alig_data_i[15:0]};
						end
						default:begin
							wdata_o	  <=0;
						end
					endcase
				end
				`EXE_LW_OP:begin
					wdata_o		<=alig_data_i;	
				end
				`EXE_LWL_OP:begin	
					case(alig_sel_i)
						2'b00:begin
							wdata_o 	<= alig_data_i[31:0];
						end
						2'b01:begin
							wdata_o		<={alig_data_i[23:0], reg_i[7:0]};
						end
						2'b10:begin
							wdata_o		<={alig_data_i[15:0],reg_i[15:0]};
						end
						2'b11:begin
							wdata_o		<={alig_data_i[7:0],reg_i[23:0]};
						end
						default:begin
							wdata_o		<=0;
						end
					endcase
				end
				`EXE_LWR_OP:begin
					case(alig_sel_i)
						2'b00:begin
               					wdata_o <= {reg_i[31:8],alig_data_i[31:24]};
						end
						2'b01:begin
            						 wdata_o <= {reg_i[31:16],alig_data_i[31:16]};
						end
						2'b10:begin
            						 wdata_o <= {reg_i[31:24],alig_data_i[31:8]};
						end
						2'b11:begin
            						 wdata_o <= alig_data_i;
						end
						default:begin
            						 wdata_o <= 0;
						end
					endcase
				end
				default:begin
				end
			endcase
		end
	end
endmodule

