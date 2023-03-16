//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper 
( 								
							  input  logic [3: 0]   status,
							  input  logic          is_gameover,
							  input  logic          is_girl, is_boy,
							  input  logic   			is_girlword, is_boyword,
							  input  logic [3: 0]   girl_status, boy_status,
							  input 	logic				is_background,
							  input 	logic				is_map1,
							  input  logic 			is_blue_diamond,
							  input  logic          is_blue_diamond1,
							  input  logic          is_blue_diamond2,
							  input  logic   			is_red_diamond,
							  input  logic   			is_red_diamond1,
							  input  logic   			is_red_diamond2,
							  input  logic 			is_board,
							  input  logic 			is_board_yellow,
							  input  logic  			is_button,
							  input  logic   			is_button1,
							  input  logic 			is_button_yellow,
							  input  logic 			is_box,
							  input  logic          is_designer,
							  input 	logic [16:0]   map1_address,
							  input 	logic [16:0]   background_address,
							  input  logic [9:0]   	girl_address, boy_address,
							  input  logic [11:0]   girlword_address, boyword_address,
							  input  logic [8:0]   	blue_diamond_address,
							  input  logic [8:0]   	blue_diamond_address1,
							  input  logic [8:0]   	blue_diamond_address2,
							  input  logic [8:0]   	red_diamond_address,
							  input  logic [8:0]   	red_diamond_address1,
							  input  logic [8:0]   	red_diamond_address2,
							  input  logic [9:0]   	board_address,
							  input  logic [9:0]    board_address_yellow,
							  input  logic [7:0]    button_address,
							  input  logic [7:0]    button_address1,
							  input  logic [7:0]    button_yellow_address,
							  input 	logic [9:0] 	box_address,
							  input  logic [12:0]   designer_address,
							  input  logic [11:0]   gameover_address,
							  input  logic [11:0]   gamewin_address,
                       input  logic [9: 0]   DrawX, DrawY,       			// Current pixel coordinates
                       output logic [7: 0]   VGA_R, VGA_G, VGA_B 			// VGA RGB output
);
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 // Output color signal
    logic [23:0] output_color_background,
					  output_color_gameover,
					  output_color_gamewin,
					  output_color_map1,
					  output_color_blue_diamond,
					  output_color_blue_diamond1,
					  output_color_blue_diamond2,
					  output_color_red_diamond,
					  output_color_red_diamond1,
					  output_color_red_diamond2,
					  output_color_board,
					  output_color_board_yellow,
					  output_color_button,
					  output_color_button1,
					  output_color_button_yellow,
					  output_color_box,
					  output_color_girl0,
					  output_color_girl1,
					  output_color_girl2,
					  output_color_girl11,
					  output_color_girl21,
					  output_color_boy0,
					  output_color_boy1,
					  output_color_boy2,
					  output_color_boy11,
					  output_color_boy21,
					  output_color_girlword,
					  output_color_boyword,
					  output_color_designer;
	 
// ------------------ Calculate the color based on the address -------------------------

	 background_rom background(.read_address(background_address), .color_output(output_color_background));
	 map1_rom map1(.read_address(map1_address), .color_output(output_color_map1));
	 gameover_rom gameover(.read_address(gameover_address), .color_output(output_color_gameover));
	 gamewin_rom gamewin(.read_address(gamewin_address), .color_output(output_color_gamewin));
	 blue_diamond_rom bd1(.read_address(blue_diamond_address), .color_output(output_color_blue_diamond));
	 blue_diamond_rom bd2(.read_address(blue_diamond_address1), .color_output(output_color_blue_diamond1));
	 blue_diamond_rom bd3(.read_address(blue_diamond_address2), .color_output(output_color_blue_diamond2));
	 red_diamond_rom rd1(.read_address(red_diamond_address), .color_output(output_color_red_diamond));
	 red_diamond_rom rd2(.read_address(red_diamond_address1), .color_output(output_color_red_diamond1));
	 red_diamond_rom rd3(.read_address(red_diamond_address2), .color_output(output_color_red_diamond2));
	 board_rom board(.read_address(board_address), .color_output(output_color_board));
	 board_rom_yellow board_yellow(.read_address(board_address_yellow), .color_output(output_color_board_yellow));
	 button_rom button(.read_address(button_address), .color_output(output_color_button));
	 button_rom button1(.read_address(button_address1), .color_output(output_color_button1));
	 button_yellow_rom button_yellow(.read_address(button_yellow_address), .color_output(output_color_button_yellow));
	 box_rom box(.read_address(box_address), .color_output(output_color_box));
	 
	 // ------------------------------------- girl ---------------------------------------------------
	 girl_rom girl(.read_address(girl_address), .color_output(output_color_girl0));
	 girl_move1_rom girl1(.read_address(girl_address), .color_output(output_color_girl1));
	 girl_move1_rom1 girl11(.read_address(girl_address), .color_output(output_color_girl11));
	 girl_move2_rom girl2(.read_address(girl_address), .color_output(output_color_girl2));
	 girl_move2_rom1 girl21(.read_address(girl_address), .color_output(output_color_girl21));
	 // -----------------------------------------------------------------------------------------------
	 girlword_rom gwr(.read_address(girlword_address), .color_output(output_color_girlword));
	 
	 // ------------------------------------- girl ---------------------------------------------------
	 boy_rom boy(.read_address(boy_address), .color_output(output_color_boy0));
	 boy_move1_rom boy1(.read_address(boy_address), .color_output(output_color_boy1));
	 boy_move1_rom1 boy11(.read_address(boy_address), .color_output(output_color_boy11));
	 boy_move2_rom boy2(.read_address(boy_address), .color_output(output_color_boy2));
	 boy_move2_rom1 boy21(.read_address(boy_address), .color_output(output_color_boy21));
	 // -----------------------------------------------------------------------------------------------
	 boyword_rom bwr(.read_address(boyword_address), .color_output(output_color_boyword));
	 
	 designer_rom dr(.read_address(designer_address), .color_output(output_color_designer));
// ------------------ Calculate the color based on the address ------------------------- 


    always_comb
    begin
		if (status == 4'b0001 && is_background == 1'b1)
			begin
				Red   = output_color_background[23:16];
				Green = output_color_background[15:8];
				Blue  = output_color_background[7:0];
			end
		else if (status == 4'b0010)
			begin
				if (is_map1 == 1'b1)
					begin
						if (is_girl == 1'b1) begin
							if (girl_status == 4'b0000 && output_color_girl0 != 24'hffffff)
								begin
									Red   = output_color_girl0[23:16];
									Green = output_color_girl0[15:8];
									Blue  = output_color_girl0[7:0];
								end
							else if(girl_status == 4'b0001)
								begin
									if ((DrawX % 8 == 0 || DrawX % 8 == 1 || DrawX % 8 == 2 || DrawX % 8 == 3)) 
									begin
										if (output_color_girl1 != 24'hffffff)
										begin
											Red   = output_color_girl1[23:16];
											Green = output_color_girl1[15:8];
											Blue  = output_color_girl1[7:0];
										end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
									else 
									begin
										if (output_color_girl11 != 24'hffffff)
											begin
											Red   = output_color_girl11[23:16];
											Green = output_color_girl11[15:8];
											Blue  = output_color_girl11[7:0];
											end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
								end
							else if(girl_status == 4'b0010)
								begin
									if ((DrawX % 8 == 0 || DrawX % 8 == 1 || DrawX % 8 == 2 || DrawX % 8 == 3)) 
									begin
										if (output_color_girl2 != 24'hffffff)
										begin
											Red   = output_color_girl2[23:16];
											Green = output_color_girl2[15:8];
											Blue  = output_color_girl2[7:0];
										end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
									else 
									begin
										if (output_color_girl21 != 24'hffffff)
											begin
											Red   = output_color_girl21[23:16];
											Green = output_color_girl21[15:8];
											Blue  = output_color_girl21[7:0];
											end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
								end
							else
								begin
									Red   = output_color_map1[23:16];
									Green = output_color_map1[15:8];
									Blue  = output_color_map1[7:0];
								end
							end
						else if (is_boy == 1'b1) begin
							if (boy_status == 4'b0000 && output_color_boy0 != 24'hffffff)
								begin
									Red   = output_color_boy0[23:16];
									Green = output_color_boy0[15:8];
									Blue  = output_color_boy0[7:0];
								end
							else if(boy_status == 4'b0001)
								begin
									if ((DrawX % 8 == 0 || DrawX % 8 == 1 || DrawX % 8 == 2 || DrawX % 8 == 3)) 
									begin
										if (output_color_boy1 != 24'hffffff)
										begin
											Red   = output_color_boy1[23:16];
											Green = output_color_boy1[15:8];
											Blue  = output_color_boy1[7:0];
										end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
									else 
									begin
										if (output_color_boy11 != 24'hffffff)
											begin
											Red   = output_color_boy11[23:16];
											Green = output_color_boy11[15:8];
											Blue  = output_color_boy11[7:0];
											end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
								end
							else if(boy_status == 4'b0010)
								begin
									if ((DrawX % 8 == 0 || DrawX % 8 == 1 || DrawX % 8 == 2 || DrawX % 8 == 3)) 
									begin
										if (output_color_boy2 != 24'hffffff)
										begin
											Red   = output_color_boy2[23:16];
											Green = output_color_boy2[15:8];
											Blue  = output_color_boy2[7:0];
										end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
									else 
									begin
										if (output_color_boy21 != 24'hffffff)
											begin
											Red   = output_color_boy21[23:16];
											Green = output_color_boy21[15:8];
											Blue  = output_color_boy21[7:0];
											end
										else
											begin
											Red   = output_color_map1[23:16];
											Green = output_color_map1[15:8];
											Blue  = output_color_map1[7:0];
											end
									end
								end
							else
								begin
									Red   = output_color_map1[23:16];
									Green = output_color_map1[15:8];
									Blue  = output_color_map1[7:0];
								end
						end
						else if (is_blue_diamond == 1'b1 && output_color_blue_diamond != 24'hffffff)
							begin
									Red   = output_color_blue_diamond[23:16];
									Green = output_color_blue_diamond[15:8];
									Blue  = output_color_blue_diamond[7:0];
							end
						else if (is_blue_diamond1 == 1'b1 && output_color_blue_diamond1 != 24'hffffff)
							begin
									Red   = output_color_blue_diamond1[23:16];
									Green = output_color_blue_diamond1[15:8];
									Blue  = output_color_blue_diamond1[7:0];
							end
						else if (is_blue_diamond2 == 1'b1 && output_color_blue_diamond2 != 24'hffffff)
							begin
									Red   = output_color_blue_diamond2[23:16];
									Green = output_color_blue_diamond2[15:8];
									Blue  = output_color_blue_diamond2[7:0];
							end
						else if (is_red_diamond == 1'b1 && output_color_red_diamond != 24'hffffff)
							begin
									Red   = output_color_red_diamond[23:16];
									Green = output_color_red_diamond[15:8];
									Blue  = output_color_red_diamond[7:0];
							end
						else if (is_red_diamond1 == 1'b1 && output_color_red_diamond1 != 24'hffffff)
							begin
									Red   = output_color_red_diamond1[23:16];
									Green = output_color_red_diamond1[15:8];
									Blue  = output_color_red_diamond1[7:0];
							end
						else if (is_red_diamond2 == 1'b1 && output_color_red_diamond2 != 24'hffffff)
							begin
									Red   = output_color_red_diamond2[23:16];
									Green = output_color_red_diamond2[15:8];
									Blue  = output_color_red_diamond2[7:0];
							end
						else if (is_board == 1'b1)
							begin
									Red   = output_color_board[23:16];
									Green = output_color_board[15:8];
									Blue  = output_color_board[7:0];
							end
						else if (is_board_yellow == 1'b1)
							begin
									Red   = output_color_board_yellow[23:16];
									Green = output_color_board_yellow[15:8];
									Blue  = output_color_board_yellow[7:0];
							end
						else if (is_button == 1'b1 && output_color_button != 24'hffffff)
							begin
									Red   = output_color_button[23:16];
									Green = output_color_button[15:8];
									Blue  = output_color_button[7:0];
							end
						else if (is_button1 == 1'b1 && output_color_button1 != 24'hffffff)
							begin
									Red   = output_color_button1[23:16];
									Green = output_color_button1[15:8];
									Blue  = output_color_button1[7:0];
							end
						else if (is_button_yellow == 1'b1 && output_color_button_yellow != 24'hffffff)
							begin
								Red   = output_color_button_yellow[23:16];
								Green = output_color_button_yellow[15:8];
								Blue  = output_color_button_yellow[7:0];
							end
						else if (is_box == 1'b1 && output_color_box != 24'hffffff)
							begin
									Red   = output_color_box[23:16];
									Green = output_color_box[15:8];
									Blue  = output_color_box[7:0];
							end
						else if (is_girlword == 1'b1 && output_color_girlword != 24'hffffff)
							begin
									Red   = output_color_girlword[23:16];
									Green = output_color_girlword[15:8];
									Blue  = output_color_girlword[7:0];
							end		
						else if (is_boyword == 1'b1 && output_color_boyword != 24'hffffff)
							begin
									Red   = output_color_boyword[23:16];
									Green = output_color_boyword[15:8];
									Blue  = output_color_boyword[7:0];
							end
						else
						begin
							Red   = output_color_map1[23:16];
							Green = output_color_map1[15:8];
							Blue  = output_color_map1[7:0];
						end
					end
				else
					begin
						Red   = output_color_background[23:16];
						Green = output_color_background[15:8];
						Blue  = output_color_background[7:0];
					end
			end
		else if (status == 4'b1000) begin
			if (is_designer == 1'b1 && output_color_designer != 24'hffffff)
				begin
					Red   = output_color_designer[23:16];
					Green = output_color_designer[15:8];
					Blue  = output_color_designer[7:0];
				end
			else begin
				Red   = output_color_gameover[23:16];
				Green = output_color_gameover[15:8];
				Blue  = output_color_gameover[7:0];
			end
		end
		else if (status == 4'b0100) begin
			if (is_designer == 1'b1 && output_color_designer != 24'hffffff)
				begin
					Red   = output_color_designer[23:16];
					Green = output_color_designer[15:8];
					Blue  = output_color_designer[7:0];
				end
			else begin
				Red   = output_color_gamewin[23:16];
				Green = output_color_gamewin[15:8];
				Blue  = output_color_gamewin[7:0];
			end
		end
		else
        begin
				Red = 8'h7b; 
				Green = 8'hFF;
				Blue = 8'h7f - {1'b0, DrawX[9:3]};
        end
    end 
    
endmodule

