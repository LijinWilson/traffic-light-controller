`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lijin Wilson
// 
// Create Date: 11/10/2024 03:28:21 PM
// Design Name: 
// Module Name: traffic_controller_tb
// Project Name: traffic oontroller
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module traffic_controller_unit_tb();

    // Inputs
    reg clock;
    reg clear;
    reg vehicle;

    // Outputs
    wire [1:0] HW;
    wire [1:0] CR;

    // Instantiate the traffic controller unit
    traffic_controller_unit uut (
        .HW(HW),
        .CR(CR),
        .clock(clock),
        .vehicle(vehicle),
        .clear(clear)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Clock period = 10ns
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        clear = 1;
        vehicle = 0;
        
        // Apply reset
        #10 clear = 0; // Clear reset after 10ns
        
        // Case 1: No vehicle on the country road, HW should stay GREEN
        vehicle = 0;
        #50;

        // Case 2: Vehicle detected on country road, transition from S0 -> S1 -> S2 -> S3
        vehicle = 1;
        #50;
        
        // Case 3: Vehicle stays on the country road, HW stays RED, CR stays GREEN
        vehicle = 1;
        #50;
        
        // Case 4: No vehicle, CR transitions to YELLOW and HW returns to GREEN
        vehicle = 0;
        #50;
        
        // Case 5: Toggle clear signal, state should reset to S0
        clear = 1;
        #10 clear = 0;

        #50 $finish;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time = %0t | HW = %0d | CR = %0d | State = %0d", $time, HW, CR, uut.state);
    end

endmodule

