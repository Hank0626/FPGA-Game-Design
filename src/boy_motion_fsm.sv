//-------------------------------------------------------------------------
//    boy_motion.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  boy_motion 
( 					input         Clk,                // 5c MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [9:0]   board_x_pos, board_y_pos,
					input [9:0]   board_purple_x_pos, board_purple_y_pos,
					input [9:0]   box_x_pos, box_y_pos,
               input [15:0]  keycode,       // added input for keycode
					input    	  is_board_up,
               output logic is_boy,             // Whether current pixel belongs to ball or background
					output logic [3:0]  boy_status,
					output logic [9:0] boy_address,
					output logic is_dead_boy,
					output logic is_win_boy,
					output logic is_diamond_eat1_red,
					output logic is_diamond_eat1_red1,
					output logic is_diamond_eat1_red2,
					output logic [3:0] num_eat_red,
					output logic is_button_push,
					output logic is_button_purple_push1,
					output logic is_button_purple_push2,
					output logic is_collide_up_board,
					output logic is_collide_up_board_purple,
					output logic is_collide_left_box,
					output logic is_collide_right_box
              );
    
	 
    parameter [9:0] boy_x_center = 10'd80;  // Center position on the X axis
    parameter [9:0] boy_y_center = 10'd442;  // Center position on the Y axis
	 
	 
    parameter [9:0] boy_x_step = 10'd1;      // Step size on the X axis
    parameter [9:0] boy_y_step = 10'd40;      // Step size on the Y axis
	 
	 
    enum logic [7:0] {STILL, LEFT, RIGHT, UP1, DOWN1} curr_state, next_state; 


    logic [9:0] boy_x_pos, boy_x_motion, boy_y_pos, boy_y_motion, max_up;
    logic [9:0] boy_x_pos_in, boy_x_motion_in, boy_y_pos_in, boy_y_motion_in, max_up_in;
    
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
            boy_x_pos <= boy_x_center;
            boy_y_pos <= boy_y_center;
            boy_x_motion <= 10'd0;
            boy_y_motion <= 10'd0;
				max_up <= 10'd0;
				curr_state <= STILL;
        end
        else
        begin
            boy_x_pos <= boy_x_pos_in;
            boy_y_pos <= boy_y_pos_in;
            boy_x_motion <= boy_x_motion_in;
            boy_y_motion <= boy_y_motion_in;
				max_up <= max_up_in;
				curr_state <= next_state;
        end
    end
    //-------------------------------------------------------------------------------------------------------//
    
	logic is_collide_up,
			is_collide_down,
			is_collide_left,
			is_collide_right,
			is_collide_left_end,
			is_collide_right_end,
			is_collide_left_top,
			is_collide_right_top;	
			
	// Determine the collide status of the boy
	collision collide(.x(boy_x_pos), 
							.y(boy_y_pos), 
							.width(20), 
							.height(40), 
							.is_collide_up, 
							.is_collide_down, 
							.is_collide_left, 
							.is_collide_right, 
							.is_collide_left_end, 
							.is_collide_right_end,
							.is_collide_left_top,
							.is_collide_right_top);
				
	// Deremine whether the boy is dead	
	dead_boy dg(.x(boy_x_pos),
					 .y(boy_y_pos),
					 .width(20),
					 .height(40),
					 .is_dead_boy);

	// Determine whether the boy is win
	win_boy wg(.x(boy_x_pos),
					.y(boy_y_pos),
					.width(20),
					.height(40),
					.is_win_boy);
					
	// Determine whether the blue diamond is eaten

	is_red_diamond_eat red_eat(.Clk,
										.Reset,
										.x(boy_x_pos),
										.y(boy_y_pos),
										.width(20),
										.height(40),
										.is_diamond_eat1_red,
										.is_diamond_eat1_red1,
										.is_diamond_eat1_red2,
										.num_eat_red);
										  
	// Determine the status of the button
	button_push button_push(.Clk,
								   .Reset,
								   .x(boy_x_pos),
								   .y(boy_y_pos),
								   .width(20),
								   .height(40),
								   .is_button_push);
	
	// Determine the status of the button_purple_1
	button_purple_push1 button_purple_push1(.Clk,
														 .Reset,
														 .x(boy_x_pos),
										             .y(boy_y_pos),
														 .width(20),
														 .height(40),
														 .is_button_purple_push1);

	button_purple_push2 button_purple_push2(.Clk,
														 .Reset,
														 .x(boy_x_pos),
										             .y(boy_y_pos),
														 .width(20),
														 .height(40),
														 .is_button_purple_push2);
														 
	logic is_collide_down_board, is_collide_down_board_purple;
	logic is_collide_left_board, is_collide_right_board_purple;
	
	collision_board cb(.x(boy_x_pos), 
							 .y(boy_y_pos), 
							 .width(20), 
							 .height(40),
							 .board_x_pos,
							 .board_y_pos,
							 .board_purple_x_pos,
							 .board_purple_y_pos,
							 .is_collide_down_board,
							 .is_collide_up_board,
							 .is_collide_left_board,
							 .is_collide_up_board_purple,
							 .is_collide_down_board_purple,
							 .is_collide_right_board_purple);

	logic is_collide_down_box;
	
	collision_box cb1(.x(boy_x_pos), 
							.y(boy_y_pos), 
							.width(20), 
							.height(40),
							.box_x_pos,
							.box_y_pos,
							.is_collide_left_box,
							.is_collide_right_box,
							.is_collide_down_box);
							
	always_comb begin
         boy_x_pos_in = boy_x_pos;
         boy_y_pos_in = boy_y_pos;
			boy_x_motion_in = boy_x_motion;
			boy_y_motion_in = boy_y_motion;
         next_state = curr_state;
			max_up_in = max_up;
         if (frame_clk_rising_edge)
				begin
				unique case(curr_state) 
					STILL: begin
						 max_up_in = max_up_in - max_up_in;
						 boy_x_motion_in = 10'd0;
						 boy_y_motion_in = 10'd0;
						 if (keycode == 16'h005c || keycode == 16'h5c00)
							  next_state = LEFT;
						 else if (keycode == 16'h005e || keycode == 16'h5e00)
							  next_state = RIGHT;
						 else if (keycode == 16'h6000 || keycode == 16'h0060)
							  next_state = UP1;
						 else if (keycode == 16'h605c || keycode == 16'h5c60)
							  begin
							  boy_x_motion_in = (~(boy_x_step) + 1'b1);
							  next_state = UP1;
							  end
						 else if (keycode == 16'h605e || keycode == 16'h5e60)
							  begin
							  boy_x_motion_in = boy_x_step;
							  next_state = UP1;
							  end	  
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0 && is_collide_down_board_purple == 1'b0 && is_collide_down_box == 1'b0)
							 next_state = DOWN1;
						 if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
							boy_y_motion_in = (~(3) + 1'b1);
					end

					LEFT: begin
						max_up_in = max_up_in - max_up_in;
						 if (is_collide_left == 1'b0 && is_collide_left_board == 1'b0 && is_collide_right_box == 1'b0)
						    begin
							 boy_x_motion_in = (~(boy_x_step) + 1'b1);
							 if (is_collide_left_end == 1'b1) 
								boy_y_motion_in = (~(2) + 1'b1);
							 else
								boy_y_motion_in = 10'd0;
							 end
						 else
							 begin
							 boy_x_motion_in = 10'd0;
							 end
						 if (is_collide_left_end == 1'b0)
						 begin
							next_state = DOWN1;
						 end
						 else
						 begin
							 if (keycode == 16'h0000)
								  next_state = STILL;
							 else if (keycode == 16'h005e || keycode == 16'h5e00)
								  next_state = RIGHT;
							 else if (keycode == 16'h605c || keycode == 16'h5c60)
							 begin
								  next_state = UP1;
							 end
							 else if (keycode == 16'h605e || keycode == 16'h5e60)
							 begin
								  next_state = UP1;
							 end
						 end
						 if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
							boy_y_motion_in = (~(1) + 1'b1);
						 if(is_collide_right_box == 1'b1) 
							next_state = STILL;
					end

					RIGHT: begin
						max_up_in = max_up_in - max_up_in;	
						 if (is_collide_right == 1'b0 && is_collide_right_board_purple == 1'b0 && is_collide_left_box == 1'b0)
							begin
							boy_x_motion_in = boy_x_step;
							if (is_collide_right_end == 1'b1) 
								boy_y_motion_in = (~(3) + 1'b1);
							 else
								boy_y_motion_in = 10'd0;
							end
						 else
							begin
							boy_x_motion_in = 10'd0;
							end
						 if (is_collide_right_end == 1'b0)
						 begin
							next_state = DOWN1;
						 end
						 else
						 begin
							 if (keycode == 16'h0000)
								  next_state = STILL;
							 else if (keycode == 16'h005c || keycode == 16'h5c00)
								  next_state = LEFT;
							 else if (keycode == 16'h605c || keycode == 16'h5c60 || keycode == 16'h605e || keycode == 16'h5e60)
							 begin
								  next_state = UP1;
							 end
						 end
						if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
							boy_y_motion_in = (~(1) + 1'b1);
						if (is_collide_left_box == 1'b1)
							next_state = STILL;
						 
					end

					UP1: begin
						 boy_x_motion_in = boy_x_motion;
						 if (is_collide_up == 1'b0 && is_collide_up_board == 1'b0 && is_collide_up_board_purple == 1'b0)
								begin
								if (max_up_in != 10'd30)
										begin
										if(max_up_in <= 10'd25)
											boy_y_motion_in = (~(2) + 1'b1);
										else
											begin
											boy_y_motion_in = (~(1) + 1'b1);
											end
										max_up_in = max_up_in + 1;
										end
								else
									begin
										next_state = DOWN1;
										//max_up_in = max_up_in - 10'd20;
										max_up_in = max_up_in - max_up_in;
									end
								end
						 else
								begin
								max_up_in = max_up_in - max_up_in;
								boy_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode != 16'h5c5e || keycode != 16'h5e5c) begin
							 if ((keycode[15:8] == 8'h5c || keycode[7:0] == 8'h5c) && is_collide_left == 1'b0 && is_collide_left_top == 1'b0)
								  boy_x_motion_in = (~(1) + 1'b1);
							 else if ((keycode[15:8] == 8'h5e || keycode[7:0] == 8'h5e) && is_collide_right == 1'b0 && is_collide_right_top == 1'b0)
								  boy_x_motion_in = 1;
							end
					end
					
					DOWN1: begin
					max_up_in = max_up_in - max_up_in;
						 boy_x_motion_in = 0;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0 && is_collide_down_board_purple == 1'b0 && is_collide_down_box == 1'b0)
								begin
								boy_y_motion_in = 1;
								end
						 else if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
								boy_y_motion_in = (~(1) + 1'b1);
						 else
								begin
								boy_y_motion_in = 0;
								next_state = STILL;
								end
						if (keycode != 16'h5c5e || keycode != 16'h5e5c) begin
						 if ((keycode[15:8] == 8'h5c || keycode[7:0] == 8'h5c) && is_collide_left == 1'b0 && is_collide_left_board == 1'b0)
							  boy_x_motion_in = (~(1) + 1'b1);
						 else if ((keycode[15:8] == 8'h5e || keycode[7:0] == 8'h5e) && is_collide_right == 1'b0 && is_collide_right_board_purple == 1'b0)
							  boy_x_motion_in = 1;
						end
					end

					default: begin
						 boy_x_motion_in = boy_x_motion;
						 boy_y_motion_in = boy_y_motion;
					end
				endcase
        boy_x_pos_in = boy_x_pos + boy_x_motion;
        boy_y_pos_in = boy_y_pos + boy_y_motion;
		  end
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY;
    assign DistX = DrawX - boy_x_pos;
    assign DistY = DrawY - boy_y_pos;

    always_comb begin
		  if ( DistX >= -10 && DistX <= 10 && DistY >= -20 && DistY <= 20) 
				is_boy = 1'b1;
		  else
				is_boy = 1'b0;
				
		  if (is_boy == 1'b1)
				boy_address = (DrawX - boy_x_pos + 10) + 20 * (DrawY - boy_y_pos + 20);
		  else 
				boy_address = 12'b0;
		if (keycode == 16'h0000)
			begin
			  boy_status = 4'b0000;
			end
		else if (keycode[15:8] == 8'h5e || keycode[7:0] == 8'h5e)
			begin
					boy_status = 4'b0001;
			end
		else if (keycode[15:8] == 8'h5c || keycode[7:0] == 8'h5c)
			begin
				boy_status = 4'b0010;
			end
		else
			begin
			  boy_status = 4'b0000;
			end
    end
    
endmodule
