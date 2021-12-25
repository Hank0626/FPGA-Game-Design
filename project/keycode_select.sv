module keycode_select(
				input  logic [15:0] keycode, keycode0,
				output logic [15:0] keycode_girl, keycode_boy);
	
	logic girl_left, girl_right, girl_up;
	logic boy_left, boy_right, boy_up;
	
	always_comb begin
		girl_left = 1'b0;
		girl_right = 1'b0;
		girl_up = 1'b0;
		boy_left = 1'b0;
		boy_right = 1'b0;
		boy_up = 1'b0;
		keycode_girl = 16'h0000;
		keycode_boy = 16'h0000;
		
		if (keycode[15:8] == 8'h50 || keycode[7:0] == 8'h50 || keycode0[15:8] == 8'h50 || keycode0[7:0] == 8'h50)
			boy_left = 1'b1;
		if (keycode[15:8] == 8'h4f || keycode[7:0] == 8'h4f || keycode0[15:8] == 8'h4f || keycode0[7:0] == 8'h4f)
			boy_right = 1'b1;		
		if (keycode[15:8] == 8'h52 || keycode[7:0] == 8'h52 || keycode0[15:8] == 8'h52 || keycode0[7:0] == 8'h52)
			boy_up = 1'b1;		
				
		if (keycode[15:8] == 8'h04 || keycode[7:0] == 8'h04 || keycode0[15:8] == 8'h04 || keycode0[7:0] == 8'h04)
			girl_left = 1'b1;
		if (keycode[15:8] == 8'h07 || keycode[7:0] == 8'h07 || keycode0[15:8] == 8'h07 || keycode0[7:0] == 8'h07)
			girl_right = 1'b1;
		if (keycode[15:8] == 8'h1a || keycode[7:0] == 8'h1a || keycode0[15:8] == 8'h1a || keycode0[7:0] == 8'h1a)
			girl_up = 1'b1;

		if (boy_up == 1'b1)
				keycode_boy = keycode_boy + 16'h5200;
		
		if (boy_left == 1'b1 && boy_right == 1'b1) begin
		end	
		else begin
			if (boy_left == 1'b1)
				keycode_boy = keycode_boy + 16'h0050;
			else if (boy_right == 1'b1)
				keycode_boy = keycode_boy + 16'h004f;
		
		end
		
		
		if (girl_up == 1'b1)
				keycode_girl = keycode_girl + 16'h1a00;
		
		if (girl_left == 1'b1 && girl_right == 1'b1) begin
		end
		else begin
			if (girl_left == 1'b1)
				keycode_girl = keycode_girl + 16'h0004;
			else if (girl_right == 1'b1)
				keycode_girl = keycode_girl + 16'h0007;
		end
		
			
			
	end
endmodule

