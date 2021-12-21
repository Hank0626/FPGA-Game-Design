/*
 * File Name: blue_diamond_display.sv
 * Module: blue_diamond, blue_diamond_rom
 * Usage: Display the initial blue_diamond using the VGA
 *
 */

module pole
(
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_pole,						  // Whether current pixel belongs to board
		output logic [9:0] pole_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (DrawX >= 140 && DrawX < 164 && DrawY >= 310 && DrawY < 334) 
	 begin
		is_pole = 1'b1;
		pole_address = (DrawX - 140) + (DrawY - 310) * 24;
	 end
	 else
	 begin
	    is_pole = 1'b0;
		pole_address = 18'b0;
	 end
	end

endmodule


					
module pole_mid_rom
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:575];

// We have 3 colors for board
logic [23:0] col [2:0];

assign col[0] = 24'hffffff;
assign col[1] = 24'hceb244;

assign color_output = col[mem[read_address]];
initial
begin
	 $readmemh("./sprite_bytes/pole_mid.txt", mem);
end
endmodule


module pole_left_rom
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:575];

// We have 3 colors for board
logic [23:0] col [2:0];

assign col[0] = 24'hffffff;
assign col[1] = 24'hceb244;

assign color_output = col[mem[read_address]];
initial
begin
	 $readmemh("./sprite_bytes/pole_left.txt", mem);
end
endmodule


module pole_right_rom
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:575];

// We have 3 colors for board
logic [23:0] col [2:0];

assign col[0] = 24'hffffff;
assign col[1] = 24'hceb244;

assign color_output = col[mem[read_address]];
initial
begin
	 $readmemh("./sprite_bytes/pole_right.txt", mem);
end
endmodule
