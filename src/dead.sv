//-------------------------------------------------------------------------
//    dead.sv                                                      		 --
//                                                                       --
//                                                                       --
//    For use with ECE 385                                               --
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

		assign address1 = x * 5 / 16 + y_bottom_cen * 5 / 16 * 200;  // bottom
		// Modify
		assign address2 = (x - 8) * 5 / 16 + (y_bottom_cen - 4) * 5 / 16 * 200;  // left_end
		assign address3 = (x + 8) * 5 / 16 + (y_bottom_cen - 4) * 5 / 16 * 200;  // right_end
		
		// ----------------------- Modify for more precise detect //
		
		
		logic [23:0] col1,
						 col2,
						 col3;
		
		map1_rom color1(.read_address(address1), .color_output(col1));
		map1_rom color2(.read_address(address2), .color_output(col2));
		map1_rom color3(.read_address(address3), .color_output(col3));
		
		// Remember to change the color
		always_comb begin
			if (col1 == 24'hac0404 || col1 == 24'h69a42a || col3 == 24'hac0404 || col3 == 24'h69a42a)
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

		assign address1 = x * 5 / 16 + y_bottom_cen * 5 / 16 * 200;  // bottom
		// Modify
		assign address2 = (x - 8) * 5 / 16 + (y_bottom_cen - 4) * 5 / 16 * 200;  // left_end
		assign address3 = (x + 8) * 5 / 16 + (y_bottom_cen - 4) * 5 / 16 * 200;  // right_end
		
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


module gameover 
(
		input  logic [3:0]    status,					// Whether now is the background page	
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_gameover,					// Whether current pixel belongs to background
		output logic [11:0] gameover_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (status == 4'b1000) 
	 begin
		is_gameover = 1'b1;
		gameover_address = DrawX * 3 / 32 + DrawY * 3 / 32 * 60;
	 end
	 else
	 begin
	   is_gameover = 1'b0;
		gameover_address = 18'b0;
	 end
	end

endmodule

module gameover_rom
(
		input  logic [11:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:60*45-1];

// We have 6 colors for background
logic [23:0] col [3:0];

assign col[0] = 24'h000000;   // black
assign col[1] = 24'hf80504; 	// red
assign col[2] = 24'h69ddfb;	// blue

assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/gameover.txt", mem);
end


endmodule