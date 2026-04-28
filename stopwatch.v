//StopWatch: Modulo-60 Counter
module stopwatch(
    input clk,
    input rst,
    input en,
    output reg [5:0] state = 0    //6-bits to represent the highest number 59
);
    always @(posedge clk, posedge rst) begin
    if (rst) 
        state <= 0;
    else if (en) begin
        if (state == 59)
            state <= 0;
        else 
            state <= state + 1;
       end
   end
   
   
endmodule




