`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 14:58:41
// Design Name: 
// Module Name: menu_toggle
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


module menu_toggle(
    input clk,
    input [15:0] sw,
    input [3:0] displayState,
    input [15:0] menu_data, input [15:0] regression_data, input [15:0] mole_data, input [15:0] mouse_data, input [15:0] number_data, input [15:0] image_data,
    input [3:0] mole_anode, input [3:0] team_anode,
    input [6:0] mole_seg, input [6:0] team_seg, 
    input [12:0] pixel_index,
    output reg [15:0] oled_data = 0,
    output reg mole_start, regression_start, team_start,
    output reg [3:0] an = 4'b1111,
    output reg [6:0] seg = 7'b1111111
    );
    
    // Colours
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF;
    parameter RED = 16'hF800;
    parameter CYAN = 16'h07FF;
    parameter DARK_BLUE = 16'h002B;
    parameter BEIGE = 16'hE633;
    parameter GREEN = 16'h07E0;
    parameter BROWN = 16'hA145;
    parameter GREY = 16'hC639;
    parameter PINK = 16'hE2B0;
    parameter ORANGE = 16'hFC00;
    
    // Screen States
    parameter MENU = 4'd0;
    parameter TEAM = 4'd1;
    parameter MOLE = 4'd2;
    parameter REGRESSION = 4'd3;
    parameter RECORDER = 4'd4;
    parameter MUSIC = 4'd5;
    parameter ABOUTUS = 4'd6;
    parameter OFF = 4'b1111;
    
    // Display Screen for Recorder and Music
    wire recorder_home, music_home;
    wire [12:0] x_index; // OLED next x_pixel
    wire [12:0] y_index; // OLED next y_pixel
    assign x_index = pixel_index % 96;
    assign y_index = pixel_index / 96;
    assign recorder_home = ((x_index == 15 && y_index == 25) || (x_index == 16 && y_index == 25) || (x_index == 17 && y_index == 25) || (x_index == 18 && y_index == 25) || (x_index == 15 && y_index == 26) || (x_index == 15 && y_index == 27) || (x_index == 16 && y_index == 27) || (x_index == 17 && y_index == 27) || (x_index == 18 && y_index == 27) || (x_index == 18 && y_index == 28) || (x_index == 15 && y_index == 29) || (x_index == 16 && y_index == 29) || (x_index == 17 && y_index == 29) || (x_index == 18 && y_index == 29) || (x_index == 20 && y_index == 25) || (x_index == 24 && y_index == 25) || (x_index == 20 && y_index == 26) || (x_index == 24 && y_index == 26) || (x_index == 20 && y_index == 27) || (x_index == 24 && y_index == 27) || (x_index == 20 && y_index == 28) || (x_index == 22 && y_index == 28) || (x_index == 24 && y_index == 28) || (x_index == 21 && y_index == 29) || (x_index == 23 && y_index == 29) || (x_index == 26 && y_index == 25) || (x_index == 27 && y_index == 25) || (x_index == 28 && y_index == 25) || (x_index == 26 && y_index == 26) || (x_index == 28 && y_index == 26) || (x_index == 26 && y_index == 27) || (x_index == 27 && y_index == 27) || (x_index == 28 && y_index == 27) || (x_index == 26 && y_index == 28) || (x_index == 28 && y_index == 28) || (x_index == 26 && y_index == 29) || (x_index == 27 && y_index == 29) || (x_index == 28 && y_index == 29) || (x_index == 31 && y_index == 27) || (x_index == 32 && y_index == 27) || (x_index == 33 && y_index == 27) || (x_index == 34 && y_index == 27) || (x_index == 35 && y_index == 27) || (x_index == 38 && y_index == 25) || (x_index == 42 && y_index == 25) || (x_index == 38 && y_index == 26) || (x_index == 42 && y_index == 26) || (x_index == 38 && y_index == 27) || (x_index == 42 && y_index == 27) || (x_index == 39 && y_index == 28) || (x_index == 41 && y_index == 28) || (x_index == 40 && y_index == 29) || (x_index == 45 && y_index == 25) || (x_index == 46 && y_index == 25) || (x_index == 44 && y_index == 26) || (x_index == 47 && y_index == 26) || (x_index == 44 && y_index == 27) || (x_index == 47 && y_index == 27) || (x_index == 44 && y_index == 28) || (x_index == 47 && y_index == 28) || (x_index == 45 && y_index == 29) || (x_index == 46 && y_index == 29) || (x_index == 49 && y_index == 25) || (x_index == 49 && y_index == 26) || (x_index == 49 && y_index == 27) || (x_index == 49 && y_index == 28) || (x_index == 49 && y_index == 29) || (x_index == 50 && y_index == 29) || (x_index == 51 && y_index == 29) || (x_index == 52 && y_index == 29) || (x_index == 54 && y_index == 25) || (x_index == 57 && y_index == 25) || (x_index == 54 && y_index == 26) || (x_index == 57 && y_index == 26) || (x_index == 54 && y_index == 27) || (x_index == 57 && y_index == 27) || (x_index == 54 && y_index == 28) || (x_index == 57 && y_index == 28) || (x_index == 55 && y_index == 29) || (x_index == 56 && y_index == 29) || (x_index == 59 && y_index == 25) || (x_index == 63 && y_index == 25) || (x_index == 59 && y_index == 26) || (x_index == 60 && y_index == 26) || (x_index == 62 && y_index == 26) || (x_index == 63 && y_index == 26) || (x_index == 59 && y_index == 27) || (x_index == 61 && y_index == 27) || (x_index == 63 && y_index == 27) || (x_index == 59 && y_index == 28) || (x_index == 63 && y_index == 28) || (x_index == 59 && y_index == 29) || (x_index == 63 && y_index == 29) || (x_index == 65 && y_index == 25) || (x_index == 66 && y_index == 25) || (x_index == 67 && y_index == 25) || (x_index == 68 && y_index == 25) || (x_index == 65 && y_index == 26) || (x_index == 65 && y_index == 27) || (x_index == 66 && y_index == 27) || (x_index == 67 && y_index == 27) || (x_index == 68 && y_index == 27) || (x_index == 65 && y_index == 28) || (x_index == 65 && y_index == 29) || (x_index == 66 && y_index == 29) || (x_index == 67 && y_index == 29) || (x_index == 68 && y_index == 29) || (x_index == 71 && y_index == 25) || (x_index == 74 && y_index == 25) || (x_index == 71 && y_index == 26) || (x_index == 74 && y_index == 26) || (x_index == 71 && y_index == 27) || (x_index == 74 && y_index == 27) || (x_index == 71 && y_index == 28) || (x_index == 74 && y_index == 28) || (x_index == 72 && y_index == 29) || (x_index == 73 && y_index == 29) || (x_index == 76 && y_index == 25) || (x_index == 77 && y_index == 25) || (x_index == 78 && y_index == 25) || (x_index == 76 && y_index == 26) || (x_index == 79 && y_index == 26) || (x_index == 76 && y_index == 27) || (x_index == 77 && y_index == 27) || (x_index == 78 && y_index == 27) || (x_index == 76 && y_index == 28) || (x_index == 76 && y_index == 29))
                         | ((x_index == 10 && y_index == 32) || (x_index == 11 && y_index == 32) || (x_index == 12 && y_index == 32) || (x_index == 13 && y_index == 32) || (x_index == 10 && y_index == 33) || (x_index == 10 && y_index == 34) || (x_index == 11 && y_index == 34) || (x_index == 12 && y_index == 34) || (x_index == 13 && y_index == 34) || (x_index == 13 && y_index == 35) || (x_index == 10 && y_index == 36) || (x_index == 11 && y_index == 36) || (x_index == 12 && y_index == 36) || (x_index == 13 && y_index == 36) || (x_index == 15 && y_index == 32) || (x_index == 19 && y_index == 32) || (x_index == 15 && y_index == 33) || (x_index == 19 && y_index == 33) || (x_index == 15 && y_index == 34) || (x_index == 19 && y_index == 34) || (x_index == 15 && y_index == 35) || (x_index == 17 && y_index == 35) || (x_index == 19 && y_index == 35) || (x_index == 16 && y_index == 36) || (x_index == 18 && y_index == 36) || (x_index == 21 && y_index == 32) || (x_index == 22 && y_index == 32) || (x_index == 23 && y_index == 32) || (x_index == 21 && y_index == 33) || (x_index == 23 && y_index == 33) || (x_index == 21 && y_index == 34) || (x_index == 22 && y_index == 34) || (x_index == 23 && y_index == 34) || (x_index == 23 && y_index == 35) || (x_index == 21 && y_index == 36) || (x_index == 22 && y_index == 36) || (x_index == 23 && y_index == 36) || (x_index == 26 && y_index == 34) || (x_index == 27 && y_index == 34) || (x_index == 28 && y_index == 34) || (x_index == 29 && y_index == 34) || (x_index == 30 && y_index == 34) || (x_index == 33 && y_index == 32) || (x_index == 37 && y_index == 32) || (x_index == 33 && y_index == 33) || (x_index == 37 && y_index == 33) || (x_index == 33 && y_index == 34) || (x_index == 37 && y_index == 34) || (x_index == 34 && y_index == 35) || (x_index == 36 && y_index == 35) || (x_index == 35 && y_index == 36) || (x_index == 40 && y_index == 32) || (x_index == 41 && y_index == 32) || (x_index == 39 && y_index == 33) || (x_index == 42 && y_index == 33) || (x_index == 39 && y_index == 34) || (x_index == 42 && y_index == 34) || (x_index == 39 && y_index == 35) || (x_index == 42 && y_index == 35) || (x_index == 40 && y_index == 36) || (x_index == 41 && y_index == 36) || (x_index == 44 && y_index == 32) || (x_index == 44 && y_index == 33) || (x_index == 44 && y_index == 34) || (x_index == 44 && y_index == 35) || (x_index == 44 && y_index == 36) || (x_index == 45 && y_index == 36) || (x_index == 46 && y_index == 36) || (x_index == 47 && y_index == 36) || (x_index == 49 && y_index == 32) || (x_index == 52 && y_index == 32) || (x_index == 49 && y_index == 33) || (x_index == 52 && y_index == 33) || (x_index == 49 && y_index == 34) || (x_index == 52 && y_index == 34) || (x_index == 49 && y_index == 35) || (x_index == 52 && y_index == 35) || (x_index == 50 && y_index == 36) || (x_index == 51 && y_index == 36) || (x_index == 54 && y_index == 32) || (x_index == 58 && y_index == 32) || (x_index == 54 && y_index == 33) || (x_index == 55 && y_index == 33) || (x_index == 57 && y_index == 33) || (x_index == 58 && y_index == 33) || (x_index == 54 && y_index == 34) || (x_index == 56 && y_index == 34) || (x_index == 58 && y_index == 34) || (x_index == 54 && y_index == 35) || (x_index == 58 && y_index == 35) || (x_index == 54 && y_index == 36) || (x_index == 58 && y_index == 36) || (x_index == 60 && y_index == 32) || (x_index == 61 && y_index == 32) || (x_index == 62 && y_index == 32) || (x_index == 63 && y_index == 32) || (x_index == 60 && y_index == 33) || (x_index == 60 && y_index == 34) || (x_index == 61 && y_index == 34) || (x_index == 62 && y_index == 34) || (x_index == 63 && y_index == 34) || (x_index == 60 && y_index == 35) || (x_index == 60 && y_index == 36) || (x_index == 61 && y_index == 36) || (x_index == 62 && y_index == 36) || (x_index == 63 && y_index == 36) || (x_index == 66 && y_index == 32) || (x_index == 67 && y_index == 32) || (x_index == 68 && y_index == 32) || (x_index == 66 && y_index == 33) || (x_index == 69 && y_index == 33) || (x_index == 66 && y_index == 34) || (x_index == 69 && y_index == 34) || (x_index == 66 && y_index == 35) || (x_index == 69 && y_index == 35) || (x_index == 66 && y_index == 36) || (x_index == 67 && y_index == 36) || (x_index == 68 && y_index == 36) || (x_index == 72 && y_index == 32) || (x_index == 73 && y_index == 32) || (x_index == 71 && y_index == 33) || (x_index == 74 && y_index == 33) || (x_index == 71 && y_index == 34) || (x_index == 74 && y_index == 34) || (x_index == 71 && y_index == 35) || (x_index == 74 && y_index == 35) || (x_index == 72 && y_index == 36) || (x_index == 73 && y_index == 36) || (x_index == 76 && y_index == 32) || (x_index == 80 && y_index == 32) || (x_index == 76 && y_index == 33) || (x_index == 80 && y_index == 33) || (x_index == 76 && y_index == 34) || (x_index == 80 && y_index == 34) || (x_index == 76 && y_index == 35) || (x_index == 78 && y_index == 35) || (x_index == 80 && y_index == 35) || (x_index == 77 && y_index == 36) || (x_index == 79 && y_index == 36) || (x_index == 82 && y_index == 32) || (x_index == 85 && y_index == 32) || (x_index == 82 && y_index == 33) || (x_index == 83 && y_index == 33) || (x_index == 85 && y_index == 33) || (x_index == 82 && y_index == 34) || (x_index == 84 && y_index == 34) || (x_index == 85 && y_index == 34) || (x_index == 82 && y_index == 35) || (x_index == 85 && y_index == 35) || (x_index == 82 && y_index == 36) || (x_index == 85 && y_index == 36));
    assign music_home = ((x_index == 21 && y_index == 25) || (x_index == 22 && y_index == 25) || (x_index == 23 && y_index == 25) || (x_index == 21 && y_index == 26) || (x_index == 24 && y_index == 26) || (x_index == 21 && y_index == 27) || (x_index == 22 && y_index == 27) || (x_index == 23 && y_index == 27) || (x_index == 21 && y_index == 28) || (x_index == 21 && y_index == 29) || (x_index == 26 && y_index == 25) || (x_index == 27 && y_index == 25) || (x_index == 28 && y_index == 25) || (x_index == 26 && y_index == 26) || (x_index == 29 && y_index == 26) || (x_index == 26 && y_index == 27) || (x_index == 27 && y_index == 27) || (x_index == 28 && y_index == 27) || (x_index == 26 && y_index == 28) || (x_index == 28 && y_index == 28) || (x_index == 26 && y_index == 29) || (x_index == 29 && y_index == 29) || (x_index == 31 && y_index == 25) || (x_index == 32 && y_index == 25) || (x_index == 33 && y_index == 25) || (x_index == 34 && y_index == 25) || (x_index == 31 && y_index == 26) || (x_index == 31 && y_index == 27) || (x_index == 32 && y_index == 27) || (x_index == 33 && y_index == 27) || (x_index == 34 && y_index == 27) || (x_index == 31 && y_index == 28) || (x_index == 31 && y_index == 29) || (x_index == 32 && y_index == 29) || (x_index == 33 && y_index == 29) || (x_index == 34 && y_index == 29) || (x_index == 36 && y_index == 25) || (x_index == 37 && y_index == 25) || (x_index == 38 && y_index == 25) || (x_index == 39 && y_index == 25) || (x_index == 36 && y_index == 26) || (x_index == 36 && y_index == 27) || (x_index == 37 && y_index == 27) || (x_index == 38 && y_index == 27) || (x_index == 39 && y_index == 27) || (x_index == 39 && y_index == 28) || (x_index == 36 && y_index == 29) || (x_index == 37 && y_index == 29) || (x_index == 38 && y_index == 29) || (x_index == 39 && y_index == 29) || (x_index == 41 && y_index == 25) || (x_index == 42 && y_index == 25) || (x_index == 43 && y_index == 25) || (x_index == 44 && y_index == 25) || (x_index == 41 && y_index == 26) || (x_index == 41 && y_index == 27) || (x_index == 42 && y_index == 27) || (x_index == 43 && y_index == 27) || (x_index == 44 && y_index == 27) || (x_index == 44 && y_index == 28) || (x_index == 41 && y_index == 29) || (x_index == 42 && y_index == 29) || (x_index == 43 && y_index == 29) || (x_index == 44 && y_index == 29) || (x_index == 47 && y_index == 25) || (x_index == 48 && y_index == 25) || (x_index == 49 && y_index == 25) || (x_index == 47 && y_index == 26) || (x_index == 50 && y_index == 26) || (x_index == 47 && y_index == 27) || (x_index == 48 && y_index == 27) || (x_index == 49 && y_index == 27) || (x_index == 47 && y_index == 28) || (x_index == 50 && y_index == 28) || (x_index == 47 && y_index == 29) || (x_index == 48 && y_index == 29) || (x_index == 49 && y_index == 29) || (x_index == 52 && y_index == 25) || (x_index == 53 && y_index == 25) || (x_index == 54 && y_index == 25) || (x_index == 53 && y_index == 26) || (x_index == 53 && y_index == 27) || (x_index == 53 && y_index == 28) || (x_index == 53 && y_index == 29) || (x_index == 56 && y_index == 25) || (x_index == 59 && y_index == 25) || (x_index == 56 && y_index == 26) || (x_index == 57 && y_index == 26) || (x_index == 59 && y_index == 26) || (x_index == 56 && y_index == 27) || (x_index == 58 && y_index == 27) || (x_index == 59 && y_index == 27) || (x_index == 56 && y_index == 28) || (x_index == 59 && y_index == 28) || (x_index == 56 && y_index == 29) || (x_index == 59 && y_index == 29) || (x_index == 61 && y_index == 25) || (x_index == 62 && y_index == 25) || (x_index == 63 && y_index == 25) || (x_index == 61 && y_index == 26) || (x_index == 64 && y_index == 26) || (x_index == 61 && y_index == 27) || (x_index == 64 && y_index == 27) || (x_index == 61 && y_index == 28) || (x_index == 64 && y_index == 28) || (x_index == 61 && y_index == 29) || (x_index == 62 && y_index == 29) || (x_index == 63 && y_index == 29) || (x_index == 67 && y_index == 25) || (x_index == 68 && y_index == 25) || (x_index == 69 && y_index == 25) || (x_index == 68 && y_index == 26) || (x_index == 68 && y_index == 27) || (x_index == 68 && y_index == 28) || (x_index == 68 && y_index == 29) || (x_index == 72 && y_index == 25) || (x_index == 73 && y_index == 25) || (x_index == 71 && y_index == 26) || (x_index == 74 && y_index == 26) || (x_index == 71 && y_index == 27) || (x_index == 74 && y_index == 27) || (x_index == 71 && y_index == 28) || (x_index == 74 && y_index == 28) || (x_index == 72 && y_index == 29) || (x_index == 73 && y_index == 29))
                      | ((x_index == 20 && y_index == 32) || (x_index == 21 && y_index == 32) || (x_index == 22 && y_index == 32) || (x_index == 20 && y_index == 33) || (x_index == 23 && y_index == 33) || (x_index == 20 && y_index == 34) || (x_index == 21 && y_index == 34) || (x_index == 22 && y_index == 34) || (x_index == 20 && y_index == 35) || (x_index == 20 && y_index == 36) || (x_index == 25 && y_index == 32) || (x_index == 25 && y_index == 33) || (x_index == 25 && y_index == 34) || (x_index == 25 && y_index == 35) || (x_index == 25 && y_index == 36) || (x_index == 26 && y_index == 36) || (x_index == 27 && y_index == 36) || (x_index == 28 && y_index == 36) || (x_index == 31 && y_index == 32) || (x_index == 32 && y_index == 32) || (x_index == 30 && y_index == 33) || (x_index == 33 && y_index == 33) || (x_index == 30 && y_index == 34) || (x_index == 31 && y_index == 34) || (x_index == 32 && y_index == 34) || (x_index == 33 && y_index == 34) || (x_index == 30 && y_index == 35) || (x_index == 33 && y_index == 35) || (x_index == 30 && y_index == 36) || (x_index == 33 && y_index == 36) || (x_index == 35 && y_index == 32) || (x_index == 37 && y_index == 32) || (x_index == 35 && y_index == 33) || (x_index == 37 && y_index == 33) || (x_index == 36 && y_index == 34) || (x_index == 36 && y_index == 35) || (x_index == 36 && y_index == 36) || (x_index == 40 && y_index == 32) || (x_index == 41 && y_index == 32) || (x_index == 42 && y_index == 32) || (x_index == 41 && y_index == 33) || (x_index == 41 && y_index == 34) || (x_index == 41 && y_index == 35) || (x_index == 41 && y_index == 36) || (x_index == 44 && y_index == 32) || (x_index == 47 && y_index == 32) || (x_index == 44 && y_index == 33) || (x_index == 47 && y_index == 33) || (x_index == 44 && y_index == 34) || (x_index == 45 && y_index == 34) || (x_index == 46 && y_index == 34) || (x_index == 47 && y_index == 34) || (x_index == 44 && y_index == 35) || (x_index == 47 && y_index == 35) || (x_index == 44 && y_index == 36) || (x_index == 47 && y_index == 36) || (x_index == 49 && y_index == 32) || (x_index == 50 && y_index == 32) || (x_index == 51 && y_index == 32) || (x_index == 52 && y_index == 32) || (x_index == 49 && y_index == 33) || (x_index == 49 && y_index == 34) || (x_index == 50 && y_index == 34) || (x_index == 51 && y_index == 34) || (x_index == 52 && y_index == 34) || (x_index == 49 && y_index == 35) || (x_index == 49 && y_index == 36) || (x_index == 50 && y_index == 36) || (x_index == 51 && y_index == 36) || (x_index == 52 && y_index == 36) || (x_index == 55 && y_index == 32) || (x_index == 56 && y_index == 32) || (x_index == 57 && y_index == 32) || (x_index == 58 && y_index == 32) || (x_index == 55 && y_index == 33) || (x_index == 55 && y_index == 34) || (x_index == 56 && y_index == 34) || (x_index == 57 && y_index == 34) || (x_index == 58 && y_index == 34) || (x_index == 58 && y_index == 35) || (x_index == 55 && y_index == 36) || (x_index == 56 && y_index == 36) || (x_index == 57 && y_index == 36) || (x_index == 58 && y_index == 36) || (x_index == 61 && y_index == 32) || (x_index == 62 && y_index == 32) || (x_index == 60 && y_index == 33) || (x_index == 63 && y_index == 33) || (x_index == 60 && y_index == 34) || (x_index == 63 && y_index == 34) || (x_index == 60 && y_index == 35) || (x_index == 63 && y_index == 35) || (x_index == 61 && y_index == 36) || (x_index == 62 && y_index == 36) || (x_index == 65 && y_index == 32) || (x_index == 68 && y_index == 32) || (x_index == 65 && y_index == 33) || (x_index == 66 && y_index == 33) || (x_index == 68 && y_index == 33) || (x_index == 65 && y_index == 34) || (x_index == 67 && y_index == 34) || (x_index == 68 && y_index == 34) || (x_index == 65 && y_index == 35) || (x_index == 68 && y_index == 35) || (x_index == 65 && y_index == 36) || (x_index == 68 && y_index == 36) || (x_index == 71 && y_index == 32) || (x_index == 72 && y_index == 32) || (x_index == 73 && y_index == 32) || (x_index == 70 && y_index == 33) || (x_index == 70 && y_index == 34) || (x_index == 72 && y_index == 34) || (x_index == 73 && y_index == 34) || (x_index == 74 && y_index == 34) || (x_index == 70 && y_index == 35) || (x_index == 74 && y_index == 35) || (x_index == 71 && y_index == 36) || (x_index == 72 && y_index == 36) || (x_index == 73 && y_index == 36));
    
    always @ (posedge clk) begin
        team_start <= (displayState == TEAM) ? 1 : 0;
        mole_start <= (displayState == MOLE) ? 1 : 0;
        regression_start <= (displayState == REGRESSION) ? 1 : 0;
        case(displayState)
        MENU: begin
            oled_data <= menu_data;
            an <= OFF;
        end
        TEAM: begin
            oled_data <= (sw[1] | sw[2] | sw[3]) ? number_data : mouse_data;
            an <= team_anode;
            seg <= team_seg;
        end
        MOLE: begin
            oled_data <= mole_data;
            an <= mole_anode;
            seg <= mole_seg;
        end
        REGRESSION: begin
            oled_data <= regression_data;
            an <= OFF;
        end    
        RECORDER: begin
            if (recorder_home) begin
                oled_data <= WHITE;
            end
            else begin
                oled_data <= BLACK;
            end
            an <= OFF;
        end
        MUSIC: begin
            if (music_home) begin
                oled_data <= BLACK;
            end
            else begin
                oled_data <= BEIGE;
            end
            an <= OFF;  
        end
        ABOUTUS: begin
            oled_data <= image_data;
            an <= OFF;
        end                           
        endcase
    end
endmodule
