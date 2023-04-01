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

module Top_Student (input CLOCK, BTNC, BTNL, BTNR, BTNU, btnD, inout PS2Clk, PS2Data, output[7:0] JC, input[15:0] sw, output[15:0] led, output[3:0] JXADC, 
                    input J_MIC_Pin3, output J_MIC_Pin1, J_MIC_Pin4, output [3:0] an, output[6:0] seg, output dp);
    wire clk6p25m, clk25m, clk20k, clk50m, clk10ms, clk10k, clk2Hz;
    wire [15:0] oled_data, number_data, mouse_data, regression_data, image_data;
    wire [12:0] pixel_index;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event;
    wire [11:0] max_volume;
    wire [20:0] frequency_count;
    wire [20:0] changed_frequency_count;
    wire isSong;
    wire [11:0] song_audio;
    wire is_play_audio;
    wire [11:0] audio_out;
    wire [11:0] piano_audio;
    wire [11:0] digital_audio;
    wire [3:0] volume;
    wire [11:0] mic_in;
    wire [4:0] isValidNumber;
    wire [4:0] volumeNumber;
    reg button_c; //check for bebouncing
    reg button_l; //check for bebouncing
    reg button_r; //check for bebouncing
    reg button_u, button_d; //check for bebouncing
    always @(posedge clk10ms) begin 
    button_c <= (BTNC == 1) ? 1 : 0; 
    button_l <= (BTNL == 1) ? 1 : 0; 
    button_r <= (BTNR == 1) ? 1 : 0; 
    button_u <= (BTNU == 1) ? 1 : 0; 
    button_d <= (btnD) ? 1 : 0;
    end
    wire[6:0] num_seg;
    wire [6:0] segDisplay;
    wire [6:0] finalDisplay;
    wire [3:0] anode;
    wire sw15_turned_off;
    wire Q1, Q2, Q2_bar, Q3, Q4;
    wire team_start, mole_start, regression_start;
    wire [3:0] displayState;
    // SW15 Debouncer
    D_FF(clk2Hz, ~sw[15], Q1);
    D_FF(clk2Hz, Q1, Q2);
    
    // SW12 Debouncer
    wire sw12, sw12off, Q7, Q8;
    D_FF(clk2Hz, sw[12], Q3);
    D_FF(clk2Hz, Q3, Q4);
    D_FF(clk2Hz, ~sw[12], Q7);
    D_FF(clk2Hz, Q7, Q8);
    assign sw12 = Q3 & ~Q4;
    assign sw12off = Q7 & ~Q8;
    
    
    // Left Click Debouncer
    wire click, Q5, Q6;
    D_FF(clk2Hz, left, Q5);
    D_FF(clk2Hz, Q5, Q6);
    assign click = Q5 & ~Q6;
    
    // Personal Improvement - Sriram 
    wire [11:0] audio_gained;
    volume_regulator(.audio_input(mic_in), .volume(volume), .basys_clock(CLOCK), .vol_decrease(sw[9]), .vol_increase(sw[8]), .audio_gained(audio_gained));
    
    //Personal improvement - tingjia
    toggle_display_regression(.CLOCK(CLOCK), .start(regression_start), .sw(sw), .pixel_index(pixel_index), .oled_data(regression_data), .left(left), .right(right), .middle(middle), .xpos(xpos), .ypos(ypos), .displayState(displayState));
     
    // Personal Improvement - Shao Yong (Activated by SW[12])
    wire [15:0] wam_data; // OLED Data
    wire [3:0] wam_anode;
    wire [6:0] wam_seg;
    mole_menu (.clk(CLOCK), .mole_start(mole_start),.clk2hz(clk2Hz), .anclk(clk20k), .btnD(btnD), .left(left), .right(right), .an(wam_anode), .seg(wam_seg), .sw12(sw12), .sw12off(sw12off), .sw(sw), .xpos(xpos), .ypos(ypos), .pixel_index(pixel_index), .oled_data(wam_data));
    
    // Personal Improvement - Cleon
    wire [11:0] user_song_audio;
    wire isUserSong;
    wire [1:0] currUser;
    wire userSong;
    wire [11:0] cleon_audio;
    play_user_song(.basys_clock(CLOCK), .user_number(currUser), .BUTTON_D(userSong), .isUserSong(isUserSong), .user_song_audio(user_song_audio));
    pitch_changer(.basys_clock(CLOCK), .BUTTON_L(button_l), .BUTTON_R(button_r), .frequency_count(frequency_count), .frequency_count_out(changed_frequency_count));
    piano_audio(.basys_clock(CLOCK), .is_play_audio(is_play_audio), .BUTTON_C(button_c), .frequency_count(changed_frequency_count), .max_volume_input(max_volume), .isPiano(sw[5]), .audio_out(piano_audio));
    final_audio(.basys_clock(CLOCK), .isUserSong(isUserSong), .audio_gained(audio_gained),.user_song_audio(user_song_audio),.digital_audio(digital_audio), .piano_audio(piano_audio), .song_audio(song_audio), .isPiano(sw[5]), .audio_out(audio_out), .displayState(displayState),.isSong(isSong));
    play_song(.basys_clock(CLOCK), .BUTTON_U(button_d), .max_volume(12'h800), .isSong(isSong), .audio_out(song_audio));
    
    assign sw15_turned_off = Q1 & ~Q2;
    //assign oled_data = (sw[1] | sw[2] | sw[3]) ? number_data : (sw[12]) ? wam_data : (~sw[10]) ? mouse_data : regression_data;
    
    assign max_volume = (sw[0]) ? 12'hFFF : 12'h800;
    assign frequency_count = (sw[0]) ? 333332 : 166665;
    assign led[15] = (isValidNumber > 0) ? sw[15] : 0;
//    assign an = (sw[12]) ? wam_anode : anode;
//    assign seg = (sw[12]) ? wam_seg : finalDisplay;
    
    // Team Menu
    parameter MENU = 4'd0;
    parameter TEAM = 4'd1;
    parameter MOLE = 4'd2;
    parameter REGRESSION = 4'd3;
    parameter RECORDER = 4'd4;
    wire [15:0] menu_data;
    wire [15:0] final_oled;
    wire [3:0] menu_an;
    wire [6:0] menu_seg;
    Team_Menu(.clk(CLOCK), .left(left), .btnU(BTNU), .btnR(BTNR), .btnL(BTNL), .btnC(BTNC), .btnD(btnD), .xpos(xpos), .ypos(ypos), .pixel_index(pixel_index), .oled_data(menu_data), .displayState(displayState), .userSong(userSong));
    menu_toggle(.clk(CLOCK), .sw(sw), .displayState(displayState), 
                .menu_data(menu_data), .regression_data(regression_data), .mole_data(wam_data), .mouse_data(mouse_data), .number_data(number_data), .image_data(image_data),
                .mole_anode(wam_anode), .team_anode(anode), .mole_seg(wam_seg), .team_seg(finalDisplay), 
                .oled_data(final_oled), .pixel_index(pixel_index),
                .mole_start(mole_start), .regression_start(regression_start), .team_start(team_start),
                .an(menu_an), .seg(menu_seg));
    assign an = menu_an;
    assign seg = menu_seg;
    assign oled_data = final_oled;
    
    clk_divider(.CLOCK(CLOCK), .m(7), .a(clk6p25m));
    clk_divider(.CLOCK(CLOCK), .m(2), .a(clk25m));
    clk_divider(.CLOCK(CLOCK), .m(2499), .a(clk20k));
    clk_divider(.CLOCK(CLOCK), .m(0), .a(clk50m));
    clk_divider(.CLOCK(CLOCK), .m(499999), .a(clk10ms));
    clk_divider(.CLOCK(CLOCK), .m(4999), .a(clk10k));
    clk_divider(.CLOCK(CLOCK), .m(24999999), .a(clk2Hz));
    
    //audio_input
    wire [9:0] led9;
    assign led[9:0] = (displayState == TEAM) ? led9 : 10'd0;
    Audio_Input audio_in(.CLK(CLOCK), .cs(clk20k), .MISO(J_MIC_Pin3),.clk_samp(J_MIC_Pin1), .sclk(J_MIC_Pin4), .sample(mic_in));
    Value_to_Volume_converter Value_to_Volume_converter(.basys_clock(CLOCK), .MIC_IN(mic_in), .volume(volume));
    Volume_LED_controller Volume_LED_controller(.volume(volume), .basys_clock(CLOCK), .led(led9), .seg2(segDisplay));
    
    //audio_output
    new_audio(.basys_clock(CLOCK), .isPiano(sw[5]), .is_play_audio(is_play_audio), .isValidNumber(isValidNumber), .frequency_count(frequency_count), .max_volume(max_volume), .audio_out(digital_audio));
    custom_button_timer(.basys_clock(CLOCK), .BUTTON_C(button_c), .isValidNumber(isValidNumber), .play_audio(is_play_audio));
    Audio_Output(.CLK(clk50m), .START(clk20k), .DATA1(audio_out), .RST(0), .D1(JXADC[1]), .D2(JXADC[2]), .CLK_OUT(JXADC[3]), .nSYNC(JXADC[0]));
    
    //mouse & OLED
    MouseCtl(.clk(CLOCK), .rst(0), .value(0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0), .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event), .ps2_clk(PS2Clk), .ps2_data(PS2Data));
    mouseIndividual(.clock(clk25m), .left(left), .middle(middle), .right(right),.xpos(xpos), .ypos(ypos), .pixel_index(pixel_index), .oled_data(mouse_data), .sw(sw), .num_seg(num_seg));
    
    //OLED
    toggle_display(team_start, clk25m, sw, pixel_index, number_data);
    color_numbers(.CLOCK(CLOCK),.sw15_turned_off(sw15_turned_off), .num_seg(num_seg), .xpos(xpos), .ypos(ypos), .pixel_index(pixel_index), .left(left), .right(right), .middle(middle));
    check_valid_number(.CLOCK(CLOCK), .num_seg(num_seg), .sw(sw), .ld15(isValidNumber));
    Oled_Display(.clk(clk6p25m), .reset(0), .pixel_data(oled_data), .cs(JC[0]), .sdin(JC[1]), .sclk(JC[3]),.d_cn(JC[4]), .resn(JC[5]), .vccen(JC[6]), .pmoden(JC[7]), .pixel_index(pixel_index), .frame_begin(frame_begin), .sending_pixels(sending_pixels), .sample_pixel(sample_pixel)); 
    anodeDisplay(.number(isValidNumber), .volume(segDisplay), .clock(clk20k), .sw15(sw[15]), .seg(finalDisplay), .dp(dp), .an(anode));
    
    //team_task images
    wire [15:0] tj, tj_blur, cleon, cleon_blur, shao, shao_blur, sweeram, sweeram_blur;
    toggle_image_display(BTNL, BTNR, CLOCK, sw, tj, tj_blur, cleon, cleon_blur, shao, shao_blur, sweeram, sweeram_blur, image_data, currUser);
    image_tj(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(tj));
    image_tj_blur(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(tj_blur));
    image_cleon(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(cleon));
    image_cleon_blur(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(cleon_blur));
    image_shao(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(shao));
    image_shao_blur(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(shao_blur));
    image_sweeram(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(sweeram));
    image_sweeram_blur(.sw(sw), .CLOCK(CLOCK), .addr(pixel_index), .data_out(sweeram_blur));

endmodule






