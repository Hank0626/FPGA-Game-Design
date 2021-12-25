/*
 * File Name: map.sv
 * Module: map, map_rom
 * Usage: Display the initial background using the VGA
 *
 */

module map1 
(
		input  logic [3:0] status,				// Whether now is the background page	
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_map1,					// Whether current pixel belongs to background
		output logic [16:0] map1_address		// address for color mapper to figure out what color the logo pixel should be
);

always_comb
    begin
        if (status == 4'b0010)
        begin
            is_map1 = 1'b1;
				map1_address = DrawX / 4 + DrawY / 4 * 160;
        end
		  else
		  begin 
				is_map1 = 1'b0;
				map1_address = 18'b0;
			end
	end

endmodule
	
 
module map1_rom
(
		input  logic [16:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:160*120 - 1];

// We have 6 colors for background
logic [23:0] col [12:0];
assign col[0] = 24'hf80504; 	// red
assign col[1] = 24'h69ddfb;	// blue
assign col[2] = 24'h59e90c;	// green
assign col[3] = 24'h5f582b;	// brown1
assign col[4] = 24'h716734;	// brown2  				// Used to determine whether collision
assign col[5] = 24'h2d2e0c;	// brown3
assign col[6] = 24'h202100;	// brown4
assign col[7] = 24'h000000;	// black
assign col[8] = 24'hac0404; 	// red for dead
assign col[9] = 24'h4face5;	// blue for dead
assign col[10] = 24'h69a42a;	// green for dead




assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/mapd.txt", mem);
end


endmodule


//module map_collide_detect
//(
//		input  logic [999:0][16:0] address,
//		output logic is_collide
//);
//
//
//// mem has width of 4 bits and a total of 230399 addresses
//logic [3:0] mem [0:119999];
//
//// We have 6 colors for background
//logic [23:0] col [12:0];
//assign col[0] = 24'hf80504; 	// red
//assign col[1] = 24'h69ddfb;	// blue
//assign col[2] = 24'h59e90c;	// green
//assign col[3] = 24'h5f582b;	// brown1
//assign col[4] = 24'h716734;	// brown2  				// Used to determine whether collision
//assign col[5] = 24'h2d2e0c;	// brown3
//assign col[6] = 24'h202100;	// brown4
//assign col[7] = 24'h000000;	// black
//assign is_collide = 0;
//
//always_comb begin
//	for (int i = 0; i < 1000; i = i + 1)
//		begin
//			if (mem[address[i]] == 4)
//				is_collide = 1;
//		end
//	end
//
//initial
//begin
//	 //$readmemh("./sprite_bytes/map1.txt", mem);
//end
//
//
//endmodule
