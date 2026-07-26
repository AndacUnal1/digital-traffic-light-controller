`timescale 1ns / 1ps

module traffic_light_controller #(
    parameter RED_DURATION    = 5,
    parameter YELLOW_DURATION = 2,
    parameter GREEN_DURATION  = 4,
    parameter [1:0] RESET_COLOR = 2'b00,
    parameter ENABLE_YELLOW   = 1
)(
    input  wire clk_i,
    input  wire rst_i,
    output reg [1:0] light_o
);

    localparam S_RED       = 3'd0;
    localparam S_YEL_PRE_G = 3'd1;
    localparam S_GREEN     = 3'd2;
    localparam S_YEL_PRE_R = 3'd3;

    localparam RED    = 2'b00;
    localparam YELLOW = 2'b01;
    localparam GREEN  = 2'b10;

    reg [2:0]  current_state, next_state;
    reg [31:0] timer;


    always @(posedge clk_i) begin
        if (rst_i) begin
            timer <= 32'd1;
            case (RESET_COLOR)
                RED:    current_state <= S_RED;
                YELLOW: current_state <= S_YEL_PRE_G;
                GREEN:  current_state <= S_GREEN;
                default: current_state <= S_RED;
            endcase
        end else begin
            if (next_state != current_state)
                timer <= 32'd1; 
            else
                timer <= timer + 1;
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_RED: begin
                if (timer >= RED_DURATION)
                    next_state = (ENABLE_YELLOW) ? S_YEL_PRE_G : S_GREEN;
            end
            S_YEL_PRE_G: begin
                if (timer >= YELLOW_DURATION)
                    next_state = S_GREEN;
            end
            S_GREEN: begin
                if (timer >= GREEN_DURATION)
                    next_state = (ENABLE_YELLOW) ? S_YEL_PRE_R : S_RED;
            end
            S_YEL_PRE_R: begin
                if (timer >= YELLOW_DURATION)
                    next_state = S_RED;
            end
            default: next_state = S_RED;
        endcase
    end

    always @(*) begin
        case (current_state)
            S_RED:       light_o = RED;
            S_YEL_PRE_G: light_o = YELLOW;
            S_GREEN:     light_o = GREEN;
            S_YEL_PRE_R: light_o = YELLOW;
            default:     light_o = RED;
        endcase
    end
endmodule