/*
 * File Name: background.sv
 * Module: background, background_rom
 * Usage: Display the initial background using the VGA
 *
 */

module background 
(
		input  logic [3:0]    status,					// Whether now is the background page	
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_background,					// Whether current pixel belongs to background
		output logic [16:0] background_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (status == 4'b0001) 
	 begin
		is_background = 1'b1;
		background_address = DrawX * 5 / 8 + DrawY * 5 / 8 * 400;
	 end
	 else
	 begin
	   is_background = 1'b0;
		background_address = 18'b0;
	 end
	end

endmodule
	
					
module background_rom
(
		input  logic [16:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:400*300-1];

// We have 6 colors for background
logic [23:0] col [7:0];
assign col[0] = 24'hf80504; 	// red
assign col[1] = 24'h69ddfb;	// blue
assign col[2] = 24'hf9de7a;	// yellow
assign col[3] = 24'h796e36;	// brown1
assign col[4] = 24'h444123;	// bronw2
assign col[5] = 24'h807029;	// brown3
assign col[6] = 24'h2f2c1a;	// brown4
assign col[7] = 24'h000000;	// black

assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/background1.txt", mem);
end


endmodule



module designer 
(	
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_designer,					// Whether current pixel belongs to background
		output logic [12:0] designer_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
	begin
	 if (DrawX >= 400 && DrawX < 600 && DrawY >= 420 && DrawY < 450) 
	 begin
		is_designer = 1'b1;
		designer_address = DrawX - 400 + (DrawY - 420) * 200;
	 end
	 else
	 begin
	   is_designer = 1'b0;
		designer_address = 18'b0;
	 end
	end

endmodule

module designer_rom
(
		input  logic [12:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:200*30-1];

// We have 6 colors for background
logic [23:0] col [2:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'hc2ae4d;

assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/designer.txt", mem);
end


endmodule