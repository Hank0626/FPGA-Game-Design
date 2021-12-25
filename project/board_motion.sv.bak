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
               input [7:0]   keycode,       // added input for keycode
               output logic  is_girl,             // Whether current pixel belongs to ball or background
					output logic [10:0] girl_address
              );
    
    parameter [9:0] girl_x_min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] girl_x_max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] girl_y_min = 10'd17;       // Topmost point on the Y axis
    parameter [9:0] girl_y_max = 10'd459;     // Bottommost point on the Y axis
	 
	 //
    parameter [9:0] girl_x_center = 10'd80;  // Center position on the X axis
    parameter [9:0] girl_y_center = 10'd350;  // Center position on the Y axis
	 
	 
	 
    parameter [9:0] girl_x_step = 10'd2;      // Step size on the X axis
    parameter [9:0] girl_y_step = 10'd25;      // Step size on the Y axis
	 



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
            girl_y_motion <= girl_y_step;
				curr_state <= still;
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
    
	 
	 
	 
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        girl_x_pos_in = girl_x_pos;
        girl_y_pos_in = girl_y_pos;
        girl_x_motion_in = girl_x_motion;
        girl_y_motion_in = girl_y_motion;
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. girl_y_pos - girl_size <= Ball_Y_Min 
            // If girl_y_pos is 0, then girl_y_pos - girl_size will not be -4, but rather a large positive number.

			case (keycode[7:0])
					 // A: moving left
					 
                8'h04: begin
                    girl_x_motion_in = (~(girl_x_step) + 1'b1);
						  if (girl_y_motion_in == girl_gravity) 
								begin
									if( girl_y_pos + girl_size > girl_y_max) 
										begin // Ball is at the bottom edge, BOUNCE!
											girl_y_motion_in = 0;  
											girl_x_motion_in = 0;
										end
									else if ( girl_y_pos <= girl_y_min + girl_size ) 
										begin // Ball is at the top edge, BOUNCE!
											girl_y_motion_in = girl_y_step;
											girl_x_motion_in = 0;  	
										end
								end
                end
					 
					 // D: moving right
                8'h07: 
					 begin    
                    girl_x_motion_in = girl_x_step;
						  if (girl_y_motion_in == girl_gravity) 
								begin
									if( girl_y_pos + girl_size > girl_y_max) 
										begin // Ball is at the bottom edge, BOUNCE!
											girl_y_motion_in = 0;  
											girl_x_motion_in = 0;
										end
									else if ( girl_y_pos <= girl_y_min + girl_size ) 
										begin // Ball is at the top edge, BOUNCE!
											girl_y_motion_in = girl_y_step;
											girl_x_motion_in = 0;  	
										end
								end
                end
					 // W: jump
                8'h1a: 
					 begin 
							if( girl_y_pos + girl_size > girl_y_max) 
							begin
								girl_y_motion_in = (~(girl_y_step) + 1'b1);
							end
							else
							begin
								girl_y_motion_in = girl_gravity;
								
							end
                end
					 
					 16'h041a:
					 	begin 
							if( girl_y_pos + girl_size > girl_y_max) 
							begin
								girl_x_motion_in = (~(girl_x_step) + 1'b1);
								girl_y_motion_in = (~(girl_y_step) + 1'b1);
							end
							else
							begin
								girl_x_motion_in = (~(girl_x_step) + 1'b1);
								girl_y_motion_in = girl_gravity;
								
							end
                end
					 
                //endcase
                //end
			    default:
				begin
							girl_y_motion_in = girl_gravity;
							if( girl_y_pos + girl_size > girl_y_max) 
                        begin // Ball is at the bottom edge, BOUNCE!
                        girl_y_motion_in = 0;  
					         girl_x_motion_in = 0;
				        end
                    else if ( girl_y_pos <= girl_y_min + girl_size ) 
					    begin // Ball is at the top edge, BOUNCE!
                        girl_y_motion_in = girl_y_step;
					         girl_x_motion_in = 0;  	
				        end
                    if (girl_x_pos + girl_size >= girl_x_max) 
					    begin
                        girl_x_motion_in = (~(girl_x_step) + 1'b1);
                        girl_y_motion_in = 0;
                        end
                    else if ( girl_x_pos <= girl_x_min + girl_size) 
					    begin
                        girl_x_motion_in = girl_x_step;
                        girl_y_motion_in = 0;
                        end
                end
            endcase
            
            
            // Update the ball's position with its motion
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
    always_comb begin
//        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
//            is_ball = 1'b1;
//        else
//            is_ball = 1'b0;
        if ( DistX >= -15 && DistX <= 15 && DistY >= -25 && DistY <= 25) 
				is_girl = 1'b1;
        else
            is_girl = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
		  if (is_girl == 1'b1)
				girl_address = (DrawX - girl_x_pos + 15) + 30 * (DrawY - girl_y_pos + 25);
		  else 
				girl_address = 12'b0;
    end
    
endmodule
