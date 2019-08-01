/**
    *** Author: Tung Thanh le
    *** This is a behavioral simulation for the up_down_counter core
**/
`timescale 10ms/10ps

module up_down_counter_testbench();

    //declaration 
    localparam   T = 10;      // F = 10 Hz T = 100ms

    reg          clk;        // clock
    reg          reset;      // reset active high
    
    // active high buttons
    reg          up;         // count up 
    reg          down;       // count down
    reg          stop;       // stop count 
    
    wire         clk_div10;
    wire [15:0]  counter;     // counter 
    
    // design under test instantiation
    up_down_counter 
        up_down_counter_dut 
    (
        .clk(clk),       
        .reset(reset),     
    
        .up(up),         
        .down(down),      
        .stop(stop),     
        
        .clk_div10(clk_div10),
        .counter(counter)
    );
    
    // clock 
    // 10 Hz clock running
    initial 
    begin 
        clk = 1'b0;
        forever #(T/2) clk = ~clk;
    end
    
    initial 
    begin 
        // active reset in 1.5s
        #100;
        reset = 1'b1;
        #150;
        reset = 1'b0;
        
        // test count up
        #750;
        up = 1'b1;
        #150;
        up = 1'b0;
        
        // test count down 
        #43850;
        down = 1'b1;
        #150;
        down = 1'b0;
        
        // test count stop 
        #7350;
        stop = 1'b1;
        #150;
        stop = 1'b0;
        
        #1000;
        
        $stop;
    end

endmodule
