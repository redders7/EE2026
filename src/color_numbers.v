`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 06:44:00 PM
// Design Name: 
// Module Name: color_numbers
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


module color_numbers(input CLOCK, input sw15_turned_off, output reg[6:0] num_seg = 0, input [11:0] xpos, ypos, input[12:0] pixel_index, input left, middle, right);
    wire [12:0] xpos_scaled;
    wire [12:0] ypos_scaled;
    reg [12:0] curr_x;
    reg [12:0] curr_y;
    reg alt = 0;
    assign xpos_scaled = xpos / 4;
    assign ypos_scaled = ypos / 4;
    
    
    always @(posedge CLOCK) begin
        alt <= (middle) ? ~alt : alt;
        if (alt) begin
        curr_x <= (xpos_scaled > 94) ? 94 : (xpos_scaled < 1) ? 1 : xpos_scaled;
        curr_y <= (ypos_scaled > 62) ? 62 : (ypos_scaled < 1) ? 1 : ypos_scaled;
        end
        else begin
        curr_x <= (xpos_scaled > 95) ? 95 : (xpos_scaled < 0) ? 0 : xpos_scaled;
        curr_y <= (ypos_scaled > 63) ? 63 : (ypos_scaled < 0) ? 0 : ypos_scaled;
        end
        if (sw15_turned_off) begin
            num_seg <= 7'b0000000;
        end
        else begin
        if (left) begin
            if (curr_x > 10 & curr_x < 40 & curr_y > 5 & curr_y < 10) begin num_seg[0] <= 1; end
            else if (curr_x > 40 & curr_x < 45 & curr_y > 10 & curr_y < 25) begin num_seg[1] <= 1; end
            else if (curr_x > 40 & curr_x < 45 & curr_y > 30 & curr_y < 45) begin num_seg[2] <= 1; end
            else if (curr_x > 10 & curr_x < 40 & curr_y > 45 & curr_y < 50) begin num_seg[3] <= 1; end
            else if (curr_x > 5 & curr_x < 10 & curr_y > 30 & curr_y < 45) begin num_seg[4] <= 1; end
            else if (curr_x > 5 & curr_x < 10 & curr_y > 10 & curr_y < 25) begin num_seg[5] <= 1; end
            else if (curr_x > 10 & curr_x < 40 & curr_y > 25 & curr_y < 30) begin num_seg[6] <= 1; end
        end
        else if (right) begin
            if (curr_x > 10 & curr_x < 40 & curr_y > 5 & curr_y < 10) begin num_seg[0] <= 0; end
            else if (curr_x > 40 & curr_x < 45 & curr_y > 10 & curr_y < 25) begin num_seg[1] <= 0; end
            else if (curr_x > 40 & curr_x < 45 & curr_y > 30 & curr_y < 45) begin num_seg[2] <= 0; end
            else if (curr_x > 10 & curr_x < 40 & curr_y > 45 & curr_y < 50) begin num_seg[3] <= 0; end             
            else if (curr_x > 5 & curr_x < 10 & curr_y > 30 & curr_y < 45) begin num_seg[4] <= 0; end
            else if (curr_x > 5 & curr_x < 10 & curr_y > 10 & curr_y < 25) begin num_seg[5] <= 0; end
            else if (curr_x > 10 & curr_x < 40 & curr_y > 25 & curr_y < 30) begin num_seg[6] <= 0; end
        end
        end
    end 
endmodule
















