
module board_rom
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


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