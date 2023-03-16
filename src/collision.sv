//-------------------------------------------------------------------------
//    collision.sv                                                       --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module collision
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_collide_up,
						is_collide_down,
						is_collide_left,
						is_collide_right,
						// Modify
						is_collide_left_end,
						is_collide_right_end,
						is_collide_left_top,
						is_collide_right_top
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;
		logic num = 0;
		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;


		logic [16:0] address1,
						 address2,
						 address3,
						 address4,
						 // Modify
						 address5,
						 address6,
						 address7,
						 address8;	
	
		assign address1 = x * 5 / 16 + y_top_cen * 5 / 16 * 200;  //top
		assign address2 = x * 5 / 16 + y_bottom_cen * 5 / 16 * 200;  //bottom
		assign address3 = x_left_cen * 5 / 16 + y * 5 / 16 * 200;  //left
		assign address4 = x_right_cen * 5 / 16 + y * 5 / 16 * 200;  //right
		
		// Modify
		assign address5 = (x - 8) * 5 / 16 + (y_bottom_cen - 4) * 5 / 16 * 200;  // left_end
		assign address6 = (x + 8) * 5 / 16 + (y_bottom_cen - 4) * 5 / 16 * 200;  // right_end
		assign address7 = (x - 8) * 5 / 16 + (y_top_cen + 4) * 5 / 16 * 200;  // left_top
		assign address8 = (x + 8) * 5 / 16 + (y_top_cen + 4) * 5 / 16 * 200;  // right_top		
		
		
		logic [23:0] col1,
						 col2,
						 col3,
						 col4,
						 // Modify
						 col5,
						 col6,
						 col7,
						 col8;
		
		
		
		map1_rom color1(.read_address(address1), .color_output(col1));
		map1_rom color2(.read_address(address2), .color_output(col2));
		map1_rom color3(.read_address(address3), .color_output(col3));
		map1_rom color4(.read_address(address4), .color_output(col4));	
		map1_rom color5(.read_address(address5), .color_output(col5));			
		map1_rom color6(.read_address(address6), .color_output(col6));	
		map1_rom color7(.read_address(address7), .color_output(col7));			
		map1_rom color8(.read_address(address8), .color_output(col8));			
		
		always_comb begin
			if (col1 == 24'h716734 || col1 == 24'h5f582b)
				is_collide_up = 1'b1;
			else
				is_collide_up = 1'b0;
				
			if (col2 == 24'h716734 || col2 == 24'h5f582b)
				is_collide_down = 1'b1;
			else
				is_collide_down = 1'b0;
			
			if (col3 == 24'h716734 || col3 == 24'h5f582b)
				is_collide_left = 1'b1;
			else
				is_collide_left = 1'b0;
			if (col4 == 24'h716734 || col4 == 24'h5f582b)
				is_collide_right = 1'b1;
			else
				is_collide_right = 1'b0;
			if (col5 == 24'h716734 || col5 == 24'h5f582b)
				is_collide_left_end = 1'b1;
			else
				is_collide_left_end = 1'b0;
			if (col6 == 24'h716734 || col6 == 24'h5f582b)
				is_collide_right_end = 1'b1;
			else
				is_collide_right_end = 1'b0;
			if (col7 == 24'h716734 || col7 == 24'h5f582b)
				is_collide_left_top = 1'b1;
			else
				is_collide_left_top = 1'b0;
			if (col8 == 24'h716734 || col8 == 24'h5f582b)
				is_collide_right_top = 1'b1;
			else
				is_collide_right_top = 1'b0;		
	
		end
endmodule

module collision_board
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			input    [9:0] board_x_pos,
			input    [9:0] board_y_pos,
			input    [9:0] board_purple_x_pos,
			input    [9:0] board_purple_y_pos,
			output 	is_collide_down_board,
			output   is_collide_up_board,
			output   is_collide_left_board,
			output   is_collide_up_board_purple,
			output   is_collide_down_board_purple,
			output   is_collide_right_board_purple
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		always_comb begin
		if (x >= board_x_pos - 45 && x <= board_x_pos + 45 && y_bottom_cen >= board_y_pos - 7 && y_bottom_cen <= board_y_pos - 5)
			is_collide_down_board = 1'b1;
		else
			is_collide_down_board = 1'b0;
		
		if (x >= board_x_pos - 45 && x <= board_x_pos + 45 && y_top_cen >= board_y_pos + 5 && y_top_cen <= board_y_pos + 7)
			is_collide_up_board = 1'b1;
		else
			is_collide_up_board = 1'b0;
		
		if (x_left_cen >= board_x_pos + 33 && x_left_cen <= board_x_pos + 35 && y + 5 >= board_y_pos - 25 && y + 5 <= board_y_pos + 6)
			is_collide_left_board = 1'b1;
		else
			is_collide_left_board = 1'b0;
		
		
		
		if (x >= board_purple_x_pos - 45 && x <= board_purple_x_pos + 45 && y_top_cen >= board_purple_y_pos + 5 && y_top_cen <= board_purple_y_pos + 6)
			is_collide_up_board_purple = 1'b1;
		else
			is_collide_up_board_purple = 1'b0;		

		if (x >= board_purple_x_pos - 45 && x <= board_purple_x_pos + 45 && y_bottom_cen >= board_purple_y_pos - 7 && y_bottom_cen <= board_purple_y_pos - 4)
			is_collide_down_board_purple = 1'b1;
		else
			is_collide_down_board_purple = 1'b0;			
		
		if (x_right_cen >= board_purple_x_pos - 35 && x_right_cen <= board_purple_x_pos - 33 && y + 5 >= board_purple_y_pos - 25 && y + 5 <= board_purple_y_pos + 6)
			is_collide_right_board_purple = 1'b1;
		else
			is_collide_right_board_purple = 1'b0;
		
		end
endmodule

module collision_box
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			input    [9:0] box_x_pos,
			input    [9:0] box_y_pos,
			output 	is_collide_left_box,
			output   is_collide_right_box,
			output   is_collide_down_box
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		always_comb begin
		if (x >= box_x_pos - 20 && x <= box_x_pos + 20 && y_bottom_cen >= box_y_pos - 12 && y_bottom_cen <= box_y_pos - 11)
			is_collide_down_box = 1'b1;
		else
			is_collide_down_box = 1'b0;
		
		if (x_left_cen >= box_x_pos + 10 && x_left_cen <= box_x_pos + 13 && y >= box_y_pos - 30 && y <= box_y_pos + 20)
			is_collide_right_box = 1'b1;
		else
			is_collide_right_box = 1'b0;
		
		if (x_right_cen >= box_x_pos - 13 && x_right_cen <= box_x_pos - 10 && y >= box_y_pos - 30 && y <= box_y_pos + 20)
			is_collide_left_box = 1'b1;
		else
			is_collide_left_box = 1'b0;
			
		end
endmodule
