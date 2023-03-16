//-------------------------------------------------------------------------
//    game_logic.sv                                                      --                                                        --
//    Spring 2005                                                        --
//                                                                       --                                               --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------

module game_logic
(
			input  logic 			Clk, 				// 50 MHz clock
			input  logic 			Reset,			// Active-high reset signal
			input  logic         is_dead,
			input  logic         is_win,
			input  logic 	[15:0] keycode,			// Input from the keycode
			output logic   [3:0] status   		// Status of the game {Background, Begin, Win, Loose}
);


	// Finite state machine for status
	enum logic [3:0] {BACKGROUND, MAP, WIN, LOSE} curr_state, next_state;
	
	always_ff @ (posedge Clk)
	begin 
		if (Reset)
		begin
			curr_state <= BACKGROUND;
		end
		
		else
		begin
			curr_state <= next_state;
		end
	end
	
	always_comb
	begin
		// Default: Nothing happens
		next_state = curr_state;
		
		// Keycode Determine the next state
		unique case (curr_state)
			// Display the background
			BACKGROUND:
				begin
					status = 4'b0001;
					if (keycode[15:8] == 8'h28 || keycode[7:0] == 8'h28)  	// Press enter to start
						next_state = MAP;
					end
			MAP:
				begin
					status = 4'b0010;
					if (is_dead == 1'b1)
						next_state = LOSE;
					if (is_win == 1'b1)
						next_state = WIN;
				end
				
			WIN:
				begin
					status = 4'b0100;
				end

			LOSE:
				begin
					status = 4'b1000;
				end
			default: 
				status = 4'b0000; 			// Never happen
		endcase
	end
endmodule
	