module is_blue_diamond_eat
(
			input 	Clk,
			input  	Reset,
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_diamond_eat1,
			output   is_diamond_eat2,
			output   is_diamond_eat3,
			output [3:0] num_eat_blue
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		logic eat1, eat2, eat3;
		enum logic [3:0] {BEGIN, EAT1, EAT2, EAT3, EAT4, EAT5, EAT6, EAT7} curr_state, next_state;
		
		always_comb begin
			if (((x >= 460 && x < 480 && y_top_cen >= 408 && y_top_cen < 428) 		  					  ||
				 (x >= 460 && x < 480 && y_bottom_cen >= 408 && y_bottom_cen < 428) 						  ||
				 (x_left_cen >= 460 && x_left_cen < 480 && y >= 408 && y < 428) 	  						  ||
				 (x_right_cen >= 460 && x_right_cen < 480 && y >= 408 && y < 428)   						  ||
				 (x - 8 >= 460 && x - 8 < 480 && y_bottom_cen - 4 >= 408 && y_bottom_cen - 4 < 428)   ||
				 (x + 8 >= 460 && x + 8 < 480 && y_bottom_cen + 4 >= 408 && y_bottom_cen + 4 < 428)   ||
				 (x - 8 >= 460 && x - 8 < 480 && y_top_cen - 4 >= 408 && y_top_cen - 4 < 428)   		  ||
				 (x + 8 >= 460 && x + 8 < 480 && y_top_cen + 4 >= 408 && y_top_cen + 4 < 428))        
				 )
				 eat1 = 1'b1;
			else
				 eat1 = 1'b0;
				 
			if (((x >= 366 && x < 386 && y_top_cen >= 238 && y_top_cen < 258) 		  					  ||
				 (x >= 366 && x < 386 && y_bottom_cen >= 238 && y_bottom_cen < 258) 						  ||
				 (x_left_cen >= 366 && x_left_cen < 386 && y >= 238 && y < 258) 	  						  ||
				 (x_right_cen >= 366 && x_right_cen < 386 && y >= 238 && y < 258)   						  ||
				 (x - 8 >= 366 && x - 8 < 386 && y_bottom_cen - 4 >= 238 && y_bottom_cen - 4 < 258)   ||
				 (x + 8 >= 366 && x + 8 < 386 && y_bottom_cen + 4 >= 238 && y_bottom_cen + 4 < 258)   ||
				 (x - 8 >= 366 && x - 8 < 386 && y_top_cen - 4 >= 238 && y_top_cen - 4 < 258)   		  ||
				 (x + 8 >= 366 && x + 8 < 386 && y_top_cen + 4 >= 238 && y_top_cen + 4 < 258))        
				 )
				 eat2 = 1'b1;
			else
				 eat2 = 1'b0;

			if (((x >= 38 && x < 58 && y_top_cen >= 90 && y_top_cen < 110) 		  					  	  ||
				 (x >= 38 && x < 58 && y_bottom_cen >= 90 && y_bottom_cen < 110) 						     ||
				 (x_left_cen >= 38 && x_left_cen < 58 && y >= 90 && y < 110) 	  						     ||
				 (x_right_cen >= 38 && x_right_cen < 58 && y >= 90 && y < 110)   						     ||
				 (x - 8 >= 38 && x - 8 < 58 && y_bottom_cen - 4 >= 90 && y_bottom_cen - 4 < 110)      ||
				 (x + 8 >= 38 && x + 8 < 58 && y_bottom_cen + 4 >= 90 && y_bottom_cen + 4 < 110)      ||
				 (x - 8 >= 38 && x - 8 < 58 && y_top_cen - 4 >= 90 && y_top_cen - 4 < 110)   		     ||
				 (x + 8 >= 38 && x + 8 < 58 && y_top_cen + 4 >= 90 && y_top_cen + 4 < 110))        
				 )
				 eat3 = 1'b1;
			else
				 eat3 = 1'b0;
		end
		
		always_ff @ (posedge Clk)
			begin 
				if (Reset)
				begin
					curr_state <= BEGIN;
				end
				
				else
				begin
					curr_state <= next_state;
				end
			end
		
		always_comb begin
			next_state = curr_state;
			unique case (curr_state)
				BEGIN: begin
					is_diamond_eat1 = 1'b0;
					is_diamond_eat2 = 1'b0;
					is_diamond_eat3 = 1'b0;
					num_eat_blue = 4'b0;
					if (eat1 == 1'b1 && eat2 == 1'b0 && eat3 == 1'b0) 
						next_state = EAT1;
					if (eat1 == 1'b0 && eat2 == 1'b1 && eat3 == 1'b0) 
						next_state = EAT2;
					if (eat1 == 1'b0 && eat2 == 1'b0 && eat3 == 1'b1) 
						next_state = EAT3;
					if (eat1 == 1'b1 && eat2 == 1'b1 && eat3 == 1'b0) 
						next_state = EAT4;
					if (eat1 == 1'b1 && eat2 == 1'b0 && eat3 == 1'b1) 
						next_state = EAT5;
					if (eat1 == 1'b0 && eat2 == 1'b1 && eat3 == 1'b1) 
						next_state = EAT6;
					if (eat1 == 1'b1 && eat2 == 1'b1 && eat3 == 1'b1) 
						next_state = EAT7;
				end
				EAT1: begin
					is_diamond_eat1 = 1'b1;
					is_diamond_eat2 = 1'b0;
					is_diamond_eat3 = 1'b0;
					num_eat_blue = 4'b1;
					if (eat2 == 1'b1 && eat3 == 1'b0)
						next_state = EAT4;
					if (eat2 == 1'b0 && eat3 == 1'b1)
						next_state = EAT5;
					if (eat2 == 1'b1 && eat3 == 1'b1)
						next_state = EAT7;
				end 
				EAT2: begin
					is_diamond_eat1 = 1'b0;
					is_diamond_eat2 = 1'b1;
					is_diamond_eat3 = 1'b0;
					num_eat_blue = 4'b1;
					if (eat1 == 1'b1 && eat3 == 1'b0)
						next_state = EAT4;
					if (eat1 == 1'b0 && eat3 == 1'b1)
						next_state = EAT6;
					if (eat1 == 1'b1 && eat3 == 1'b1)
						next_state = EAT7;
				end 	
				EAT3: begin
					is_diamond_eat1 = 1'b0;
					is_diamond_eat2 = 1'b0;
					is_diamond_eat3 = 1'b1;
					num_eat_blue = 4'b1;
					if (eat1 == 1'b1 && eat2 == 1'b0)
						next_state = EAT5;
					if (eat1 == 1'b0 && eat2 == 1'b1)
						next_state = EAT6;
					if (eat1 == 1'b1 && eat2 == 1'b1)
						next_state = EAT7;
				end 		
				EAT4: begin
					is_diamond_eat1 = 1'b1;
					is_diamond_eat2 = 1'b1;
					is_diamond_eat3 = 1'b0;
					num_eat_blue = 4'b10;
					if (eat3 == 1'b1)
						next_state = EAT7;
				end
				EAT5: begin
					is_diamond_eat1 = 1'b1;
					is_diamond_eat2 = 1'b0;
					is_diamond_eat3 = 1'b1;
					num_eat_blue = 4'b10;
					if (eat2 == 1'b1)
						next_state = EAT7;
				end
				EAT6: begin
					is_diamond_eat1 = 1'b0;
					is_diamond_eat2 = 1'b1;
					is_diamond_eat3 = 1'b1;
					num_eat_blue = 4'b10;
					if (eat1 == 1'b1)
						next_state = EAT7;
				end
				EAT7: begin
					is_diamond_eat1 = 1'b1;
					is_diamond_eat2 = 1'b1;
					is_diamond_eat3 = 1'b1;
					num_eat_blue = 4'b11;
				end
			endcase
					
		end		
endmodule



module is_red_diamond_eat
(
			input 	Clk,
			input  	Reset,
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_diamond_eat1_red,
			output   is_diamond_eat1_red1,
			output   is_diamond_eat1_red2,
			output [3:0] num_eat_red
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		logic eat1, eat2, eat3;
		enum logic [3:0] {BEGIN, EAT1, EAT2, EAT3, EAT4, EAT5, EAT6, EAT7} curr_state, next_state;
		
		always_comb begin
			if (((x >= 330 && x < 350 && y_top_cen >= 408 && y_top_cen < 428) 		  					  ||
				 (x >= 330 && x < 350 && y_bottom_cen >= 408 && y_bottom_cen < 428) 						  ||
				 (x_left_cen >= 330 && x_left_cen < 350 && y >= 408 && y < 428) 	  						  ||
				 (x_right_cen >= 330 && x_right_cen < 350 && y >= 408 && y < 428)   						  ||
				 (x - 8 >= 330 && x - 8 < 350 && y_bottom_cen - 4 >= 408 && y_bottom_cen - 4 < 428)   ||
				 (x + 8 >= 330 && x + 8 < 350 && y_bottom_cen + 4 >= 408 && y_bottom_cen + 4 < 428)   ||
				 (x - 8 >= 330 && x - 8 < 350 && y_top_cen - 4 >= 408 && y_top_cen - 4 < 428)   		  ||
				 (x + 8 >= 330 && x + 8 < 350 && y_top_cen + 4 >= 408 && y_top_cen + 4 < 428))        
				 )
				 eat1 = 1'b1;
			else
				 eat1 = 1'b0;
				 
			if (((x >= 300 && x < 320 && y_top_cen >= 220 && y_top_cen < 240) 		  					  ||
				 (x >= 300 && x < 320 && y_bottom_cen >= 220 && y_bottom_cen < 240) 						  ||
				 (x_left_cen >= 300 && x_left_cen < 320 && y >= 220 && y < 240) 	  						  ||
				 (x_right_cen >= 300 && x_right_cen < 320 && y >= 220 && y < 240)   						  ||
				 (x - 8 >= 300 && x - 8 < 320 && y_bottom_cen - 4 >= 220 && y_bottom_cen - 4 < 240)   ||
				 (x + 8 >= 300 && x + 8 < 320 && y_bottom_cen + 4 >= 220 && y_bottom_cen + 4 < 240)   ||
				 (x - 8 >= 300 && x - 8 < 320 && y_top_cen - 4 >= 220 && y_top_cen - 4 < 240)   		  ||
				 (x + 8 >= 300 && x + 8 < 320 && y_top_cen + 4 >= 220 && y_top_cen + 4 < 240))        
				 )
				 eat2 = 1'b1;
			else
				 eat2 = 1'b0;
				 
			if (((x >= 190 && x < 210 && y_top_cen >= 42 && y_top_cen < 62) 		  					     ||
				 (x >= 190 && x < 210 && y_bottom_cen >= 42 && y_bottom_cen < 62) 						  ||
				 (x_left_cen >= 190 && x_left_cen < 210 && y >= 42 && y < 62) 	  						     ||
				 (x_right_cen >= 190 && x_right_cen < 210 && y >= 42 && y < 62)   						  ||
				 (x - 8 >= 190 && x - 8 < 210 && y_bottom_cen - 4 >= 42 && y_bottom_cen - 4 < 62)     ||
				 (x + 8 >= 190 && x + 8 < 210 && y_bottom_cen + 4 >= 42 && y_bottom_cen + 4 < 62)     ||
				 (x - 8 >= 190 && x - 8 < 210 && y_top_cen - 4 >= 42 && y_top_cen - 4 < 62)   		  ||
				 (x + 8 >= 190 && x + 8 < 210 && y_top_cen + 4 >= 42 && y_top_cen + 4 < 62))        
				 )
				 eat3 = 1'b1;
			else
				 eat3 = 1'b0;
		end
		
		always_ff @ (posedge Clk)
			begin 
				if (Reset)
				begin
					curr_state <= BEGIN;
				end
				
				else
				begin
					curr_state <= next_state;
				end
			end
		
		always_comb begin
			next_state = curr_state;
			unique case (curr_state)
				BEGIN: begin
					is_diamond_eat1_red = 1'b0;
					is_diamond_eat1_red1 = 1'b0;
					is_diamond_eat1_red2 = 1'b0;
					num_eat_red = 4'b0;
					if (eat1 == 1'b1 && eat2 == 1'b0 && eat3 == 1'b0) 
						next_state = EAT1;
					if (eat1 == 1'b0 && eat2 == 1'b1 && eat3 == 1'b0) 
						next_state = EAT2;
					if (eat1 == 1'b0 && eat2 == 1'b0 && eat3 == 1'b1) 
						next_state = EAT3;
					if (eat1 == 1'b1 && eat2 == 1'b1 && eat3 == 1'b0) 
						next_state = EAT4;
					if (eat1 == 1'b1 && eat2 == 1'b0 && eat3 == 1'b1) 
						next_state = EAT5;
					if (eat1 == 1'b0 && eat2 == 1'b1 && eat3 == 1'b1) 
						next_state = EAT6;
					if (eat1 == 1'b1 && eat2 == 1'b1 && eat3 == 1'b1) 
						next_state = EAT7;
				end
				EAT1: begin
					is_diamond_eat1_red = 1'b1;
					is_diamond_eat1_red1 = 1'b0;
					is_diamond_eat1_red2 = 1'b0;
					num_eat_red = 4'b1;
					if (eat2 == 1'b1 && eat3 == 1'b0)
						next_state = EAT4;
					if (eat2 == 1'b0 && eat3 == 1'b1)
						next_state = EAT5;
					if (eat2 == 1'b1 && eat3 == 1'b1)
						next_state = EAT7;
				end 
				EAT2: begin
					is_diamond_eat1_red = 1'b0;
					is_diamond_eat1_red1 = 1'b1;
					is_diamond_eat1_red2 = 1'b0;
					num_eat_red = 4'b1;
					if (eat1 == 1'b1 && eat3 == 1'b0)
						next_state = EAT4;
					if (eat1 == 1'b0 && eat3 == 1'b1)
						next_state = EAT6;
					if (eat1 == 1'b1 && eat3 == 1'b1)
						next_state = EAT7;
				end 	
				EAT3: begin
					is_diamond_eat1_red = 1'b0;
					is_diamond_eat1_red1 = 1'b0;
					is_diamond_eat1_red2 = 1'b1;
					num_eat_red = 4'b1;
					if (eat1 == 1'b1 && eat2 == 1'b0)
						next_state = EAT5;
					if (eat1 == 1'b0 && eat2 == 1'b1)
						next_state = EAT6;
					if (eat1 == 1'b1 && eat2 == 1'b1)
						next_state = EAT7;
				end 		
				EAT4: begin
					is_diamond_eat1_red = 1'b1;
					is_diamond_eat1_red1 = 1'b1;
					is_diamond_eat1_red2 = 1'b0;
					num_eat_red = 4'b10;
					if (eat3 == 1'b1)
						next_state = EAT7;
				end
				EAT5: begin
					is_diamond_eat1_red = 1'b1;
					is_diamond_eat1_red1 = 1'b0;
					is_diamond_eat1_red2 = 1'b1;
					num_eat_red = 4'b10;
					if (eat2 == 1'b1)
						next_state = EAT7;
				end
				EAT6: begin
					is_diamond_eat1_red = 1'b0;
					is_diamond_eat1_red1 = 1'b1;
					is_diamond_eat1_red2 = 1'b1;
					num_eat_red = 4'b10;
					if (eat1 == 1'b1)
						next_state = EAT7;
				end
				EAT7: begin
					is_diamond_eat1_red = 1'b1;
					is_diamond_eat1_red1 = 1'b1;
					is_diamond_eat1_red2 = 1'b1;
					num_eat_red = 4'b11;
				end
			endcase
					
		end		
endmodule
