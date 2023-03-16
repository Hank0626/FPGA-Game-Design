//-------------------------------------------------------------------------
//    dead.sv                                                      		 --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module win_girl
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_win_girl
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
		if (x_left_cen >= 560  && x_right_cen <= 608 && y_top_cen >= 50 && y_bottom_cen <= 120)
			is_win_girl = 1'b1;
		else
			is_win_girl = 1'b0;
		end

endmodule



module win_boy
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_win_boy
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
		if (x_left_cen >=  525 && x_right_cen <= 560 && y_top_cen >= 55 && y_bottom_cen <= 110)
			is_win_boy = 1'b1;
		else
			is_win_boy = 1'b0;
		end
endmodule



module gamewin 
(
		input  logic [3:0]    status,					// Whether now is the background page	
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_gamewin,					// Whether current pixel belongs to background
		output logic [11:0] gamewin_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (status == 4'b0100) 
	 begin
		is_gamewin = 1'b1;
		gamewin_address = DrawX * 3 / 32 + DrawY * 3 / 32 * 60;
	 end
	 else
	 begin
	   is_gamewin = 1'b0;
		gamewin_address = 18'b0;
	 end
	end

endmodule

module gamewin_rom
(
		input  logic [11:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:60*45-1];

// We have 6 colors for background
logic [23:0] col [3:0];

assign col[0] = 24'h000000;   // black
assign col[1] = 24'hdd8ad2; 	// pink

assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/win.txt", mem);
end


endmodule