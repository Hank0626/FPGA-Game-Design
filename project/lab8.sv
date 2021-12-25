//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
				 output logic [7:0]  LEDG, 
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [15:0] keycode, keycode0, keycode1, keycode_girl, keycode_boy;
    logic [7:0] led;  
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
		  LEDG <= led;
    end
	 
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 logic [9:0] DrawX,DrawY;	 
	 
	 
// ---------------- Add for Final Project -----------------
	 
	 // Signal for big logic
	 logic [3:0] status;
	 
	 // Signal determining whether the element exists or not
	 logic is_girl;
	 logic is_boy;
	 logic is_map1;
	 logic is_background;
	 logic is_blue_diamond;
	 logic is_blue_diamond1;
	 logic is_blue_diamond2;
	 logic is_red_diamond;
	 logic is_red_diamond1;
	 logic is_red_diamond2;
	 logic is_board_purple;
	 logic is_board_yellow;
	 logic is_button;
	 logic is_button_yellow;
	 logic is_box;
	 logic [3:0] girl_status;
	 logic [3:0] boy_status;
	 
	 // Signal for the address for the display element
	 logic [16:0] background_address;
	 logic [16:0] map1_address;
	 logic [9:0] girl_address;
	 logic [9:0] boy_address;
	 logic [8:0] blue_diamond_address;
	 logic [8:0] blue_diamond_address1;
	 logic [8:0] blue_diamond_address2;
	 logic [8:0] red_diamond_address;
	 logic [8:0] red_diamond_address1;
	 logic [8:0] red_diamond_address2;
	 logic [9:0] board_address_purple;
	 logic [9:0] board_address_yellow;
	 logic [7:0] button_address;
	 logic [7:0] button_address1;
	 logic [7:0] button_yellow_address;
	 logic [9:0] box_address;
	  
	 // Determine whether the game is end
	 logic is_dead;
	 logic is_dead_girl;
	 logic is_dead_boy;
   
	 // Determine whether the blue diamond is eaten
	 logic is_diamond_eat1;
	 logic is_diamond_eat2;
	 logic is_diamond_eat3;
	 logic is_diamond_eat1_red;
	 logic is_diamond_eat1_red1;
	 logic is_diamond_eat1_red2;
	 
	 // Determine whether the board come down
	 logic is_button_push;
	 assign is_button_push1 = 1'b0;
	 logic is_button_purple_push1;
	 
	 
	 logic is_button_push_girl;
	 logic is_button_push_boy;
	 logic is_button_purple_push1_girl;
	 logic is_button_purple_push1_boy;

	 
	 logic is_button_purple_push2;
	 logic is_button_purple_push2_girl;
	 logic is_button_purple_push2_boy;
	 
	 
	 logic board_yellow_down;
	 logic [9:0] board_x_pos, board_y_pos, board_purple_x_pos, board_purple_y_pos;
	 
	 logic is_collide_up_board;
	 logic is_collide_up_board_purple;
	 
	 logic is_collide_up_board_girl;
	 logic is_collide_up_board_purple_girl; 	 
	 logic is_collide_up_board_boy;
	 logic is_collide_up_board_purple_boy; 
	 
	 
	 logic is_collide_down_board_purple;
	 
	 logic is_board_up;
// ----------------------------------------------------------



// ---------------- hpi and nios module ---------------------

    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
									  .keycode_0_export(keycode0),
                             .keycode_1_export(keycode1),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset),
    );
    
	 
	 keycode_select ks(.keycode, .keycode0, .keycode_girl, .keycode_boy);
// -----------------------------------------------------------------


// --------------------- VGA relevanr module ------------------

    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    VGA_controller vga_controller_insance(.Clk, .Reset(Reset_h), .VGA_HS,.VGA_VS,.VGA_CLK,.VGA_BLANK_N,.VGA_SYNC_N,.DrawX,.DrawY);

// -----------------------------------------------------------------


// ------------------- Display element module ----------------------	 
	 
    girl_motion girl_motion(.Clk,
									 .Reset(Reset_h),
									 .frame_clk(VGA_VS),
									 .DrawX,
									 .DrawY,
									 .board_x_pos,
									 .board_y_pos,
									 .board_purple_x_pos,
									 .board_purple_y_pos,
									 .keycode(keycode_girl),
									 .is_board_up,
									 .is_girl, 
									 .girl_status, 
									 .girl_address, 
									 .is_dead_girl,
									 .is_diamond_eat1,
									 .is_diamond_eat2,
									 .is_diamond_eat3,
									 .is_button_push(is_button_push_girl),
									 .is_button_purple_push1(is_button_purple_push1_girl),
									 .is_button_purple_push2(is_button_purple_push2_girl),
									 .is_collide_up_board(is_collide_up_board_girl),
									 .is_collide_up_board_purple(is_collide_up_board_purple_girl));
	 
	 boy_motion boy_motion(.Clk,
	                       .Reset(Reset_h),
								  .frame_clk(VGA_VS),
								  .DrawX,
								  .DrawY,
								  .board_x_pos,
								  .board_y_pos,
								  .board_purple_x_pos,
								  .board_purple_y_pos,
								  .keycode(keycode_boy),
								  .is_board_up,
								  .is_boy,
								  .boy_status,
								  .boy_address,
								  .is_dead_boy,
								  .is_diamond_eat1_red,
								  .is_diamond_eat1_red1,
								  .is_diamond_eat1_red2,
								  .is_button_push(is_button_push_boy),
								  .is_button_purple_push1(is_button_purple_push1_boy),  
								  .is_button_purple_push2(is_button_purple_push2_boy),  
								  .is_collide_up_board(is_collide_up_board_boy),
								  .is_collide_up_board_purple(is_collide_up_board_purple_boy));
	 
	 
	 background background(.status, .DrawX, .DrawY, .is_background, .background_address);
	 
	 map1 map1(.status, .DrawX, .DrawY, .is_map1, .map1_address);
	 
	 blue_diamond bd(.DrawX,
	                 .DrawY, 
						  .is_diamond_eat1, 
						  .is_diamond_eat2, 
						  .is_diamond_eat3,
						  .is_blue_diamond, 
						  .is_blue_diamond1,
						  .is_blue_diamond2,
						  .blue_diamond_address,
						  .blue_diamond_address1,
						  .blue_diamond_address2);
	 
	 red_diamond rd(.DrawX,
	                .DrawY, 
						 .is_diamond_eat1_red, 
						 .is_diamond_eat1_red1,
						 .is_diamond_eat1_red2,
						 .is_red_diamond, 
						 .is_red_diamond1,
						 .is_red_diamond2,
						 .red_diamond_address,
						 .red_diamond_address1,
						 .red_diamond_address2);
	 
	 button button(.DrawX, .DrawY, .is_button_purple_push1, .is_button, .button_address);
	 
	 button1 button1(.DrawX, .DrawY, .is_button_purple_push2, .is_button1, .button_address1);
	 
	 button_yellow button_y(.DrawX, .DrawY, .is_button_push, .is_button_yellow, .button_yellow_address);
	 
	 box box(.DrawX, .DrawY, .is_box, .box_address);
	 
	 board_motion(.Clk,
					  .Reset(Reset_h),
					  .frame_clk(VGA_VS),
					  .DrawX,
					  .DrawY,
					  .is_button_push,
					  .is_collide_up_board,
					  .is_board_yellow,
					  .board_address_yellow,
					  .board_x_pos,
					  .board_y_pos
					  );
					  
	 board_purple_motion(.Clk,
								.Reset(Reset_h),
								.frame_clk(VGA_VS),
							   .DrawX,
							   .DrawY,
					         .is_button_purple_push1,
					         .is_button_purple_push2,
					         .is_collide_up_board_purple,
							   .is_collide_down_board_purple,
							   .is_board_purple,
							   .board_address_purple,
							   .board_purple_x_pos,
							   .board_purple_y_pos,
								.is_board_up
								 );
					  
// -----------------------------------------------------------------

	 // Whole logic of the game
	 game_logic my_logic(.Clk, .Reset(Reset_h), .keycode, .status);
	 
	 
    color_mapper color_instance(
										  .status(status),
										  .is_girl(is_girl), 
										  .is_boy(is_boy),
										  .girl_status(girl_status),
										  .boy_status(boy_status),
										  .is_background(is_background), 
										  .is_map1(is_map1),
										  .is_blue_diamond(is_blue_diamond),
										  .is_blue_diamond1(is_blue_diamond1),
										  .is_blue_diamond2(is_blue_diamond2),
										  .is_red_diamond(is_red_diamond),
										  .is_red_diamond1(is_red_diamond1),
										  .is_red_diamond2(is_red_diamond2),
										  .is_board(is_board_purple),
										  .is_board_yellow(is_board_yellow),
										  .is_button(is_button),
										  .is_button1(is_button1),
										  .is_button_yellow(is_button_yellow),
										  .is_box(is_box),
										  .map1_address(map1_address), 
										  .background_address(background_address), 
										  .girl_address(girl_address),
										  .boy_address(boy_address),
										  .blue_diamond_address(blue_diamond_address),
										  .blue_diamond_address1(blue_diamond_address1),
										  .blue_diamond_address2(blue_diamond_address2),
										  .red_diamond_address(red_diamond_address),
										  .red_diamond_address1(red_diamond_address1),
										  .red_diamond_address2(red_diamond_address2),
										  .board_address(board_address_purple),
										  .board_address_yellow(board_address_yellow),
										  .button_address(button_address),
										  .button_address1(button_address1),
										  .button_yellow_address(button_yellow_address),
										  .box_address(box_address),
										  .DrawX(DrawX),
										  .DrawY(DrawY),
										  .VGA_R(VGA_R),
										  .VGA_G(VGA_G),
										  .VGA_B(VGA_B));
	 
	 
	 select sel1(.in0(is_dead_boy), .in1(is_dead_girl), .out(is_dead));
	 select sel2(.in0(is_button_push_boy), .in1(is_button_push_girl), .out(is_button_push));
	 select sel3(.in0(is_button_purple_push1_boy), .in1(is_button_purple_push1_girl), .out(is_button_purple_push1));
	 select sel4(.in0(is_collide_up_board_boy), .in1(is_collide_up_board_girl), .out(is_collide_up_board));
	 select sel5(.in0(is_collide_up_board_purple_boy), .in1(is_collide_up_board_purple_girl), .out(is_collide_up_board_purple));
	 select sel6(.in0(is_button_purple_push2_boy), .in1(is_button_purple_push2_girl), .out(is_button_purple_push2));
	 
	 
	 
	 // Display keycode on hex display
    HexDriver hex_inst_0 (keycode_girl[3:0], HEX0);
    HexDriver hex_inst_1 (keycode_girl[7:4], HEX1);
    HexDriver hex_inst_2 (keycode_girl[11:8], HEX2);
    HexDriver hex_inst_3 (keycode_girl[15:12], HEX3);

    HexDriver hex_inst_4 (keycode_boy[3:0], HEX4);
    HexDriver hex_inst_5 (keycode_boy[7:4], HEX5);

    HexDriver hex_inst_6 (keycode_boy[11:8], HEX6);
    HexDriver hex_inst_7 (keycode_boy[15:12], HEX7);

	 
// ------------------------- led for debug -------------------
	 always_comb
    begin
	   // default case
	   led = 8'b0000;
		case(is_dead)
				// dead
				1'b1: begin
							led = 8'b0010;
					end
				1'b0: begin
							led = 8'b0001;
					end
		endcase
    end	
	 
endmodule
