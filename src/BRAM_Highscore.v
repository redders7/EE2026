`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 14:22:49
// Design Name: 
// Module Name: BRAM_Highscore
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


module BRAM_Highscore(clk, addr, read_write, clear, data_in, data_out);
parameter n = 1;
parameter w = 8;

input clk, read_write, clear;
input [n-1:0] addr;
input [w-1:0] data_in;
output reg [w-1:0] data_out;

// Start module here!
reg [w-1:0] reg_array [2**n-1:0];

integer i;
initial begin
    for( i = 0; i < 2**n; i = i + 1 ) begin
        reg_array[i] <= 0;
    end
end

always @(negedge(clk)) begin
    if( read_write == 1 )
        reg_array[addr] <= data_in;
    data_out = reg_array[addr];
end
endmodule  
