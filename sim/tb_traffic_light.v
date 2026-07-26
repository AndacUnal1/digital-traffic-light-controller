`timescale 1ns / 1ps

module tb_traffic_light();
    reg clk_i, rst_i;
    wire [1:0] light_o;

    localparam RED_D = 5;
    localparam YEL_D = 2;
    localparam GRE_D = 4;

    traffic_light_controller #(
        .RED_DURATION(RED_D),
        .YELLOW_DURATION(YEL_D),
        .GREEN_DURATION(GRE_D),
        .RESET_COLOR(2'b00),
        .ENABLE_YELLOW(1)
    ) uut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .light_o(light_o)
    );

    initial clk_i = 0;
    always #5 clk_i = ~clk_i;

    task check_duration(input [1:0] color, input integer expected);
        integer count;
        begin
            wait(light_o == color);
            count = 0;
            while(light_o == color) begin
                @(posedge clk_i);
                count = count + 1;
            end
            if (count == expected)
                $display("[PASS] Color %b lasted %0d cycles", color, count);
            else
                $display("[FAIL] Color %b lasted %0d, expected %0d", color, count, expected);
        end
    endtask

    initial begin
   
        rst_i = 1; #20; 
        @(posedge clk_i); rst_i = 0;
        
        $display("--- Starting Automated Sequence Test ---");
        check_duration(2'b00, RED_D); 
        check_duration(2'b01, YEL_D); 
        check_duration(2'b10, GRE_D); 
        check_duration(2'b01, YEL_D); 
        
        $display("--- Testing Mid-Cycle Reset ---");
        #25;
        rst_i = 1; #10; rst_i = 0;
        if (light_o == 2'b00) $display("[PASS] Reset successful");

        #100;
        $display("--- Simulation Finished ---");
        $finish;
    end
endmodule