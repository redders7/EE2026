`timescale 1ns / 1ps


module toggle_image_display(input btnL, btnR, CLOCK, input [15:0] sw, tj, tj_blur, cleon, cleon_blur, shao, shao_blur, sweeram, sweeram_blur, output reg [15:0] data_out = 0, output [1:0] currUser); 
    reg [31:0] left_count = 0;
    reg [63:0] right_count = 0;
    reg left_pressed = 0;
    reg right_pressed = 0;
    reg [1:0] who_to_display = 0; //0-3 tj,cleon,shao,sweeram
    assign currUser = who_to_display;
    
    always @(posedge CLOCK) begin
        
//        if (btnR) right_count <= (right_count == 249999999) ? 0 : right_count + 1;
//        else right_count <= 0;
        
        if (left_pressed == 1) begin 
            left_count <= (left_count == 24999999) ? 0 : left_count + 1; 
            left_pressed <= (left_count == 24999999) ? 0 : 1;
        end
        if (btnL & left_pressed == 0) left_pressed <= 1;
        
        if (right_pressed == 1) begin
            right_count <= (right_count == 24999999) ? 0 : right_count + 1; 
            right_pressed <= (right_count == 24999999) ? 0 : 1;
        end 
        if (btnR & right_pressed == 0) right_pressed <= 1;
        
    end
    
    always @(posedge CLOCK) begin
        if (btnL == 1 & left_pressed == 0) who_to_display <= (who_to_display == 0) ? 3 : who_to_display - 1;
        else if (btnR == 1 & right_pressed == 0) who_to_display <= (who_to_display == 3) ? 0 : who_to_display + 1;
    end
    
    always @(posedge CLOCK) begin
        if (sw[4]) begin //blur
            if (who_to_display == 0) data_out <= tj_blur;
            else if (who_to_display == 1) data_out <= cleon_blur;
            else if (who_to_display == 2) data_out <= shao_blur;
            else if (who_to_display == 3) data_out <= sweeram_blur;
        end
        else begin //3:0 = gray, decrease, increase, negative
            if (who_to_display == 0) data_out <= tj;
            else if (who_to_display == 1) data_out <= cleon;
            else if (who_to_display == 2) data_out <= shao;
            else if (who_to_display == 3) data_out <= sweeram;
        end
    end

endmodule
