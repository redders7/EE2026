`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 12:21:29 PM
// Design Name: 
// Module Name: new_audio
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


module new_audio(
    input basys_clock,
    input is_play_audio,
    input [4:0] isValidNumber,
    input [20:0] frequency_count,
    input [11:0] max_volume,
    output reg [11:0] audio_out = 0
    );
    

    wire clk0p1,clk0p2,clk0p3,clk0p4,clk0p5,clk0p6,clk0p7,clk0p8,clk0p9,clk1;
    reg [18:0] count = 0;
    clk_divider(.CLOCK(basys_clock),.m(4999999), .a(clk0p1));
//    clk_divider(.CLOCK(basys_clock),.m(9999999), .a(clk0p2));
//    clk_divider(.CLOCK(basys_clock),.m(14999999), .a(clk0p3));
//    clk_divider(.CLOCK(basys_clock),.m(19999999), .a(clk0p4));
//    clk_divider(.CLOCK(basys_clock),.m(24999999), .a(clk0p5));
//    clk_divider(.CLOCK(basys_clock),.m(29999999), .a(clk0p6));
//    clk_divider(.CLOCK(basys_clock),.m(34999999), .a(clk0p7));
//    clk_divider(.CLOCK(basys_clock),.m(39999999), .a(clk0p8));
//    clk_divider(.CLOCK(basys_clock),.m(44999999), .a(clk0p9));
//    clk_divider(.CLOCK(basys_clock),.m(49999999), .a(clk1));

    always @ (posedge basys_clock) begin
        if (is_play_audio == 0)
        begin
            count <= 0;
            audio_out <= 0;
        end
        if (is_play_audio == 1)
        begin
            count <= (count == frequency_count) ? 0 : count + 1;
            audio_out <= (count == 0) ? (audio_out == max_volume) ? 0 : max_volume : audio_out;
        end        
    end
    
//    always @ (posedge basys_clock)
//    begin

//        case (isValidNumber)
//            5'd0: begin
//                if (is_play_audio == 0)
//                begin
//                    count = 0;
//                    audio_out = 0;
//                end
            
//                if (is_play_audio == 1)
//                begin
//                    count <= (count == frequency_count) ? 0 : count + 1;
//                    audio_out <= (count == 0) ? (audio_out == max_volume) ? 0 : max_volume : audio_out;
//                end
//            end
//            5'd1: begin
//                audio_out <= clk0p1;
//            end
//            5'd2: begin
//                audio_out <= clk0p2;
//            end
//            5'd3: begin
//                audio_out <= clk0p3;
//            end
//            5'd4: begin
//                audio_out <= clk0p4;
//            end
//            5'd5: begin
//                audio_out <= clk0p5;
//            end
//            5'd6: begin
//                audio_out <= clk0p6;
//            end
//            5'd7: begin
//                audio_out <= clk0p7;
//            end
//            5'd8: begin
//                audio_out <= clk0p8;
//            end
//            5'd9: begin
//                audio_out <= clk0p9;
//            end
//            5'd10: begin
//                audio_out <= clk1;
//            end                                                
//        endcase        
//    end
        
endmodule