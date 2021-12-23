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
             output logic [6:0]  HEX0, HEX1,
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
    logic [7:0] keycode;
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
	 logic is_map1;
	 logic is_background;
	 logic is_blue_diamond;
	 logic is_board;
	 logic is_board_yellow;
	 logic is_button;
	 logic is_button_yellow;
	 logic is_box;
	 logic is_pole;
	 logic [3:0] girl_status;
	 logic [2:0] pole_status;
	 
	 // Signal for the address for the display element
	 logic [16:0] background_address;
	 logic [16:0] map1_address;
	 logic [9:0] girl_address;
	 logic [8:0] blue_diamond_address;
	 logic [9:0] board_address;
	 logic [9:0] board_address_yellow;
	 logic [7:0] button_address;
	 logic [7:0] button_yellow_address;
	 logic [9:0] box_address;
	 logic [9:0] pole_address;
	  
	 // Determine whether the game is end
	 logic is_dead_girl;
   
	 // Determine whether the blue diamond is eaten
	 logic is_diamond_eat1;
	 logic eaten1;
	 
	 // Determine whether the board come down
	 logic is_button_push;
	 logic board_yellow_down;
	 logic [9:0] board_x_pos, board_y_pos;
	 logic is_girl_collide;
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
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset),
    );
    
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
									 .keycode,
									 .is_girl, 
									 .girl_status, 
									 .girl_address, 
									 .is_dead_girl,
									 .is_girl_collide,
									 .is_diamond_eat1,
									 .is_button_push);
	 
	 background background(.status, .DrawX, .DrawY, .is_background, .background_address);
	 
	 map1 map1(.status, .DrawX, .DrawY, .is_map1, .map1_address);
	 
	 blue_diamond bd(.DrawX, .DrawY, .is_diamond_eat1, .is_blue_diamond, .blue_diamond_address);
	 
	 board board(.DrawX, .DrawY, .is_board, .board_address);
	 
	 //board_yellow board_yellow(.DrawX, .DrawY, .is_board_yellow, .board_address_yellow);
	 
	 button button(.DrawX, .DrawY, .is_button, .button_address);
	 
	 button_yellow button_y(.DrawX, .DrawY, .is_button_push, .is_button_yellow, .button_yellow_address);
	 
	 box box(.DrawX, .DrawY, .is_box, .box_address);
	 
	 board_motion(.Clk,
					  .Reset(Reset_h),
					  .frame_clk(VGA_VS),
					  .DrawX,
					  .DrawY,
					  .is_button_push,
					  .is_girl_collide,
					  .is_board_yellow,
					  .board_address_yellow,
					  .board_x_pos,
					  .board_y_pos
					  );
					  
	 
// -----------------------------------------------------------------

	 // Whole logic of the game
	 game_logic my_logic(.Clk, .Reset(Reset_h), .keycode, .status);
	 
	 
    color_mapper color_instance(
										  .status(status),
										  .is_girl(is_girl), 
										  .girl_status(girl_status),
										  .is_background(is_background), 
										  .is_map1(is_map1),
										  .is_blue_diamond(is_blue_diamond),
										  .is_board(is_board),
										  .is_board_yellow(is_board_yellow),
										  .is_button(is_button),
										  .is_button_yellow(is_button_yellow),
										  .is_box(is_box),
										  .map1_address(map1_address), 
										  .background_address(background_address), 
										  .girl_address(girl_address),
										  .blue_diamond_address(blue_diamond_address),
										  .board_address(board_address),
										  .board_address_yellow(board_address_yellow),
										  .button_address(button_address),
										  .button_yellow_address(button_yellow_address),
										  .box_address(box_address),
										  .DrawX(DrawX),
										  .DrawY(DrawY),
										  .VGA_R(VGA_R),
										  .VGA_G(VGA_G),
										  .VGA_B(VGA_B));
	 
	 
	 
	 // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
	 
	 
// ------------------------- led for debug -------------------
	 always_comb
    begin
	   // default case
	   led = 8'b0000;
//		case(keycode)
//               // A
//					8'h04: begin
//								led = 8'b0010;
//							end
//					// D
//					8'h07: begin
//								led = 8'b0001;
//							end
//					// W
//					8'h1a: begin
//								led = 8'b1000;
//							end
//					// S
//					8'h16: begin
//								led = 8'b0100;
//							end
//		endcase
		
		case(is_dead_girl)
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
