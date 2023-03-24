`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2023 10:33:45 AM
// Design Name: 
// Module Name: toggle_display
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

module toggle_display(input clk, input [4:0] sw, input [12:0] pixel_index, output reg [15:0] oled_data = 0);
    wire [12:0] x_index; wire [12:0] y_index;
    assign x_index = pixel_index % 96;
    assign y_index = pixel_index / 96;
   
    always @(posedge clk) begin
        //display green border
        if (~sw[4] & ((x_index >= 57 & x_index <= 59 & y_index <= 59) | (y_index >= 57 & y_index <= 59 & x_index <= 59))) begin
            oled_data <= 16'h07E0;
        end
        else begin
            oled_data <= 0;
        end
        //display number 3
        if (sw[3]) begin
            if ((x_index >= 5 & x_index <= 45 & ((y_index >= 5 & y_index <= 10) | (y_index >= 25 & y_index <= 30) | (y_index >= 45 & y_index <= 50)))
                | (y_index >= 5 & y_index <= 50 & x_index >= 40 & x_index <= 45))
            begin
                oled_data <= 16'hFFFF;
            end 
        end
        //display number 2
        else if (sw[2]) begin
            if ((x_index >= 5 & x_index <= 45 & ((y_index >= 5 & y_index <= 10) | (y_index >= 25 & y_index <= 30) | (y_index >= 45 & y_index <= 50)))
                | (y_index >= 5 & y_index <= 30 & x_index >= 40 & x_index <= 45)
                | (y_index >= 25 & y_index <= 50 & x_index >= 5 & x_index <= 10)) 
            begin
                oled_data <= 16'hFFFF;
            end 
        end
        //display number 1
        else if (sw[1]) begin
            if ((x_index >= 28 & x_index <= 33 & y_index >= 5 & y_index <= 50)) begin
                oled_data <= 16'hFFFF;
            end
        end
        
    end
endmodule

