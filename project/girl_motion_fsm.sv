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
               input [7:0]   keycode,       // added input for keycode
               output logic is_girl,             // Whether current pixel belongs to ball or background
					output logic is_girl_collide,
					output logic [3:0]  girl_status,
					output logic [9:0] girl_address,
					output logic is_dead_girl,
					output logic is_diamond_eat1,
					output logic is_button_push
              );
    
    parameter [9:0] girl_x_min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] girl_x_max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] girl_y_min = 10'd17;       // Topmost point on the Y axis
    parameter [9:0] girl_y_max = 10'd459;     // Bottommost point on the Y axis
	 
	 //
    parameter [9:0] girl_x_center = 10'd270;  // Center position on the X axis
    parameter [9:0] girl_y_center = 10'd410;  // Center position on the Y axis
	 
	 
    parameter [9:0] girl_x_step = 10'd1;      // Step size on the X axis
    parameter [9:0] girl_y_step = 10'd40;      // Step size on the Y axis
	 
	 
    enum logic [7:0] {STILL, 
							 LEFT, 
							 RIGHT, 
							 UP1, 
							 UP2, 
							 UP3, 
							 UP4, 
							 UP5, 
							 UP6, 
							 UP7, 
							 UP8, 
							 UP9, 
							 UP10, 
							 UP11, 
							 UP12, 
							 UP13, 
							 UP14, 
							 UP15, 
							 UP16,
							 UP17, 
							 UP18, 
							 UP19, 
							 UP20, 
							 UP21, 
							 UP22, 
							 UP23, 
							 UP24, 
							 UP25, 
//							 UP26, 
//							 UP27, 
//							 UP28, 
//							 UP29, 
//							 UP30, 
//							 UP31, 
//							 UP32,
							 DOWN1, 
							 DOWN2, 
							 DOWN3, 
							 DOWN4, 
							 DOWN5, 
							 DOWN6, 
							 DOWN7, 
							 DOWN8,
							 DOWN9, 
							 DOWN10, 
							 DOWN11, 
							 DOWN12, 
							 DOWN13, 
							 DOWN14, 
							 DOWN15, 
							 DOWN16,
							 DOWN17, 
							 DOWN18, 
							 DOWN19, 
							 DOWN20, 
							 DOWN21, 
							 DOWN22, 
							 DOWN23, 
							 DOWN24,
							 DOWN25
//							 DOWN26, 
//							 DOWN27, 
//							 DOWN28, 
//							 DOWN29, 
//							 DOWN30, 
//							 DOWN31, 
//							 DOWN32
							 } curr_state, next_state; 


    parameter [9:0] girl_gravity = 10'd2;      // Step size for gravity the Y axis
    //parameter [9:0] Ball_acceleration = 10'd2;
    parameter [9:0] girl_size = 10'd25;        // Ball size


    logic [9:0] girl_x_pos, girl_x_motion, girl_y_pos, girl_y_motion;
    logic [9:0] girl_x_pos_in, girl_x_motion_in, girl_y_pos_in, girl_y_motion_in;
    
	 
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
				curr_state <= STILL;
        end
        else
        begin
            girl_x_pos <= girl_x_pos_in;
            girl_y_pos <= girl_y_pos_in;
            girl_x_motion <= girl_x_motion_in;
            girl_y_motion <= girl_y_motion_in;
				curr_state <= next_state;
        end
    end
    //-------------------------------------------------------------------------------------------------------//
    
	logic is_collide_up,
			is_collide_down,
			is_collide_left,
			is_collide_right,
			is_collide_left_end,
			is_collide_right_end;	
	
//	logic is_collide_pole_down,
//			is_collide_pole_left,
//			is_collide_pole_right,
//			is_collide_pole_left_end,
//			is_collide_pole_right_end;
			
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
							.is_collide_right_end);
				
	// Deremine whether the girl is dead	
	dead_girl dg(.x(girl_x_pos),
					 .y(girl_y_pos),
					 .width(20),
					 .height(40),
					 .is_dead_girl);
					 
	// Determine whether the blue diamond is eaten

	is_blue_diamond_eat blue_eat(.Clk,
										  .Reset,
										  .x(girl_x_pos),
										  .y(girl_y_pos),
										  .width(20),
										  .height(40),
										  .is_diamond_eat1);
										  
	// Determine the status of the buttom
	button_push button_push(.Clk,
								   .Reset,
								   .x(girl_x_pos),
								   .y(girl_y_pos),
								   .width(20),
								   .height(40),
								   .is_button_push);
	
	logic is_collide_down_board;
	collision_board cb(.x(girl_x_pos), 
							 .y(girl_y_pos), 
							 .width(20), 
							 .height(40),
							 .board_x_pos,
							 .board_y_pos,
							 .is_collide_down_board);
							
	always_comb begin
         girl_x_pos_in = girl_x_pos;
         girl_y_pos_in = girl_y_pos;
			girl_x_motion_in = girl_x_motion;
			girl_y_motion_in = girl_y_motion;
         next_state = curr_state;
         if (frame_clk_rising_edge)
				begin
				unique case(curr_state) 
					STILL: begin
						 girl_x_motion_in = 10'd0;
						 girl_y_motion_in = 10'd0;
						 if (keycode == 8'h04)
							  next_state = LEFT;
						 else if (keycode == 8'h07)
							  next_state = RIGHT;
						 else if (keycode == 8'h1a)
							  next_state = UP1;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
							 next_state = DOWN1;
					end

					LEFT: begin
						 if (is_collide_left == 1'b0)
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
							 if (keycode == 8'h00)
								  next_state = STILL;
							 else if (keycode == 8'h04)
								  next_state = RIGHT;
							 else if (keycode == 8'h1a)
							 begin
								  next_state = UP1;
							 end
						 end
					end

					RIGHT: begin
						 if (is_collide_right == 1'b0)
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
							 if (keycode == 8'h00)
								  next_state = STILL;
							 else if (keycode == 8'h04)
								  next_state = LEFT;
							 else if (keycode == 8'h1a)
							 begin
								  next_state = UP1;
							 end
						 end
						 
					end

					UP1: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(10) + 1'b1);
								next_state = UP2;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP2: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(10) + 1'b1);
								next_state = UP3;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP3: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP4;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					UP4: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP5;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					
					UP5: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP6;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					UP6: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP7;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					UP7: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP8;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					UP8: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP9;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP9: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP10;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP10: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP11;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP11: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP12;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP12: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP13;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP13: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP14;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP14: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP15;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP15: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP16;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP16: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP17;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP17: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP18;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP18: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP19;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP19: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(2) + 1'b1);
								next_state = UP20;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP20: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(1) + 1'b1);
								next_state = UP21;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP21: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(1) + 1'b1);
								next_state = UP22;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP22: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(1) + 1'b1);
								next_state = UP23;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP23: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(1) + 1'b1);
								next_state = UP24;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP24: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(0) + 1'b1);
								next_state = UP25;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					UP25: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_up == 1'b0)
								begin
								girl_y_motion_in = (~(0) + 1'b1);
								next_state = DOWN1;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = DOWN1;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(2) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					DOWN1: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 0;
								next_state = DOWN2;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN2: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 0;
								next_state = DOWN3;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
			  
					DOWN3: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN4;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN4: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN5;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					DOWN5: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN6;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					DOWN6: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN7;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					DOWN7: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN8;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end
					
					DOWN8: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN9;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN9: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN10;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN10: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN11;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN11: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN12;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN12: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN13;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN13: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN14;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN14: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN15;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN15: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN16;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN16: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN17;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN17: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN18;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN18: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN19;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN19: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN20;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN20: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN21;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN21: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 2;
								next_state = DOWN22;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN22: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN23;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN23: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN24;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN24: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = DOWN25;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
					end

					DOWN25: begin
						 girl_x_motion_in = girl_x_motion;
						 if (is_collide_down == 1'b0 && is_collide_down_board == 1'b0)
								begin
								girl_y_motion_in = 1;
								next_state = STILL;
								end
						 else
								begin
								girl_y_motion_in = 0;
								next_state = STILL;
								end
						 if (keycode == 8'h04 && is_collide_left == 1'b0)
							  girl_x_motion_in = (~(girl_x_step) + 1'b1);
						 else if (keycode == 8'h07 && is_collide_right == 1'b0)
							  girl_x_motion_in = girl_x_step;
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
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - girl_x_pos;
    assign DistY = DrawY - girl_y_pos;
    assign Size = girl_size;
	 logic track;
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
		else if (keycode == 8'h07)
			begin
					girl_status = 4'b0001;
			end
		else if (keycode == 8'h04)
			begin
				girl_status = 4'b0010;
			end
		else
			begin
			  girl_status = 4'b0000;
			end
    end
    
endmodule
