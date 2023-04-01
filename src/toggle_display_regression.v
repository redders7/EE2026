`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 19:08:01
// Design Name: 
// Module Name: toggle_display_regression
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


module toggle_display_regression(input start, input [3:0] displayState, input CLOCK, input [15:0] sw, input [12:0] pixel_index, output reg [15:0] oled_data = 0, input [11:0] xpos, ypos, input left, middle, right);
    // Screen States
    parameter MENU = 4'd0;
    parameter TEAM = 4'd1;
    parameter MOLE = 4'd2;
    parameter REGRESSION = 4'd3;
    parameter RECORDER = 4'd4;
    parameter MUSIC = 4'd5;
    parameter ABOUTUS = 4'd6;
    parameter OFF = 4'b1111;
    
    wire [13:0] x_coord; 
    wire [13:0] y_coord;
    assign x_coord = pixel_index % 96;
    assign y_coord = pixel_index / 96;
    
    
    wire [12:0] xpos_scaled;
    wire [12:0] ypos_scaled;
    reg [12:0] curr_x;
    reg [12:0] curr_y;
    
    assign xpos_scaled = xpos / 4;
    assign ypos_scaled = ypos / 4;
    
    reg pixel_colored[6143:0];
    reg [12:0] cur_pos;
    reg signed [31:0] sum_x;
    reg signed [31:0] sum_y;
    reg signed [47:0] sum_xy;
    reg signed [47:0] sum_xsquared;
    reg signed [31:0] n;
    reg signed [47:0] slope;
    reg signed [47:0] intercept;
    reg signed [31:0] y_check; 
    
    integer i;
    
    always @(posedge CLOCK) begin
        if (displayState == REGRESSION & sw[10]) begin
            //display axis
            if ((x_coord >= 47 & x_coord <= 47) | (y_coord >= 31 & y_coord <= 31)) begin
                oled_data <= 16'hFFFF;
            end 
            //display colored points on graph
            else if (pixel_colored[pixel_index] == 1) begin
                oled_data <= 16'h07E0;
            end
            //display graph, cursor or blanks
            else begin
                curr_x <= (xpos_scaled > 95) ? 95 : (xpos_scaled < 0) ? 0 : xpos_scaled;
                curr_y <= (ypos_scaled > 63) ? 63 : (ypos_scaled < 0) ? 0 : ypos_scaled;
                cur_pos <= curr_x + curr_y*96;
                y_check = x_coord * slope + intercept;
                if (sw[11] == 1 &  (y_check + y_coord * 100 >= 6200) & (y_check + y_coord * 100 <= 6400)) oled_data = 16'b0000000000111111; 
                else if (x_coord == curr_x && y_coord == curr_y) oled_data = 16'b1111100000000000;
                else oled_data = 0;
                if (left) begin
                    if (pixel_colored[cur_pos] == 0) begin
                        pixel_colored[cur_pos] = 1;
                        n = n + 1;
                        sum_x = sum_x + curr_x;
                        sum_y = sum_y + ((63 - curr_y) * 100);
                        sum_xy = sum_xy + curr_x * ((63 - curr_y) * 100);
                        sum_xsquared = sum_xsquared + (curr_x * curr_x);
                    end
                end
                if (right) begin
                    if (pixel_colored[cur_pos] == 1) begin
                        pixel_colored[cur_pos] = 0;
                        n = n - 1;
                        sum_x = sum_x - curr_x;
                        sum_y = sum_y - ((63 - curr_y) * 100);
                        sum_xy = sum_xy - curr_x * ((63 - curr_y) * 100);
                        sum_xsquared = sum_xsquared - (curr_x * curr_x);
                    end
                end
                slope = (sum_xy * n - (sum_x * sum_y)) / (sum_xsquared * n - (sum_x * sum_x));
                intercept = (sum_y - (slope * sum_x)) / n;
             end 
        end
        else if (displayState == REGRESSION & ~sw[10]) begin
            pixel_colored[pixel_index] = 0;
            n = 0;
            sum_x = 0;
            sum_y = 0;
            sum_xy = 0;
            sum_xsquared = 0;
            slope = 0;
            intercept = 0;
        end   
    end
    
endmodule
