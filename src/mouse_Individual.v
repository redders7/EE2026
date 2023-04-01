`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2023 09:13:05
// Design Name: 
// Module Name: mouseIndividual
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


module mouseIndividual(
    input clock,
    input left, middle, right,
    input [11:0] xpos,
    input [11:0] ypos,
    input [12:0] pixel_index,
    output reg [15:0] oled_data = 0,
    input [4:0] sw,
    input [6:0] num_seg
    );
    
    reg alt = 0;
    wire [12:0] x_coord;
    assign x_coord = pixel_index % 96;
    wire [12:0] y_coord;
    assign y_coord = pixel_index / 96;
    reg [12:0] curr_x;
    reg [12:0] curr_y; 
    wire [12:0] xpos_scaled;
    wire [12:0] ypos_scaled;
    assign xpos_scaled = xpos / 4;
    assign ypos_scaled = ypos / 4;
//    assign curr_x = (xpos_scaled > 95) ? 95 : (xpos_scaled < 1) ? 1 : xpos_scaled;
//    assign curr_y = (ypos_scaled > 63) ? 63 : (ypos_scaled < 1) ? 1 : ypos_scaled;
    
    always @ (posedge clock) begin
        //display green lines 
        if (~sw[4] & ((x_coord >= 57 & x_coord <= 59 & y_coord <= 59) | (y_coord >= 57 & y_coord <= 59 & x_coord <= 59))) begin
            oled_data <= 16'h07E0;
        end
        
        //display white borders
        else if (((x_coord === 5 | x_coord === 10 | x_coord == 40 | x_coord === 45) & (y_coord >= 5 & y_coord <= 50)) |
                ((x_coord >= 5 & x_coord <= 45) & (y_coord === 5 | y_coord === 10 | y_coord === 25 | y_coord === 30 | y_coord === 45 | y_coord === 50))) begin
            oled_data <= 16'hFFFF;
        end
        
        //if coloured, display colors at segments
        else if (num_seg[0] & (x_coord > 10 & x_coord < 40 & y_coord > 5 & y_coord < 10)) begin oled_data <= 16'hFFFF; end
        else if (num_seg[1] & (x_coord > 40 & x_coord < 45 & y_coord > 10 & y_coord < 25)) begin oled_data <= 16'hFFFF; end
        else if (num_seg[2] & (x_coord > 40 & x_coord < 45 & y_coord > 30 & y_coord < 45)) begin oled_data <= 16'hFFFF; end
        else if (num_seg[3] & (x_coord > 10 & x_coord < 40 & y_coord > 45 & y_coord < 50)) begin oled_data <= 16'hFFFF; end
        else if (num_seg[4] & (x_coord > 5 & x_coord < 10 & y_coord > 30 & y_coord < 45)) begin oled_data <= 16'hFFFF; end
        else if (num_seg[5] & (x_coord > 5 & x_coord < 10 & y_coord > 10 & y_coord < 25)) begin oled_data <= 16'hFFFF; end
        else if (num_seg[6] & (x_coord > 10 & x_coord < 40 & y_coord > 25 & y_coord < 30)) begin oled_data <= 16'hFFFF; end
        
        //if coloured, display colors at corner boxes
        else if ((num_seg[0] | num_seg[5]) & ((x_coord > 5 & x_coord < 10 & y_coord > 5 & y_coord < 10))) begin oled_data <= 16'hFFFF; end
        else if ((num_seg[0] | num_seg[1]) & ((x_coord > 40 & x_coord < 45 & y_coord > 5 & y_coord < 10))) begin oled_data <= 16'hFFFF; end
        else if ((num_seg[4] | num_seg[5] | num_seg[6]) & ((x_coord > 5 & x_coord < 10 & y_coord > 25 & y_coord < 30))) begin oled_data <= 16'hFFFF; end
        else if ((num_seg[1] | num_seg[2] | num_seg[6]) & ((x_coord > 40 & x_coord < 45 & y_coord > 25 & y_coord < 30))) begin oled_data <= 16'hFFFF; end
        else if ((num_seg[3] | num_seg[4]) & ((x_coord > 5 & x_coord < 10 & y_coord > 45 & y_coord < 50))) begin oled_data <= 16'hFFFF; end
        else if ((num_seg[2] | num_seg[3]) & ((x_coord > 40 & x_coord < 45 & y_coord > 45 & y_coord < 50))) begin oled_data <= 16'hFFFF; end
        
        //finally if everything is empty, display mouse positions
        else begin
        alt <= (middle) ? ~alt : alt;
        if ((alt))
        begin
            curr_x <= (xpos_scaled > 94) ? 94 : (xpos_scaled < 0) ? 0 : xpos_scaled;
            curr_y <= (ypos_scaled > 62) ? 62 : (ypos_scaled < 0) ? 0 : ypos_scaled;
            if ((x_coord == curr_x && y_coord == curr_y) | (x_coord == curr_x+1 && y_coord == curr_y) | (x_coord == curr_x-1 && y_coord == curr_y)|
                (x_coord == curr_x && y_coord == curr_y+1) | (x_coord == curr_x+1 && y_coord == curr_y+1) | (x_coord == curr_x-1 && y_coord == curr_y+1) |
                (x_coord == curr_x && y_coord == curr_y-1) | (x_coord == curr_x+1 && y_coord == curr_y-1) |  (x_coord == curr_x-1 && y_coord == curr_y-1))                  
            begin
                oled_data <= 16'b0000011111100000;
            end
            else begin
                oled_data <= 0;
            end
        end
        
        else if (~alt) 
        begin
            curr_x <= (xpos_scaled > 95) ? 95 : (xpos_scaled < 0) ? 0 : xpos_scaled;
            curr_y <= (ypos_scaled > 63) ? 63 : (ypos_scaled < 0) ? 0 : ypos_scaled;
            if (x_coord == curr_x && y_coord == curr_y)
            begin
                oled_data <= 16'b1111100000000000;
            end
            else begin
                oled_data <= 0;
            end
        end
        end
    end
endmodule
