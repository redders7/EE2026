`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 07:39:52 PM
// Design Name: 
// Module Name: check_valid_number
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


module check_valid_number(input CLOCK, input [6:0] num_seg, input [15:0] sw, output reg [4:0] ld15 = 0);

    always @(posedge CLOCK) begin
        if (num_seg[0] & num_seg[1] & num_seg[2] & num_seg[3] & num_seg[4] & num_seg[5] & ~num_seg[6]) begin ld15 = 1; end
        else if (~num_seg[0] & num_seg[1] & num_seg[2] & ~num_seg[3] & ~num_seg[4] & ~num_seg[5] & ~num_seg[6])  begin ld15 = 2; end
        else if (num_seg[0] & num_seg[1] & ~num_seg[2] & num_seg[3] & num_seg[4] & ~num_seg[5] & num_seg[6])  begin ld15 = 3; end
        else if (num_seg[0] & num_seg[1] & num_seg[2] & num_seg[3] & ~num_seg[4] & ~num_seg[5] & num_seg[6])  begin ld15 = 4; end
        else if (~num_seg[0] & num_seg[1] & num_seg[2] & ~num_seg[3] & ~num_seg[4] & num_seg[5] & num_seg[6])  begin ld15 = 5'd5; end
        else if(num_seg[0] & ~num_seg[1] & num_seg[2] & num_seg[3] & ~num_seg[4] & num_seg[5] & num_seg[6])  begin ld15 = 5'd6; end
        else if (num_seg[0] & ~num_seg[1] & num_seg[6] & num_seg[2] & num_seg[3] & num_seg[4] & num_seg[5])  begin ld15 = 7; end
        else if (num_seg[0] & num_seg[1] & num_seg[2] & ~num_seg[3] & ~num_seg[4] & ~num_seg[5] & ~num_seg[6])  begin ld15 = 8; end
        else if (num_seg[0] & num_seg[1] & num_seg[2] & num_seg[3] & num_seg[4] & num_seg[5] & num_seg[6])  begin ld15 = 9; end
        else if (num_seg[0] & num_seg[1] & num_seg[2] & num_seg[3] & ~num_seg[4] & num_seg[5] & num_seg[6])  begin ld15 = 10; end
        else begin ld15 = 0; end
    end
endmodule
