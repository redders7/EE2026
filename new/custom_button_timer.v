`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 12:26:38 PM
// Design Name: 
// Module Name: custom_button_timer
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


module custom_button_timer(
    input basys_clock,
    input BUTTON_C,
    input [4:0] isValidNumber,
    output reg play_audio = 0
    );
    
    wire clk0p1, clk4Hz, Q1, Q2, buttonPress;
    reg [4:0] count = 0;
    reg my_clock_out = 0;
    reg previous_BTNC;
    
    
    clk_divider(.CLOCK(basys_clock),.m(4999999), .a(clk0p1));
    clk_divider(.CLOCK(basys_clock), .m(12499999), .a(clk4Hz));    
    D_FF dff1(clk4Hz, BUTTON_C, Q1);
    D_FF dff2(clk4Hz, Q1, Q2);
    assign buttonPress = Q1 & ~Q2;
    reg a = 0;
    reg [4:0] prevNumber;
    
    always @ (posedge clk0p1) begin
        if (isValidNumber == 0) begin
            prevNumber <= 0;
        end
        if (a == 0) begin
            play_audio <= 0;
            if (buttonPress)
            begin
                a <= 1;
                count <= 5'd10;
            end
            else if (isValidNumber != 0 && prevNumber != isValidNumber)
            begin
                a <= 1;
                count <= isValidNumber;
                prevNumber <= isValidNumber;
            end
        end
        else begin
            count <= count - 1;
            a <= (count == 0) ? 0 : 1;
            play_audio <= 1;            
        end 
    end
        
    
endmodule