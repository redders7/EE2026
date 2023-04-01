`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2023 08:19:51 PM
// Design Name: 
// Module Name: play_user_song
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


module play_user_song(
    input basys_clock,
    input [1:0] user_number, //00 ,01, 10, 11
    input BUTTON_D,
    output reg isUserSong,
    output reg [11:0] user_song_audio
    );
    
    
    reg [31:0] pitch_lut [0:49];
    reg [5:0] song_zero [0:30];
    reg [5:0] song_one [0:16];
    reg [5:0] song_two [0:23];
    reg [5:0] song_three [0:34];
    reg [31:0] half_second_counter = 0;
    reg previous_BTND;
    reg [1:0] prev_user;
    reg [7:0] note = 0;
    reg [7:0] max_note = 0;
    reg play_note = 0;
    wire [11:0] song_audio;
    reg [8:0] short_delay;
    reg [20:0] frequency;
    
    
    always @(posedge basys_clock)
    begin
        half_second_counter = (half_second_counter == 49999999) ? 0 : half_second_counter + 1; 
        short_delay = (short_delay == 100) ? 0 : short_delay + 1;
        if ((BUTTON_D == 1 && previous_BTND == 0) || (prev_user != user_number))
        begin
            case(user_number)
                2'b00 : max_note = 30;
                2'b01 : max_note = 16;
                2'b10 : max_note = 22;
                2'b11 : max_note = 23;
            endcase
            note <= 0;
        end
        if (half_second_counter == 0 && note < max_note) 
        begin
            note <= note + 1;
            isUserSong <= 1;
            
            case(user_number)
                2'b00 : 
                    if (song_zero[note] != 0)
                    begin
                        frequency <= pitch_lut[song_zero[note]];
                        play_note <= 1;
                    end
                2'b01 :
                    if (song_one[note] != 0)
                    begin
                        frequency <= pitch_lut[song_one[note]];
                        play_note <= 1;
                    end
                2'b10 :
                    if (song_two[note] != 0)
                    begin
                        frequency <= pitch_lut[song_two[note]];
                        play_note <= 1;
                    end
                2'b11 : 
                    if (song_three[note] != 0)
                    begin
                        frequency <= pitch_lut[song_three[note]];
                        play_note <= 1;
                    end
            endcase
        end
        
        if (note == max_note) 
        begin
            isUserSong <= 0;
        end
        
        if (short_delay == 0)
        begin
            play_note <= 0;
        end
        
        user_song_audio <= song_audio; 
        previous_BTND = BUTTON_D;
        prev_user <= user_number;
        
    end

        piano_audio(.basys_clock(basys_clock), .is_play_audio(1), .BUTTON_C(play_note), .frequency_count(frequency), .max_volume_input(12'h800), .isPiano(1), .audio_out(song_audio));
    
 
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
         
         song_zero[0] = 17;
         song_zero[1] = 15;
         song_zero[2] = 13;
         song_zero[3] = 15;
         song_zero[4] = 17;
         song_zero[5] = 17;
         song_zero[6] = 17;
         song_zero[7] = 0;
         song_zero[8] = 15;
         song_zero[9] = 15;
         song_zero[10] = 15;
         song_zero[11] = 0;
         song_zero[12] = 17;
         song_zero[13] = 17;
         song_zero[14] = 17;
         song_zero[15] = 0;
         song_zero[16] = 17;
         song_zero[17] = 15;
         song_zero[18] = 13;
         song_zero[19] = 15;
         song_zero[20] = 17;
         song_zero[21] = 17;
         song_zero[22] = 17;
         song_zero[23] = 0;
         song_zero[24] = 15;
         song_zero[25] = 15;
         song_zero[26] = 17;
         song_zero[27] = 15;
         song_zero[28] = 13;
         song_zero[29] = 0;
         
         song_one[0] = 3;
         song_one[1] = 3;
         song_one[2] = 10;
         song_one[3] = 10;
         song_one[4] = 12;
         song_one[5] = 12;
         song_one[6] = 10;
         song_one[7] = 0;
         song_one[8] = 8;
         song_one[9] = 8;
         song_one[10] = 7;
         song_one[11] = 7;
         song_one[12] = 5;
         song_one[13] = 5;
         song_one[14] = 3;
         song_one[15] = 0;
         
         song_two[0] = 11;
         song_two[1] = 11;
         song_two[2] = 13;
         song_two[3] = 0;
         song_two[4] = 11;
         song_two[5] = 0;
         song_two[6] = 16;
         song_two[7] = 0;
         song_two[8] = 15;
         song_two[9] = 0;
         song_two[10] = 0;
         song_two[11] = 0;
         song_two[12] = 11;
         song_two[13] = 11;
         song_two[14] = 13;
         song_two[15] = 0;
         song_two[16] = 11;
         song_two[17] = 0;
         song_two[18] = 18;
         song_two[19] = 0;
         song_two[20] = 16;
         song_two[21] = 0;

         song_three[0] = 10;
         song_three[1] = 13;
         song_three[2] = 0;
         song_three[3] = 15;
         song_three[4] = 17;
         song_three[5] = 0;
         song_three[6] = 18;
         song_three[7] = 17;
         song_three[8] = 15;
         song_three[9] = 0;
         song_three[10] = 12;
         song_three[11] = 8;
         song_three[12] = 0;
         song_three[13] = 10;
         song_three[14] = 12;
         song_three[15] = 13;
         song_three[16] = 12;
         song_three[17] = 10;
         song_three[18] = 9;
         song_three[19] = 7;
         song_three[20] = 9;
         song_three[21] = 10;
         song_three[22] = 0;
         
         
         
//         song_zero[0] = 17;
//         song_zero[1] = 16;
//         song_zero[2] = 17;
//         song_zero[3] = 16;
//         song_zero[4] = 17;
//         song_zero[5] = 12;
//         song_zero[6] = 15;
//         song_zero[7] = 13;
//         song_zero[8] = 10;
//         song_zero[9] = 0;
//         song_zero[10] = 0;
//         song_zero[11] = 5;
//         song_zero[12] = 9;
//         song_zero[13] = 10;
//         song_zero[14] = 12;
//         song_zero[15] = 0;
//         song_zero[16] = 0;
//         song_zero[17] = 5;
//         song_zero[18] = 10;
//         song_zero[19] = 12;
//         song_zero[20] = 13;
//         song_zero[21] = 0;
//         song_zero[22] = 0;
//         song_zero[23] = 0;
//         song_zero[24] = 17;
//         song_zero[25] = 16;
//         song_zero[26] = 17;
//         song_zero[27] = 16;
//         song_zero[28] = 17;
//         song_zero[29] = 12;
//         song_zero[30] = 15;
//         song_zero[31] = 13;
//         song_zero[32] = 10;
//         song_zero[33] = 0;
//         song_zero[34] = 0;
//         song_zero[35] = 5;
//         song_zero[36] = 9;
//         song_zero[37] = 10;
//         song_zero[38] = 12;
//         song_zero[39] = 0;
//         song_zero[40] = 0;
//         song_zero[41] = 5;
//         song_zero[42] = 13;
//         song_zero[43] = 12;
//         song_zero[44] = 10;
//         song_zero[45] = 0;
//         song_zero[46] = 0;
//         song_zero[47] = 0;
     end

    
endmodule
