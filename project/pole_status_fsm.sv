//-------------------------------------------------------------------------
//    collision.sv                                                       --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module pole_status_det
(
			input 	Clk,
			input  	Reset,
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	[2:0] pole_status,
			output   is_collide_pole_down,
			output   is_collide_pole_left,
			output   is_collide_pole_right,
			output   is_collide_pole_left_end,
			output   is_collide_pole_right_end,
			output   board_yellow_down
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;
		logic [9:0] x1;
		logic [9:0] y1;

		assign x_left_cen = x - width / 2 - 140;
		assign x_right_cen = x + width / 2 - 140;
		
		assign y_top_cen = y - height / 2 - 310;
		assign y_bottom_cen = y + height / 2 - 310;

		assign x1 = x - 140;
		assign y1 = y - 310;
 		
		
		logic may_touch;
		
		logic [16:0] address1,
						 address2,
						 address3,
						 address4,
						 address5;
		
		assign address1 = x1 + y_bottom_cen *	24;  //bottom
		assign address2 = x_left_cen + y1 * 24;  //left
		assign address3 = x_right_cen + y1 * 24;  //right
		assign address4 = x1 - 10 + (y_bottom_cen - 1) * 24;  // left_end
		assign address5 = x1 + 10 + (y_bottom_cen - 1) * 24;  // right_end
		
		always_comb begin
			if ((x1 >= 0 && x1 < 24 && y_bottom_cen >= 0 && y_bottom_cen < 24) 						  ||
				 (x_left_cen >= 0 && x_left_cen < 24 && y1 >= 0 && y1 < 24)     						  ||
				 (x_right_cen >= 0 && x_right_cen < 24 && y1 >= 0 && y1 < 24)   						  ||
				 (x1 - 10 >= 0 && x1 - 10 < 24 && y_bottom_cen - 1 >= 0 && y_bottom_cen - 1 < 24)  ||
				 (x1 + 10 >= 0 && x1 + 10 < 24 && y_bottom_cen - 1 >= 0 && y_bottom_cen - 1 < 24)
				 )
				begin
					may_touch = 1'b1;
				end
			else
				begin
					may_touch = 1'b0;
				end
		end
		
		logic [23:0] col1,
						 col2,
						 col3,
						 col4,
						 col5,
						 col6,
						 col7,
						 col8,
						 col9,
						 col10,
						 col11,
						 col12,
						 col13,
						 col14,
						 col15;
		
		pole_right_rom color1(.read_address(address1), .color_output(col1));
		pole_right_rom color2(.read_address(address2), .color_output(col2));
		pole_right_rom color3(.read_address(address3), .color_output(col3));
		pole_right_rom color4(.read_address(address4), .color_output(col4));	
		pole_right_rom color5(.read_address(address5), .color_output(col5));			
		
		pole_mid_rom color6(.read_address(address1), .color_output(col6));
		pole_mid_rom color7(.read_address(address2), .color_output(col7));
		pole_mid_rom color8(.read_address(address3), .color_output(col8));
		pole_mid_rom color9(.read_address(address4), .color_output(col9));	
		pole_mid_rom color10(.read_address(address5), .color_output(col10));
		
		pole_left_rom color11(.read_address(address1), .color_output(col11));
		pole_left_rom color12(.read_address(address2), .color_output(col12));
		pole_left_rom color13(.read_address(address3), .color_output(col13));
		pole_left_rom color14(.read_address(address4), .color_output(col14));	
		pole_left_rom color15(.read_address(address5), .color_output(col15));
		
		enum logic [3:0] {POLE_RIGHT, POLE_MID, POLE_LEFT} curr_state, next_state;
		
		always_ff @ (posedge Clk)
		begin 
			if (Reset)
			begin
				curr_state <= POLE_RIGHT;
			end
			
			else
			begin
				curr_state <= next_state;
			end
		end
		
		always_comb begin
			next_state = curr_state;
			is_collide_pole_down = 1'b0;
			is_collide_pole_left = 1'b0;
			is_collide_pole_right = 1'b0;
			is_collide_pole_left_end = 1'b0;
			is_collide_pole_right_end = 1'b0;
			unique case(curr_state)
				POLE_RIGHT: begin
					pole_status = 3'b001;
					board_yellow_down = 1'b0;
					if (may_touch == 1'b1)
						begin
							if (col2 == 24'hceb244)
								begin
								is_collide_pole_left = 1'b1;
								next_state = POLE_MID;
								end
							else if (col5 == 24'hceb244)
								is_collide_pole_right_end = 1'b1;
							else if (col1 == 24'hceb244)
								is_collide_pole_down = 1'b1;
						end
				end
				
				POLE_MID: begin
					pole_status = 3'b010;
					board_yellow_down = 1'b0;
					if (may_touch == 1'b1)
						begin
							if (col7 == 24'hceb244 )
								begin
								is_collide_pole_right = 1'b1;
								next_state = POLE_RIGHT;
								end
							else if (col8 == 24'hceb244)
								begin
								next_state = POLE_LEFT;
								is_collide_pole_left = 1'b1;
								end
							else if (col6 == 24'hceb244)
								is_collide_pole_down = 1'b1;
						end
				end
				
				
				POLE_LEFT: begin
					pole_status = 3'b100;
					board_yellow_down = 1'b1;
					if (may_touch == 1'b1)
						begin
							if (col12 == 24'hceb244)
								begin
								next_state = POLE_MID;
								is_collide_pole_right = 1'b1;
								end
							else if (col14 == 24'hceb244)
								is_collide_pole_left_end = 1'b1;
							else if (col11 == 24'hceb244)
								is_collide_pole_down = 1'b1;
						end
				end
				
			endcase
				
		end
		
endmodule
