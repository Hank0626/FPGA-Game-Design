/*
 * File Name: blue_diamond_display.sv
 * Module: blue_diamond, blue_diamond_rom
 * Usage: Display the initial blue_diamond using the VGA
 *
 */

module board 
(
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_board,						  // Whether current pixel belongs to board
		output logic [9:0] board_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (DrawX >= 556 && DrawX < 624 && DrawY >= 204 && DrawY < 216) 
	 begin
		is_board = 1'b1;
		board_address = (DrawX - 556) + (DrawY - 204) * 68;
	 end
	 else
	 begin
	    is_board = 1'b0;
		board_address = 18'b0;
	 end
	end

endmodule

module board_yellow
(
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_board_yellow,						  // Whether current pixel belongs to board
		output logic [9:0] board_address_yellow		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (DrawX >= 24 && DrawX < 92 && DrawY >= 252 && DrawY < 264) 
	 begin
		is_board_yellow = 1'b1;
		board_address_yellow = (DrawX - 24) + (DrawY - 252) * 68;
	 end
	 else
	 begin
	    is_board_yellow= 1'b0;
		board_address_yellow = 18'b0;
	 end
	end

endmodule
	


					
module board_rom
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:815];

// We have 3 colors for board
logic [23:0] col [3:0];

assign col[0] = 24'h9a12a2;
assign col[1] = 24'h000000;
assign col[2] = 24'hdcdcd9;

assign color_output = col[mem[read_address]];
initial
begin
	 $readmemh("./sprite_bytes/board.txt", mem);
end
endmodule


module board_rom_yellow
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:815];

// We have 3 colors for board
logic [23:0] col [3:0];

assign col[0] = 24'hdcdcd9;
assign col[1] = 24'hacad69;
assign col[2] = 24'h000000;



assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/board_yellow.txt", mem);
end


endmodule