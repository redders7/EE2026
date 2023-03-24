`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 11:13:16 AM
// Design Name: 
// Module Name: clk_divider
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

//input CLOCK = 100MHz
//@posege CLOCK = 50Mhz
//set m = 50MHz/(desired frequency) - 1, example: 6.25Mhz -> m = 7

module clk_divider(
    input CLOCK,
    input [31:0] m,
    output reg a = 0
    );
    
    reg [31:0] count = 0;
    always @ (posedge CLOCK) begin
        count <= (count == m) ? 0 : count + 1;
        a <= (count == 0) ? ~a : a;
    end  
endmodule
