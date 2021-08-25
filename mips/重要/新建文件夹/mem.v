

module mem(
 
	input	rst,


	input[31:0]	except_i,
	input 		in_delayslot_i,
	input[31:0]	cur_inst_addr,
	input[31:0]	last_except_i,	
	input		except_mem_i,

	input[7:0]	mem_op_i,
	input[31:0]	mem_wdata_i,
	input[31:0]	mem_addr_i,
	input[31:0]	mem_rdata_i,
	input		mem_valid_i,

	
	input[4:0]   waddr_i,
	input          wena_i,
	input[31:0]   wdata_i,

	input[31:0]   hi_i,
	input[31:0]   lo_i,
	input         hilo_ena_i,


	input		cp0_ena_i,
	input[4:0]	cp0_addr_i,
	input[31:0]    cp0_data_i,

	input		LL_i,


	input		alig_LL_ena_i,
	input		alig_LL_data_i,
	input		wb_LL_ena_i,
	input		wb_LL_data_i,


	
	output[31:0]	except_o,
	output 			in_delayslot_o,
	output[31:0]	cur_inst_addr_o,
	
	output reg		stall,
	output reg[7:0]		align_op_o,
	output reg[31:0]	reg_o,

	output reg[31:0]    	mem_addr_o,
	output 			mem_ena_o,
	output reg[3:0]		mem_sel_o,
	output reg[31:0]    	mem_data_o,
	output reg		mem_w_r_o,	

	
	output reg[4:0]   	waddr_o,
	output reg              wena_o,
	output reg[31:0]    	wdata_o,

	output reg[31:0]    hi_o,
	output reg[31:0]    lo_o,
	output reg[31:0]    hilo_ena_o,


	output reg		cp0_ena_o,
	output reg[4:0]		cp0_addr_o,
	output reg[31:0]  	cp0_data_o,
	

	output reg		 LL_ena_o,
	output reg		 LL_data_o

);
 


wire[31:0]	zero32;
reg		LLbit;



reg	mem_ena_temp;

assign zero32   = 0; 
assign in_delayslot_o 	= in_delayslot_i;
assign cur_inst_addr_o 	= cur_inst_addr;

assign except_o   	= {except_i[31:16],except_mem_i,except_i[14:0]};	
assign mem_ena_o	= mem_ena_temp & (~(|except_o)) & (~(|last_except_i));


	always @ (*) begin
  		if(!rst) begin
    			LLbit <= 1'b0;
  		end 
		else begin
    			if(alig_LL_ena_i == 1'b1) begin
       				LLbit <= alig_LL_data_i;     
    			end
			else if(wb_LL_ena_i == 1'b1) begin
     				LLbit <= wb_LL_data_i; 
			end 
			else begin
       				LLbit <= LL_i;
    			end
  		end
	end





always @(*) begin
	if(!rst) begin
		stall <= 0;
	end
	else begin
		stall <= 0;
		if(mem_ena_o) begin
			if(!mem_valid_i) begin
				stall <= 1'b1;
			end
			else begin
				stall <= 1'b0;
			end
		end
		else begin
			stall <= 0;
		end
	end



end




	always @ (*) begin
		if(!rst) begin
	  		waddr_o    <= 0;
	    		wena_o  <= 0;
	    		wdata_o <= 0;
			hi_o    <= 0;
			lo_o    <= 0;
			hilo_ena_o <= 0;
      			mem_addr_o <= 0;
     		mem_w_r_o  <= 0;
      			mem_sel_o  <=  4'b0000;
      			mem_data_o <= 0;
      			mem_ena_temp   <= 0;
			LL_ena_o 	<=1'b0;
			LL_data_o  	<=1'b0;
			cp0_ena_o	<=0;
			cp0_addr_o 	<=5'b0;
			cp0_data_o	<=0;
			align_op_o	<=0;
			reg_o		<=0;

	  	end 
		else begin

			align_op_o	<=mem_op_i;
			reg_o		<=mem_wdata_i;
	    		waddr_o  <= waddr_i;
	    		wena_o   <= wena_i;
	    		wdata_o  <= wdata_i;
			hi_o     <= hi_i;
			lo_o     <= lo_i;
			hilo_ena_o <= hilo_ena_i;

      			mem_addr_o <= 0;
     			mem_w_r_o  <= 0;
      			mem_sel_o  <=  4'b0000;
      			mem_data_o <= 0;
      			mem_ena_temp  <= 0;
			LL_ena_o 	<=1'b0;
			LL_data_o  	<=1'b0;
			cp0_ena_o	<=cp0_ena_i;
			cp0_addr_o 	<=cp0_addr_i;
			cp0_data_o	<=cp0_data_i;
			case(mem_op_i)

      				`EXE_LL_OP:begin            
          				mem_addr_o    <= mem_addr_i;
          				mem_w_r_o     <= 0;
        			 	mem_sel_o     <= 4'b1111;
        				mem_ena_temp  <= 1'b1;
          				wdata_o       <= mem_rdata_i;
         				LL_ena_o      <= 1'b1;
        				LL_data_o     <= 1'b1;
 
				end

    				 `EXE_SC_OP:begin              
          				if(LLbit == 1'b1) begin
            					LL_ena_o      <= 1'b1;
           					LL_data_o     <= 1'b0;
            					mem_addr_o    <= mem_addr_i;
            					mem_w_r_o     <= 1'b1;
            					mem_data_o    <= mem_wdata_i;
            					mem_sel_o     <= 4'b1111;
            					mem_ena_temp  <= 1'b1;
           					wdata_o       <= 32'h0000_0001;
         				end 
					else begin
            					wdata_o       <= 32'b0;
		     			end
				end


				`EXE_LB_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 0;
					mem_ena_temp	<= 1;	
					case(mem_addr_i[1:0])
						2'b11:begin
							mem_sel_o	<=4'b1000;
						end
						2'b10:begin
							mem_sel_o	<=4'b0100;
						end
						2'b01:begin
							mem_sel_o	<=4'b0010;
						end
						2'b00:begin
							mem_sel_o	<=4'b0001;
						end
					endcase
				
				end
				`EXE_LBU_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 0;
					mem_ena_temp	<= 1'b1;
					case(mem_addr_i[1:0])
						2'b11:begin
							mem_sel_o	<=4'b1000;
						end
						2'b10:begin
							mem_sel_o	<=4'b0100;
						end
						2'b01:begin
							mem_sel_o	<=4'b0010;
						end
						2'b00:begin
							mem_sel_o	<=4'b0001;
						end
					endcase
				end
				`EXE_LH_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 0;
					mem_ena_temp	<= 1'b1;	
					case(mem_addr_i[1:0])
						2'b10:begin
              						mem_sel_o <= 4'b1100;
						end

						2'b00:begin
              						mem_sel_o <= 4'b0011;
						end

						default:begin
							mem_sel_o <= 4'b0000;
						end
					endcase
				end
				`EXE_LHU_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 0;
					mem_ena_temp	<= 1'b1;	
					case(mem_addr_i[1:0])
						2'b10:begin
               						mem_sel_o <= 4'b1100;
						end
						2'b00:begin
               						mem_sel_o <= 4'b0011;
						end
						default:begin
							mem_sel_o <= 4'b0000;
						end
					endcase
				end
				`EXE_LW_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 0;
					mem_ena_temp	<= 1'b1;
					mem_sel_o	<= 4'b1111;	
	
				end
				`EXE_LWL_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 0;
					mem_ena_temp	<= 1'b1;
					mem_sel_o	<=4'b1111;
				end
				`EXE_LWR_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 0;
					mem_ena_temp	<= 1'b1;
					mem_sel_o	<= 4'b1111;	

				end
				`EXE_SB_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 1'b1;
					mem_ena_temp	<= 1'b1;
					mem_data_o	<={mem_wdata_i[7:0],mem_wdata_i[7:0],mem_wdata_i[7:0],mem_wdata_i[7:0]};	
					case(mem_addr_i[1:0])
						2'b00:begin
							mem_sel_o	<= 4'b0001;
						end
						2'b01:begin
							mem_sel_o 	<= 4'b0010;
						end
						2'b10:begin
							mem_sel_o 	<= 4'b0100;
						end
						2'b11:begin
							mem_sel_o 	<= 4'b1000;
						end
						default:begin
							mem_sel_o 	<= 4'b0000;
						end
					endcase
				end
				`EXE_SH_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 1'b1;
					mem_ena_temp	<= 1'b1;
					mem_data_o	<={mem_wdata_i[15:0],mem_wdata_i[15:0]};	
					case(mem_addr_i[1:0])
						2'b00:begin
							mem_sel_o 	<= 4'b0011;
						end

						2'b10:begin
							mem_sel_o 	<= 4'b1100;
						end

						default:begin
							mem_sel_o 	<= 4'b0000;
						end
					endcase
				end
				`EXE_SW_OP:begin
					mem_addr_o 	<= mem_addr_i;
					mem_w_r_o	<= 1'b1;
					mem_ena_temp	<= 1'b1;
					mem_data_o	<= mem_wdata_i;
					mem_sel_o	<= 4'b1111;	
	
				end
				`EXE_SWL_OP:begin
					mem_addr_o 	<= {mem_addr_i[31:2],2'b00};
					mem_w_r_o	<= 1'b1;
					mem_ena_temp	<= 1'b1;	
					case(mem_addr_i[1:0])
						2'b00:begin
              						mem_sel_o <= 4'b1111;
              						mem_data_o <= mem_wdata_i;
						end
						2'b01:begin
            						mem_sel_o <= 4'b1110;
              						mem_data_o <= {mem_wdata_i[31:8],zero32[7:0]};
						end
						2'b10:begin
            						mem_sel_o <= 4'b1100;
              						mem_data_o <= {mem_wdata_i[31:16],zero32[15:0]};
						end
						2'b11:begin
            						mem_sel_o <= 4'b1000;
               						mem_data_o <= {mem_wdata_i[31:24],zero32[23:0]};
						end
						default:begin
            						mem_sel_o <= 4'b0000;
  
						end
					endcase
				end
				`EXE_SWR_OP:begin
					mem_addr_o 	<= {mem_addr_i[31:2],2'b00};
					mem_w_r_o	<= 1'b1;
					mem_ena_temp	<= 1'b1;	
					case(mem_addr_i[1:0])
						2'b00:begin
                 					mem_sel_o  <= 4'b0001;
                 					mem_data_o <= {zero32[23:0],mem_wdata_i[7:0]};
						end
						2'b01:begin
               						mem_sel_o  <= 4'b0011;
                 					mem_data_o <= {zero32[15:0],mem_wdata_i[15:0]};
						end
						2'b10:begin
               						mem_sel_o  <= 4'b0111;
                 					mem_data_o <= {zero32[7:0],mem_wdata_i[23:0]};
						end
						2'b11:begin
               						mem_sel_o  <= 4'b1111;
                 					mem_data_o <= mem_wdata_i[31:0];
						end
						default:begin
							mem_sel_o	<=4'b0000;
						end
					endcase
				end
				default:begin
				end
			endcase
	  	end    
	end      
 
 
endmodule
