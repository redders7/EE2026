`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.03.2023 19:49:23
// Design Name: 
// Module Name: mole_menu
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


module mole_menu(
    input clk,
    input clk2hz,
    input anclk,
    input btnD,
    input left,
    input right,
    input sw12, sw12off,
    input mole_start, 
    input [3:0] displayState,
    input [15:0] sw, 
    input [11:0] xpos,
    input [11:0] ypos,
    input [12:0] pixel_index,
    output reg [3:0] an = 4'b1111,
    output reg [6:0] seg = 7'b1111111,
    output reg [15:0] oled_data = 0
    );
   
    // Colours
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF;
    parameter RED = 16'hF800;
    parameter CYAN = 16'h07FF;
    parameter BEIGE = 16'hE633;
    parameter GREEN = 16'h07E0;
    parameter BROWN = 16'hA145;
    
    // Game Data
    parameter GOOD = 0; // +1 point if hit
    parameter BAD = 1; // -1 point if hit
    parameter EASY = 8'd6; // 3s per mole
    parameter MEDIUM = 8'd4; // 2s per mole
    parameter HARD = 8'd2; // 1s per mole
    parameter HIT_GOOD = 1;
    parameter HIT_BAD = -1;
    parameter GAME_LENGTH = 121; //30s game over
    reg [4:0] moles;
    reg [7:0] score;
    reg [7:0] highscore;
    reg [7:0] timer;
    reg [7:0] mole_timer;
    reg [31:0] curr_mole_pos; // holes 0 to 4
    reg curr_type;
    reg [31:0] next_mole_pos;
    reg next_type;
    wire [7:0] difficulty;
    assign difficulty = (sw[14]) ? HARD : (sw[13]) ? MEDIUM : EASY;

        
    // Game States
    parameter MENU = 2'd0;
    parameter SETUP = 2'd1;
    parameter INGAME = 2'd2;
    parameter END = 2'd3;
    reg [1:0] game_state = MENU;   
    wire [12:0] x_index; // OLED 
    wire [12:0] y_index; // OLED
    wire [12:0] mouse_x; 
    wire [12:0] mouse_y;
    reg [12:0] curr_x; // current mouse position
    reg [12:0] curr_y;
    wire W,dash,A,dash2,M,excl; // W-A-M!
    wire P,L,A2,Y; // PLAY
    wire wam, play, gameover_text;
    wire play_box;
    assign x_index = pixel_index % 96;
    assign y_index = pixel_index / 96;
    assign mouse_x = xpos / 4;
    assign mouse_y = ypos / 4;
    
    assign W = (x_index >= 21 && x_index <= 23 && y_index >= 3 && y_index <= 14) | 
               (x_index >= 24 && x_index <= 26 && y_index >= 15 && y_index <= 17) |
               (x_index >= 27 && x_index <= 29 && y_index >= 12 && y_index <= 14) |
               (x_index >= 30 && x_index <= 32 && y_index >= 15 && y_index <= 17) |
               (x_index >= 33 && x_index <= 35 && y_index >= 3 && y_index <= 14);
    assign dash = (x_index >= 37 && x_index <= 40 && y_index >= 7 && y_index <= 9);
    assign A = (x_index >= 42 && x_index <= 44 && y_index >= 6 && y_index <= 17) |
               (x_index >= 45 && x_index <= 49 && y_index >= 3 && y_index <= 5) |
               (x_index >= 45 && x_index <= 49 && y_index >= 9 && y_index <= 11) |
               (x_index >= 50 && x_index <= 52 && y_index >= 6 && y_index <= 17);
    assign dash2 = (x_index >= 54 && x_index <= 57 && y_index >= 7 && y_index <= 9);
    assign M = (x_index >= 59 && x_index <= 61 && y_index >= 3 && y_index <= 17) | 
               (x_index >= 62 && x_index <= 64 && y_index >= 6 && y_index <= 8) |
               (x_index >= 65 && x_index <= 67 && y_index >= 9 && y_index <= 11) |
               (x_index >= 62 && x_index <= 64 && y_index >= 6 && y_index <= 8) |
               (x_index >= 65 && x_index <= 67 && y_index >= 3 && y_index <= 17);    
    assign excl = (x_index >= 69 && x_index <= 71 && y_index >= 3 && y_index <= 11) |
                  (x_index >= 69 && x_index <= 71 && y_index >= 15 && y_index <= 17);
    assign P = (x_index >= 25 && x_index <= 27 && y_index >= 35 && y_index <= 49) |
               (x_index >= 28 && x_index <= 33 && y_index >= 35 && y_index <= 37) |
               (x_index >= 28 && x_index <= 33 && y_index >= 41 && y_index <= 43) |
               (x_index >= 34 && x_index <= 36 && y_index >= 38 && y_index <= 40);
    assign L = (x_index >= 38 && x_index <= 40 && y_index >= 35 && y_index <= 49) |
               (x_index >= 41 && x_index <= 46 && y_index >= 47 && y_index <= 49);
    assign A2 = (x_index >= 48 && x_index <= 50 && y_index >= 38 && y_index <= 49) |
                (x_index >= 51 && x_index <= 56 && y_index >= 35 && y_index <= 37) |
                (x_index >= 51 && x_index <= 56 && y_index >= 41 && y_index <= 43) |
                (x_index >= 56 && x_index <= 58 && y_index >= 38 && y_index <= 49);                                        
    assign Y = (x_index >= 60 && x_index <= 62 && y_index >= 35 && y_index <= 43) |
               (x_index >= 64 && x_index <= 66 && y_index >= 41 && y_index <= 49) |
               (x_index >= 66 && x_index <= 68 && y_index >= 35 && y_index <= 43);
    assign play_box =(x_index >= 23 & x_index <= 70 & y_index >= 32 & y_index <= 33) | 
                     (x_index >= 23 & x_index <= 70 & y_index >= 51 & y_index <= 52) | 
                     (x_index >= 21 & x_index <= 22 & y_index >= 32 & y_index <= 51) | 
                     (x_index >= 70 & x_index <= 71 & y_index >= 32 & y_index <= 51);                 
     assign wam = W | dash | A | dash2 | M | excl;
     assign play = P | L | A2 | Y;
     assign gameover_text = ((x_index == 27 && y_index == 32) || (x_index == 28 && y_index == 32) || (x_index == 29 && y_index == 32) || (x_index == 26 && y_index == 33) || (x_index == 26 && y_index == 34) || (x_index == 28 && y_index == 34) || (x_index == 29 && y_index == 34) || (x_index == 30 && y_index == 34) || (x_index == 26 && y_index == 35) || (x_index == 30 && y_index == 35) || (x_index == 27 && y_index == 36) || (x_index == 28 && y_index == 36) || (x_index == 29 && y_index == 36) || (x_index == 33 && y_index == 32) || (x_index == 34 && y_index == 32) || (x_index == 32 && y_index == 33) || (x_index == 35 && y_index == 33) || (x_index == 32 && y_index == 34) || (x_index == 33 && y_index == 34) || (x_index == 34 && y_index == 34) || (x_index == 35 && y_index == 34) || (x_index == 32 && y_index == 35) || (x_index == 35 && y_index == 35) || (x_index == 32 && y_index == 36) || (x_index == 35 && y_index == 36) || (x_index == 37 && y_index == 32) || (x_index == 41 && y_index == 32) || (x_index == 37 && y_index == 33) || (x_index == 38 && y_index == 33) || (x_index == 40 && y_index == 33) || (x_index == 41 && y_index == 33) || (x_index == 37 && y_index == 34) || (x_index == 39 && y_index == 34) || (x_index == 41 && y_index == 34) || (x_index == 37 && y_index == 35) || (x_index == 41 && y_index == 35) || (x_index == 37 && y_index == 36) || (x_index == 41 && y_index == 36) || (x_index == 43 && y_index == 32) || (x_index == 44 && y_index == 32) || (x_index == 45 && y_index == 32) || (x_index == 46 && y_index == 32) || (x_index == 43 && y_index == 33) || (x_index == 43 && y_index == 34) || (x_index == 44 && y_index == 34) || (x_index == 45 && y_index == 34) || (x_index == 46 && y_index == 34) || (x_index == 43 && y_index == 35) || (x_index == 43 && y_index == 36) || (x_index == 44 && y_index == 36) || (x_index == 45 && y_index == 36) || (x_index == 46 && y_index == 36) || (x_index == 50 && y_index == 32) || (x_index == 51 && y_index == 32) || (x_index == 49 && y_index == 33) || (x_index == 52 && y_index == 33) || (x_index == 49 && y_index == 34) || (x_index == 52 && y_index == 34) || (x_index == 49 && y_index == 35) || (x_index == 52 && y_index == 35) || (x_index == 50 && y_index == 36) || (x_index == 51 && y_index == 36) || (x_index == 54 && y_index == 32) || (x_index == 58 && y_index == 32) || (x_index == 54 && y_index == 33) || (x_index == 58 && y_index == 33) || (x_index == 54 && y_index == 34) || (x_index == 58 && y_index == 34) || (x_index == 55 && y_index == 35) || (x_index == 57 && y_index == 35) || (x_index == 56 && y_index == 36) || (x_index == 60 && y_index == 32) || (x_index == 61 && y_index == 32) || (x_index == 62 && y_index == 32) || (x_index == 63 && y_index == 32) || (x_index == 60 && y_index == 33) || (x_index == 60 && y_index == 34) || (x_index == 61 && y_index == 34) || (x_index == 62 && y_index == 34) || (x_index == 63 && y_index == 34) || (x_index == 60 && y_index == 35) || (x_index == 60 && y_index == 36) || (x_index == 61 && y_index == 36) || (x_index == 62 && y_index == 36) || (x_index == 63 && y_index == 36) || (x_index == 65 && y_index == 32) || (x_index == 66 && y_index == 32) || (x_index == 67 && y_index == 32) || (x_index == 65 && y_index == 33) || (x_index == 68 && y_index == 33) || (x_index == 65 && y_index == 34) || (x_index == 66 && y_index == 34) || (x_index == 67 && y_index == 34) || (x_index == 65 && y_index == 35) || (x_index == 67 && y_index == 35) || (x_index == 65 && y_index == 36) || (x_index == 68 && y_index == 36));      
            
    // Mole holes
    wire hole [0:4];
    assign hole[0] = (x_index >= 8 && x_index <= 27 && y_index >= 24 && y_index <= 26);
    assign hole[1] = (x_index >= 37 && x_index <= 56 && y_index >= 24 && y_index <= 26);
    assign hole[2] = (x_index >= 66 && x_index <= 85 && y_index >= 24 && y_index <= 26);
    assign hole[3] = (x_index >= 23 && x_index <= 42 && y_index >= 52 && y_index <= 54);
    assign hole[4] = (x_index >= 52 && x_index <= 71 && y_index >= 52 && y_index <= 54);
    
    // Moles
    wire mole [0:4];
    assign mole[0] = (x_index >= 12 && x_index <= 23 && y_index >= 19 && y_index <= 23);
    assign mole[1] = (x_index >= 41 && x_index <= 52 && y_index >= 19 && y_index <= 23);
    assign mole[2] = (x_index >= 70 && x_index <= 81 && y_index >= 19 && y_index <= 23);
    assign mole[3] = (x_index >= 27 && x_index <= 38 && y_index >= 47 && y_index <= 51);
    assign mole[4] = (x_index >= 56 && x_index <= 67 && y_index >= 47 && y_index <= 51);
    reg [1:0] hit;
    
    // Randomiser
    reg [31:0] random;
    wire [31:0] random_mole;
    wire [31:0] random_type;
    reg [31:0] random2;
    always @ (posedge clk) begin
        random <= random + 1;
    end
    wire clkprime;
    clk_divider(.CLOCK(clk), .m(7862), .a(clkprime));
    always @ (posedge clkprime) begin
        random2 <= random2 +1;
    end    
    assign random_mole = (random * random2) % 5;
    assign random_type = (random * random2) % 2;

    // Initialise to Game Menu
    initial begin
        game_state <= MENU;
    end
    
    // Difficulty settings
    wire twohz, fivehz, tenhz;
    reg clicked = 0;
    reg right_clicked = 0;
    modified_clk_divider gamelogic(.clk(clk), .m(24999999), .a(twohz));
    reg rst = 0;
    
    // Timer and Game State Logic
    always @ (posedge clk) begin
        if (mole_start && !rst) begin
            game_state <= MENU;
            rst <= 1;
        end
        if (sw12 || sw12off) begin
            game_state <= MENU;
        end
        if (left) clicked <= 1;
        if (right) right_clicked <= 1;
        if (twohz) begin
            case(game_state)
            MENU: begin
                if (clicked) begin
                    if (curr_x >= 23 & curr_x <= 70 & curr_y >= 32 & curr_y <= 51) begin
                        timer <= 13;
                        game_state <= SETUP;
                        clicked <= 0;
                    end
                end        
            end
            
            SETUP: begin
                game_state <= (timer == GAME_LENGTH) ? INGAME : SETUP;        
                timer <= (timer == 0) ? GAME_LENGTH : timer - 1; 
                next_mole_pos = random_mole;
                next_type <= GOOD; 
                score <= 0;     
                hit <= 0;  
                mole_timer <= 0;
            end
            
            INGAME: begin
                game_state <= (timer == 0) ? END : INGAME;
                timer <= (timer == 0) ? 0 : timer - 1;
                mole_timer <= mole_timer + 1; 
                // Game Logic
                if (clicked) begin
                    case (curr_mole_pos)
                        32'd0: begin
                            hit <= (curr_x >= 12 && curr_x <= 23 && curr_y >= 19 && curr_y <= 23) ? (curr_type == GOOD) ? 1 : 2 : 0;
                        end
                        32'd1: begin
                            hit <= (curr_x >= 41 && curr_x <= 52 && curr_y >= 19 && curr_y <= 23) ? (curr_type == GOOD) ? 1 : 2 : 0;                     
                        end
                        32'd2: begin
                            hit <= (curr_x >= 70 && curr_x <= 81 && curr_y >= 19 && curr_y <= 23) ? (curr_type == GOOD) ? 1 : 2 : 0;                        
                        end
                        32'd3: begin
                            hit <= (curr_x >= 27 && curr_x <= 38 && curr_y >= 47 && curr_y <= 51) ? (curr_type == GOOD) ? 1 : 2 : 0;                        
                        end
                        32'd4: begin
                            hit <= (curr_x >= 56 && curr_x <= 67 && curr_y >= 47 && curr_y <= 51) ? (curr_type == GOOD) ? 1 : 2 : 0;                                               
                        end                                                
                    endcase
                    clicked <= 0;
                end
                else if (right_clicked) begin
                    case (curr_mole_pos)
                        32'd0: begin
                            hit <= (curr_x >= 12 && curr_x <= 23 && curr_y >= 19 && curr_y <= 23) ? (curr_type == BAD) ? 1 : 2 : 0;
                        end
                        32'd1: begin
                            hit <= (curr_x >= 41 && curr_x <= 52 && curr_y >= 19 && curr_y <= 23) ? (curr_type == BAD) ? 1 : 2 : 0;                     
                        end
                        32'd2: begin
                            hit <= (curr_x >= 70 && curr_x <= 81 && curr_y >= 19 && curr_y <= 23) ? (curr_type == BAD) ? 1 : 2 : 0;                        
                        end
                        32'd3: begin
                            hit <= (curr_x >= 27 && curr_x <= 38 && curr_y >= 47 && curr_y <= 51) ? (curr_type == BAD) ? 1 : 2 : 0;                        
                        end
                        32'd4: begin
                            hit <= (curr_x >= 56 && curr_x <= 67 && curr_y >= 47 && curr_y <= 51) ? (curr_type == BAD) ? 1 : 2 : 0;                                               
                        end                                                
                    endcase
                    right_clicked <= 0;
                end
                if (hit > 0) begin
                    score <= (hit == 1) ? score+1 : (score == 0) ? 0 : score-1;
                    curr_mole_pos <= (next_mole_pos == curr_mole_pos) ? (curr_mole_pos == 4) ? 0 : next_mole_pos + 1 : next_mole_pos;
                    curr_type <= next_type;
                    next_mole_pos <= random_mole;
                    next_type <= random_type;
                    mole_timer <= 0;
                    hit <= 0;
                end
                else if (mole_timer == difficulty) begin
                    curr_mole_pos <= (next_mole_pos == curr_mole_pos) ? (curr_mole_pos == 4) ? 0 : next_mole_pos + 1 : next_mole_pos;
                    curr_type <= next_type;
                    next_mole_pos <= random_mole;
                    next_type <= random_type;
                    mole_timer <= 0;
                    hit <= 0;
                end  
                clicked <= 0;
                right_clicked <= 0;     
            end
            
            END: begin
                if (score > highscore) begin
                    highscore <= score;
                end
                if (clicked | right_clicked) begin
                    game_state <= MENU;
                end        
            end
            endcase
            clicked <= 0;
            right_clicked <= 0;
        end
    end
    
    // OLED Display
    always @ (posedge clk) begin
        // cursor  
        curr_x <= (mouse_x > 95) ? 95 : (mouse_x < 0) ? 0 : mouse_x;
        curr_y <= (mouse_y > 63) ? 63 : (mouse_y < 0) ? 0 : mouse_y;
        
        case(game_state)
            MENU: begin
                if (wam) begin
                    oled_data <= RED;
                end
                else if (play) begin
                    oled_data <= CYAN;
                end
                else if (play_box) begin
                    oled_data <= GREEN;
                end
                else if ((x_index == curr_x && y_index == curr_y) | (x_index == curr_x+1 && y_index == curr_y) | (x_index == curr_x-1 && y_index == curr_y)|          (x_index == curr_x && y_index == curr_y+1) | (x_index == curr_x+1 && y_index == curr_y+1) | (x_index == curr_x-1 && y_index == curr_y+1) | (x_index == curr_x && y_index == curr_y-1) | (x_index == curr_x+1 && y_index == curr_y-1) |  (x_index == curr_x-1 && y_index == curr_y-1)) begin
                    oled_data <= 16'b0000011111100000;
                end 
                else begin
                    oled_data <= BEIGE;
                end
            end
            
            SETUP: begin
                if (hole[0] | hole[1] | hole[2] | hole[3] | hole[4]) begin
                    oled_data <= BROWN;
                end
                else if ((x_index == curr_x && y_index == curr_y) | (x_index == curr_x+1 && y_index == curr_y) | (x_index == curr_x-1 && y_index == curr_y)|          (x_index == curr_x && y_index == curr_y+1) | (x_index == curr_x+1 && y_index == curr_y+1) | (x_index == curr_x-1 && y_index == curr_y+1) | (x_index == curr_x && y_index == curr_y-1) | (x_index == curr_x+1 && y_index == curr_y-1) |  (x_index == curr_x-1 && y_index == curr_y-1)) begin
                    oled_data <= 16'b0000011111100000;
                end
                else begin
                    oled_data <= BEIGE;
                end
            end
            
            INGAME: begin
                if (hole[0] | hole[1] | hole[2] | hole[3] | hole[4]) begin
                    oled_data <= BROWN;
                end
                else if (mole[curr_mole_pos] && ~hit) begin
                    oled_data <= (curr_type == GOOD) ? GREEN : RED;
                end
                else if ((x_index == curr_x && y_index == curr_y) | (x_index == curr_x+1 && y_index == curr_y) | (x_index == curr_x-1 && y_index == curr_y)|(x_index == curr_x && y_index == curr_y+1) | (x_index == curr_x+1 && y_index == curr_y+1) | (x_index == curr_x-1 && y_index == curr_y+1) | (x_index == curr_x && y_index == curr_y-1) | (x_index == curr_x+1 && y_index == curr_y-1) |  (x_index == curr_x-1 && y_index == curr_y-1)) begin
                    oled_data <= 16'b0000011111100000;
                end
                else begin
                    oled_data <= BEIGE;
                end                
            end
            
            END: begin
                if (gameover_text) begin
                    oled_data <= RED;
                end

                else begin
                    oled_data <= BEIGE;
                end
            end
        endcase
        
    end
    
    // Anode Display (an[3:2] shows score, an[2:1] shows timer)
    reg [2:0] seq = 0;
    reg [7:0] timer_seconds;
    reg [3:0] timer1;
    reg [3:0] timer0;
    reg [3:0] score1;
    reg [3:0] score0;
    reg [3:0] hiscore1;
    reg [3:0] hiscore0;
    reg [7:0] display_digit;
    
    // Cycle through anodes
    always @ (posedge anclk) begin
        seq <= (seq == 3) ? 0 : seq + 1;
    end
    
    // Set anode and digit to display
    always @ (*) begin
        timer_seconds <= timer/4;
        hiscore1 <= highscore/10;
        hiscore0 <= highscore % 10;
        score1 <= score / 10;
        score0 <= score % 10;
        timer1 <= timer_seconds / 10;
        timer0 <= timer_seconds % 10;
        
        // Turn on/off anodes
        case (game_state)
        MENU: begin
            an <= 4'b1111;
        end
        SETUP: begin
            case(seq)
            3'd0: begin an <= 4'b0111; display_digit <= timer1; end
            3'd1: begin an <= 4'b1011; display_digit <= timer0; end
            3'd2: an <= 4'b1111; 
            3'd3: an <= 4'b1111;
            endcase           
        end
        INGAME: begin
            case(seq)
            3'd0: begin an <= 4'b0111; display_digit <= timer1; end
            3'd1: begin an <= 4'b1011; display_digit <= timer0; end
            3'd2: begin an <= 4'b1101; display_digit <= score1; end
            3'd3: begin an <= 4'b1110; display_digit <= score0; end
            endcase 
        end
        END: begin
            case(seq)
            3'd0: begin an <= 4'b0111; display_digit <= 7'd10; end
            3'd1: begin an <= 4'b1011; display_digit <= 7'd1; end
            3'd2: begin an <= 4'b1101; display_digit <= hiscore1; end
            3'd3: begin an <= 4'b1110; display_digit <= hiscore0; end
            endcase 
        end         
        endcase
     end 
    
    // Digit to 7-segment display conversion
    always @(*)
        begin
        case(display_digit)
            7'd0: seg = 7'b1000000; // "0"     
            7'd1: seg = 7'b1111001; // "1" 
            7'd2: seg = 7'b0100100; // "2" 
            7'd3: seg = 7'b0110000; // "3" 
            7'd4: seg = 7'b0011001; // "4" 
            7'd5: seg = 7'b0010010; // "5" 
            7'd6: seg = 7'b0000010; // "6" 
            7'd7: seg = 7'b1111000; // "7" 
            7'd8: seg = 7'b0000000; // "8"     
            7'd9: seg = 7'b0010000; // "9"
            7'd10: seg = 7'b0001001; // "H"
            7'd11: seg = 7'b1001111; // "I"
        endcase
    end    
endmodule
