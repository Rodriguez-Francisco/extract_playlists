module fsm_and_counters(
    input clk,
    input reset,
    input tick_10Hz,
    input start,
    input stop,
    input clear,
    input count_down,
    output reg [3:0] tenths,
    output reg [3:0] sec_ones,
    output reg [3:0] sec_tens,
    output reg [3:0] minutes
);
    reg state; // 0 = STOPPED, 1 = RUNNING
    reg dir;   // 0 = UP, 1 = DOWN

    always @(posedge clk) begin
        // Active High Synchronous Reset
        if (reset) begin
            state <= 0;
            dir <= 0;
            tenths <= 0; sec_ones <= 0; sec_tens <= 0; minutes <= 0;
        end else begin
            
            if (state == 0) begin 
                // --- S_STOPPED ---
                dir <= count_down; // Latch direction only while stopped
                
                if (clear) begin
                    tenths <= 0; sec_ones <= 0; sec_tens <= 0; minutes <= 0;
                end else if (start) begin
                    state <= 1; // Transition to RUNNING
                end
                
            end else begin 
                // --- S_RUNNING ---
                if (stop) begin
                    state <= 0; // Transition to STOPPED
                end else if (tick_10Hz) begin
                    
                    if (dir == 0) begin 
                        // --- COUNT UP ---
                        if (tenths == 9) begin
                            tenths <= 0;
                            if (sec_ones == 9) begin
                                sec_ones <= 0;
                                if (sec_tens == 5) begin
                                    sec_tens <= 0;
                                    if (minutes == 9) minutes <= 0;
                                    else minutes <= minutes + 1;
                                end else sec_tens <= sec_tens + 1;
                            end else sec_ones <= sec_ones + 1;
                        end else tenths <= tenths + 1;
                        
                    end else begin 
                        // --- COUNT DOWN ---
                        if (tenths == 0) begin
                            tenths <= 9;
                            if (sec_ones == 0) begin
                                sec_ones <= 9;
                                if (sec_tens == 0) begin
                                    sec_tens <= 5;
                                    if (minutes == 0) minutes <= 9;
                                    else minutes <= minutes - 1;
                                end else sec_tens <= sec_tens - 1;
                            end else sec_ones <= sec_ones - 1;
                        end else tenths <= tenths - 1;
                    end
                end
            end
        end
    end
endmodule