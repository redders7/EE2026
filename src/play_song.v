`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2023 12:17:17
// Design Name: 
// Module Name: play_song
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module play_song(
    input basys_clock,
    input BUTTON_U, 
    input [11:0] max_volume,
    output reg isSong,
    output reg [11:0] audio_out
    );
    
    reg [31:0] pitch_lut [0:49];
    reg [5:0] pitch [0:34];

    
    reg previous_BTNU;
    wire [11:0] song_audio;
    reg play_note;
    reg [6:0] note = 0;
    reg [31:0] second_counter = 99999998;
    
    always @(posedge basys_clock)
    begin
        second_counter = (second_counter == 99999998) ? second_counter : second_counter + 1; 
        
        if (BUTTON_U == 1 && previous_BTNU == 0)
        begin
            second_counter <= 0;
            play_note <= 0;
            note <= (note == 34) ? 1 : note + 1;
        end
        
        if (second_counter != 99999998) 
        begin
            play_note <= 1;
            isSong <= 1;
        end
        
        if (second_counter == 99999998) 
        begin
            play_note <= 0;
            isSong <= 0;
        end
        
        audio_out <= song_audio; 
        previous_BTNU = BUTTON_U;
    end
    
    piano_audio(.basys_clock(basys_clock), .is_play_audio(play_note), .BUTTON_C(BUTTON_U), .frequency_count(pitch_lut[pitch[note]]), .max_volume_input(max_volume), .isPiano(1), .audio_out(song_audio));
    //new_audio test (.basys_clock(basys_clock), .isPiano(0), .is_play_audio(isSong), .frequency_count(264558), .max_volume(max_volume), .audio_out(song_audio));
    
    initial 
    begin
        pitch_lut[0] = 529119;
        pitch_lut[1] = 499419;
        pitch_lut[2] = 471387;
        pitch_lut[3] = 444928;
        pitch_lut[4] = 419954;
        pitch_lut[5] = 396382;
        pitch_lut[6] = 374133;
        pitch_lut[7] = 353133;
        pitch_lut[8] = 333311;
        pitch_lut[9] = 314603;
        pitch_lut[10] = 296944;
        pitch_lut[11] = 280276;
        pitch_lut[12] = 264544;
        pitch_lut[13] = 249696;
        pitch_lut[14] = 235680;
        pitch_lut[15] = 222451;
        pitch_lut[16] = 209965;
        pitch_lut[17] = 198180;
        pitch_lut[18] = 187056;
        pitch_lut[19] = 176556;
        pitch_lut[20] = 166646;
        pitch_lut[21] = 157292;
        pitch_lut[22] = 148464;
        
        pitch[0] = 0;
        pitch[1] = 17;
        pitch[2] = 16;
        pitch[3] = 17;
        pitch[4] = 16;
        pitch[5] = 17;
        pitch[6] = 12;
        pitch[7] = 15;
        pitch[8] = 13;
        pitch[9] = 10;
        pitch[10] = 5;
        pitch[11] = 9;
        pitch[12] = 10;
        pitch[13] = 12;
        pitch[14] = 5;
        pitch[15] = 10;
        pitch[16] = 12;
        pitch[17] = 13;
        pitch[18] = 17;
        pitch[19] = 16;
        pitch[20] = 17;
        pitch[21] = 16;
        pitch[22] = 17;
        pitch[23] = 12;
        pitch[24] = 15;
        pitch[25] = 13;
        pitch[26] = 10;
        pitch[27] = 5;
        pitch[28] = 9;
        pitch[29] = 10;
        pitch[30] = 12;
        pitch[31] = 5;
        pitch[32] = 13;
        pitch[33] = 12;
        pitch[34] = 10;
        
    end
    
    
endmodule
