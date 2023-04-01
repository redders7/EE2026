`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2023 04:09:59 PM
// Design Name: 
// Module Name: piano_audio
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


module piano_audio(
    input basys_clock,
    input is_play_audio,
    input BUTTON_C,
    input [20:0] frequency_count,
    input [11:0] max_volume_input,
    input isPiano,
    output reg [11:0] audio_out = 0
    );
   
   parameter M = 512;
    
    reg [11:0] piano_wave [0:511];

    reg [11:0] i;
    initial begin
        for (i = 0; i < 80; i = i + 1)
        begin
            piano_wave[i] = 504;
        end
        for (i = 80; i < 512; i = i + 1)
        begin
            piano_wave[i] = 504-i+80;
        end
    end
    
    
    wire [19:0] max_volume = max_volume_input;
    reg [20:0] new_wave = 0;
    reg [20:0] count = 0;
    reg [10:0] sample = 0;
    reg [18:0] points = 0;
    reg previous_BTNC;
    
    always @(posedge basys_clock)
    begin
        if (BUTTON_C == 1 && previous_BTNC == 0)
            begin
                sample <= 0;
            end
        if (is_play_audio == 1 && isPiano == 1)
        begin 
            points <= (points == 195312) ? 0 : points + 1; //a second split into 512 points
            count <= (count == frequency_count) ? 0 : count + 1;
            new_wave <= (count == 0) ? (new_wave != 0) ? 0 : max_volume*piano_wave[sample]/512 : new_wave;
            
            if (points == 0)
            begin  
                sample <= (sample == M-1) ? sample : sample+1;
            end

            audio_out <= new_wave[11:0]; 
            previous_BTNC <= BUTTON_C;
            
        end
    end

    
    
endmodule