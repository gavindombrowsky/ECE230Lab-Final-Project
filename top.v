module top 
(
    input clk,           // 100 MHz
    input btnC,          // reset
    input [15:0] sw,     // switches
    output [15:0] led,    // LEDs
    output [3:0] an,     // Outputs for 7-segment display
    output [6:0] seg     // Outputs for 7-segment display
);

/******** DO NOT MODIFY ********/
wire clk_1Hz;       //Generate Internal 1Hz Clock
wire btnC_1Hz;     //Stretch load signal

//If running simulation, output clock frequency is 100MHz, else 1Hz
`ifndef SYNTHESIS
    assign clk_1Hz = clk;
`else
    clk_div #(.INPUT_FREQ(100_000_000), .OUTPUT_FREQ(1)) clk_div_1Hz 
    (.iclk(clk) , .rst(btnC) , .oclk(clk_1Hz));
`endif

// Check stopwatch/timer frequency
initial begin
`ifndef SYNTHESIS
    $display("Stopwatch/Timer Frequency set to 100MHz");
`else
    $display("Stopwatch/Timer Frequency set to 1Hz");
`endif
end

//Seven Segment Display Interface
//Note: 'count' is defined below
seven_segment_inf seven_segment_inf_inst (.clk(clk), .rst(btnC), .count(count) , .anode(an), .segs(seg));
/********************************/

/******** UNCOMMENT & UPDATE THIS SECTION ********/
// Internal wires to hold the state of the counters
wire [5:0] sw_cnt;
wire [5:0] tm_cnt;

// Mux: If mode is 1 (timer), show tm_cnt; if 0 (stopwatch), show sw_cnt
wire [5:0] count = (mode) ? tm_cnt : sw_cnt;

/******** UPDATE THIS SECTION ********/
// Control signals
wire mode   = sw[0];        // 0 = stopwatch, 1= timer
wire run    = sw[1];        // 0 = pause, 1 = run
wire load   = sw[2];        // 1 = load, 0 = do nothing
wire [5:0] load_value = sw[15:10]; 

// Stopwatch Module Instance
stopwatch sw_inst (
    .clk(clk_1Hz),
    .rst(btnC),
    .en(run),
    .state(sw_cnt)
);

// Timer Module Instance
timer tm_inst (
    .clk(clk_1Hz),
    .rst(btnC),
    .en(run),
    .load(load),
    .load_value(load_value),
    .state(tm_cnt)
);

// Mapping internal counters to LEDs (Fixes the "Z" error)
// Based on testbench: led[15:10] = timer, led[8:3] = stopwatch
assign led[15:10] = tm_cnt;
assign led[8:3]   = sw_cnt;
assign led[9]     = 1'b0;    // Unused
assign led[2:0]   = 3'b0;    // Unused

endmodule