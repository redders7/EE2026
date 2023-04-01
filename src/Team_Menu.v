`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.03.2023 13:15:53
// Design Name: 
// Module Name: Team_Menu
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


module Team_Menu(
    input clk, 
    input left,
    input btnR,
    input btnL,
    input btnC,
    input btnU,
    input btnD,
    input [11:0] xpos,
    input [11:0] ypos,
    input [12:0] pixel_index,
    output reg [15:0] oled_data = 0,
    output reg [3:0] displayState = 0,
    output userSong
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
    reg[3:0] menu_state;
    initial begin
        menu_state <= TEAM;
    end
    assign userSong = (displayState == ABOUTUS) ? 1 : 0;
    // Mouse and OLED Setup
    wire [12:0] x_index; // OLED next x_pixel
    wire [12:0] y_index; // OLED next y_pixel
    wire [12:0] mouse_x; 
    wire [12:0] mouse_y;
    wire [12:0] curr_x; // current mouse position
    wire [12:0] curr_y;
    assign x_index = pixel_index % 96;
    assign y_index = pixel_index / 96;
    assign mouse_x = xpos / 4;
    assign mouse_y = ypos / 4; 
    assign curr_x = (mouse_x > 95) ? 95 : (mouse_x < 0) ? 0 : mouse_x;
    assign curr_y = (mouse_y > 63) ? 63 : (mouse_y < 0) ? 0 : mouse_y;   
    
    // Display words and boxes
    wire ee2026, team, mole, bestfit, recorder, aboutus, box, music;
    wire click_left, click_right, click_aboutus;
    wire T,E,A,M;
    wire left_arrow, right_arrow;
    assign left_arrow = (x_index == 23 && y_index >= 28 && y_index <= 34) |
                        (x_index == 22 && y_index >= 29 && y_index <= 33) |
                        (x_index == 21 && y_index >= 30 && y_index <= 32) |
                        (x_index == 20 && y_index == 31);
    assign right_arrow = (x_index == 73 && y_index >= 28 && y_index <= 34) |
                         (x_index == 74 && y_index >= 29 && y_index <= 33) |
                         (x_index == 75 && y_index >= 30 && y_index <= 32) |
                         (x_index == 76 && y_index == 31);            
    assign click_left = (curr_x == 23 && curr_y >= 28 && curr_y <= 34) |
                        (curr_x == 22 && curr_y >= 29 && curr_y <= 33) |
                        (curr_x == 21 && curr_y >= 30 && curr_y <= 32) |
                        (curr_x == 20 && curr_y == 31);
    assign click_right = (curr_x == 73 && curr_y >= 28 && curr_y <= 34) |
                         (curr_x == 74 && curr_y >= 29 && curr_y <= 33) |
                         (curr_x == 75 && curr_y >= 30 && curr_y <= 32) |
                         (curr_x == 76 && curr_y == 31);            
    assign click_aboutus = (curr_y >= 56 && curr_y <= 62 && curr_x >= 31 && curr_x <= 62);
    assign T = (x_index >= 27 && x_index <= 35 && y_index >= 25 && y_index <= 27) |
               (x_index >= 30 && x_index <= 32 && y_index >= 28 && y_index <= 39);
    assign E = (x_index >= 37 && x_index <= 39 && y_index >= 25 && y_index <= 39) |
               (x_index >= 40 && x_index <= 47 && y_index >= 25 && y_index <= 27) |
               (x_index >= 40 && x_index <= 44 && y_index >= 31 && y_index <= 33) |
               (x_index >= 40 && x_index <= 47 && y_index >= 37 && y_index <= 39);
    assign A = (x_index >= 49 && x_index <= 51 && y_index >= 28 && y_index <= 39) |
               (x_index >= 52 && x_index <= 56 && y_index >= 25 && y_index <= 27) |
               (x_index >= 52 && x_index <= 56 && y_index >= 31 && y_index <= 33) |
               (x_index >= 57 && x_index <= 59 && y_index >= 28 && y_index <= 39);
    assign M = (x_index >= 61 && x_index <= 63 && y_index >= 25 && y_index <= 39) | 
               (x_index >= 64 && x_index <= 66 && y_index >= 28 && y_index <= 30) |
               (x_index >= 67 && x_index <= 69 && y_index >= 31 && y_index <= 33) |
               (x_index >= 64 && x_index <= 66 && y_index >= 28 && y_index <= 30) |
               (x_index >= 67 && x_index <= 69 && y_index >= 25 && y_index <= 39); 
    assign team = T | E | A | M;
    wire W,A2,M2;
    assign W = (x_index >= 30 && x_index <= 32 && y_index >= 25 && y_index <= 36) | 
                (x_index >= 33 && x_index <= 35 && y_index >= 37 && y_index <= 39) |
                (x_index >= 36 && x_index <= 38 && y_index >= 34 && y_index <= 36) |
                (x_index >= 39 && x_index <= 41 && y_index >= 37 && y_index <= 39) |
                (x_index >= 42 && x_index <= 44 && y_index >= 25 && y_index <= 36);
    assign A2 = (x_index >= 46 && x_index <= 48 && y_index >= 28 && y_index <= 39) |
                (x_index >= 49 && x_index <= 53 && y_index >= 25 && y_index <= 27) |
                (x_index >= 49 && x_index <= 53 && y_index >= 31 && y_index <= 33) |
                (x_index >= 54 && x_index <= 56 && y_index >= 28 && y_index <= 39);
     assign M2 = (x_index >= 58 && x_index <= 60 && y_index >= 25 && y_index <= 39) | 
                (x_index >= 61 && x_index <= 63 && y_index >= 28 && y_index <= 30) |
                (x_index >= 64 && x_index <= 66 && y_index >= 31 && y_index <= 33) |
                (x_index >= 61 && x_index <= 63 && y_index >= 28 && y_index <= 30) |
                (x_index >= 64 && x_index <= 66 && y_index >= 25 && y_index <= 39);
    assign mole = W | A2 | M2;
    assign bestfit = ((x_index == 39 && y_index == 25) || (x_index == 40 && y_index == 25) || (x_index == 41 && y_index == 25) || (x_index == 39 && y_index == 26) || (x_index == 42 && y_index == 26) || (x_index == 39 && y_index == 27) || (x_index == 40 && y_index == 27) || (x_index == 41 && y_index == 27) || (x_index == 39 && y_index == 28) || (x_index == 42 && y_index == 28) || (x_index == 39 && y_index == 29) || (x_index == 40 && y_index == 29) || (x_index == 41 && y_index == 29) || (x_index == 44 && y_index == 25) || (x_index == 45 && y_index == 25) || (x_index == 46 && y_index == 25) || (x_index == 47 && y_index == 25) || (x_index == 44 && y_index == 26) || (x_index == 44 && y_index == 27) || (x_index == 45 && y_index == 27) || (x_index == 46 && y_index == 27) || (x_index == 47 && y_index == 27) || (x_index == 44 && y_index == 28) || (x_index == 44 && y_index == 29) || (x_index == 45 && y_index == 29) || (x_index == 46 && y_index == 29) || (x_index == 47 && y_index == 29) || (x_index == 49 && y_index == 25) || (x_index == 50 && y_index == 25) || (x_index == 51 && y_index == 25) || (x_index == 52 && y_index == 25) || (x_index == 49 && y_index == 26) || (x_index == 49 && y_index == 27) || (x_index == 50 && y_index == 27) || (x_index == 51 && y_index == 27) || (x_index == 52 && y_index == 27) || (x_index == 52 && y_index == 28) || (x_index == 49 && y_index == 29) || (x_index == 50 && y_index == 29) || (x_index == 51 && y_index == 29) || (x_index == 52 && y_index == 29) || (x_index == 54 && y_index == 25) || (x_index == 55 && y_index == 25) || (x_index == 56 && y_index == 25) || (x_index == 55 && y_index == 26) || (x_index == 55 && y_index == 27) || (x_index == 55 && y_index == 28) || (x_index == 55 && y_index == 29)) ||
                      ((x_index == 43 && y_index == 32) || (x_index == 44 && y_index == 32) || (x_index == 45 && y_index == 32) || (x_index == 46 && y_index == 32) || (x_index == 43 && y_index == 33) || (x_index == 43 && y_index == 34) || (x_index == 44 && y_index == 34) || (x_index == 45 && y_index == 34) || (x_index == 46 && y_index == 34) || (x_index == 43 && y_index == 35) || (x_index == 43 && y_index == 36) || (x_index == 48 && y_index == 32) || (x_index == 48 && y_index == 33) || (x_index == 48 && y_index == 34) || (x_index == 48 && y_index == 35) || (x_index == 48 && y_index == 36) || (x_index == 50 && y_index == 32) || (x_index == 51 && y_index == 32) || (x_index == 52 && y_index == 32) || (x_index == 51 && y_index == 33) || (x_index == 51 && y_index == 34) || (x_index == 51 && y_index == 35) || (x_index == 51 && y_index == 36));
    assign ee2026 = ((x_index == 35 && y_index == 3) || (x_index == 36 && y_index == 3) || (x_index == 37 && y_index == 3) || (x_index == 38 && y_index == 3) || (x_index == 35 && y_index == 4) || (x_index == 35 && y_index == 5) || (x_index == 36 && y_index == 5) || (x_index == 37 && y_index == 5) || (x_index == 38 && y_index == 5) || (x_index == 35 && y_index == 6) || (x_index == 35 && y_index == 7) || (x_index == 36 && y_index == 7) || (x_index == 37 && y_index == 7) || (x_index == 38 && y_index == 7) || (x_index == 40 && y_index == 3) || (x_index == 41 && y_index == 3) || (x_index == 42 && y_index == 3) || (x_index == 43 && y_index == 3) || (x_index == 40 && y_index == 4) || (x_index == 40 && y_index == 5) || (x_index == 41 && y_index == 5) || (x_index == 42 && y_index == 5) || (x_index == 43 && y_index == 5) || (x_index == 40 && y_index == 6) || (x_index == 40 && y_index == 7) || (x_index == 41 && y_index == 7) || (x_index == 42 && y_index == 7) || (x_index == 43 && y_index == 7) || (x_index == 45 && y_index == 3) || (x_index == 46 && y_index == 3) || (x_index == 47 && y_index == 3) || (x_index == 47 && y_index == 4) || (x_index == 45 && y_index == 5) || (x_index == 46 && y_index == 5) || (x_index == 47 && y_index == 5) || (x_index == 45 && y_index == 6) || (x_index == 45 && y_index == 7) || (x_index == 46 && y_index == 7) || (x_index == 47 && y_index == 7) || (x_index == 49 && y_index == 3) || (x_index == 50 && y_index == 3) || (x_index == 51 && y_index == 3) || (x_index == 49 && y_index == 4) || (x_index == 51 && y_index == 4) || (x_index == 49 && y_index == 5) || (x_index == 51 && y_index == 5) || (x_index == 49 && y_index == 6) || (x_index == 51 && y_index == 6) || (x_index == 49 && y_index == 7) || (x_index == 50 && y_index == 7) || (x_index == 51 && y_index == 7) || (x_index == 53 && y_index == 3) || (x_index == 54 && y_index == 3) || (x_index == 55 && y_index == 3) || (x_index == 55 && y_index == 4) || (x_index == 53 && y_index == 5) || (x_index == 54 && y_index == 5) || (x_index == 55 && y_index == 5) || (x_index == 53 && y_index == 6) || (x_index == 53 && y_index == 7) || (x_index == 54 && y_index == 7) || (x_index == 55 && y_index == 7) || (x_index == 57 && y_index == 3) || (x_index == 58 && y_index == 3) || (x_index == 59 && y_index == 3) || (x_index == 57 && y_index == 4) || (x_index == 57 && y_index == 5) || (x_index == 58 && y_index == 5) || (x_index == 59 && y_index == 5) || (x_index == 57 && y_index == 6) || (x_index == 59 && y_index == 6) || (x_index == 57 && y_index == 7) || (x_index == 58 && y_index == 7) || (x_index == 59 && y_index == 7));
    assign aboutus = ((x_index == 32 && y_index == 57) || (x_index == 33 && y_index == 57) || (x_index == 31 && y_index == 58) || (x_index == 34 && y_index == 58) || (x_index == 31 && y_index == 59) || (x_index == 32 && y_index == 59) || (x_index == 33 && y_index == 59) || (x_index == 34 && y_index == 59) || (x_index == 31 && y_index == 60) || (x_index == 34 && y_index == 60) || (x_index == 31 && y_index == 61) || (x_index == 34 && y_index == 61) || (x_index == 36 && y_index == 57) || (x_index == 37 && y_index == 57) || (x_index == 38 && y_index == 57) || (x_index == 36 && y_index == 58) || (x_index == 39 && y_index == 58) || (x_index == 36 && y_index == 59) || (x_index == 37 && y_index == 59) || (x_index == 38 && y_index == 59) || (x_index == 36 && y_index == 60) || (x_index == 39 && y_index == 60) || (x_index == 36 && y_index == 61) || (x_index == 37 && y_index == 61) || (x_index == 38 && y_index == 61) || (x_index == 42 && y_index == 57) || (x_index == 43 && y_index == 57) || (x_index == 41 && y_index == 58) || (x_index == 44 && y_index == 58) || (x_index == 41 && y_index == 59) || (x_index == 44 && y_index == 59) || (x_index == 41 && y_index == 60) || (x_index == 44 && y_index == 60) || (x_index == 42 && y_index == 61) || (x_index == 43 && y_index == 61) || (x_index == 46 && y_index == 57) || (x_index == 49 && y_index == 57) || (x_index == 46 && y_index == 58) || (x_index == 49 && y_index == 58) || (x_index == 46 && y_index == 59) || (x_index == 49 && y_index == 59) || (x_index == 46 && y_index == 60) || (x_index == 49 && y_index == 60) || (x_index == 47 && y_index == 61) || (x_index == 48 && y_index == 61) || (x_index == 51 && y_index == 57) || (x_index == 52 && y_index == 57) || (x_index == 53 && y_index == 57) || (x_index == 52 && y_index == 58) || (x_index == 52 && y_index == 59) || (x_index == 52 && y_index == 60) || (x_index == 52 && y_index == 61) || (x_index == 56 && y_index == 57) || (x_index == 59 && y_index == 57) || (x_index == 56 && y_index == 58) || (x_index == 59 && y_index == 58) || (x_index == 56 && y_index == 59) || (x_index == 59 && y_index == 59) || (x_index == 56 && y_index == 60) || (x_index == 59 && y_index == 60) || (x_index == 57 && y_index == 61) || (x_index == 58 && y_index == 61) || (x_index == 61 && y_index == 57) || (x_index == 62 && y_index == 57) || (x_index == 63 && y_index == 57) || (x_index == 64 && y_index == 57) || (x_index == 61 && y_index == 58) || (x_index == 61 && y_index == 59) || (x_index == 62 && y_index == 59) || (x_index == 63 && y_index == 59) || (x_index == 64 && y_index == 59) || (x_index == 64 && y_index == 60) || (x_index == 61 && y_index == 61) || (x_index == 62 && y_index == 61) || (x_index == 63 && y_index == 61) || (x_index == 64 && y_index == 61));
    assign recorder = ((x_index == 37 && y_index == 25) || (x_index == 41 && y_index == 25) || (x_index == 37 && y_index == 26) || (x_index == 41 && y_index == 26) || (x_index == 37 && y_index == 27) || (x_index == 41 && y_index == 27) || (x_index == 38 && y_index == 28) || (x_index == 40 && y_index == 28) || (x_index == 39 && y_index == 29) || (x_index == 44 && y_index == 25) || (x_index == 45 && y_index == 25) || (x_index == 43 && y_index == 26) || (x_index == 46 && y_index == 26) || (x_index == 43 && y_index == 27) || (x_index == 46 && y_index == 27) || (x_index == 43 && y_index == 28) || (x_index == 46 && y_index == 28) || (x_index == 44 && y_index == 29) || (x_index == 45 && y_index == 29) || (x_index == 48 && y_index == 25) || (x_index == 48 && y_index == 26) || (x_index == 48 && y_index == 27) || (x_index == 48 && y_index == 28) || (x_index == 48 && y_index == 29) || (x_index == 51 && y_index == 25) || (x_index == 52 && y_index == 25) || (x_index == 50 && y_index == 26) || (x_index == 53 && y_index == 26) || (x_index == 50 && y_index == 27) || (x_index == 50 && y_index == 28) || (x_index == 53 && y_index == 28) || (x_index == 51 && y_index == 29) || (x_index == 52 && y_index == 29) || (x_index == 55 && y_index == 25) || (x_index == 56 && y_index == 25) || (x_index == 57 && y_index == 25) || (x_index == 58 && y_index == 25) || (x_index == 55 && y_index == 26) || (x_index == 55 && y_index == 27) || (x_index == 56 && y_index == 27) || (x_index == 57 && y_index == 27) || (x_index == 58 && y_index == 27) || (x_index == 55 && y_index == 28) || (x_index == 55 && y_index == 29) || (x_index == 56 && y_index == 29) || (x_index == 57 && y_index == 29) || (x_index == 58 && y_index == 29)) |
                      ((x_index == 40 && y_index == 32) || (x_index == 41 && y_index == 32) || (x_index == 42 && y_index == 32) || (x_index == 40 && y_index == 33) || (x_index == 43 && y_index == 33) || (x_index == 40 && y_index == 34) || (x_index == 41 && y_index == 34) || (x_index == 42 && y_index == 34) || (x_index == 40 && y_index == 35) || (x_index == 42 && y_index == 35) || (x_index == 40 && y_index == 36) || (x_index == 43 && y_index == 36) || (x_index == 45 && y_index == 32) || (x_index == 46 && y_index == 32) || (x_index == 47 && y_index == 32) || (x_index == 48 && y_index == 32) || (x_index == 45 && y_index == 33) || (x_index == 45 && y_index == 34) || (x_index == 46 && y_index == 34) || (x_index == 47 && y_index == 34) || (x_index == 48 && y_index == 34) || (x_index == 45 && y_index == 35) || (x_index == 45 && y_index == 36) || (x_index == 46 && y_index == 36) || (x_index == 47 && y_index == 36) || (x_index == 48 && y_index == 36) || (x_index == 51 && y_index == 32) || (x_index == 52 && y_index == 32) || (x_index == 53 && y_index == 32) || (x_index == 50 && y_index == 33) || (x_index == 50 && y_index == 34) || (x_index == 52 && y_index == 34) || (x_index == 53 && y_index == 34) || (x_index == 54 && y_index == 34) || (x_index == 50 && y_index == 35) || (x_index == 54 && y_index == 35) || (x_index == 51 && y_index == 36) || (x_index == 52 && y_index == 36) || (x_index == 53 && y_index == 36));
    assign music = ((x_index == 37 && y_index == 28) || (x_index == 41 && y_index == 28) || (x_index == 37 && y_index == 29) || (x_index == 38 && y_index == 29) || (x_index == 40 && y_index == 29) || (x_index == 41 && y_index == 29) || (x_index == 37 && y_index == 30) || (x_index == 39 && y_index == 30) || (x_index == 41 && y_index == 30) || (x_index == 37 && y_index == 31) || (x_index == 41 && y_index == 31) || (x_index == 37 && y_index == 32) || (x_index == 41 && y_index == 32) || (x_index == 43 && y_index == 28) || (x_index == 46 && y_index == 28) || (x_index == 43 && y_index == 29) || (x_index == 46 && y_index == 29) || (x_index == 43 && y_index == 30) || (x_index == 46 && y_index == 30) || (x_index == 43 && y_index == 31) || (x_index == 46 && y_index == 31) || (x_index == 44 && y_index == 32) || (x_index == 45 && y_index == 32) || (x_index == 48 && y_index == 28) || (x_index == 49 && y_index == 28) || (x_index == 50 && y_index == 28) || (x_index == 51 && y_index == 28) || (x_index == 48 && y_index == 29) || (x_index == 48 && y_index == 30) || (x_index == 49 && y_index == 30) || (x_index == 50 && y_index == 30) || (x_index == 51 && y_index == 30) || (x_index == 51 && y_index == 31) || (x_index == 48 && y_index == 32) || (x_index == 49 && y_index == 32) || (x_index == 50 && y_index == 32) || (x_index == 51 && y_index == 32) || (x_index == 53 && y_index == 28) || (x_index == 53 && y_index == 29) || (x_index == 53 && y_index == 30) || (x_index == 53 && y_index == 31) || (x_index == 53 && y_index == 32) || (x_index == 56 && y_index == 28) || (x_index == 57 && y_index == 28) || (x_index == 55 && y_index == 29) || (x_index == 58 && y_index == 29) || (x_index == 55 && y_index == 30) || (x_index == 55 && y_index == 31) || (x_index == 58 && y_index == 31) || (x_index == 56 && y_index == 32) || (x_index == 57 && y_index == 32));
    
    
    // Modified Clock
    wire twohz, clk2s;
    modified_clk_divider(.clk(clk), .m(24999999), .a(twohz));
    modified_clk_divider(.clk(clk), .m(99999999), .a(clk2s));
    
    // Button Presses and Reset 
    reg [1:0] count = 0;
    reg rst = 0;
    reg clicked = 0;
    reg r,l,s,d;
    
    // Driver Code
    always @ (posedge clk) begin
    
    // Return to Menu
    if (clk2s) begin     
        count <= (btnU) ? count + 1 : 0;
        rst <= (count == 1) ? 1 : 0;
        if (rst) begin
           menu_state <= TEAM;
           displayState <= MENU;
           rst = 0;
        end
    end
    
    // Menu Driver
    if(displayState == MENU) begin
        
        if (twohz) begin
            clicked <= (left) ? 1 : 0;
            r <= (btnR) ? 1 : 0;
            l <= (btnL) ? 1 :0;
            s <= (btnC) ? 1 : 0;
            d <= (btnD) ? 1 : 0;
        end
        // cursor  
//        curr_x <= (mouse_x > 95) ? 95 : (mouse_x < 0) ? 0 : mouse_x;
//        curr_y <= (mouse_y > 63) ? 63 : (mouse_y < 0) ? 0 : mouse_y;
        if (left_arrow | right_arrow) begin
            oled_data <= RED;
        end
        else if (ee2026) begin
            oled_data <= DARK_BLUE;
        end
        else if (aboutus) begin
            oled_data <= BLACK; 
        end
        else if ((x_index == curr_x && y_index == curr_y) | (x_index == curr_x+1 && y_index == curr_y) | (x_index == curr_x-1 && y_index == curr_y)|(x_index == curr_x && y_index == curr_y+1) | (x_index == curr_x+1 && y_index == curr_y+1) | (x_index == curr_x-1 && y_index == curr_y+1) | (x_index == curr_x && y_index == curr_y-1) | (x_index == curr_x+1 && y_index == curr_y-1) |  (x_index == curr_x-1 && y_index == curr_y-1)) begin
            oled_data <= GREEN;
        end
        else begin
            oled_data <= GREY;
        end 
               
        if (clicked) begin
            clicked <= 0;
            displayState <= (click_aboutus) ? ABOUTUS : displayState;
            menu_state <= (click_left) ? (menu_state == TEAM) ? MUSIC : menu_state-1 : 
                          (click_right) ? (menu_state == MUSIC) ? TEAM : menu_state+1 : menu_state;
        end
        
        else if (l) begin
            l <= 0;
            if (menu_state == TEAM) begin menu_state = MUSIC; end
            else begin menu_state = menu_state -1; end
        end
        
        else if (r) begin
            r <= 0;
            if (menu_state == MUSIC) begin menu_state = TEAM; end
            else begin menu_state = menu_state + 1; end
        end 
               
        else if (s) begin
            s <= 0;
            displayState <= menu_state;
        end
        
        else if ((d) || (clicked & (curr_x >= 32 && curr_x <= 64 && curr_y >= 56 && curr_y <= 63))) begin
            displayState <= ABOUTUS;
            clicked <= 0;
            d <= 0;
        end
        
        // Enter different modes
        case(menu_state)
            TEAM: begin
                if (team) begin
                    oled_data <= DARK_BLUE;
                end
                if (clicked) begin
                    if (curr_x >= 27 && curr_x <= 69 && curr_y >= 24 && curr_y <= 39) begin
                        displayState <= TEAM;
                    end
                    
                end
            end
            MOLE: begin
                if (mole) begin
                oled_data <= ORANGE;
                end
                if (clicked) begin
                    if (curr_x >= 27 && curr_x <= 69 && curr_y >= 24 && curr_y <= 39) begin
                        displayState <= MOLE;
                        clicked <= 0;
                    end
                end                
            end
            REGRESSION: begin
                if (bestfit) begin
                    oled_data <= PINK;
                end
                if (clicked) begin
                    if (curr_x >= 27 && curr_x <= 69 && curr_y >= 24 && curr_y <= 39) begin
                        displayState <= REGRESSION; 
                        clicked <= 0;
                    end
                end            
            end
            RECORDER: begin
                if (recorder) begin
                oled_data <= BROWN;
                end
                if (clicked) begin
                    if (curr_x >= 27 && curr_x <= 69 && curr_y >= 24 && curr_y <= 39) begin
                        displayState <= RECORDER;
                        clicked <= 0;
                    end
                end            
            end
            MUSIC: begin
                if (music) begin
                    oled_data <= CYAN;
                end
                if (clicked) begin
                    if (curr_x >= 27 && curr_x <= 69 && curr_y >= 24 && curr_y <= 39) begin
                        displayState <= MUSIC;
                        clicked <= 0;
                    end
                end 
            end
        endcase
    end    
    end
endmodule
