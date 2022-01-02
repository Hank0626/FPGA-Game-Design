/*
 * File Name: map.sv
 * Module: map, map_rom
 * Usage: Display the initial background using the VGA
 *
 */

module map1 
(
		input  logic [3:0] status,				// Whether now is the map page	
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		output logic is_map1,					// Whether current pixel belongs to map
		output logic [16:0] map1_address		// address for color mapper to figure out what color the map pixel should be
);

always_comb
    begin
        if (status == 4'b0010)
        begin
            is_map1 = 1'b1;
				map1_address = DrawX * 5 / 16 + DrawY * 5 / 16 * 200;
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
logic [3:0] mem [0:200*150 - 1];

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
assign col[11] = 24'h776633;



assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/mapp1.txt", mem);
end


endmodule


module girl_word
(
		input  logic keyboardpress,
		input  logic [9:0] DrawX, DrawY,
		output logic is_girlword,					
		output logic [11:0] girlword_address
);
always_comb
    begin
        if (keyboardpress == 1'b0)
        begin
				if (DrawX >= 100 && DrawX < 200 && DrawY >= 358 && DrawY <= 388) begin
					is_girlword = 1'b1;
					girlword_address = (DrawX - 100) + (DrawY - 358) * 100;
					end
				else
				begin 
					is_girlword = 1'b0;
					girlword_address = 18'b0;
				end
        end
		  else
		  begin 
				is_girlword = 1'b0;
				girlword_address = 18'b0;
			end
	end

endmodule


module boy_word
(
		input  logic keyboardpress,
		input  logic [9:0] DrawX, DrawY,
		output logic is_boyword,					
		output logic [11:0] boyword_address
);

always_comb
    begin
        if (keyboardpress == 1'b0)
        begin
				if (DrawX >= 100 && DrawX < 200 && DrawY >= 425 && DrawY <= 455) begin
					is_boyword = 1'b1;
					boyword_address = (DrawX - 100) + (DrawY - 425) * 100;
					end
			  else
			  begin 
					is_boyword = 1'b0;
					boyword_address = 18'b0;
				end
        end
		  else
		  begin 
				is_boyword = 1'b0;
				boyword_address = 18'b0;
			end
	end

endmodule


module girlword_rom
(
		input  logic [11:0] read_address,
		output logic [23:0] color_output
);


logic [3:0] mem [0:100*30 - 1];

logic [23:0] col [3:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'hd8ca72;

assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/girlword.txt", mem);
end

endmodule

module boyword_rom
(
		input  logic [11:0] read_address,
		output logic [23:0] color_output
);


logic [3:0] mem [0:100*30 - 1];

logic [23:0] col [3:0];
assign col[0] = 24'hffffff;
assign col[1] = 24'hd8ca72;

assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/boyword.txt", mem);
end

endmodule