

module id(
input 			rst, 
input[31:0]   		pc_i,
input[31:0]   		inst_i,

input[31:0]		except_i,

input[31:0]   		reg1_data_i,
input[31:0]   		reg2_data_i,

input			ena_fore_i,
input			in_delayslot_i,
input[7:0]		mem_op_i,
input			mem_data_valid_i,

input[31:0]		mem_wdata_i,
input[4:0]		mem_waddr_i,
input 			mem_wena_i,


input[31:0]		alig_wdata_i,
input[4:0]		alig_waddr_i,
input 			alig_wena_i,

input[31:0]		wb_wdata_i,
input[4:0]		wb_waddr_i,
input 			wb_wena_i,



output reg 		next_in_delayslot_o,

output reg		valid_branch_o,
output reg[31:0]	addr_branch_o,
output reg			suc_branch_o,

output reg[31:0]	return_addr_o,
output reg		in_delayslot_o,


output reg 		reg1_ena_o,
output reg[4:0]		reg1_addr_o,
output reg 		reg2_ena_o,
output reg[4:0]		reg2_addr_o,

output reg[2:0]		ex_type_o,
output reg[7:0]		ex_op_o,

output[31:0]		reg1_o,
output[31:0]		reg2_o,
output reg[4:0]		waddr_o,
output reg		wena_o,

output[31:0]		inst_o,

output[31:0]		except_o,
output[31:0]		cur_inst_addr_o,

output reg[2:0] k,


output 		stallreq



);

wire[5:0] op1  = inst_i[31:26];
wire[5:0] op2  = inst_i[5:0];
wire[4:0] op3  = inst_i[20:16];
wire[4:0] op4  = inst_i[10:6];


reg[31:0] reg1_temp_o;
reg[31:0] reg2_temp_o;
reg[31:0] imm;
reg ins_valid;

reg stallreq_for_reg1_loadrelate;
reg stallreq_for_reg2_loadrelate;

reg except_is_syscall;
reg except_is_eret;

wire pre_inst_is_load; 

wire[31:0] pc_plus_4;
wire[31:0] pc_plus_8;

wire[31:0] imm_signedext;


	assign reg1_o = reg1_temp_o;
	assign reg2_o = reg2_temp_o;
	assign except_o = {18'b0,except_i[0],except_is_eret,2'b0,ins_valid,except_is_syscall,8'b0};
	assign cur_inst_addr_o = pc_i;
		

	assign pc_plus_4 	  = pc_i + 4;
	assign pc_plus_8 	  = pc_i + 8;
	assign imm_signedext = {{14{inst_i[15]}},inst_i[15:0],2'b00};
	assign inst_o 		  = inst_i;
	assign stallreq 	  = stallreq_for_reg1_loadrelate | stallreq_for_reg2_loadrelate;

	assign pre_inst_is_load = ((mem_op_i == `EXE_LB_OP)||
				   (mem_op_i == `EXE_LBU_OP)||
				   (mem_op_i == `EXE_LH_OP)||
				   (mem_op_i == `EXE_LHU_OP)||
				   (mem_op_i == `EXE_LW_OP)||
				   (mem_op_i == `EXE_LWR_OP)||
				   (mem_op_i == `EXE_LWL_OP)||
				   (mem_op_i == `EXE_LL_OP)||
				   (mem_op_i == `EXE_SC_OP))? 1'b1 : 1'b0;


	always @(*)begin
		if(!rst) begin
			stallreq_for_reg1_loadrelate <= 0;
		end
		else if(pre_inst_is_load == 1'b1 && mem_data_valid_i == 1'b1 && 
			mem_waddr_i == reg1_addr_o && reg1_ena_o == 1'b1)  begin
			stallreq_for_reg1_loadrelate <= `True;
		end
		else begin
			stallreq_for_reg1_loadrelate	<= `False;
		end
	end

	
	always @(*)begin
		if(!rst) begin
			stallreq_for_reg2_loadrelate <= 0;
		end
		else if(pre_inst_is_load == 1'b1 && mem_data_valid_i == 1'b1 && 
				mem_waddr_i == reg2_addr_o && reg2_ena_o == 1'b1)begin
			
			stallreq_for_reg2_loadrelate <= `True;
		end
		else begin
			stallreq_for_reg2_loadrelate	<= `False;
		end
	end


	always@(*) begin
		if(rst ==0) begin
			ex_op_o     <= `EXE_NOP_OP;
			ex_type_o   <= `EXE_TYPE_NOP;
			waddr_o     <= 0;
			wena_o	    <= `Disable_write;
			ins_valid  <= `invalid_ins;
			reg1_ena_o <= `Disable_read;
			reg2_ena_o <= `Disable_read;
			reg1_addr_o <= 0;
			reg2_addr_o <= 0;
			imm	    <= 0;
			return_addr_o 	<= 0;
			addr_branch_o 	<= 0;
			valid_branch_o  <= `NoBranch;
			suc_branch_o	<= 0;
			next_in_delayslot_o <= `NotInDelaySlot;
			except_is_syscall	 <=`False;
			except_is_eret	 	 <=`False;
			k <= 1;

			
		end
		else if(inst_i == 0) begin
			ex_op_o     <= `EXE_NOP_OP;
			ex_type_o   <= `EXE_TYPE_NOP;
			waddr_o     <= 0;
			wena_o	    <= `Disable_write;
			ins_valid  <= `invalid_ins;
			reg1_ena_o <= `Disable_read;
			reg2_ena_o <= `Disable_read;
			reg1_addr_o <= 0;
			reg2_addr_o <= 0;
			imm	    <= 0;
			return_addr_o 	<= 0;
			addr_branch_o 	<= 0;
			valid_branch_o  <= `NoBranch;
			suc_branch_o	<= 0;
			next_in_delayslot_o <= `NotInDelaySlot;
			except_is_syscall	 <=`False;
			except_is_eret	 	 <=`False;
				k <= 2;

		
		
		end
		else if(inst_i == `EXE_ERET)begin
					wena_o      <= `Disable_write;
					ex_op_o     <= `EXE_ERET_OP;
					ex_type_o   <= `EXE_TYPE_NOP;
					reg1_ena_o <= `Disable_read;
					reg2_ena_o <= `Disable_read;
					except_is_eret <= `True;
					ins_valid   <= `valid_ins;
				
		end
		else if(inst_i[31:21] == 11'b010_0000_0000 )begin
			ex_op_o     <= `EXE_MFC0_OP;
			ex_type_o   <= `EXE_TYPE_NOP;
			waddr_o     <= inst_i[20:16];
			wena_o	    <= `Enable_write;
			ins_valid   <= `valid_ins;
			reg1_ena_o <= `Disable_read;
			reg2_ena_o <= `Disable_read;	
		end
		else if(inst_i[31:21] == 11'b010_0000_0100 ) begin
			ex_op_o    <= `EXE_MTC0_OP;
			ex_type_o    <= `EXE_TYPE_NOP;
			reg1_addr_o <= inst_i[20:16];
			wena_o	    <= `Disable_write;
			ins_valid   <= `valid_ins;
			reg1_ena_o <= `Enable_read;
			reg2_ena_o <= `Disable_read;	
		end
		else begin	
			ex_op_o	       <= `EXE_NOP_OP;
			ex_type_o      <= `EXE_TYPE_NOP;
			ins_valid      <= `invalid_ins;
			waddr_o        <= inst_i[15:11];
			wena_o	       <= `Disable_write;
			reg1_addr_o    <= inst_i[25:21];
			reg2_addr_o    <= inst_i[20:16];
			reg1_ena_o     <= 0;
			reg2_ena_o     <= 0;
			return_addr_o  <= 0;
      	addr_branch_o  <= 0;
      	valid_branch_o <= `NoBranch;	
      	next_in_delayslot_o <= `NotInDelaySlot;


			case(op1)
				`EXE_LL:begin
					wena_o		<=`Enable_write;
					ex_op_o		<=`EXE_LL_OP;
					ex_type_o	<=`EXE_TYPE_LOAD_STORE;
					reg1_ena_o	<=`Enable_read;
					reg2_ena_o	<=`Disable_read;
					waddr_o		<=inst_i[20:16];
					ins_valid	<=`valid_ins;
				end
				`EXE_SC:begin
					wena_o		<=`Enable_write;
					ex_op_o		<=`EXE_SC_OP;
					ex_type_o	<=`EXE_TYPE_LOAD_STORE;
					reg1_ena_o	<=`Enable_read;
					reg2_ena_o	<=`Enable_read;
					waddr_o		<=inst_i[20:16];
					ins_valid	<=`valid_ins;

				end
				`EXE_ORI:  begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_ORI_OP;
					ex_type_o   <= `EXE_TYPE_LOGIC;
					reg1_ena_o  <= `Enable_read;
					reg2_ena_o  <= `Disable_read;
					imm	    <= {16'h0,inst_i[15:0]};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_ANDI: begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_ANDI_OP;
					ex_type_o   <= `EXE_TYPE_LOGIC;
					reg1_ena_o  <= `Enable_read;
					reg2_ena_o  <= `Disable_read;
					imm	    <= {16'h0,inst_i[15:0]};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;	
				end
				`EXE_XORI: begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_XOR_OP;
					ex_type_o   <= `EXE_TYPE_LOGIC;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					imm	    <= {16'h0,inst_i[15:0]};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;		
				end
				`EXE_LUI:  begin
					wena_o      <= `Enable_write;
					ex_op_o    <= `EXE_LUI_OP;
					ex_type_o   <= `EXE_TYPE_LOGIC;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					imm	    <= {inst_i[15:0],16'h0};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				/*`EXE_PREF:begin							//?????
					wena_o      <= `Disable_write;
					aluop1      <= `EXE_NOP_OP;
					ex_type_o    <= `EXE_TYPE_LOGIC;
					reg1_ena_o <= `Disable_read;
					reg2_ena_o <= `Disable_read;
					imm	    <= `word_zero;
					wd_o	    <= inst_i[15:11];
					ins_valid   <= `valid_ins;
				end*/
				`EXE_SLTI:begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_SLTI_OP;
					ex_type_o   <= `EXE_TYPE_ARITHMETIC;
					reg1_ena_o  <= `Enable_read;
					reg2_ena_o  <= `Disable_read;
					imm	    <= {{16{inst_i[15]}},inst_i[15:0]};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_SLTIU:begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_SLTIU_OP;
					ex_type_o   <= `EXE_TYPE_ARITHMETIC;
					reg1_ena_o  <= `Enable_read;
					reg2_ena_o  <= `Disable_read;
					imm	    <= {{16{inst_i[15]}},inst_i[15:0]};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_ADDI:begin

					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_ADDI_OP;
					ex_type_o   <= `EXE_TYPE_ARITHMETIC;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					imm	    <= {{16{inst_i[15]}},inst_i[15:0]};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_ADDIU:begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_ADDI_OP;
					ex_type_o   <= `EXE_TYPE_ARITHMETIC;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					imm	    <= {{16{inst_i[15]}},inst_i[15:0]};
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_J:begin
					 wena_o      <= `Disable_write;
                			 ex_op_o     <= `EXE_J_OP;
              				 ex_type_o   <= `EXE_TYPE_JUMP_BRANCH;
             				 reg1_ena_o  <= `Disable_read;
              				 reg2_ena_o  <= `Disable_read;										 		 		 imm 	     <= 0;
					 waddr_o     <=  inst_i[15:11];
					 return_addr_o  <= 0;
					 addr_branch_o 	<= {pc_plus_4[31:28],inst_i[25:0],2'b00};
					 valid_branch_o <= `Branch;
					 suc_branch_o   <=`Suc_Branch;
				   	 ins_valid   	<= `valid_ins;
						if(ena_fore_i)		
						     next_in_delayslot_o       <= `NotInDelaySlot;	
						else					 	         		 	 							     next_in_delayslot_o       <= `InDelaySlot;

				end
				
				`EXE_JAL:begin
					 wena_o       <= `Enable_write;
                			 ex_op_o      <= `EXE_JAL_OP;
              				 ex_type_o    <= `EXE_TYPE_JUMP_BRANCH;
             				 reg1_ena_o   <= `Disable_read;
              				 reg2_ena_o   <= `Disable_read;										 		 		 imm 	      <= 0;
					 waddr_o 	<=  5'b11111;
					 return_addr_o  <= pc_plus_8;
					 addr_branch_o 	<= {pc_plus_4[31:28],inst_i[25:0],2'b00};
					 valid_branch_o <= `Branch;
					 suc_branch_o   <=`Suc_Branch;
				   	 ins_valid   	<= `valid_ins;
						if(ena_fore_i)		
						     next_in_delayslot_o       <= `NotInDelaySlot;	
						else					 	         		 	 							     next_in_delayslot_o       <= `InDelaySlot;
				end
			
				`EXE_BEQ:begin
					 wena_o      <= `Disable_write;
                			 ex_op_o     <= `EXE_BEQ_OP;
              				 ex_type_o   <= `EXE_TYPE_JUMP_BRANCH;
             				 reg1_ena_o  <= `Enable_read;
              				 reg2_ena_o  <= `Enable_read;									
			   	 	 ins_valid   	<= `valid_ins;
					 if(reg1_temp_o == reg2_temp_o) begin
						 addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=`Suc_Branch;
						 if(ena_fore_i)		
						     next_in_delayslot_o       <= `NotInDelaySlot;	
						 else					 	         		 	 							     next_in_delayslot_o       <= `InDelaySlot;
					 end
					 else begin
					 	 addr_branch_o 	<= pc_plus_4;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=0;				 	         		 	 					 next_in_delayslot_o       <= `NotInDelaySlot;
						
					 end
	
				end
		
				`EXE_BGTZ:begin
 					 wena_o      <= `Disable_write;
                			 ex_op_o     <= `EXE_BGTZ_OP;
              				 ex_type_o    <= `EXE_TYPE_JUMP_BRANCH;
             				 reg1_ena_o <= `Enable_read;
              				 reg2_ena_o <= `Disable_read;
		   	 		 ins_valid  <= `valid_ins;							
				 	 if((reg1_temp_o[31] == 1'b0) && (reg1_temp_o != 0)) begin
						 addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=`Suc_Branch;
						 if(ena_fore_i)		
						     next_in_delayslot_o       <= `NotInDelaySlot;	
						 else					 	         		 	 							     next_in_delayslot_o       <= `InDelaySlot;
					 end
					 else begin
					 	 addr_branch_o 	<= pc_plus_4;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=0;				 	         		 	 					 next_in_delayslot_o       <= `NotInDelaySlot;
						
					 end
		
				end

				`EXE_BLEZ:begin
 					 wena_o      <= `Disable_write;
                			 ex_op_o     <= `EXE_BEQ_OP;
              				 ex_type_o   <= `EXE_TYPE_JUMP_BRANCH;
             				 reg1_ena_o <= `Enable_read;
              				 reg2_ena_o <= `Disable_read;									
				   	 ins_valid  <= `valid_ins;
		 			 if((reg1_temp_o[31] == 1'b1) && (reg1_temp_o != 0)) begin
						 addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=`Suc_Branch;
						 if(ena_fore_i)		
						     next_in_delayslot_o       <= `NotInDelaySlot;	
						 else					 	         		 	 							     next_in_delayslot_o       <= `InDelaySlot;
					 end
					 else begin
					 	 addr_branch_o 	<= pc_plus_4;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=0;				 	         		 	 					 next_in_delayslot_o       <= `NotInDelaySlot;
						
					 end
				end

				`EXE_BNE:begin
 					 wena_o      <= `Disable_write;
                			 ex_op_o     <= `EXE_BEQ_OP;
              				 ex_type_o  <= `EXE_TYPE_JUMP_BRANCH;
             				 reg1_ena_o <= `Enable_read;
              				 reg2_ena_o <= `Enable_read;
		   	 		 ins_valid  <= `valid_ins;									
		 			 if(reg1_temp_o != reg2_temp_o) begin
						 addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=`Suc_Branch;
						 if(ena_fore_i)		
						     next_in_delayslot_o       <= `NotInDelaySlot;	
						 else					 	         		 	 							     next_in_delayslot_o       <= `InDelaySlot;
					 end
					 else begin
					 	 addr_branch_o 	<= pc_plus_4;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=0;				 	         		 	 					 next_in_delayslot_o       <= `NotInDelaySlot;
						
					 end
				end

				`EXE_LB:begin
					wena_o      <= `Enable_write;
					ex_op_o       <= `EXE_LB_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;	
				end
				`EXE_LBU:begin	
					wena_o      <= `Enable_write;
					ex_op_o       <= `EXE_LBU_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_LH:begin
					wena_o      <= `Enable_write;
					ex_op_o       <= `EXE_LH_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_LHU:begin
					wena_o      <= `Enable_write;
					ex_op_o       <= `EXE_LHU_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Disable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_LW:begin
					wena_o      <= `Enable_write;
					ex_op_o      <= `EXE_LW_OP;
					ex_type_o    <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o  <= `Enable_read;
					reg2_ena_o  <= `Disable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_LWL:begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_LWL_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Enable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_LWR:begin
					wena_o      <= `Enable_write;
					ex_op_o     <= `EXE_LWR_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Enable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_SB:begin
					wena_o      <= `Disable_write;
					ex_op_o     <= `EXE_SB_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Enable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_SH:begin
					wena_o      <= `Disable_write;
					ex_op_o     <= `EXE_SH_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Enable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_SW:begin
					wena_o      <= `Disable_write;
					ex_op_o     <= `EXE_SW_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Enable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_SWL:begin
					wena_o      <= `Disable_write;
					ex_op_o     <= `EXE_SWL_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Enable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end
				`EXE_SWR:begin
					wena_o      <= `Disable_write;
					ex_op_o     <= `EXE_SWR_OP;
					ex_type_o   <= `EXE_TYPE_LOAD_STORE;
					reg1_ena_o <= `Enable_read;
					reg2_ena_o <= `Enable_read;
					waddr_o	    <= inst_i[20:16];
					ins_valid   <= `valid_ins;
				end


				`EXE_REGIMM_INST:begin
					case(op3)
						`EXE_TEQI:begin
							wena_o      <= `Disable_write;
							ex_op_o   <= `EXE_TEQI_OP;
							ex_type_o   <= `EXE_TYPE_NOP;
							reg1_ena_o  <= `Enable_read;
							reg2_ena_o  <= `Disable_read;
							imm         <= {{16{inst_i[15]}},inst_i[15:0]};
							waddr_o     <=  inst_i[15:11];
							ins_valid   <= `valid_ins;
						end
						`EXE_TGEI:begin
							wena_o      <= `Disable_write;
							ex_op_o   <= `EXE_TGEI_OP;
							ex_type_o   <= `EXE_TYPE_NOP;
							reg1_ena_o  <= `Enable_read;
							reg2_ena_o  <= `Disable_read;
							imm         <= {{16{inst_i[15]}},inst_i[15:0]};
							waddr_o     <=  inst_i[15:11];
							ins_valid   <= `valid_ins;
						end
						`EXE_TGEIU:begin
							wena_o      <= `Disable_write;
							ex_op_o   <= `EXE_TGEIU_OP;
							ex_type_o   <= `EXE_TYPE_NOP;
							reg1_ena_o  <= `Enable_read;
							reg2_ena_o  <= `Disable_read;
							imm    	    <= {{16{inst_i[15]}},inst_i[15:0]};
							waddr_o	    <=  inst_i[15:11];
							ins_valid   <= `valid_ins;
						end
						`EXE_TLTI:begin
							wena_o      <= `Disable_write;
							ex_op_o   <= `EXE_TLTI_OP;
							ex_type_o   <= `EXE_TYPE_NOP;
							reg1_ena_o  <= `Enable_read;
							reg2_ena_o  <= `Disable_read;
							imm         <= {{16{inst_i[15]}},inst_i[15:0]};
							waddr_o     <=  inst_i[15:11];
							ins_valid   <= `valid_ins;
						end
						`EXE_TLTIU:begin
							wena_o      <= `Disable_write;
							ex_op_o   <= `EXE_TLTIU_OP;
							ex_type_o   <= `EXE_TYPE_NOP;
							reg1_ena_o <= `Enable_read;
							reg2_ena_o <= `Disable_read;
							imm         <= {{16{inst_i[15]}},inst_i[15:0]};
							waddr_o     <=  inst_i[15:11];
							ins_valid   <= `valid_ins;
						end
						`EXE_TNEI:begin
							wena_o      <= `Disable_write;
							ex_op_o   <= `EXE_TNEI_OP;
							ex_type_o   <= `EXE_TYPE_NOP;
							reg1_ena_o <= `Enable_read;
							reg2_ena_o <= `Disable_read;
							imm         <= {{16{inst_i[15]}},inst_i[15:0]};
							waddr_o     <=  inst_i[15:11];
							ins_valid   <= `valid_ins;
						end
			
						`EXE_BGEZ:begin
 					 		wena_o     <= `Disable_write;
                			 		ex_op_o  <= `EXE_BGEZ_OP;
              				 		ex_type_o  <= `EXE_TYPE_JUMP_BRANCH;
             				 		reg1_ena_o <= `Enable_read;
              				 		reg2_ena_o <= `Disable_read;							
				   	 		ins_valid   <= `valid_ins;
		 					if(reg1_temp_o[31]== 1'b0) begin
						 		addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=`Suc_Branch;
						 		if(ena_fore_i)		
						    			next_in_delayslot_o       <= `NotInDelaySlot;	
						 		else					 	         		 	 							     	next_in_delayslot_o       <= `InDelaySlot;
					 		end
					 		else begin
					 	 		addr_branch_o 	<= pc_plus_4;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=0;				 	         		 	 					next_in_delayslot_o       <= `NotInDelaySlot;
						
					 		end
						end

						`EXE_BGEZAL:begin
 					 		wena_o       <= `Enable_write;
                			 		ex_op_o    <= `EXE_BGEZAL_OP;
              				 		ex_type_o    <= `EXE_TYPE_JUMP_BRANCH;
             				 		reg1_ena_o <= `Enable_read;
              				 		reg2_ena_o <= `Disable_read;			
						 	waddr_o        <=  5'b11111;
					 		return_addr_o  <= pc_plus_8;
				   	 		ins_valid   <= `valid_ins;
		 					if(reg1_temp_o[31]== 1'b0) begin
						 		addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=`Suc_Branch;
						 		if(ena_fore_i)		
						    			next_in_delayslot_o       <= `NotInDelaySlot;	
						 		else					 	         		 	 							     	next_in_delayslot_o       <= `InDelaySlot;
					 		end
					 		else begin
					 	 		addr_branch_o 	<= pc_plus_4;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=0;				 	         		 	 					next_in_delayslot_o       <= `NotInDelaySlot;
						
					 		end
						end
						`EXE_BLTZ:begin
 					 		wena_o      <= `Disable_write;
                			 		ex_op_o    <= `EXE_BLTZ_OP;
              				 		ex_type_o    <= `EXE_TYPE_JUMP_BRANCH;
             				 		reg1_ena_o <= `Enable_read;
              				 		reg2_ena_o <= `Disable_read;
				   	 		ins_valid   <= `valid_ins;
		 					if(reg1_temp_o[31]== 1'b1) begin
						 		addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=`Suc_Branch;
						 		if(ena_fore_i)		
						    			next_in_delayslot_o       <= `NotInDelaySlot;	
						 		else
								next_in_delayslot_o       <= `InDelaySlot;
					 		end
					 		else begin
					 	 		addr_branch_o 	<= pc_plus_4;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=0;				 	         		 	 					next_in_delayslot_o       <= `NotInDelaySlot;
						
					 		end
						end

						`EXE_BLTZAL:begin 
 					 		wena_o      <= `Enable_write;
                			 		ex_op_o   <= `EXE_BLTZAL_OP;
              				 		ex_type_o   <= `EXE_TYPE_JUMP_BRANCH;
             				 		reg1_ena_o <= `Enable_read;
              				 		reg2_ena_o <= `Disable_read;							
						 	waddr_o    <=  5'b11111;
					 		return_addr_o <= pc_plus_8;
				   	 		ins_valid   <= `valid_ins;
		 					if(reg1_temp_o[31]== 1'b0) begin
						 		addr_branch_o 	<= pc_plus_4 + imm_signedext;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=`Suc_Branch;
						 		if(ena_fore_i)		
						    			next_in_delayslot_o       <= `NotInDelaySlot;	
						 		else					 	         		 	 							     	next_in_delayslot_o       <= `InDelaySlot;
					 		end
					 		else begin
					 	 		addr_branch_o 	<= pc_plus_4;
					 	 		valid_branch_o <= `Branch;											 			suc_branch_o   <=0;				 	         		 	 					next_in_delayslot_o       <= `NotInDelaySlot;
						
					 		end
						
						end
					endcase
				end

				`EXE_SPECIAL2_INST:begin
					case(op2)
				  	 `EXE_CLZ:begin
						wena_o      <= `Enable_write;
						ex_op_o     <= `EXE_CLZ_OP;
						ex_type_o   <= `EXE_TYPE_ARITHMETIC ;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Disable_read;
						ins_valid   <= `valid_ins;
					   end
					  `EXE_CLO:begin
						wena_o      <= `Enable_write;
						ex_op_o     <= `EXE_CLO;
						ex_type_o   <= `EXE_TYPE_ARITHMETIC ;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Disable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_MUL:begin
						wena_o      <= `Enable_write;
						ex_op_o     <= `EXE_MUL_OP;
						ex_type_o   <= `EXE_TYPE_MUL ;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_MADD:begin
					  k<=5;
						wena_o      <= `Disable_write;
						ex_op_o     <= `EXE_MADD_OP;
						ex_type_o   <= `EXE_TYPE_MUL;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_MADDU:begin
						wena_o      <= `Disable_write;
						ex_op_o     <= `EXE_MADDU;
						ex_type_o   <= `EXE_TYPE_MUL;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end	
					  `EXE_MSUB:begin
						wena_o      <= `Disable_write;
						ex_op_o     <= `EXE_MSUB_OP;
						ex_type_o   <= `EXE_TYPE_MUL;
						reg1_ena_o <= `Enable_read;
						reg2_ena_o <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_MSUBU:begin
						wena_o      <= `Disable_write;
						ex_op_o     <= `EXE_MSUBU_OP;
						ex_type_o   <= `EXE_TYPE_MUL;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  default:begin
					  end
					endcase
				end

				`EXE_SPECIAL_INST: begin
	
					  case(op2)
					  `EXE_TEQ:begin
						wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_SYSCALL_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Disable_read;
						reg2_ena_o  <= `Disable_read;
						ins_valid   <= `valid_ins;
					   end
					  `EXE_TGE:begin
						wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_TGE_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_TGEU:begin
						wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_TGEU_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					   end
					  `EXE_TLT:begin
						wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_TLT_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_TLTU:begin
						wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_TLTU_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					   end
					  `EXE_TNE:begin
						wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_TNE_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					   end
					  `EXE_SYSCALL:begin
						wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_SYSCALL_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Disable_read;
						reg2_ena_o  <= `Disable_read;
						except_is_syscall <= `True;
						ins_valid   <= `valid_ins;
					   end
					  `EXE_OR: begin
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_OR_OP;
						ex_type_o   <= `EXE_TYPE_LOGIC;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Disable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_AND:begin
				
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_AND_OP;
						ex_type_o   <= `EXE_TYPE_LOGIC;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_XOR:begin
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_XOR_OP;
						ex_type_o   <= `EXE_TYPE_LOGIC;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_NOR:begin
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_NOR_OP;
						ex_type_o   <= `EXE_TYPE_LOGIC;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					 `EXE_SLL:begin

						wena_o      <= `Enable_write;
						ex_op_o     <= `EXE_SLL_OP;
						ex_type_o   <= `EXE_TYPE_SHIFT;
						reg1_ena_o  <= `Disable_write;
						reg2_ena_o  <= `Enable_read;
						imm[4:0]    <= inst_i[10:6];
						ins_valid   <= `valid_ins;
					 end
					 `EXE_SRL:begin
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_SRL_OP;
						ex_type_o   <= `EXE_TYPE_SHIFT;
						reg1_ena_o  <= `Disable_write;
						reg2_ena_o  <= `Enable_read;
						imm[4:0]    <= inst_i[10:6];
						ins_valid   <= `valid_ins;		
					 end
					 `EXE_SRA:begin
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_SRA_OP;
						ex_type_o   <= `EXE_TYPE_SHIFT;
						reg1_ena_o  <= `Disable_write;
						reg2_ena_o  <= `Enable_read;
						imm[4:0]    <= inst_i[10:6];
						ins_valid   <= `valid_ins;
					 end
				  	  `EXE_SLLV:begin
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_SLLV_OP;
						ex_type_o   <= `EXE_TYPE_SHIFT;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_SRLV:begin
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_SRLV_OP;
						ex_type_o   <= `EXE_TYPE_SHIFT;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_SRAV:begin																
					   wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_SRAV_OP;
						ex_type_o   <= `EXE_TYPE_SHIFT;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_SYNC:begin			//?????
						wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_NOP_OP;
						ex_type_o   <= `EXE_TYPE_NOP;
						reg1_ena_o  <= `Disable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_MFHI:begin
					  	wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_MFHI_OP;
						ex_type_o   <= `EXE_TYPE_MOVE;
						reg1_ena_o  <= `Disable_read;
						reg2_ena_o  <= `Disable_read;
						ins_valid   <= `valid_ins;							
					  end
					  `EXE_MFLO:begin
					  	wena_o      <= `Enable_write;
						ex_op_o   <= `EXE_MFLO;
						ex_type_o   <= `EXE_TYPE_MOVE;
						reg1_ena_o  <= `Disable_read;
						reg2_ena_o  <= `Disable_read;
						ins_valid   <= `valid_ins;							
				  	  end
					  `EXE_MTHI:begin
					  	wena_o      <= `Disable_write;
						ex_op_o     <= `EXE_MTHI_OP;
						ex_type_o    <= `EXE_TYPE_MOVE;
						reg1_ena_o <= `Enable_read;
						reg2_ena_o <= `Disable_read;
						ins_valid   <= `valid_ins;							
					  end
					  `EXE_MTLO:begin
					  	wena_o      <= `Disable_write;
						ex_op_o   <= `EXE_MTLO_OP;
						ex_type_o   <= `EXE_TYPE_MOVE;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Disable_read;
						ins_valid   <= `valid_ins;							
					  end
					  `EXE_MOVN:begin
						if(reg2_temp_o != 0)begin
							wena_o <= `Enable_write;
						end
						else begin
					  		wena_o <= `Disable_write;
						end
						ex_op_o   <= `EXE_MOVN_OP;
						ex_type_o   <= `EXE_TYPE_MOVE;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;							
					  end
					  `EXE_MOVZ:begin
						if(reg2_temp_o != 0)begin
							wena_o <= `Enable_write;
						end
						else begin
					  		wena_o <= `Disable_write;
						end
						ex_op_o   <= `EXE_MOVZ_OP;
						ex_type_o   <= `EXE_TYPE_MOVE;
						reg1_ena_o  <= `Enable_read;
						reg2_ena_o  <= `Enable_read;
						ins_valid   <= `valid_ins;
					  end
					  `EXE_SLT:begin
             					 wena_o      <= `Enable_write;
             					 ex_op_o   <= `EXE_SLT_OP;
              					 ex_type_o   <= `EXE_TYPE_ARITHMETIC;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;														 
									 ins_valid   <= `valid_ins;

					  end
					  `EXE_SLTU:begin
            					 wena_o      <= `Enable_write;
                			         ex_op_o   <= `EXE_SLTU_OP;
              					 ex_type_o   <= `EXE_TYPE_ARITHMETIC;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;								
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_ADD:begin
		
            					 wena_o      <= `Enable_write;
                			    ex_op_o   	 <= `EXE_ADD_OP;
              					 ex_type_o   <= `EXE_TYPE_ARITHMETIC;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;								
									 ins_valid   <= `valid_ins;
					  end
					  `EXE_ADDU:begin
            					 wena_o      <= `Enable_write;
                			         ex_op_o   <= `EXE_ADDU_OP;
              					 ex_type_o   <= `EXE_TYPE_ARITHMETIC;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;								
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_SUB:begin
            					 wena_o      <= `Enable_write;
                			         ex_op_o   <= `EXE_SUB_OP;
              					 ex_type_o   <= `EXE_TYPE_ARITHMETIC;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;								
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_SUBU:begin
            					 wena_o      <= `Enable_write;
                			         ex_op_o   <= `EXE_SUBU_OP;
              					 ex_type_o   <= `EXE_TYPE_ARITHMETIC;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;								
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_MULT:begin
            					 wena_o      <= `Disable_write;
                			         ex_op_o   <= `EXE_MULT_OP;
              					 ex_type_o   <= `EXE_TYPE_MUL;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;								
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_MULTU:begin
            					 wena_o      <= `Disable_write;
                			         ex_op_o   <= `EXE_MULTU_OP;
              					 ex_type_o   <= `EXE_TYPE_MUL;
             					 reg1_ena_o  <= `Enable_read;
              					 reg2_ena_o  <= `Enable_read;	
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_DIV:begin
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_DIVU:begin
						 ins_valid   <= `valid_ins;
					  end
					  `EXE_JR:begin
						 wena_o    <= `Disable_write;
                	ex_op_o      <= `EXE_JR_OP;
              					 ex_type_o      <= `EXE_TYPE_JUMP_BRANCH;
             					 reg1_ena_o     <= `Enable_read;
              					 reg2_ena_o     <= `Disable_read;
						 addr_branch_o 	<= reg1_temp_o;
					 	 valid_branch_o <= `Branch;											 			 
						 suc_branch_o   <=`Suc_Branch;
				 		 ins_valid      <= `valid_ins;
						 	if(ena_fore_i)		
						    next_in_delayslot_o       <= `NotInDelaySlot;	
						 	else					 	   	
							next_in_delayslot_o       <= `InDelaySlot;
					 								
		
					  end
					  `EXE_JALR:begin
 						 wena_o         <= `Enable_write;
                			    ex_op_o      <= `EXE_JALR_OP;
              					 ex_type_o      <= `EXE_TYPE_JUMP_BRANCH;
             					 reg1_ena_o     <= `Enable_read;
              					 reg2_ena_o     <= `Disable_read;							
						 return_addr_o  <= pc_plus_8;
						 addr_branch_o 	<= reg1_temp_o;
					 	 valid_branch_o <= `Branch;											 			 suc_branch_o   <=`Suc_Branch;
				 		 ins_valid      <= `valid_ins;
						 	if(ena_fore_i)		
						    		next_in_delayslot_o       <= `NotInDelaySlot;	
						 	else					 	         		 	 							     	next_in_delayslot_o       <= `InDelaySlot;
					  end
					  default:  begin
					  end
					  endcase //op2
				end

				default:begin
				end
			endcase//ENDCASE
		end//ELSEIF
	end




	always @(*) begin
		if( !rst) begin
			reg1_temp_o <= 0;
		end
		else begin
			if((reg1_ena_o == `Enable_read)&&(mem_wena_i == `Enable_write)&&(mem_waddr_i == reg1_addr_o)) begin
				reg1_temp_o <= mem_wdata_i;
			end
			else if((reg1_ena_o == `Enable_read)&&(alig_wena_i == `Enable_write)&&(alig_waddr_i == reg1_addr_o)) begin
				reg1_temp_o <= alig_wdata_i;
			end
			else if((reg1_ena_o == `Enable_read)&&(wb_wena_i == `Enable_write)&&(wb_waddr_i == reg1_addr_o)) begin
				reg1_temp_o <= wb_wdata_i;
			end
			else if(reg1_ena_o == `Enable_read) begin
				reg1_temp_o <= reg1_data_i;
			end
			else if(reg1_ena_o == `Disable_read) begin
				reg1_temp_o <= imm;
			end
			else begin
				reg1_temp_o <= 0;
			end
		end
	end


	
	
			
	always @(*) begin
		if( !rst) begin
			reg2_temp_o <= 0;
		end
		else begin
			if((reg2_ena_o == `Enable_read)&&(mem_wena_i == `Enable_write)&&(mem_waddr_i == reg2_addr_o)) begin
				reg2_temp_o <= mem_wdata_i;
			end
			else if((reg2_ena_o == `Enable_read)&&(alig_wena_i == `Enable_write)&&(alig_waddr_i == reg2_addr_o)) begin
				reg2_temp_o <= alig_wdata_i;

			end
			else if((reg2_ena_o == `Enable_read)&&(wb_wena_i == `Enable_write)&&(wb_waddr_i == reg2_addr_o)) begin
				reg2_temp_o <= wb_wdata_i;

			end
			else if(reg2_ena_o == `Enable_read) begin
				reg2_temp_o <= reg2_data_i;
			end
			else if(reg2_ena_o == `Disable_read) begin
				reg2_temp_o <= imm;
			end
			else begin
				reg2_temp_o <= 0;
			end
		end
	end




	always@( *)begin
		if(!rst) begin
			in_delayslot_o <= `NotInDelaySlot;
		end
		else if(ena_fore_i == `Disable) begin
			in_delayslot_o <= in_delayslot_i;
		end
		else begin
			in_delayslot_o <= 0;
		end
	end










   

endmodule


 


