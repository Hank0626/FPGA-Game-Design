//-------------------------------------------------------------------------
//    dead.sv                                                      		 --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module dead_girl
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_dead_girl
			);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign y_bottom_cen = y + height / 2;


		logic [16:0] address1,
						 address2,
						 address3;

		assign address1 = x / 4 + y_bottom_cen / 4 * 160;  // bottom
		// Modify
		assign address2 = (x - 8) / 4 + (y_bottom_cen - 4) / 4 * 160;  // left_end
		assign address3 = (x + 8) / 4 + (y_bottom_cen - 4) / 4 * 160;  // right_end
		
		// ----------------------- Modify for more precise detect //
		
		
		logic [23:0] col1,
						 col2,
						 col3;
		
		map1_rom color1(.read_address(address1), .color_output(col1));
		map1_rom color2(.read_address(address2), .color_output(col2));
		map1_rom color3(.read_address(address3), .color_output(col3));
		
		// Remember to change the color
		always_comb begin
			if (col1 == 24'hac0404 || col1 == 24'h69a42a || col2 == 24'hac0404 || col2 == 24'h69a42a || col3 == 24'hac0404 || col3 == 24'h69a42a)
				is_dead_girl = 1'b1;
			else
				is_dead_girl = 1'b0;
		end
endmodule

module dead_boy
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_dead_boy
			);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign y_bottom_cen = y + height / 2;


		logic [16:0] address1,
						 address2,
						 address3;

		assign address1 = x / 4 + y_bottom_cen / 4 * 160;  // bottom
		// Modify
		assign address2 = (x - 8) / 4 + (y_bottom_cen - 4) / 4 * 160;  // left_end
		assign address3 = (x + 8) / 4 + (y_bottom_cen - 4) / 4 * 160;  // right_end
		
		// ----------------------- Modify for more precise detect //
		
		
		logic [23:0] col1,
						 col2,
						 col3;
		
		map1_rom color1(.read_address(address1), .color_output(col1));
		map1_rom color2(.read_address(address2), .color_output(col2));
		map1_rom color3(.read_address(address3), .color_output(col3));
		
		// Remember to change the color
		always_comb begin
			if (col1 == 24'h4face5 || col1 == 24'h69a42a || col2 == 24'h4face5 || col2 == 24'h69a42a || col3 == 24'h4face5 || col3 == 24'h69a42a)
				is_dead_boy = 1'b1;
			else
				is_dead_boy = 1'b0;
		end
endmodule
