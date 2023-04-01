`timescale 1ns / 1ps

module image_shao(sw, CLOCK, addr, data_out);
    input [15:0] sw;
    input CLOCK;
    input [12:0] addr;
    output reg [15:0] data_out;
    reg [15:0] input_data[6143:0];
    reg [4:0] red, blue; reg [5:0] green;
    reg [12:0] average;
    
    initial begin
        $readmemb("C:/Users/wangt/Desktop/EE2026_Lab/images/shao.txt", input_data);
    end
    
    always @(posedge CLOCK) begin
        if (sw[0]) begin //negative
            red[4:0] = 5'b11111 - input_data[addr][15:11];
            green[5:0] = 6'b111111 - input_data[addr][10:5];
            blue[4:0] = 5'b11111 - input_data[addr][4:0];
            data_out = {red, green, blue};
        end else if (sw[1]) begin //increased brightness
            red[4:0] = (input_data[addr][15:11] > 28) ? 31 : input_data[addr][15:11] + 3;
            green[5:0] = (input_data[addr][10:5] > 58) ? 63 : input_data[addr][10:5] + 5;
            blue[4:0] = (input_data[addr][4:0] > 28) ? 31 : input_data[addr][4:0] + 3;
            data_out = {red, green, blue};
        end else if (sw[2]) begin //decreased brightness
            red[4:0] = (input_data[addr][15:11] < 4) ? 0 : input_data[addr][15:11] - 4;
            green[5:0] = (input_data[addr][10:5] < 8) ? 0 : input_data[addr][10:5] - 8;
            blue[4:0] = (input_data[addr][4:0] < 4) ? 0 : input_data[addr][4:0] - 4;
            data_out = {red, green, blue};
        end else if (sw[3]) begin //greyscale
            red[4:0] = input_data[addr][15:11];
            green[5:0] = input_data[addr][10:5];
            blue[4:0] = input_data[addr][4:0];
            average = (red * 2 + blue * 2 + green) / 6;
            data_out = {average[4:0], 1'b0, average[4:0], average[4:0]};
        end
        else data_out <= input_data[addr];
        
    end
endmodule