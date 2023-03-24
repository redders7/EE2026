`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2023 12:47:04 PM
// Design Name: 
// Module Name: Value_to_Volume_converter
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
module Value_to_Volume_converter(
    input basys_clock, [11:0] MIC_IN, 
    output reg [3:0] volume
    );
    
    reg [11:0] current_value = 12'd0;
    reg [11:0] peak_value = 12'd0;
    reg [31:0] count = 32'd0;
    
    always @ (posedge basys_clock)
        begin
            count <= count + 1;
            current_value <= MIC_IN; 
            if (current_value > peak_value) begin
                peak_value <= current_value;
            end
            if (count == 24999999) begin
                if (peak_value <= 2298) begin
                    // volume == 0
                    volume <= 0;
                    end
                else if (peak_value > 2298 && peak_value <= 2476) begin
                    // volume == 1
                    volume <= 1;
                    end
                else if (peak_value > 2476 && peak_value <= 2654) begin
                    // volume == 2
                    volume <= 2;
                    end
                else if (peak_value > 2654 && peak_value <= 2832) begin
                    // volume == 3
                    volume <= 3;
                    end
                else if (peak_value > 2832 && peak_value <= 3010) begin
                    // volume == 4
                    volume <= 4;
                    end
                else if (peak_value > 3188 && peak_value <= 3366) begin
                    // volume == 5
                    volume <= 5;
                    end
                else if (peak_value > 3366 && peak_value <= 3544) begin
                    // volume == 6
                    volume <= 6;
                    end
                else if (peak_value > 3544 && peak_value <= 3722) begin
                    // volume == 7
                    volume <= 7;
                    end
                else if (peak_value > 3722 && peak_value <= 3900) begin
                    // volume == 8
                    volume <= 8;
                    end
                else if (peak_value > 3900) begin
                    // volume == 9
                    volume <= 9;
                    end
            
                count <= 32'd0;
                peak_value <= 12'd0;
            end
        end
    
endmodule
