`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2023 07:50:30 PM
// Design Name: 
// Module Name: final_audio
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


module final_audio(
    input basys_clock,
    input [11:0] digital_audio, 
    input [11:0] piano_audio,
    input [11:0] song_audio,
    input [11:0] user_song_audio,
    input [11:0] audio_gained,
    input isUserSong,
    input isPiano,
    input isSong,
    input [3:0] displayState,
    output reg [11:0] audio_out = 0

    );
    
    parameter MENU = 4'd0;
    parameter TEAM = 4'd1;
    parameter MOLE = 4'd2;
    parameter REGRESSION = 4'd3;
    parameter RECORDER = 4'd4;
    parameter MUSIC = 4'd5;
    parameter ABOUTUS = 4'd6;
    
    always @(posedge basys_clock)
    begin
        case (displayState)
            ABOUTUS: begin
                if (isUserSong) begin
                    audio_out <= user_song_audio;
                end
            end
            MUSIC: begin
                if (isPiano == 1 && isSong == 0) begin
                    audio_out <= piano_audio;
                end
        
                if (isPiano == 0 && isSong == 1) begin
                    audio_out <= song_audio;
                end
                if (isPiano == 1 && isSong == 1) begin
                    audio_out <= song_audio;
                end
                if (isPiano == 0 && isSong == 0 ) begin
                    audio_out <= digital_audio;
                end                
            end
            RECORDER: begin
                audio_out <= audio_gained;
            end
            TEAM: begin
                audio_out <= digital_audio;
            end
        endcase
    end
    
    
endmodule

