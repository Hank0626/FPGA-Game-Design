/*
 * File Name: box_display.sv
 * Module: box, box_rom
 * Usage: Display the box using the VGA
 *
 */
				
module box_rom
(
		input  logic [9:0] read_address,
		output logic [23:0] color_output
);


// mem has width of 4 bits and a total of 230399 addresses
logic [3:0] mem [0:575];

// We have 6 colors for box
logic [23:0] col [4:0];

assign col[0] = 24'hffffff; // white
assign col[1] = 24'hc7cdcd;	// grey
assign col[2] = 24'hf7dd3d;	// yellow


assign color_output = col[mem[read_address]];

initial
begin
	 $readmemh("./sprite_bytes/box.txt", mem);
end


endmodule

module box_collide
(
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output	is_collide_down,
						is_collide_left,
						is_collide_right
						
);
			logic	[9:0] x_left_cen;
			logic [9:0] x_right_cen;
			logic	[9:0] y_top_cen;
			logic [9:0] y_bottom_cen;

			assign x_left_cen = x - width / 2;
			assign x_right_cen = x + width / 2;		
			assign y_top_cen = y - height / 2;
			assign y_bottom_cen = y + height / 2;
		
			logic [16:0] address1,
							 address2,
							 address3;	
		
			assign address1 = x * 5 / 16 + y_bottom_cen * 5 / 16 * 200;  //bottom
			assign address2 = x_left_cen * 5 / 16 + y * 5 / 16 * 200;  //left
			assign address3 = x_right_cen * 5 / 16 + y * 5 / 16 * 200;  //right
		
			logic [23:0] col1,
							 col2,
							 col3;
							 
							 
			map1_rom color1(.read_address(address1), .color_output(col1));
			map1_rom color2(.read_address(address2), .color_output(col2));
			map1_rom color3(.read_address(address3), .color_output(col3));
			
			always_comb begin
			
				if (col1 == 24'h716734 || col1 == 24'h5f582b)
					is_collide_down = 1'b1;
				else
					is_collide_down = 1'b0;
					
				if (col2 == 24'h716734 || col2 == 24'h5f582b)
					is_collide_left = 1'b1;
				else
					is_collide_left = 1'b0;				
					
				if (col3 == 24'h716734 || col3 == 24'h5f582b)
					is_collide_right = 1'b1;
				else
					is_collide_right = 1'b0;				
					
			end
endmodule


module  box_motion 
( 					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input         is_box_left_push,
					input   		  is_box_right_push,
					output logic  is_box,
					output logic [9:0] box_address,
					output logic [9:0] box_x_pos, box_y_pos
              );

	 
    parameter [9:0] box_x_center = 10'd400;  // Center position on the X axis
    parameter [9:0] box_y_center = 10'd134;  // Center position on the Y axis
	 
	 


    logic [9:0] box_x_motion, box_y_motion;
    logic [9:0] box_x_pos_in, box_x_motion_in, box_y_pos_in, box_y_motion_in;
    
	 logic [9:0] max_down, max_down_in;
	 
	 enum logic [2:0] {STILL,
							 DOWN} curr_state, next_state;
	 
	 
	 
    //-------------------------------Do not modify the always_ff blocks. -----------------------------------//
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            box_x_pos <= box_x_center;
            box_y_pos <= box_y_center;
            box_x_motion <= 10'd0;
            box_y_motion <= 10'd0;
				curr_state <= STILL;
				max_down <= 10'd0;
		  end
        else
        begin
            box_x_pos <= box_x_pos_in;
            box_y_pos <= box_y_pos_in;
            box_x_motion <= box_x_motion_in;
            box_y_motion <= box_y_motion_in;
				curr_state <= next_state;
				max_down <= max_down_in;
        end
    end
    //-------------------------------------------------------------------------------------------------------//
    
	 logic is_collide_down,
			 is_collide_left,
			 is_collide_right;
	 
	 box_collide bc(.x(box_x_pos),
						 .y(box_y_pos),
						 .width(24),
						 .height(24),
						 .is_collide_down,
						 .is_collide_left,
						 .is_collide_right);
	 
    always_comb begin
         box_x_pos_in = box_x_pos;
         box_y_pos_in = box_y_pos;
			box_x_motion_in = box_x_motion;
			box_y_motion_in = box_y_motion;
         next_state = curr_state;
			max_down_in = max_down;
         if (frame_clk_rising_edge) begin
				unique case(curr_state)
					STILL: begin
						max_down_in = max_down_in - max_down_in;
						box_x_motion_in = 10'd0;
						box_y_motion_in = 10'd0;
						if (is_box_right_push == 1'b1 && is_collide_left == 1'b0 && is_collide_right == 1'b0) 
							box_x_motion_in = ~(1) + 1;
						else if (is_box_left_push == 1'b1 && is_collide_right == 1'b0 && is_collide_left == 1'b0) 
							box_x_motion_in = 1;
						if(is_collide_left == 1'b1 || is_collide_right == 1'b1)
							begin
							box_x_motion_in = 10'd0;
							box_y_motion_in = 10'd0;
							end
						if (is_box_left_push == 1'b1 && is_box_right_push == 1'b1)
							begin
							box_x_motion_in = 10'd0;
							box_y_motion_in = 10'd0;
							end
						if (is_collide_down == 1'b0)
							next_state = DOWN;
					end
					
					DOWN: begin
						if (max_down_in <= 10'd10)
							begin
							box_x_motion_in = ~(2) + 1;
							box_y_motion_in = 10'd1;
							end
						else if (max_down_in <= 10'd16)
							begin
							box_x_motion_in = ~(1) + 1;
							box_y_motion_in = 10'd1;
							end
						else 
							begin
							box_x_motion_in = 0;
							box_y_motion_in = 10'd1;
							end
						max_down_in = max_down_in + 1;
						if (is_collide_down == 1'b1)
							next_state = STILL;
					end
					
				endcase
				box_x_pos_in = box_x_pos + box_x_motion;
				box_y_pos_in = box_y_pos + box_y_motion;
			end
	 end
	 
	 
    // Compute whether the pixel corresponds to ball or background
	 int DistX, DistY;
	 assign DistX = DrawX - box_x_pos;
    assign DistY = DrawY - box_y_pos;
    always_comb begin
        if (DistX >= -12 && DistX <= 12 && DistY >= -12 && DistY <= 12)
				is_box = 1'b1;
        else
            is_box = 1'b0;
				

		  if (is_box == 1'b1)
				box_address = (DrawX - box_x_pos + 12) + 24 * (DrawY - box_y_pos + 12);
		  else 
				box_address = 10'b0;
    end
    
endmodule
