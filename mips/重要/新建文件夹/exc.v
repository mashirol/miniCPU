

module exc(
	input rst,
	
	input[7:0] 	op_i,
	input[2:0]  type_i,
	input[31:0]	reg1_i,
	input[31:0]	reg2_i,
	input[4:0]	waddr_i,
	input 		wena_i,

	input[31:0]	cp0_rdata_i,
	input[63:0]	hilo_temp_i,
	input[1:0]	cnt_i,


	input[31:0]   	hi_i,
	input[31:0]   	lo_i,

	input[63:0]	div_result_i,
	input 		div_final_i,
	
	input[31:0]   	mem_hi_i,
	input[31:0]   	mem_lo_i,
	input	      	mem_whilo_i,

	input[31:0]  	alig_hi_i,
	input[31:0]  	alig_lo_i,
	input	     	alig_whilo_i,

	input[31:0]   	wb_hi_i,
	input[31:0]   	wb_lo_i,
	input	      	wb_whilo_i,


	input		mem_wcp0_i,
	input[4:0]	mem_cp0_addr_i,
	input[31:0]	mem_cp0_data_i,

	input		alig_wcp0_i,
	input[4:0]	alig_cp0_addr_i,
	input[31:0]	alig_cp0_data_i,

	input		wb_wcp0_i,
	input[4:0]	wb_cp0_addr_i,
	input[31:0]	wb_cp0_data_i,


	input 	      	in_delayslot_i,
	input[31:0]   	return_addr_i,

	input[31:0]	inst_i,

	input[31:0]	except_i,
	input[31:0]     cur_inst_addr_i,


	output[31:0]	except_o,
	output 		in_delayslot_o,
	output[31:0]	cur_inst_addr_o,


	output reg[4:0]		cp0_raddr_o,

	output reg		cp0_ena_o,
	output reg[4:0]		cp0_addr_o,
	output reg[31:0]	cp0_data_o,
	
	output [7:0]		mem_op_o,
	output [31:0]		mem_addr_o,
	output [31:0]		mem_data_o,
	

	output reg[31:0] 	div_op1_o,
	output reg[31:0] 	div_op2_o,
	output reg		div_start_o,
	output reg 		div_sign_o,	

	output reg 		wena_o,
	output[4:0]		waddr_o,
	output reg[31:0] 	wdata_o,

	output reg[31:0] 	hi_o,
	output reg[31:0] 	lo_o,
	output reg		hilo_ena_o,

	output reg[63:0]  	hilo_temp_o,
	output reg[1:0]		cnt_o,
	output[31:0] result,
	
	output reg	  	stallreq


);



reg 	trapassert;
reg 	ovassert;


reg[31:0] templogic;
reg[31:0] tempshift;
reg[31:0] tempmove;
reg[31:0] temphi;
reg[31:0] templo;
reg[31:0] tempcp0;
reg[31:0] temparit;


wire	ov_sum;
wire	reg1_lt_reg2;

wire[31:0]  reg2_i_mux;
wire[31:0]  result_sum;
wire[63:0]  hilo_temp;

reg[63:0]   mulres;

wire[31:0]  op1_mult;
wire[31:0]  op2_mult;

reg[63:0]   hilo_temp1;

reg		    stallreq_for_madd_msub;
reg		    stallreq_for_div;



	assign result = result_sum;

//*************************************************对算数进行操作，未计数******************************************************
	assign	waddr_o 	= waddr_i;
	assign except_o 	= {except_i[31:12] , ovassert, trapassert, except_i[9:8], 8'b0};
	assign in_delayslot_o	= in_delayslot_i;
	assign cur_inst_addr_o	= cur_inst_addr_i;

	assign mem_op_o          = op_i;
	assign mem_addr_o	 = reg1_i + {{16{inst_i[15]}},inst_i[15:0]};

	assign mem_data_o        = reg2_i;

	assign reg2_i_mux = (	(op_i == `EXE_SUB_OP)  || 
                      		(op_i == `EXE_SUBU_OP) ||
                      		(op_i == `EXE_SLT_OP)  ||
                      		(op_i == `EXE_SLTI_OP) ||
		      		(op_i == `EXE_TLT_OP)  ||
		      		(op_i == `EXE_TLTI_OP) ||
		      		(op_i == `EXE_TGE_OP)  ||
		      		(op_i == `EXE_TGEI_OP))?
                      		(~reg2_i)+1 : reg2_i; 

	assign result_sum   = reg1_i + reg2_i_mux;//（采用加法）

	assign reg1_lt_reg2 = ( (op_i == `EXE_SLT_OP) ||
                      		(op_i == `EXE_SLTI_OP)||
		      		(op_i == `EXE_TLT_OP) ||
		      		(op_i == `EXE_TLTI_OP)||
		      		(op_i == `EXE_TGE_OP) ||
		      		(op_i == `EXE_TGEI_OP)  )?
                         			((reg1_i[31] && !reg2_i[31])                  || 
                         			(!reg1_i[31] && !reg2_i[31] && result_sum[31])||
			                   	( reg1_i[31] &&  reg2_i[31] && result_sum[31]))
                         			:(reg1_i < reg2_i);

	assign ov_sum       = ((!reg1_i[31] && !reg2_i_mux[31]) && result_sum[31])||
				((reg1_i[31] && reg2_i_mux[31]) && (!result_sum[31]));

//*************************************************对算数进行操作，未计数******************************************************

	always @ (*) begin
	   	if(!rst) begin

			temparit <= 0;
	   	end 
		else begin
			case (op_i)                        
	 	  	`EXE_SLT_OP , `EXE_SLTU_OP: begin
		     		temparit <= reg1_lt_reg2 ;   
		   	end
		 	 
			`EXE_ADD_OP, `EXE_ADDU_OP, `EXE_ADDI_OP, `EXE_ADDIU_OP: begin	
          			temparit <= result_sum;     
		   	end
		  
			`EXE_SUB_OP, `EXE_SUBU_OP: begin
		     		temparit <= result_sum;     
		   	end		
		 	
			 `EXE_CLZ_OP:begin
				                
		     	end
		  
			 `EXE_CLO_OP:begin      
		     	end

		     	default:begin
			 	temparit <= 0;
		     	end
			endcase
	 	 end
	end



//*************************************************对乘法进行操作******************************************************

assign op1_mult = (     ((op_i == `EXE_MUL_OP) || 
                        (op_i == `EXE_MULT_OP) ||
                        (op_i == `EXE_MADD_OP) || 
                        (op_i == `EXE_MSUB_OP))&&
			(reg1_i[31] == 1'b1))  ? 
			(~reg1_i + 1) : reg1_i;
     

assign op2_mult = (	 ((op_i == `EXE_MUL_OP) || 
                         (op_i == `EXE_MULT_OP) ||
                         (op_i == `EXE_MADD_OP) || 
                         (op_i == `EXE_MSUB_OP))&& 
                         (reg2_i[31] == 1'b1)) ? 
			(~reg2_i + 1) : reg2_i;



/*booth s1(
	.a(reg1_i),
	.b(reg2_i),
	.s(hilo_temp)

)

	always @(*) begin

		       if((op_i == `EXE_MUL_OP) || 
                       	 (op_i == `EXE_MULT_OP) ||
                         (op_i == `EXE_MADD_OP) || 
                         (op_i == `EXE_MSUB_OP)) begin
				mulres <= hilo_temp;
			end
			else begin
				mulres <= reg1_i * reg2_i;
			end
	end

*/

//assign hilo_temp = reg1_i * reg2_i;
assign hilo_temp = op1_mult * op2_mult;

	always @ (*) begin
    		if(!rst) begin
      			 mulres <= 0 ;
    		end 
		else begin
			if ((op_i == `EXE_MULT_OP) || (op_i == `EXE_MUL_OP)  ||
                	 (op_i == `EXE_MADD_OP) || (op_i == `EXE_MSUB_OP)) begin
      				if(reg1_i[31] ^ reg2_i[31] == 1'b1) begin
         				mulres <= ~hilo_temp + 1;
      				end 
				else begin
         				mulres <= hilo_temp;
      				end
    			end 
			else begin
      				mulres <= hilo_temp;
    			end
		end
  	end







 	always @ (*) begin
  		if(!rst) begin
    			hilo_temp_o <= 0;
    			cnt_o       <= 2'b00;
    			stallreq_for_madd_msub <= `Nostop;
  		end 
		else begin
      			case (op_i) 
        		 `EXE_MADD_OP, `EXE_MADDU_OP: begin    
            			if(cnt_i == 2'b00) begin          
              				hilo_temp_o <= mulres;
              				cnt_o       <= 2'b01;
              				hilo_temp1  <= 0;
              				stallreq_for_madd_msub <= `Stop;
            			end 
				else if(cnt_i == 2'b01) begin
              				hilo_temp_o <= 0;		    
              				cnt_o       <= 2'b00;
              				hilo_temp1  <= hilo_temp_i + {temphi,templo};
             				stallreq_for_madd_msub <= `Nostop;
           			end
         		 end
        
			 `EXE_MSUB_OP, `EXE_MSUBU_OP: begin  
            			if(cnt_i == 2'b00) begin        
             				 hilo_temp_o <=  ~mulres + 1 ;
             				 cnt_o       <= 2'b01;
             				 stallreq_for_madd_msub <= `Stop;
            			end 
				else if(cnt_i == 2'b01)begin 
               				 hilo_temp_o <= 0;
              				 cnt_o       <= 2'b00;
               				 hilo_temp1   <= hilo_temp_i + {temphi,templo};
               				 stallreq_for_madd_msub <= `Nostop;
            			end				
       			end
       			default:begin
          			hilo_temp_o <= 0;
          			cnt_o       <= 2'b00;
          			stallreq_for_madd_msub <= `Nostop;
       			end
     		endcase
   		end
 	 end	


//*************************************************对除法进行操作******************************************************




   	always @ (*) begin
     		if(!rst) begin
      			stallreq_for_div <= `Nostop;
       			div_op1_o    <= 0;
       			div_op2_o    <= 0;
      			div_start_o      <= `Stop;
      			div_sign_o     <= 1'b0;
     		end 
		else begin
      			 case (op_i) 
      				 `EXE_DIV_OP:	begin           
         				 if(div_final_i == 0) begin
            					div_op1_o    <= reg1_i;         //被除数
           					div_op2_o    <= reg2_i;         //除数
            					div_start_o      <= 1;    
            					div_sign_o     <= 1'b1;           
            					stallreq_for_div <= `Stop;          //请求流水线暂停
          				end 
					else if(div_final_i == 1) begin
           				 	div_op1_o    <= reg1_i;
           			 		div_op2_o    <= reg2_i;
           					div_start_o      <= 0;       //结束除法运算
            					div_sign_o     <= 1'b1;
            					stallreq_for_div <= `Nostop;        //不再请求流水线暂停
          				end 
					else begin
            					div_op1_o   <= 0;
            					div_op2_o    <= 0;
            					div_start_o      <= 0;
            					div_sign_o     <= 1'b1;
            					stallreq_for_div <= `Nostop;
          				end					
        			end
       				`EXE_DIVU_OP:	begin         
          				if(div_final_i == 0) begin
           					 div_op1_o    <= reg1_i;
            					 div_op2_o    <= reg2_i;
           					 div_start_o      <= 1;
            					 div_sign_o     <= 1'b0;           
            					 stallreq_for_div <= `Stop;
          				end 
					else if(div_final_i == 1) begin
           					  div_op1_o    <= reg1_i;
           					  div_op2_o    <= reg2_i;
           					  div_start_o      <= 0;
           					  div_sign_o     <= 1'b0;
           					  stallreq_for_div <= `Nostop;
        			  	end 
					else begin
            					 div_op1_o    <= 0;
          					 div_op2_o    <= 0;
           					 div_start_o      <= 0;
            					 div_sign_o     <= 1'b0;
            					 stallreq_for_div <= `Nostop;
         				 end
         			end
     				default: begin
    				end
    			endcase
  		end
	end

//*************************************************对CP0进行操作******************************************************
	always @(*)begin
		if(!rst) begin
			cp0_addr_o	 <= 5'b0;
			cp0_ena_o	 <= `Disable_write;
			cp0_data_o	 <= 0;
		end
		else if(op_i == `EXE_MTC0_OP) begin
			cp0_addr_o	 <= inst_i[15:11];
			cp0_ena_o	 <= `Enable_write;
			cp0_data_o	 <= reg1_i;
		end
		else begin
			cp0_addr_o	 <= 5'b0;
			cp0_ena_o	 <= `Disable_write;
			cp0_data_o	 <= 0;
		end
	end

//*************************************************对异常进行操作******************************************************
	always @(*)begin
		if(!rst)begin
			trapassert <= `TrapNotAssert;
		end
		else begin
			case(op_i)
			
			`EXE_TEQ_OP,`EXE_TEQI_OP:begin
				if(reg1_i == reg2_i ) begin
					trapassert <=`TrapAssert;
				end
			end
	
			`EXE_TGE_OP,`EXE_TGEI_OP,`EXE_TGEIU_OP, `EXE_TGEU_OP:begin
				if(~reg1_lt_reg2 ) begin
					trapassert <=`TrapAssert;
				end
			end
		
			`EXE_TLT_OP,`EXE_TLTI_OP,`EXE_TLTIU_OP,`EXE_TLTU_OP:begin
				if(reg1_lt_reg2 ) begin
					trapassert <=`TrapAssert;
				end
			end

			`EXE_TNE_OP,`EXE_TNEI_OP:begin
				if(reg1_i != reg2_i ) begin
					trapassert <=`TrapAssert;
				end
			end
			default:begin
				trapassert <=`TrapNotAssert;
			end
			endcase
		end
	end



//*************************************************对逻辑进行操作******************************************************


	always @(*) begin
		if(!rst) begin
			templogic <= 0;
		end
		else begin
			case(op_i)
				`EXE_OR_OP: begin
					templogic <= reg1_i | reg2_i;
				end
				
				`EXE_AND_OP:begin
					templogic <= reg1_i & reg2_i;
				end
				`EXE_NOR_OP:begin
					templogic <= ~(reg1_i | reg2_i);
				end
				`EXE_XOR_OP:begin
					templogic <= reg1_i ^ reg2_i;
				end
				default: begin
					templogic <=0;
				end
			endcase
		end
	end

//*************************************************对移位进行操作******************************************************

	always @(*) begin
		if(!rst) begin
			tempshift <= 0;
		end
		else begin
			case(op_i)
				`EXE_SLL_OP: begin
					tempshift <= reg2_i << reg1_i[4:0];
				end
				
				`EXE_SRL_OP:begin
					tempshift <= reg2_i >> reg1_i[4:0];
				end

				`EXE_SRA_OP:begin
					tempshift <= ({32{reg2_i[31]}}<<(~reg1_i[4:0])) | reg2_i >> reg1_i[4:0];
				end



				default: begin
					tempshift<=0;
				end
			endcase
		end
	end



//*************************************************对移动进行操作******************************************************

	always @(*) begin
		if(!rst) begin
			tempmove <= 0;
		end
		else begin
			case(op_i)
				`EXE_MFHI_OP : begin
					tempmove <= temphi;
				 end
				
				 `EXE_MFLO_OP: begin
					tempmove <= templo;
				 end
		
				 `EXE_MOVZ_OP: begin
				 	tempmove <= reg1_i;
				  end
			
				 `EXE_MOVN_OP: begin
					tempmove <= reg1_i;
				 end
				 `EXE_MFC0_OP:begin
					tempmove <= tempcp0;
				 end
			
				default:begin
				end
			endcase
		end
	end




//*************************************************对HILO进行操作******************************************************



	always @(*)begin
		if(!rst) begin
			hilo_ena_o <= `Disable_write;
			hi_o    <= 0;
			lo_o    <= 0;
		end
		else begin
			if((op_i == `EXE_MULT_OP)||(op_i == `EXE_MULTU_OP))begin
      				hilo_ena_o <= `Enable_write;
      			 	hi_o <= mulres[63:32];
       			 	lo_o <= mulres[31:0];
			end
			else if(op_i == `EXE_MTHI_OP) begin
				hilo_ena_o <= `Enable_write;
				hi_o    <= reg1_i;
				lo_o    <= templo;
			end
			else if	(op_i == `EXE_MTLO_OP)begin
				hilo_ena_o <= `Enable_write;
				hi_o    <= temphi;
				lo_o    <= reg1_i;	
			end
			else if((op_i == `EXE_MSUB_OP)||(op_i == `EXE_MSUBU_OP)) begin
				hilo_ena_o   <= `Enable_write;
				hi_o    <= hilo_temp1[63:32];
				lo_o    <= hilo_temp1[31:0];
			end
			else if((op_i == `EXE_MADD_OP) || (op_i == `EXE_MADDU_OP)) begin
     	 			hilo_ena_o <= `Enable_write;
      			hi_o    <= hilo_temp1[63:32];
     				lo_o    <= hilo_temp1[31:0];

			end
			else if ((op_i == `EXE_DIV_OP) || (op_i == `EXE_DIVU_OP)) begin
       				hilo_ena_o <= `Enable_write;
      				hi_o    <= div_result_i[63:32];
       				lo_o    <= div_result_i[31:0];	
			end
			else begin
			hilo_ena_o <= `Disable_write;
			hi_o    <= 0;
			lo_o    <= 0;	
			end
		end
	end	


//*************************************************对寄存器进行操作******************************************************
	always @(*) begin
	 	if(((op_i == `EXE_ADD_OP) || (op_i == `EXE_ADDI_OP) || 
	      		(op_i == `EXE_SUB_OP)) && (ov_sum == `True)) begin
	    			wena_o 	<= `Disable_write;
				ovassert<= `True;
	 	end 
		else begin
	    			wena_o <= wena_i;
				   ovassert<= `False;
		end

		case(type_i)
			`EXE_TYPE_LOGIC: begin
				wdata_o <= templogic;									
			end

			`EXE_TYPE_SHIFT:begin
				wdata_o <= tempshift;
			end

			`EXE_TYPE_MOVE:begin
				wdata_o <= tempmove;
			end
			
			`EXE_TYPE_ARITHMETIC:begin
				wdata_o <= temparit;
			end

			`EXE_TYPE_MUL:begin
				wdata_o <= mulres[31:0];
			end

			`EXE_TYPE_JUMP_BRANCH:begin
				wdata_o <= return_addr_i;
			end

			
			default: begin
				wdata_o <= 0;
			end
		endcase
	end


//*************************************************对CP0进行重定位******************************************************
	always @(*)begin
		if(!rst) begin
			cp0_raddr_o 	<= 0;
			tempcp0 	<= 0;
		end
		else begin
			cp0_raddr_o 	<= inst_i[15:11];
			if(mem_wcp0_i == `Enable_write && mem_cp0_addr_i == inst_i[15:11])begin
				tempcp0 <= mem_cp0_data_i;
			end
			else if(alig_wcp0_i == `Enable_write && alig_cp0_addr_i == inst_i[15:11]) begin
				tempcp0 <= alig_cp0_data_i;
			end
			else if(wb_wcp0_i == `Enable_write && wb_cp0_addr_i == inst_i[15:11]) begin
				tempcp0 <= wb_cp0_data_i;
			end
			else begin
				tempcp0 <= cp0_rdata_i;
			end
		end
	end

//*************************************************对HILO进行重定位******************************************************
	always @(*)begin
		if(!rst) begin
			{temphi,templo} <= 0;
		end 
		else begin
			if(mem_whilo_i == `Enable_write) begin
				{temphi,templo} <= {mem_hi_i,mem_lo_i};
			end
			else if(alig_whilo_i == `Enable_write) begin
				{temphi,templo} <= {alig_hi_i,alig_lo_i};			
			end
			else if(wb_whilo_i == `Enable_write) begin
				{temphi,templo} <= {wb_hi_i,wb_lo_i};
			end
			else begin
				{temphi,templo} <= {hi_i,lo_i};
			end
		end
	end
			
//*************************************************对暂停进行操作******************************************************

	always@(*) begin
		 stallreq <= stallreq_for_madd_msub || stallreq_for_div;
	end


endmodule








