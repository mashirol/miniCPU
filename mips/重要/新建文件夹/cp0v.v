
module cp0(

	input	rst,			
	input 	clk,								
	
	
	input                     ena,
	input[4:0]               waddr_i,
	input[4:0]               raddr_i,
	input[31:0]           	  wdata_i,
	
	input[31:0]              except_i,
	input[5:0]               int_i,
	input[31:0]    	  	 cur_inst_addr_i,
	input                    in_delayslot_i,

	
	output reg[31:0]           rdata_o,

	output reg                 timer_int_o,  
	
	output reg[31:0]				count_o,
	output reg[31:0]				compare_o,
	output reg[31:0]           status_o,
	output reg[31:0]           cause_o,
	output reg[31:0]           epc_o,
	output reg[31:0]           config_o

	
  
	
);


	always @ (posedge clk) begin
		if(!rst) begin
			count_o <= 0;		//计数
			compare_o <= 0;		//与conunt判断中断
							
			status_o <= 32'b0001_0_0_0_00_0_0_0_0_000_00000000_000_0_0_0_0_0;        //状态寄存器
			cause_o <= 32'b0_0_00_0_0_00_0_0_000000_000000_00_0_00000_00;		//异常原因
			epc_o <= 0;								//异常返回地址
							
			config_o <= 32'b0_000000000000000_1_00_000_000_000_0_000; 		//处理器配置
		end 
		else begin

		  	cause_o[15:10] <= int_i;
					
			if(ena == 1'b1) begin
				case (waddr_i) 
					`CP0_REG_COUNT:begin
						count_o <= wdata_i;
					end
					`CP0_REG_COMPARE:	begin
						compare_o   <= wdata_i;
						count_o     <= 0;
					end
					`CP0_REG_STATUS:begin
						status_o <= wdata_i;
						count_o <= count_o + 1 ;
					end
					`CP0_REG_EPC:begin
						epc_o    <= wdata_i;
						count_o <= count_o + 1 ;
					end
					`CP0_REG_CAUSE:	begin
						cause_o[9:8] <= wdata_i[9:8];
						cause_o[23]  <= wdata_i[23];
						cause_o[22]  <= wdata_i[22];
						count_o <= count_o + 1 ;
					end					
				endcase 
			end
			else begin
				count_o <= count_o + 1 ;
			end
					
			case(except_i)
				32'h0000_0001:begin
					if(in_delayslot_i == `InDelaySlot) begin
						epc_o		<= cur_inst_addr_i - 4;
						cause_o[31]<=1'b1;
					end
					else begin
						epc_o		<= cur_inst_addr_i;
						cause_o[31]<=1'b0;
					end
					status_o[1]	<= 1'b1;
					cause_o[6:2]	<=5'b0;
				end
				
				32'h0000_0008:begin
					if(status_o[1] == 1'b0)begin
						if(in_delayslot_i == `InDelaySlot) begin
							epc_o		<=cur_inst_addr_i - 4;
							cause_o[31]	<=1'b1;
						end
						else begin
							epc_o		<=cur_inst_addr_i;
							cause_o[31]	<=1'b0;
						end
					end
					status_o[1]	<= 1'b1;
					cause_o[6:2]	<=5'b01000;
				end

				32'h0000_000a:begin
					if(status_o[1] == 1'b0)begin
						if(in_delayslot_i == `InDelaySlot) begin
							epc_o		<=cur_inst_addr_i - 4;
							cause_o[31]	<=1'b1;
						end
						else begin
							epc_o		<=cur_inst_addr_i;
							cause_o[31]	<=1'b0;
						end
					end
					status_o[1]	<= 1'b1;
					cause_o[6:2]	<= 5'b01010;
				end


				32'h0000_000c:begin
					if(status_o[1] == 1'b0)begin
						if(in_delayslot_i == `InDelaySlot) begin
							epc_o		<=cur_inst_addr_i - 4;
							cause_o[31]	<=1'b1;
						end
						else begin
							epc_o		<=cur_inst_addr_i;
							cause_o[31]	<=1'b0;
						end
					end
					status_o[1]	<= 1'b1;
					cause_o[6:2]	<=5'b01100;
				end

				32'h0000_000e:begin
					status_o[1]	<= 1'b0;
				end
			
				default:begin
				end
			endcase
		end
	end



	always @(*) begin
		if(!rst) begin
	      		timer_int_o <= `InterruptNotAssert;
		end
		else if(compare_o != 0 && count_o == compare_o) begin
				timer_int_o <= `InterruptAssert;
			end
		else begin
	      		timer_int_o <= `InterruptNotAssert;
		end
	end




	
	always @(*) begin
		if(!rst) begin
			rdata_o <= 0;
		end 
		else begin
			case (raddr_i) 
				`CP0_REG_COUNT:begin
					rdata_o <= count_o ;
				end
				`CP0_REG_COMPARE:begin
					rdata_o <= compare_o ;
				end
				`CP0_REG_STATUS:begin
					rdata_o <= status_o ;
				end
				`CP0_REG_CAUSE:begin						
					rdata_o <=  cause_o ;
				end
					
				`CP0_REG_EPC:begin
					rdata_o <=  epc_o ;
				end	
		
				`CP0_REG_CONFIG:begin
					rdata_o <= config_o ;
				end	
				default: begin
				end							
			endcase  		
		end    
	end    

	

endmodule