/*
 * File Name: blue_diamond_display.sv
 * Module: blue_diamond, blue_diamond_rom
 * Usage: Display the initial blue_diamond using the VGA
 *
 */

module button 
(
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_button,						  // Whether current pixel belongs to button
		output logic [7:0] button_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (DrawX >= 172 && DrawX < 192 && DrawY >= 241 && DrawY < 251) 
	 begin
		is_button = 1'b1;
		button_address = (DrawX - 172) + (DrawY - 241) * 20;
	 end
	 else
	 begin
	    is_button = 1'b0;
		button_address = 18'b0;
	 end
	end

endmodule
	
					
module button_rom
(
		input  logic [7:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:199];

// We have 3 colors for button
logic [23:0] col [3:0];

assign col[0] = 24'hffffff;
assign col[1] = 24'h9a12a2;
assign col[2] = 24'hefbe41;


assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/button.txt", mem);
end


endmodule

