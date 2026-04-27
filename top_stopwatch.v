module top_stopwatch(
    input clk,          // 100MHz internal Basys3 clock
    input reset,        // Active-high master reset
    input btn_start,    // RAW physical button
    input btn_stop,     // RAW physical button
    input btn_clear,    // RAW physical button
    input sw_countdown, // Slide switch for direction
    output [6:0] seg,   // 7-segment cathodes (active low)
    output [3:0] an,    // Anodes (active low)
    output dp           // Decimal point (active low)
);

    wire tick_10Hz, tick_500Hz;
    wire [3:0] val_tenths, val_sec_ones, val_sec_tens, val_minutes;

    // 1. Timing Belt
    clk_divider timing_unit (
        .clk_in(clk),
        .tick_10Hz(tick_10Hz),
        .tick_500Hz(tick_500Hz)
    );

    // 2. The Brain & Counters
    fsm_and_counters core_logic (
        .clk(clk),
        .reset(reset),
        .tick_10Hz(tick_10Hz),
        .start(btn_start), 
        .stop(btn_stop),   
        .clear(btn_clear), 
        .count_down(sw_countdown),
        .tenths(val_tenths),
        .sec_ones(val_sec_ones),
        .sec_tens(val_sec_tens),
        .minutes(val_minutes)
    );

    // 3. The Display Driver
    display_mux display_unit (
        .clk(clk),
        .tick_500Hz(tick_500Hz),
        .tenths(val_tenths),
        .sec_ones(val_sec_ones),
        .sec_tens(val_sec_tens),
        .minutes(val_minutes),
        .seg(seg),
        .an(an),
        .dp(dp)
    );

endmodule