//-------------------------------------------------------------------------
//    girl_motion.sv                                                            --
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


module  girl_motion 
( 					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [9:0]   board_x_pos, board_y_pos,
					input [9:0]   board_purple_x_pos, board_purple_y_pos,
					input [9:0]   box_x_pos, box_y_pos,
               input [15:0]   keycode,       // added input for keycode
					input    	  is_board_up,
               output logic is_girl,             // Whether current pixel belongs to ball or background
					output logic [3:0]  girl_status,
					output logic [9:0] girl_address,
					output logic is_dead_girl,
					output logic is_win_girl,
					output logic is_diamond_eat1,
					output logic is_diamond_eat2,
					output logic is_diamond_eat3,
					output logic [3:0] num_eat_blue,
					output logic is_button_push,
					output logic is_button_purple_push1,
					output logic is_button_purple_push2,
					output logic is_collide_up_board,
					output logic is_collide_up_board_purple,
					output logic is_collide_left_box,
					output logic is_collide_right_box
              );

    parameter [9:0] girl_x_center = 10'd80;  // Center position on the X axis
    parameter [9:0] girl_y_center = 10'd365;  // Center position on the Y axis
	 
	 
    parameter [9:0] girl_x_step = 10'd1;      // Step size on the X axis
    parameter [9:0] girl_y_step = 10'd40;      // Step size on the Y axis
	 
	 
    enum logic [7:0] {STILL, LEFT, RIGHT, UP1, DOWN1} curr_state, next_state; 


    logic [9:0] girl_x_pos, girl_x_motion, girl_y_pos, girl_y_motion, max_up;
    logic [9:0] girl_x_pos_in, girl_x_motion_in, girl_y_pos_in, girl_y_motion_in, max_up_in;
	 
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
            girl_x_pos <= girl_x_center;
            girl_y_pos <= girl_y_center;
            girl_x_motion <= 10'd0;
            girl_y_motion <= 10'd0;
				max_up <= 10'd0;
				curr_state <= STILL;
        end
        else
        begin
            girl_x_pos <= girl_x_pos_in;
            girl_y_pos <= girl_y_pos_in;
            girl_x_motion <= girl_x_motion_in;
            girl_y_motion <= girl_y_motion_in;
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
			
	// Determine the collide status of the girl
	collision collide(.x(girl_x_pos), 
							.y(girl_y_pos), 
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
				
	// Deremine whether the girl is dead	
	dead_girl dg(.x(girl_x_pos),
					 .y(girl_y_pos),
					 .width(20),
					 .height(40),
					 .is_dead_girl);
					 
	// Determine whether the girl is win
	win_girl wg(.x(girl_x_pos),
					.y(girl_y_pos),
					.width(20),
					.height(40),
					.is_win_girl);
	
	// Determine whether the blue diamond is eaten

	is_blue_diamond_eat blue_eat(.Clk,
										  .Reset,
										  .x(girl_x_pos),
										  .y(girl_y_pos),
										  .width(20),
										  .height(40),
										  .is_diamond_eat1,
										  .is_diamond_eat2,
										  .is_diamond_eat3,
										  .num_eat_blue);
										  
	// Determine the status of the button
	button_push button_push(.Clk,
								   .Reset,
								   .x(girl_x_pos),
								   .y(girl_y_pos),
								   .width(20),
								   .height(40),
								   .is_button_push);
	
	// Determine the status of the button_purple_1
	button_purple_push1 button_purple_push1(.Clk,
														 .Reset,
														 .x(girl_x_pos),
										             .y(girl_y_pos),
														 .width(20),
														 .height(40),
														 .is_button_purple_push1);

	button_purple_push2 button_purple_push2(.Clk,
														 .Reset,
														 .x(girl_x_pos),
										             .y(girl_y_pos),
														 .width(20),
														 .height(40),
														 .is_button_purple_push2);
														 
	logic is_collide_down_board, is_collide_down_board_purple;
	logic is_collide_left_board, is_collide_right_board_purple;
	
	// Determine the collision of the board
	collision_board cb(.x(girl_x_pos), 
							 .y(girl_y_pos), 
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
							 
	// Determine the collison of the box
	logic is_collide_down_box;
	
	collision_box cb1(.x(girl_x_pos), 
							.y(girl_y_pos), 
							.width(20), 
							.height(40),
							.box_x_pos,
							.box_y_pos,
							.is_collide_left_box,
							.is_collide_right_box,
							.is_collide_down_box);
		
							
	always_comb begin
         girl_x_pos_in = girl_x_pos;
         girl_y_pos_in = girl_y_pos;
			girl_x_motion_in = girl_x_motion;
			girl_y_motion_in = girl_y_motion;
         next_state = curr_state;
			max_up_in = max_up;
         if (frame_clk_rising_edge)
				begin
				unique case(curr_state) 
					STILL: begin
						 max_up_in = max_up_in - max_up_in;
						 girl_x_motion_in = 10'd0;
						 girl_y_motion_in = 10'd0;
						 if (keycode == 16'h0004 || keycode == 16'h0400)
							  next_state = LEFT;
						 else if (keycode == 16'h0007 || keycode == 16'h0700)
							  next_state = RIGHT;
						 else if (keycode == 16'h1a00 || keycode == 16'h001a)
							  next_state = UP1;
						 else if (keycode == 16'h1a04 || keycode == 16'h041a)
							  begin
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
							  next_state = UP1;
							  end
						 else if (keycode == 16'h1a07 || keycode == 16'h071a)
							  begin
							  girl_x_motion_in = girl_x_step;
							  next_state = UP1;
							  end	  
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0 && is_collide_down_board_purple == 1'b0 && is_collide_down_box == 1'b0)
							 next_state = DOWN1;
						 if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
							girl_y_motion_in = (~(3) + 1'b1);
					end

					LEFT: begin
						max_up_in = max_up_in - max_up_in;
						 if (is_collide_left == 1'b0 && is_collide_left_board == 1'b0 && is_collide_right_box == 1'b0)
						    begin
								girl_x_motion_in = (~(girl_x_step) + 1'b1);
							 if (is_collide_left_end == 1'b1) 
								girl_y_motion_in = (~(2) + 1'b1);
							 else
								girl_y_motion_in = 10'd0;
							 end
						 else
							 begin
							 girl_x_motion_in = 10'd0;
							 end
						 if (is_collide_left_end == 1'b0)
						 begin
							next_state = DOWN1;
						 end
						 else
						 begin
							 if (keycode == 16'h0000)
								  next_state = STILL;
							 else if (keycode == 16'h0007 || keycode == 16'h0700)
								  next_state = RIGHT;
							 else if (keycode == 16'h1a04 || keycode == 16'h041a)
							 begin
								  next_state = UP1;
							 end
							 else if (keycode == 16'h1a07 || keycode == 16'h071a)
							 begin
								  next_state = UP1;
							 end
						 end
						 if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
							girl_y_motion_in = (~(1) + 1'b1);
						 if (is_collide_right_box == 1'b1)
						    next_state = STILL;
					end

					RIGHT: begin
						max_up_in = max_up_in - max_up_in;	
						 if (is_collide_right == 1'b0 && is_collide_right_board_purple == 1'b0 && is_collide_left_box == 1'b0)
							begin
							girl_x_motion_in = girl_x_step;
							if (is_collide_right_end == 1'b1) 
								girl_y_motion_in = (~(2) + 1'b1);
							 else
								girl_y_motion_in = 10'd0;
							end
						 else
							begin
							girl_x_motion_in = 10'd0;
							end
						 if (is_collide_right_end == 1'b0)
						 begin
							next_state = DOWN1;
						 end
						 else
						 begin
							 if (keycode == 16'h0000)
								  next_state = STILL;
							 else if (keycode == 16'h0004 || keycode == 16'h0400)
								  next_state = LEFT;
							 else if (keycode == 16'h1a04 || keycode == 16'h041a || keycode == 16'h1a07 || keycode == 16'h071a)
							 begin
								  next_state = UP1;
							 end
						 end
						if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
							girl_y_motion_in = (~(1) + 1'b1);
						 if (is_collide_left_box == 1'b1)
						    next_state = STILL;
						 
					end

					UP1: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0 && is_collide_up_board == 1'b0 && is_collide_up_board_purple == 1'b0)
								begin
								if (max_up_in != 10'd30)
										begin
										if(max_up_in <= 10'd25)
											girl_y_motion_in = (~(2) + 1'b1);
										else
											begin
											girl_y_motion_in = (~(1) + 1'b1);
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
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode != 16'h0407 || keycode != 16'h0704) begin
							 if ((keycode[15:8] == 8'h04 || keycode[7:0] == 8'h04) && is_collide_left == 1'b0 && is_collide_left_top == 1'b0)
								  girl_x_motion_in = (~(1) + 1'b1);
							 else if ((keycode[15:8] == 8'h07 || keycode[7:0] == 8'h07) && is_collide_right == 1'b0 && is_collide_right_top == 1'b0)
								  girl_x_motion_in = 1;
							end
					end
					
					DOWN1: begin
					max_up_in = max_up_in - max_up_in;
						 girl_x_motion_in = 0;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0 && is_collide_down_board_purple == 1'b0 && is_collide_down_box == 1'b0)
								begin
								girl_y_motion_in = 1;
								end
						 else if (is_collide_down_board_purple == 1'b1 && is_board_up == 1'b1)
							  girl_y_motion_in = (~(1) + 1'b1);
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						if (keycode != 16'h0407 || keycode != 16'h0704) begin
						 if ((keycode[15:8] == 8'h04 || keycode[7:0] == 8'h04) && is_collide_left == 1'b0 && is_collide_left_board == 1'b0)
							  girl_x_motion_in = (~(1) + 1'b1);
						 else if ((keycode[15:8] == 8'h07 || keycode[7:0] == 8'h07) && is_collide_right == 1'b0 && is_collide_right_board_purple == 1'b0)
							  girl_x_motion_in = 1;
						end
					end

					default: begin
						 girl_x_motion_in = girl_x_motion;
						 girl_y_motion_in = girl_y_motion;
					end
				endcase
        girl_x_pos_in = girl_x_pos + girl_x_motion;
        girl_y_pos_in = girl_y_pos + girl_y_motion;
		  end
    end
    
    // Compute whether the pixel corresponds to ball or background
    int DistX, DistY;
    assign DistX = DrawX - girl_x_pos;
    assign DistY = DrawY - girl_y_pos;

	 // Use keycode to determine the status
    always_comb begin
		  if ( DistX >= -10 && DistX <= 10 && DistY >= -20 && DistY <= 20) 
				is_girl = 1'b1;
		  else
				is_girl = 1'b0;
				
		  if (is_girl == 1'b1)
				girl_address = (DrawX - girl_x_pos + 10) + 20 * (DrawY - girl_y_pos + 20);
		  else 
				girl_address = 12'b0;
		if (keycode == 8'h00)
			begin
			  girl_status = 4'b0000;
			end
		else if (keycode[15:8] == 8'h07 || keycode[7:0] == 8'h07)
			begin
					girl_status = 4'b0001;
			end
		else if (keycode[15:8] == 8'h04 || keycode[7:0] == 8'h04)
			begin
				girl_status = 4'b0010;
			end
		else
			begin
			  girl_status = 4'b0000;
			end
    end
    
endmodule
