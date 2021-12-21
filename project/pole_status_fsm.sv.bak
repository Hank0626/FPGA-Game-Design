//-------------------------------------------------------------------------
//    collision.sv                                                       --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module is_blue_diamond_eat
(
			input 	Clk,
			input  	Reset,
			input 	[9:0] x,
			input 	[9:0] y,
			input  	[6:0] width,
			input 	[6:0] height,
			output 	is_diamond_eat1
		);

		logic	[9:0] x_left_cen;
		logic [9:0] x_right_cen;
		logic	[9:0] y_top_cen;
		logic [9:0] y_bottom_cen;

		assign x_left_cen = x - width / 2;
		assign x_right_cen = x + width / 2;
		
		assign y_top_cen = y - height / 2;
		assign y_bottom_cen = y + height / 2;

		logic eat1;
		enum logic [3:0] {BEGIN, EAT1} curr_state, next_state;
		
		always_comb begin
			if (((x >= 458 && x < 478 && y_top_cen >= 408 && y_top_cen < 428) 		  					  ||
				 (x >= 458 && x < 478 && y_bottom_cen >= 408 && y_bottom_cen < 428) 						  ||
				 (x_left_cen >= 458 && x_left_cen < 478 && y >= 408 && y < 428) 	  						  ||
				 (x_right_cen >= 458 && x_right_cen < 478 && y >= 408 && y < 428)   						  ||
				 (x - 8 >= 458 && x - 8 < 478 && y_bottom_cen - 4 >= 408 && y_bottom_cen - 4 < 428)   ||
				 (x + 8 >= 458 && x + 8 < 478 && y_bottom_cen + 4 >= 408 && y_bottom_cen + 4 < 428)   ||
				 (x - 8 >= 458 && x - 8 < 478 && y_top_cen - 4 >= 408 && y_top_cen - 4 < 428)   		  ||
				 (x + 8 >= 458 && x + 8 < 478 && y_top_cen + 4 >= 408 && y_top_cen + 4 < 428))        
				 )
				 eat1 = 1'b1;
			else
				 eat1 = 1'b0;
		end
		
		always_ff @ (posedge Clk)
			begin 
				if (Reset)
				begin
					curr_state <= BEGIN;
				end
				
				else
				begin
					curr_state <= next_state;
				end
			end
		
		always_comb begin
			next_state = curr_state;
			unique case (curr_state)
				BEGIN: begin
					is_diamond_eat1 = 1'b0;
					if (eat1 == 1'b1) 
						next_state = EAT1;
				end
				EAT1: begin
					is_diamond_eat1 = 1'b1;
				end 
			endcase
					
		end		
endmodule
