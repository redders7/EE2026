`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2023 17:24:05
// Design Name: 
// Module Name: volume_regulator
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


module volume_regulator(
        input [11:0] audio_input, 
        input volume, basys_clock, vol_decrease, vol_increase,
        output reg [11:0] audio_gained
    );
    
    reg [11:0] loss = 2'b10;
    reg [11:0] normal = 2'b01;
    
    // lose by half : audio_input >> loss;
    //gain by 1.4 : (audio_input << 1) + (audio_input >> 2);
    //gain by 1.5 : (audio_in << 1) + (audio_in >> 1);
    //gain by 1.6 : (audio_in << 1) + (audio_in >> 3) + (audio_in >> 4);
    //gain idk but nubbad : (audio_input >> 1) + (audio_input << 2);
    
    always @ (posedge basys_clock) begin
        if (vol_decrease == 1 && vol_increase == 1) begin
            audio_gained <= audio_input * normal;
        end else if (vol_decrease == 1) begin
            audio_gained <= audio_input >> loss;
        end else if (vol_increase == 1) begin
            audio_gained <= (audio_input << 1) + (audio_input >> 3) + (audio_input >> 4);
        end else begin
            audio_gained <= audio_input * normal;
        end
    end

//    always @ (posedge basys_clock) begin
//        if (volume > 7) begin
//            audio_gained <= audio_input >> loss;
//        end else if (volume < 4 && volume != 0) begin
//            audio_gained <= (audio_input << 1) + (audio_input >> 3) + (audio_input >> 4);
//        end else begin
//            audio_gained <= audio_input * normal;
//        end
//    end
    
endmodule