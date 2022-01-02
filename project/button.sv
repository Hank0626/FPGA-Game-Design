
module button 
(
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		input  logic is_button_purple_push1,
		output logic is_button,			  
		output logic [7:0] button_address
);

always_comb
	begin
		if (is_button_purple_push1 == 1'b0)
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
		else
			begin
				 is_button = 1'b0;
				button_address = 18'b0;
			end
		
	end

endmodule

module button1
(
		input  logic [9:0] DrawX, DrawY,				// Current pixel coordinates
		input  logic is_button_purple_push2,
		output logic is_button1,
		output logic [7:0] button_address1
);

always_comb
	begin
		if (is_button_purple_push2 == 1'b0)
		begin
			 if (DrawX >= 520 && DrawX < 540 && DrawY >= 178 && DrawY < 188) 
			 begin
				is_button1 = 1'b1;
				button_address1 = (DrawX - 520) + (DrawY - 178) * 20;
			 end
			 else
			 begin
				 is_button1 = 1'b0;
				button_address1 = 18'b0;
			 end
		end
		else
			begin
				 is_button1 = 1'b0;
				button_address1 = 18'b0;
			end
		
	end

endmodule


					
module button_rom
(
		input  logic [7:0] read_address,
		output logic [23:0] color_output
);


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



module button_yellow 
(
		input  logic [9:0] DrawX, DrawY,
		input  logic is_button_push,
		output logic is_button_yellow,
		output logic [7:0] button_yellow_address
);

always_comb
	begin
	if (is_button_push == 1'b0) begin
		 if (DrawX >= 142 && DrawX < 162 && DrawY >= 322 && DrawY < 332) 
		 begin
			is_button_yellow = 1'b1;
			button_yellow_address = (DrawX - 142) + (DrawY - 322) * 20;
		 end
		 else
			begin
				 is_button_yellow = 1'b0;
				 button_yellow_address = 18'b0;
			end
	 end
	 else
	 begin
	    is_button_yellow = 1'b0;
		 button_yellow_address = 18'b0;
	 end
	end

endmodule

module button_yellow_rom
(
		input  logic [7:0] read_address,
		output logic [23:0] color_output
);

logic [3:0] mem [0:199];

// We have 3 colors for button
logic [23:0] col [3:0];

assign col[0] = 24'hffffff;
assign col[1] = 24'hb5b72a;
assign col[2] = 24'hefbe41;


assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/button_yellow.txt", mem);
end


endmodule
