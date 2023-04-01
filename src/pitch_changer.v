`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2023 08:27:35 PM
// Design Name: 
// Module Name: pitch_changer
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


module pitch_changer(
    input basys_clock, 
    input BUTTON_L, 
    input BUTTON_R,
    input [20:0] frequency_count,
    output reg [20:0] frequency_count_out
    );
    
    reg previous_BTNR;
    reg previous_BTNL;
    reg [20:0] current_change;
    reg [5:0] pitch_number;
    
    initial begin
        current_change = 1000;
        pitch_number = 8;
    end
    
    always @ (posedge basys_clock)
    begin
        //every push will only be counted as one, not multiple
        if (BUTTON_R == 1 && previous_BTNR == 0 && pitch_number < 49)
        begin
            //increase pitch by 1 semitone
            current_change <= current_change * 94387 / 100000;
            pitch_number <= pitch_number + 1;
        end
        
        if (BUTTON_L == 1 && previous_BTNL == 0 && pitch_number > 0)
        begin
            //decrease pitch by 1 semitone
            current_change <= current_change * 105946 / 100000;
            pitch_number <= pitch_number - 1;
        end
        
        previous_BTNR = BUTTON_R;
        previous_BTNL = BUTTON_L;
        frequency_count_out <= frequency_count * current_change / 1000;
    end
    
endmodule