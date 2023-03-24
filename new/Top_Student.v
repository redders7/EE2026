`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////

//Task 4: on switch 1-3 to display number, highest number priority. on switch 4 to turn off double green line 

module Top_Student (input CLOCK, BTNC, btnD, inout PS2Clk, PS2Data, output[7:0] JC, input[15:0] sw, output[15:0] led, output[3:0] JXADC, 
                    input J_MIC_Pin3, output J_MIC_Pin1, J_MIC_Pin4, output [3:0] an, output[6:0] seg, output dp);
    wire clk6p25m, clk25m, clk20k, clk50m, clk10ms, clk10k, clk2Hz;
    wire [15:0] oled_data, number_data, mouse_data, regression_data;
    wire [12:0] pixel_index;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    wire [11:0] max_volume;
    wire [20:0] frequency_count;
    wire is_play_audio;
    wire [11:0] audio_out;
    wire [3:0] volume;
    wire [11:0] mic_in;
    wire [4:0] isValidNumber;
    wire [4:0] volumeNumber;
    reg button_c; //check for bebouncing
    always @(posedge clk10ms) begin button_c <= (BTNC == 1) ? 1 : 0; end
    wire[6:0] num_seg;
    wire [6:0] segDisplay;
    wire [6:0] finalDisplay;
    wire [3:0] anode;
    wire sw15_turned_off;
    wire Q1, Q2, Q2_bar, Q3, Q4;
    // SW15 Debouncer
    D_FF(clk2Hz, ~sw[15], Q1);
    D_FF(clk2Hz, Q1, Q2);
    
    // SW12 Debouncer
    wire sw12;
    D_FF(clk2Hz, sw[12], Q3);
    D_FF(clk2Hz, Q3, Q4);
    assign sw12 = Q3 & ~Q4;
    
    //Personal improvement - tingjia
    toggle_display_regression(.CLOCK(CLOCK), .sw(sw), .pixel_index(pixel_index), .oled_data(regression_data), .left(left), .right(right), .middle(middle), .xpos(xpos), .ypos(ypos));
     
    // Personal Improvement - Shao Yong (Activated by SW[12])
    wire [15:0] wam_data; // OLED Data
    wire [3:0] wam_anode;
    wire [6:0] wam_seg;
    mole_menu (.clk(CLOCK), .clk2hz(clk2Hz), .anclk(clk20k), .btnD(btnD), .left(left), .right(right), .an(wam_anode), .seg(wam_seg), .sw12(sw12), .sw(sw), .xpos(xpos), .ypos(ypos), .pixel_index(pixel_index), .oled_data(wam_data));
    
    assign sw15_turned_off = Q1 & ~Q2;
    assign oled_data = (sw[1] | sw[2] | sw[3]) ? number_data : (sw[12]) ? wam_data : (~sw[10]) ? mouse_data : regression_data;
    
    assign max_volume = (sw[0]) ? 12'hFFF : 12'h800;
    assign frequency_count = (sw[0]) ? 166665 : 333332;
    assign led[15] = (isValidNumber > 0) ? sw[15] : 0;
    assign an = (sw[12]) ? wam_anode : anode;
    assign seg = (sw[12]) ? wam_seg : finalDisplay;
    
    clk_divider(.CLOCK(CLOCK), .m(7), .a(clk6p25m));
    clk_divider(.CLOCK(CLOCK), .m(2), .a(clk25m));
    clk_divider(.CLOCK(CLOCK), .m(2499), .a(clk20k));
    clk_divider(.CLOCK(CLOCK), .m(0), .a(clk50m));
    clk_divider(.CLOCK(CLOCK), .m(499999), .a(clk10ms));
    clk_divider(.CLOCK(CLOCK), .m(4999), .a(clk10k));
    clk_divider(.CLOCK(CLOCK), .m(24999999), .a(clk2Hz));
    
    //audio_input
    Audio_Input audio_in(.CLK(CLOCK), .cs(clk20k), .MISO(J_MIC_Pin3),.clk_samp(J_MIC_Pin1), .sclk(J_MIC_Pin4), .sample(mic_in));
    Value_to_Volume_converter Value_to_Volume_converter(.basys_clock(CLOCK), .MIC_IN(mic_in), .volume(volume));
    Volume_LED_controller Volume_LED_controller(.volume(volume), .basys_clock(CLOCK), .led(led[9:0]), .seg2(segDisplay));
    
    //audio_output
    new_audio(.basys_clock(CLOCK), .is_play_audio(is_play_audio), .isValidNumber(isValidNumber), .frequency_count(frequency_count), .max_volume(max_volume), .audio_out(audio_out));
    custom_button_timer(.basys_clock(CLOCK), .BUTTON_C(button_c), .isValidNumber(isValidNumber), .play_audio(is_play_audio));
    Audio_Output(.CLK(clk50m), .START(clk20k), .DATA1(audio_out), .RST(0), .D1(JXADC[1]), .D2(JXADC[2]), .CLK_OUT(JXADC[3]), .nSYNC(JXADC[0]));
    
    //mouse & OLED
    MouseCtl(.clk(CLOCK), .rst(0), .value(0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0), .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event), .ps2_clk(PS2Clk), .ps2_data(PS2Data));
    mouseIndividual(.clock(clk25m), .left(left), .middle(middle), .right(right),.xpos(xpos), .ypos(ypos), .pixel_index(pixel_index), .oled_data(mouse_data), .sw(sw), .num_seg(num_seg));
    
    //OLED
    toggle_display(clk25m, sw, pixel_index, number_data);
    color_numbers(.CLOCK(CLOCK),.sw15_turned_off(sw15_turned_off), .num_seg(num_seg), .xpos(xpos), .ypos(ypos), .pixel_index(pixel_index), .left(left), .right(right), .middle(middle));
    check_valid_number(.CLOCK(CLOCK), .num_seg(num_seg), .sw(sw), .ld15(isValidNumber));
    Oled_Display(.clk(clk6p25m), .reset(0), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),.d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]), .pixel_index(pixel_index), .frame_begin(frame_begin), .sending_pixels(sending_pixels), .sample_pixel(sample_pixel)); 
    anodeDisplay(.number(isValidNumber), .volume(segDisplay), .clock(clk20k), .sw15(sw[15]), .seg(finalDisplay), .dp(dp), .an(anode));

endmodule






