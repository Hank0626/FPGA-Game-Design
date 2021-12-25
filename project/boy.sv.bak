/*
 * File Name: girl.sv
 * Module: girl, girl_rom
 * Usage: Display the initial background using the VGA
 *
 */
	
module girl_rom
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:799];

// We have 6 colors for background
logic [23:0] col [3:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'h69ddfb;
assign col[2] = 24'h000000;

assign color_output = col[mem[read_address]];


initial
	begin
		$readmemh("./sprite_bytes/girl.txt", mem);
	end
endmodule


module girl_move1_rom
(
		input  logic [10:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:799];

// We have 6 colors for background
logic [23:0] col [3:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'h69ddfb;
assign col[2] = 24'h000000;

assign color_output = col[mem[read_address]];


initial
	begin
		$readmemh("./sprite_bytes/sg1.txt", mem);
	end
endmodule


module girl_move1_rom1
(
		input  logic [10:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:799];

// We have 6 colors for background
logic [23:0] col [3:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'h69ddfb;
assign col[2] = 24'h000000;

assign color_output = col[mem[read_address]];


initial
	begin
		$readmemh("./sprite_bytes/sg2.txt", mem);
	end
endmodule


module girl_move2_rom
(
		input  logic [10:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:799];

// We have 6 colors for background
logic [23:0] col [3:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'h69ddfb;
assign col[2] = 24'h000000;

assign color_output = col[mem[read_address]];


initial
	begin
		$readmemh("./sprite_bytes/sg11.txt", mem);
	end
endmodule

module girl_move2_rom1
(
		input  logic [10:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:799];

// We have 6 colors for background
logic [23:0] col [3:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'h69ddfb;
assign col[2] = 24'h000000;

assign color_output = col[mem[read_address]];


initial
	begin
		$readmemh("./sprite_bytes/sg21.txt", mem);
	end
endmodule
