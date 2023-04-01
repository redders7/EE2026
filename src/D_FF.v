`timescale 1ns / 1ps

module D_FF(input clk, input D, output reg Q = 0);
    always @(posedge clk) begin
        Q <= D;
    end
endmodule
