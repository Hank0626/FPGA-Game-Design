module button_push
(
			input 	Clk,
			input  	Reset,
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_button_push
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		logic eat1;
		enum logic [3:0] {BEGIN, PUSH} curr_state, next_state;
		
		always_comb begin
			if (x >= 142 && x < 162 && y_bottom_cen - 5 >= 322 && y_bottom_cen - 5 < 332)
				 eat1 = 1'b1;
			else
				 eat1 = 1'b0;
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
					is_button_push = 1'b0;
					if (eat1 == 1'b1) 
						next_state = PUSH;
				end
				PUSH: begin
					is_button_push = 1'b1;
				end 
			endcase
					
		end		
endmodule



module button_purple_push1
(
			input 	Clk,
			input  	Reset,
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_button_purple_push1
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		logic eat1;
		enum logic [3:0] {BEGIN, PUSH} curr_state, next_state;
		
		always_comb begin
			if ((x >= 172 && x < 192 && y_bottom_cen - 5 >= 241 && y_bottom_cen - 5 < 251))
				 eat1 = 1'b1;
			else
				 eat1 = 1'b0;
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
					is_button_purple_push1 = 1'b0;
					if (eat1 == 1'b1) 
						next_state = PUSH;
				end
				PUSH: begin
					is_button_purple_push1 = 1'b1;
					if (eat1 == 1'b0)
						next_state = BEGIN;
				end 
			endcase
					
		end		
endmodule


module button_purple_push2
(
			input 	Clk,
			input  	Reset,
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_button_purple_push2
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		logic eat1;
		enum logic [3:0] {BEGIN, PUSH} curr_state, next_state;
		
		always_comb begin
			if ((x >= 520 && x < 540 && y_bottom_cen - 5 >= 178 && y_bottom_cen - 5 < 188))
				 eat1 = 1'b1;
			else
				 eat1 = 1'b0;
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
					is_button_purple_push2 = 1'b0;
					if (eat1 == 1'b1) 
						next_state = PUSH;
				end
				PUSH: begin
					is_button_purple_push2 = 1'b1;
					if (eat1 == 1'b0)
						next_state = BEGIN;
				end 
			endcase
					
		end		
endmodule