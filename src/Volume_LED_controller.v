`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 12:47:39 PM
// Design Name: 
// Module Name: Volume_LED_controller
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

module Volume_LED_controller(
    input [3:0] volume, basys_clock,
    output reg [9:0] led, 
    output [6:0] seg2
    );

    reg [6:0] seg;
    assign seg2 = seg;
    always @ (posedge basys_clock)
        begin
        if (volume == 0) begin
            led <= 10'b00_0000_0001;
            seg <= 7'b1000000;
        end
        else if (volume == 1) begin
            led <= 10'b00_0000_0011;
            seg <= 7'b1111001;
        end
        else if (volume == 2) begin
            led <= 10'b00_0000_0111;
            seg <= 7'b0100100;
        end
        else if (volume == 3) begin
            led <= 10'b00_0000_1111;
            seg <= 7'b0110000;
        end
        else if (volume == 4) begin
            led <= 10'b00_0001_1111;
            seg <= 7'b0011001;
        end
        else if (volume == 5) begin
            led <= 10'b00_0011_1111;
            seg <= 7'b0010010;
        end
        else if (volume == 6) begin
            led <= 10'b00_0111_1111;
            seg <= 7'b0000010;
        end
        else if (volume == 7) begin
            led <= 10'b00_1111_1111;
            seg <= 7'b1111000;
        end
        else if (volume == 8) begin
            led <= 10'b01_1111_1111;
            seg <= 7'b00000000;
        end
        else if (volume == 9) begin
            led <= 10'b11_1111_1111;
            seg <= 7'b0010000;
        end
    end
    
    
endmodule
