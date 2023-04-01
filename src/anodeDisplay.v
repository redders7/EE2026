`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.03.2023 17:06:24
// Design Name: 
// Module Name: anodeDisplay
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


module anodeDisplay(
    input [4:0] number,
    input [6:0] volume,
    input clock,
    input sw15,
    output reg [6:0] seg,
    output reg dp,
    output reg [3:0] an
    );
    
    reg [1:0] seq = 0;
    reg reset = 0;
    always @ (posedge clock) begin
        if (~sw15) begin
            seq <= 0;
            reset <= 1;
            an <= 4'b1110;
            seg <= volume;
        end
        if (sw15) begin
            reset <= 0;
            seq <= (seq == 3 | reset) ? 0 : seq + 1;
            case (seq)
            3'd0: begin
                if (number == 10) begin
                    an <= 4'b0111;
                    seg <= 7'b1111001;
                    dp <= 0;
                end
                else if (number == 0 | reset) begin
                    an <= 4'b1110;
                end
                else begin
                    an <= 4'b0111;
                    seg <= 7'b1000000;
                    dp <= 0;
                end
            end
            3'd1: begin
                dp <= 1;
                case(number)
                5'd0: begin
                    an <= 4'b1111;
                end
                5'd1: begin
                    an <= 4'b1011;
                    seg <= 7'b1111001;
                end
                5'd2: begin
                    an <= 4'b1011;
                    seg <= 7'b0100100;
                end
                5'd3: begin
                    an <= 4'b1011;
                    seg <= 7'b0110000;
                end
                5'd4: begin
                    an <= 4'b1011;
                    seg <= 7'b0011001;
                end
                5'd5: begin
                    an <= 4'b1011;
                    seg <= 7'b0010010;
                end
                5'd6: begin
                    an <= 4'b1011;
                    seg <= 7'b0000010;
                end
                5'd7: begin
                    an <= 4'b1011;
                    seg <= 7'b1111000;
                end
                5'd8: begin
                    an <= 4'b1011;
                    seg <= 7'b0000000;
                end
                5'd9: begin
                    an <= 4'b1011;
                    seg <= 7'b0010000;
                end
                5'd10: begin
                    an <= 4'b1011;
                    seg <= 7'b1000000;
                end                                                
                endcase
            end
            3'd2: begin
                dp <= 1;
                an <= 4'b1110;
                seg <= volume;
            end
            endcase
        end
    end
endmodule
