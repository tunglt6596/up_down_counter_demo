/**
    *** Author: Tung Thanh le
    *** Implement an up and down counter which fulfils requirements including:
        - speed: 1 Hz, range: [5500:0], default value: 3550, step up/down: 5
        - clock input 10 Hz and high active reset 
        - high active buttons: up, down, stop
**/

module up_down_counter
#(
    parameter   INITIAL_VALUE   =   3550,   // the assigned value when pressing reset button 
    parameter   MIN_VALUE       =   0,      // lowest limit
    parameter   MAX_VALUE       =   5500,   // highest limit
    parameter   STEP            =   5       // up or down count step
)
(
    input   wire        clk,        // clock
    input   wire        reset,      // reset active high
    
    // active high buttons
    input   wire        up,         // count up 
    input   wire        down,       // count down
    input   wire        stop,       // stop count 
    
    output  reg         clk_div10,  // clock frequency divided by 10
    output  reg [15:0]  counter     // counter 
);

// Save the latest chosen counting mode 
reg [1:0]   counter_mode;

localparam  COUNT_STOP    =   2'b00;
localparam  COUNT_UP      =   2'b01;
localparam  COUNT_DOWN    =   2'b10;

always @*
begin 
    if ( up )
        counter_mode <= COUNT_UP;
    else if ( down )
        counter_mode <= COUNT_DOWN;
    else if ( stop )
        counter_mode <= COUNT_STOP;
end 

/*
    ** Clock input is 10 Hz while counting speed is 1 Hz
    ** Below is a frequency divider 
*/
reg [2:0]   adder_value;            // adder for diving clock frequency
localparam  MAX_COUNTER =   5;      // max value to reset adder_value 

always @( posedge clk, posedge reset )
begin 
    if ( reset ) begin 
        clk_div10 <= 0;
        adder_value <= 0;
    end 
    else if ( adder_value == MAX_COUNTER - 1 ) begin 
        clk_div10 <= ~clk_div10;
        adder_value <= 0;
    end 
    else
        adder_value <= adder_value + 1;
end 

// Implement the counter according to the requirements at the top
always @( posedge clk_div10, posedge reset )
begin 
    if ( reset )
        counter <= INITIAL_VALUE;
    else begin 
        case ( counter_mode ) 
            COUNT_UP:     counter <= ( counter == MAX_VALUE ) ? MIN_VALUE : ( counter + STEP );
            COUNT_DOWN:   counter <= ( counter == MIN_VALUE ) ? MAX_VALUE : ( counter - STEP );
            default:      counter <= counter;
        endcase
    end
end

endmodule
