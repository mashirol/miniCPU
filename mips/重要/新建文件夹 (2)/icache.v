module icache(

input			clk,
input			rst,
input[31:0]		addr_i,
input[31:0]		data_i,
input			w_r_i,
input			ena_i,
input[127:0]		data_chg_i,
input 			valid_chg_i,
input			valid_inq_i,


input[127:0]		data_i1,
input[127:0]		data_i2,
input[26:0]		addr_i1,
input[26:0]		addr_i2,



output reg[31:0]	data_o,
output reg  		valid_o,
output reg		suc_o,
output reg[127:0]	data_chg_o,
output reg[31:0]	addr_chg_o,
output reg		inq_o,


output reg		valid_r_o,
output reg[5:0]		r_addr_o,
output reg[6:0]		w_addr_o,
output reg[26:0]	data_addr_o,
output reg[127:0]	data_d_o,
output reg		valid_w_o,
output reg		chg_o,

output[2:0] state

);


parameter s0 =3'b000;
parameter s1 =3'b001;
parameter s2 =3'b010;
parameter s3 =3'b011;
parameter s4 =3'b100;

reg cnt;
reg[2:0] cur_state, next_state;



reg[31:0]   data_o_i;
reg  	    valid_o_i;
reg	    suc_o_i;
reg[127:0]  data_chg_o_i;
reg[31:0]   addr_chg_o_i;
reg	    inq_o_i;


reg		valid_r_o_i;
reg[5:0]	r_addr_o_i;
reg[6:0]	w_addr_o_i;
reg[26:0]	data_addr_o_i;
reg[127:0]	data_d_o_i;
reg		valid_w_o_i;
reg		chg_o_i;


wire[3:0]sel_byte;

assign sel_byte = 4'b1111;
assign state = cur_state;

always @(posedge clk) begin
	if(!rst) begin

		data_o_i  	<=0;
		valid_o_i  	<=0;
		suc_o_i  	<=0;
		data_chg_o_i  	<=0;
		addr_chg_o_i  	<=0;
		inq_o_i  	<=0;
		valid_r_o_i  	<=0;
		r_addr_o_i  	<=0;
		w_addr_o_i  	<=0;
		data_addr_o_i  	<=0;
		data_d_o_i  	<=0;
		valid_w_o_i  	<=0;
		chg_o_i 	<=0;
		cur_state <= 0;
		cnt	<=0;
	end
	else begin

		data_o_i  	<=data_o;
		valid_o_i  	<=valid_o;
		suc_o_i  	<=suc_o;
		data_chg_o_i  	<=data_chg_o;
		addr_chg_o_i  	<=addr_chg_o;
		inq_o_i  	<=inq_o;
		valid_r_o_i  	<=valid_r_o;
		r_addr_o_i  	<=r_addr_o;
		w_addr_o_i  	<=w_addr_o;
		data_addr_o_i  	<=data_addr_o;
		data_d_o_i  	<=data_d_o;
		valid_w_o_i  	<=valid_w_o;
		chg_o_i 	<=chg_o;

		cur_state <= next_state;
		cnt	  <= ~cnt;
	end
	
end


always @(*) begin

	if(!rst) begin
		data_o 	<=0;
 		valid_o <=0;
		suc_o 	<=0;
		data_chg_o <=0;
		addr_chg_o <=0;
		inq_o 	<=0;
		w_addr_o <=0;
		data_addr_o <=0;
		data_d_o  <=0;
		valid_w_o <=0;
		chg_o 	  <=0;
		next_state <=0;
	end
	else begin

		data_o  	<=data_o_i;
		valid_o  	<=valid_o_i;
		suc_o  		<=suc_o_i;
		data_chg_o  	<=data_chg_o_i;
		addr_chg_o  	<=addr_chg_o_i;
		inq_o		<=inq_o_i;

		w_addr_o  	<=w_addr_o_i;
		data_addr_o 	<=data_addr_o_i;
		data_d_o  	<=data_d_o_i;
		valid_w_o  	<=valid_w_o_i;
		chg_o 		<=chg_o_i;

		case(cur_state)
		s0:begin
			valid_w_o <= 0;
			inq_o     <= 0;
			valid_o   <= 0;

			if(ena_i && w_r_i == 0) begin
				if(addr_i1[21:0] == addr_i[31:10]) begin
					case(addr_i[3:2])
					0: begin
						if(addr_i1[23]) begin
							data_o	<= data_i1[31:0];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end
					end
					1:begin
						if(addr_i1[24]) begin
							data_o	<= data_i1[63:32];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end

					end
					2:begin
						if(addr_i1[25]) begin
							data_o	<= data_i1[95:64];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end
					end
					3:begin
						if(addr_i1[26]) begin
							data_o	<= data_i1[127:96];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end
					end
					default:begin
							data_o	<= 0;
							valid_o	  	<= 1'b0;
							suc_o		<= 1'b0;
							next_state	<= s0;
						end
					endcase	
				end
				else if(addr_i2[21:0] == addr_i[31:10]) begin
					case(addr_i[3:2])
					0: begin
						if(addr_i2[23]) begin
							data_o	<= data_i2[31:0];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end
					end
					1:begin
						if(addr_i2[24]) begin
							data_o	<= data_i2[63:32];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end

					end
					2:begin
						if(addr_i2[25]) begin
							data_o	<= data_i2[95:64];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end
					end
					3:begin
						if(addr_i2[26]) begin
							data_o	<= data_i2[127:96];
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b1;
							next_state	<= s0;
						end
						else begin
							data_o	<= 0;
							valid_o	  	<= 1'b1;
							suc_o		<= 1'b0;
							next_state	<= s1;
						end
					end
					default:begin
							data_o	<= 0;
							valid_o	  	<= 1'b0;
							suc_o		<= 1'b0;
							next_state	<= s0;
						end
					endcase
				end
				else begin
						valid_o	  	<= 1'b1;
						suc_o		<= 1'b0;
						next_state 	<= s1;
				end
				
			end
			else if(ena_i && w_r_i == 1) begin
				if(addr_i1[21:0]  == addr_i[31:10] ) begin
					valid_w_o	<= 1'b1;
					data_addr_o[22]	<= 1'b1;
					w_addr_o 	<= {addr_i[9:4],1'b0};
					case(addr_i[3:2])
					0: begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i1[127:8],data_i[7:0]};
							4'b0010:data_d_o<= {data_i1[127:16],data_i[15:8],data_i1[7:0]};
							4'b0100:data_d_o<= {data_i1[127:24],data_i[23:16],data_i1[15:0]};
							4'b1000:data_d_o<= {data_i1[127:32],data_i[31:24],data_i1[23:0]};
							4'b0111:data_d_o<= {data_i1[127:24],data_i[23:0]};
							4'b0011:data_d_o<= {data_i1[127:16],data_i[15:0]};
							4'b1100:data_d_o<= {data_i1[127:32],data_i[31:16],data_i1[15:0]};
							4'b1111:data_d_o<= {data_i1[127:32],data_i};
							default:data_d_o<= {data_i1[127:32],data_i};

						endcase
						data_addr_o[23]<=1'b1;
					end
					1:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i1[127:40],data_i[7:0],data_i1[31:0]};
							4'b0010:data_d_o<= {data_i1[127:48],data_i[15:8],data_i1[39:0]};
							4'b0100:data_d_o<= {data_i1[127:56],data_i[23:16],data_i1[47:0]};
							4'b1000:data_d_o<= {data_i1[127:64],data_i[31:24],data_i1[55:0]};
							4'b0011:data_d_o<= {data_i1[127:48],data_i[15:0],data_i1[31:0]};
							4'b0111:data_d_o<= {data_i1[127:56],data_i[23:0],data_i1[31:0]};
							4'b1100:data_d_o<= {data_i1[127:64],data_i[31:16],data_i1[47:0]};
							4'b1111:data_d_o<= {data_i1[127:64],data_i,data_i1[31:0]};
							default:data_d_o<= {data_i1[127:64],data_i,data_i1[31:0]};
						endcase
						data_addr_o[24]<=1'b1;
					end
					2:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i1[127:72],data_i[7:0],data_i1[63:0]};
							4'b0010:data_d_o<= {data_i1[127:80],data_i[15:8],data_i1[71:0]};
							4'b0100:data_d_o<= {data_i1[127:88],data_i[23:16],data_i1[79:0]};
							4'b1000:data_d_o<= {data_i1[127:96],data_i[31:24],data_i1[87:0]};
							4'b0011:data_d_o<= {data_i1[127:80],data_i[15:0],data_i1[63:0]};
							4'b0111:data_d_o<= {data_i1[127:88],data_i[23:0],data_i1[63:0]};
							4'b1100:data_d_o<= {data_i1[127:96],data_i[31:16],data_i1[79:0]};
							4'b1111:data_d_o<= {data_i1[127:96],data_i,data_i1[63:0]};
							default:data_d_o<= {data_i1[127:96],data_i,data_i1[63:0]};
						endcase
						data_addr_o[25]<=1'b1;

					end
					3:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i1[127:104],data_i[7:0],data_i1[95:0]};
							4'b0010:data_d_o<= {data_i1[127:112],data_i[15:8],data_i1[103:0]};
							4'b0100:data_d_o<= {data_i1[127:120],data_i[23:16],data_i1[111:0]};
							4'b1000:data_d_o<= {data_i[31:24],data_i1[119:0]};
							4'b0011:data_d_o<= {data_i1[127:112],data_i[15:0],data_i1[95:0]};
							4'b0111:data_d_o<= {data_i1[127:120],data_i[23:0],data_i1[95:0]};	
							4'b1100:data_d_o<= {data_i[31:16],data_i1[111:0]};
							4'b1111:data_d_o<= {data_i,data_i1[95:0]};
							default:data_d_o<= {data_i,data_i1[95:0]};
						endcase
						data_addr_o[26]<=1'b1;
					end
					default:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i1[127:40],data_i[7:0],data_i1[31:0]};
							4'b0010:data_d_o<= {data_i1[127:48],data_i[15:8],data_i1[39:0]};
							4'b0100:data_d_o<= {data_i1[127:56],data_i[23:16],data_i1[47:0]};
							4'b1000:data_d_o<= {data_i1[127:64],data_i[31:24],data_i1[55:0]};
							4'b0011:data_d_o<= {data_i1[127:48],data_i[15:0],data_i1[31:0]};
							4'b1100:data_d_o<= {data_i1[127:64],data_i[31:16],data_i1[47:0]};
							4'b1111:data_d_o<= {data_i1[127:64],data_i,data_i1[31:0]};
							default:data_d_o<= {data_i1[127:64],data_i,data_i1[31:0]};
						endcase
						data_addr_o[23]<=1'b1;
					end
					endcase
			
					valid_o	  	<= 1'b1;
					suc_o		<= 1'b1;
					next_state	<= s0;
					
				end
				else if(addr_i2[21:0]  == addr_i[31:10]) begin
					valid_w_o	<= 1'b1;
					data_addr_o[22]<=1'b1;
					w_addr_o <= {addr_i[9:4],1'b1};
					case(addr_i[3:2])
					0: begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i2[127:8],data_i[7:0]};
							4'b0010:data_d_o<= {data_i2[127:16],data_i[15:8],data_i2[7:0]};
							4'b0100:data_d_o<= {data_i2[127:24],data_i[23:16],data_i2[15:0]};
							4'b1000:data_d_o<= {data_i2[127:32],data_i[31:24],data_i2[23:0]};
							4'b0011:data_d_o<= {data_i2[127:16],data_i[15:0]};
							4'b0111:data_d_o<= {data_i1[127:24],data_i[23:0]};
							4'b1100:data_d_o<= {data_i2[127:32],data_i[31:16],data_i2[15:0]};
							4'b1111:data_d_o<= {data_i2[127:32],data_i};
							default:data_d_o<= {data_i2[127:32],data_i};

						endcase
						data_addr_o[23]<=1'b1;
					end
					1:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i2[127:40],data_i[7:0],data_i2[31:0]};
							4'b0010:data_d_o<= {data_i2[127:48],data_i[15:8],data_i2[39:0]};
							4'b0100:data_d_o<= {data_i2[127:56],data_i[23:16],data_i2[47:0]};
							4'b1000:data_d_o<= {data_i2[127:64],data_i[31:24],data_i2[55:0]};
							4'b0011:data_d_o<= {data_i2[127:48],data_i[15:0],data_i2[31:0]};
							4'b0111:data_d_o<= {data_i1[127:56],data_i[23:0],data_i1[31:0]};
							4'b1100:data_d_o<= {data_i2[127:64],data_i[31:16],data_i2[47:0]};
							4'b1111:data_d_o<= {data_i2[127:64],data_i,data_i2[31:0]};
							default:data_d_o<= {data_i2[127:64],data_i,data_i2[31:0]};
						endcase
						data_addr_o[24]<=1'b1;
					end
					2:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i2[127:72],data_i[7:0],data_i2[63:0]};
							4'b0010:data_d_o<= {data_i2[127:80],data_i[15:8],data_i2[71:0]};
							4'b0100:data_d_o<= {data_i2[127:88],data_i[23:16],data_i2[79:0]};
							4'b1000:data_d_o<= {data_i2[127:96],data_i[31:24],data_i2[87:0]};
							4'b0011:data_d_o<= {data_i2[127:80],data_i[15:0],data_i2[63:0]};
							4'b0111:data_d_o<= {data_i1[127:88],data_i[23:0],data_i1[63:0]};
							4'b1100:data_d_o<= {data_i2[127:96],data_i[31:16],data_i2[79:0]};
							4'b1111:data_d_o<= {data_i2[127:96],data_i,data_i2[63:0]};
							default:data_d_o<= {data_i2[127:96],data_i,data_i2[63:0]};
						endcase
						data_addr_o[25]<=1'b1;
					end
					3:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i2[127:104],data_i[7:0],data_i2[95:0]};
							4'b0010:data_d_o<= {data_i2[127:112],data_i[15:8],data_i2[103:0]};
							4'b0100:data_d_o<= {data_i2[127:120],data_i[23:16],data_i2[111:0]};
							4'b1000:data_d_o<= {data_i[31:24],data_i2[119:0]};
							4'b0111:data_d_o<= {data_i1[127:120],data_i[23:0],data_i1[95:0]};
							4'b0011:data_d_o<= {data_i2[127:112],data_i[15:0],data_i2[95:0]};
							4'b1100:data_d_o<= {data_i[31:16],data_i2[111:0]};
							4'b1111:data_d_o<= {data_i,data_i2[95:0]};
							default:data_d_o<= {data_i,data_i2[95:0]};
						endcase
						data_addr_o[26]<=1'b1;
					end
					default:begin
						case(sel_byte)
							4'b0001:data_d_o<= {data_i2[127:40],data_i[7:0],data_i2[31:0]};
							4'b0010:data_d_o<= {data_i2[127:48],data_i[15:8],data_i2[39:0]};
							4'b0100:data_d_o<= {data_i2[127:56],data_i[23:16],data_i2[47:0]};
							4'b1000:data_d_o<= {data_i2[127:64],data_i[31:24],data_i2[55:0]};
							4'b0011:data_d_o<= {data_i2[127:48],data_i[15:0],data_i2[31:0]};
							4'b1100:data_d_o<= {data_i2[127:64],data_i[31:16],data_i2[47:0]};
							4'b1111:data_d_o<= {data_i2[127:64],data_i,data_i2[31:0]};
							default:data_d_o<= {data_i2[127:64],data_i,data_i2[31:0]};
						endcase
						data_addr_o[23]<=1'b1;
					end
					endcase

					valid_o	  	<= 1'b1;
					suc_o		<= 1'b1;
					next_state	<= s0;
				end
				else if(!addr_i1[22]) begin
					

					inq_o		<= 1'b0;
					valid_o	  	<= 1'b1;
					suc_o		<= 1'b0;
					valid_w_o		<= 1'b0;
					data_addr_o[22]		<= 1'b1;
					data_addr_o[21:0]	<= addr_i[31:10];
					w_addr_o 		<= {addr_i[9:4],1'b0};
					next_state	<= s4;
					
				end
				else if(!addr_i2[22]) begin

					inq_o		<= 1'b0;
					valid_o	  	<= 1'b1;
					suc_o		<= 1'b0;
					valid_w_o		<= 1'b0;
					data_addr_o[22]		<= 1'b1;
					data_addr_o[21:0]	<= addr_i[31:10];
					w_addr_o 		<= {addr_i[9:4],1'b1};
					next_state	<= s4;
				end
				else begin
					valid_o	  	<= 1'b1;
					valid_w_o	<= 1'b0;
					suc_o 		<= 1'b0;
					if(cnt == 0) begin
						w_addr_o   <= {addr_i[9:4],1'b0};
						data_chg_o <= data_i1;
						addr_chg_o <= {addr_i1[21:0],addr_i[9:4],4'b0000};
						inq_o      <= 1'b1;
						next_state <= s3;
					end
					else begin
						w_addr_o <= {addr_i[9:4],1'b1};																			data_chg_o <= data_i2;
						addr_chg_o <= {addr_i2[21:0],addr_i[9:4],4'b0000};
						inq_o      <= 1'b1;
						next_state <= s3;
					end
				end

			end
			else begin
				valid_o	  <= 1'b0;
				suc_o	  <= 1'b0;
				next_state<=s0;
			end 

		end
		s1:begin
			if(!valid_chg_i) begin
				next_state <= s1;
				valid_w_o  <= 0;
			end
			else begin
				if(addr_i1[22] == 0) begin
					w_addr_o <= {addr_i[9:4],1'b0};
					case(addr_i[3:2])
						2'b00:data_o  <= data_chg_i[31:0];
						2'b01:data_o  <= data_chg_i[63:32];
						2'b10:data_o  <= data_chg_i[95:64];
						2'b11:data_o  <= data_chg_i[127:96];
					endcase
					valid_w_o	   <= 1'b1;
					data_d_o           <= data_chg_i;
					data_addr_o	   <= {5'b11110,addr_i[31:10]};
					next_state	   <= s0;
					valid_o	  	   <= 1'b1;
					suc_o 		   <= 1'b1;	
				end
				else if(addr_i2[22] == 0) begin
					w_addr_o <= {addr_i[9:4],1'b1};
					case(addr_i[3:2])
						2'b00:data_o  <= data_chg_i[31:0];
						2'b01:data_o  <= data_chg_i[63:32];
						2'b10:data_o  <= data_chg_i[95:64];
						2'b11:data_o  <= data_chg_i[127:96];
					endcase
					valid_w_o	   <= 1'b1;
					data_d_o           <= data_chg_i;
					data_addr_o	   <={5'b11110,addr_i[31:10]};
					next_state	   <= s0;
					valid_o	  	   <= 1'b1;
					suc_o 		   <= 1'b1;	
				end
				else begin
					if(cnt == 0)begin
						w_addr_o  <= {addr_i[9:4],1'b0};
						valid_w_o <= 1'b0;
						data_chg_o<= data_i1;
						addr_chg_o<= {addr_i1[21:0],addr_i[9:4],4'b0000};
						inq_o     <= 1'b1;
						next_state<= s2;						
					end
					else begin
						w_addr_o    <= {addr_i[9:4],1'b1};
						valid_w_o  <= 1'b0;
						data_chg_o <=data_i2;
						addr_chg_o <={addr_i2[21:0],addr_i[9:4],4'b0000};
						inq_o      <=1'b1;
						next_state <= s2;
					end

				end
			end 
		end
		s2:begin
			if(!valid_inq_i) begin
				next_state <= s2;
			end
			else begin
				valid_w_o	   <= 1'b1;
				data_d_o           <= data_chg_i;
				case(addr_i[3:2])
					2'b00:data_o  <= data_chg_i[31:0];
					2'b01:data_o  <= data_chg_i[63:32];
					2'b10:data_o  <= data_chg_i[95:64];
					2'b11:data_o  <= data_chg_i[127:96];
				endcase
				data_addr_o	   <={5'b11110,addr_i[31:10]};
				suc_o 		   <= 1'b1;
				valid_o 	   <= 1'b1;
				next_state	   <= s0;				
			end
		end
		s3:begin
			if(!valid_inq_i) begin
				next_state <= s3;
			end
			else begin
				valid_w_o	  <= 1'b0;
				data_addr_o[22]   <= 1'b1;
				data_addr_o[21:0] <= addr_i[31:10];
				suc_o 		  <= 1'b0;
				next_state	  <= s4;
				
			end
		end
		s4:begin
			if(!valid_chg_i) begin
			end
			else begin
				valid_w_o	<= 1'b1;				
				case(addr_i[3:2])
				0: begin
					case(sel_byte)
						4'b0001:data_d_o<= {data_chg_i[127:8],data_i[7:0]};
						4'b0010:data_d_o<= {data_chg_i[127:16],data_i[15:8],data_chg_i[7:0]};
						4'b0100:data_d_o<= {data_chg_i[127:24],data_i[23:16],data_chg_i[15:0]};
						4'b1000:data_d_o<= {data_chg_i[127:32],data_i[31:24],data_chg_i[23:0]};
						4'b0111:data_d_o<= {data_i1[127:24],data_i[23:0]};
						4'b0011:data_d_o<= {data_chg_i[127:16],data_i[15:0]};
						4'b1100:data_d_o<= {data_chg_i[127:32],data_i[31:16],data_chg_i[15:0]};
						4'b1111:data_d_o<= {data_chg_i[127:32],data_i};
						default:data_d_o<= {data_chg_i[127:32],data_i};
					endcase
					data_addr_o[26:23] <=4'b0001;
				end
				1:begin
					case(sel_byte)
						4'b0001:data_d_o<= {data_chg_i[127:40],data_i[7:0],data_chg_i[31:0]};
						4'b0010:data_d_o<= {data_chg_i[127:48],data_i[15:8],data_chg_i[39:0]};
						4'b0100:data_d_o<= {data_chg_i[127:56],data_i[23:16],data_chg_i[47:0]};
						4'b1000:data_d_o<= {data_chg_i[127:64],data_i[31:24],data_chg_i[55:0]};
						4'b0111:data_d_o<= {data_i1[127:56],data_i[23:0],data_i1[31:0]};
						4'b0011:data_d_o<= {data_chg_i[127:48],data_i[15:0],data_chg_i[31:0]};
						4'b1100:data_d_o<= {data_chg_i[127:64],data_i[31:16],data_chg_i[47:0]};
						4'b1111:data_d_o<= {data_chg_i[127:64],data_i,data_chg_i[31:0]};
						default:data_d_o<= {data_chg_i[127:64],data_i,data_chg_i[31:0]};
					endcase
					data_addr_o[26:23] <=4'b0010;
				end
				2:begin
					case(sel_byte)
						4'b0001:data_d_o<= {data_chg_i[127:72],data_i[7:0],data_chg_i[63:0]};
						4'b0010:data_d_o<= {data_chg_i[127:80],data_i[15:8],data_chg_i[71:0]};
						4'b0100:data_d_o<= {data_chg_i[127:88],data_i[23:16],data_chg_i[79:0]};
						4'b1000:data_d_o<= {data_chg_i[127:96],data_i[31:24],data_chg_i[87:0]};
						4'b0011:data_d_o<= {data_chg_i[127:80],data_i[15:0],data_chg_i[63:0]};
						4'b0111:data_d_o<= {data_i1[127:88],data_i[23:0],data_i1[63:0]};
						4'b1100:data_d_o<= {data_chg_i[127:96],data_i[31:16],data_chg_i[79:0]};
						4'b1111:data_d_o<= {data_chg_i[127:96],data_i,data_chg_i[63:0]};
						default:data_d_o<= {data_chg_i[127:96],data_i,data_chg_i[63:0]};
					endcase
					data_addr_o[26:23] <=4'b0100;
				end
				3:begin
					case(sel_byte)
						4'b0001:data_d_o<= {data_chg_i[127:104],data_i[7:0],data_chg_i[95:0]};
						4'b0010:data_d_o<= {data_chg_i[127:112],data_i[15:8],data_chg_i[103:0]};
						4'b0100:data_d_o<= {data_chg_i[127:120],data_i[23:16],data_chg_i[111:0]};
						4'b1000:data_d_o<= {data_i[31:24],data_chg_i[119:0]};
						4'b0111:data_d_o<= {data_i1[127:120],data_i[23:0],data_i1[95:0]};
						4'b0011:data_d_o<= {data_chg_i[127:112],data_i[15:0],data_chg_i[95:0]};
						4'b1100:data_d_o<= {data_i[31:16],data_chg_i[111:0]};
						4'b1111:data_d_o<= {data_i,data_chg_i[95:0]};
						default:data_d_o<= {data_i,data_chg_i[95:0]};
					endcase
					data_addr_o[26:23] <=4'b1000;
				end
				default:begin
					case(sel_byte)
						4'b0001:data_d_o<= {data_chg_i[127:40],data_i[7:0],data_chg_i[31:0]};
						4'b0010:data_d_o<= {data_chg_i[127:48],data_i[15:8],data_chg_i[39:0]};
						4'b0100:data_d_o<= {data_chg_i[127:56],data_i[23:16],data_chg_i[47:0]};
						4'b1000:data_d_o<= {data_chg_i[127:64],data_i[31:24],data_chg_i[55:0]};
						4'b0011:data_d_o<= {data_chg_i[127:48],data_i[15:0],data_chg_i[31:0]};
						4'b1100:data_d_o<= {data_chg_i[127:64],data_i[31:16],data_chg_i[47:0]};
						4'b1111:data_d_o<= {data_chg_i[127:64],data_i,data_chg_i[31:0]};
						default:data_d_o<= {data_chg_i[127:64],data_i,data_chg_i[31:0]};
					endcase
					data_addr_o[26:23] <=4'b0001;
				end
				endcase				
				valid_o	  	<= 1'b1;
				suc_o		<= 1'b1;
				next_state	<= s0;
			end

		
		end
		endcase
	end

end


always @(*) begin

	if(!rst) begin
		valid_r_o  <=0;
		r_addr_o  <=0;
	end
	else begin
		valid_r_o 	<=valid_r_o_i;
		r_addr_o  	<=r_addr_o_i;  
		case(cur_state)
		s0:begin
			if(ena_i) begin
				valid_r_o <= 1'b1;
				r_addr_o  <= addr_i[9:4];				
			end
			else begin
				valid_r_o <= 0;				
			end 
		end
		s1:begin		
		end
		s2:begin
		end
		s3:begin
		end
		default:begin
		end
		endcase
	end

end


endmodule