module clk_divider(
    input clk_in,
    output reg tick_10Hz,
    output reg tick_500Hz
);
    // 100,000,000 / 10 = 10,000,000 cycles per tick
    reg [23:0] cnt_10 = 0; 
    
    // 100,000,000 / 500 = 200,000 cycles per tick
    reg [17:0] cnt_500 = 0;

    always @(posedge clk_in) begin
        // 10 Hz Generator (0.1 second)
        if (cnt_10 == 9_999_999) begin
            cnt_10 <= 0;
            tick_10Hz <= 1;
        end else begin
            cnt_10 <= cnt_10 + 1;
            tick_10Hz <= 0;
        end

        // 500 Hz Generator (Display Refresh)
        if (cnt_500 == 199_999) begin
            cnt_500 <= 0;
            tick_500Hz <= 1;
        end else begin
            cnt_500 <= cnt_500 + 1;
            tick_500Hz <= 0;
        end
    end
endmodule