module display_mux(
    input clk,
    input tick_500Hz,
    input [3:0] tenths,
    input [3:0] sec_ones,
    input [3:0] sec_tens,
    input [3:0] minutes,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg dp
);
    reg [1:0] digit_sel = 0;
    reg [3:0] current_val;

    // Cycle through digits 0, 1, 2, 3
    always @(posedge clk) begin
        if (tick_500Hz) begin
            digit_sel <= digit_sel + 1;
        end
    end

    // Select the correct value, turn on the correct anode (active low), and handle decimal points
    always @(*) begin
        case(digit_sel)
            2'b00: begin current_val = tenths;   an = 4'b1110; dp = 1; end // Rightmost digit, no DP
            2'b01: begin current_val = sec_ones; an = 4'b1101; dp = 0; end // Seconds ones, DP ON (0 = ON)
            2'b10: begin current_val = sec_tens; an = 4'b1011; dp = 1; end // Seconds tens, no DP
            2'b11: begin current_val = minutes;  an = 4'b0111; dp = 0; end // Minutes, DP ON (acts as colon)
        endcase
    end

    // Standard BCD to 7-Segment Decoder (Cathodes are Active Low)
    always @(*) begin
        case(current_val)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111; // Blank display if out of range
        endcase
    end
endmodule