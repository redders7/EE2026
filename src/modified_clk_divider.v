`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 16:54:05
// Design Name: 
// Module Name: modified_clk_divider
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


module modified_clk_divider(
    input clk,
    input [31:0] m,
    output reg a
    );
        
    reg [31:0] count = 0;
    always @ (posedge clk) begin
        count <= (count == m) ? 0 : count + 1;
        a <= (count == 0) ? 1 : 0;
    end
endmodule
