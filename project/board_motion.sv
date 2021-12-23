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


module  board_motion 
( 					input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input   		  is_button_push,
					input 		  is_girl_collide,
               output logic  is_board_yellow,             // Whether current pixel belongs to ball or background
					output logic [9:0] board_address_yellow,
					output logic [9:0] board_x_pos, board_y_pos
              );

	 
    parameter [9:0] board_x_center = 10'd58;  // Center position on the X axis
    parameter [9:0] board_y_center = 10'd258;  // Center position on the Y axis
	 
	 


    logic [9:0] board_x_motion, board_y_motion;
    logic [9:0] board_x_pos_in, board_x_motion_in, board_y_pos_in, board_y_motion_in;
    
	 
	 
	 enum logic [7:0] {STILL,
							 DOWN1,
							 DOWN2,
							 DOWN3,
							 DOWN4,
							 DOWN5,
							 DOWN6} curr_state, next_state;
	 
	 
	 
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
            board_x_pos <= board_x_center;
            board_y_pos <= board_y_center;
            board_x_motion <= 10'd0;
            board_y_motion <= 10'd0;
				curr_state <= STILL;
        end
        else
        begin
            board_x_pos <= board_x_pos_in;
            board_y_pos <= board_y_pos_in;
            board_x_motion <= board_x_motion_in;
            board_y_motion <= board_y_motion_in;
				curr_state <= next_state;
        end
    end
    //-------------------------------------------------------------------------------------------------------//
    
	 
    always_comb begin
         board_x_pos_in = board_x_pos;
         board_y_pos_in = board_y_pos;
			board_x_motion_in = board_x_motion;
			board_y_motion_in = board_y_motion;
         next_state = curr_state;
         if (frame_clk_rising_edge) begin
				unique case(curr_state)
					STILL: begin
						board_x_motion_in = 10'd0;
						board_y_motion_in = 10'd0;
						if (is_button_push == 1'b1) 
							next_state = DOWN1;
					end
					
					DOWN1: begin
						board_x_motion_in = 10'd0;
						board_y_motion_in = 10'd0;
						if (is_girl_collide == 1'b0)
							begin
								board_y_motion_in = 10'd1;
								if (board_y_pos == 10'd318)
									next_state = DOWN2;
							end
					end
					
					
					DOWN2: begin
						board_x_motion_in = 10'd0;
						board_y_motion_in = 10'd0;
					end
				endcase
				board_x_pos_in = board_x_pos + board_x_motion;
				board_y_pos_in = board_y_pos + board_y_motion;
			end
	 end
	 
	 
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
	 int DistX, DistY;
	 assign DistX = DrawX - board_x_pos;
    assign DistY = DrawY - board_y_pos;
    always_comb begin
        if (DistX >= -34 && DistX <= 34 && DistY >= -6 && DistY <= 6)
				is_board_yellow = 1'b1;
        else
            is_board_yellow = 1'b0;
				

		  if (is_board_yellow == 1'b1)
				board_address_yellow = (DrawX - board_x_pos + 34) + 68 * (DrawY - board_y_pos + 6);
		  else 
				board_address_yellow = 10'b0;
    end
    
endmodule
