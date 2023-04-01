`timescale 1ns / 1ps

module image_tj_blur(sw, CLOCK, addr, data_out);
    input [15:0] sw;
    input CLOCK;
    input [12:0] addr;
    output reg [15:0] data_out;
    reg [15:0] input_data[6143:0];
    
    initial begin
        $readmemb("C:/Users/wangt/Desktop/EE2026_Lab/images/tj_blur.txt", input_data);
    end
    
    always @(posedge CLOCK) begin
        data_out <= input_data[addr];
        
    end
endmodule
