`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Lijin Wilson
// 
// Create Date: 11/10/2024 03:27:57 PM
// Design Name: 
// Module Name: traffic_controller_unit
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

module traffic_controller_unit(
HW, CR, clock, vehicle, clear
    );
    // defining the delay of Yellow to Red light transition delay
    parameter Y_to_R_delay = 3;
    
    // defining the delay of Red to Green light transition delay
    parameter R_to_G_delay = 2;
      
    input clock, clear;
    // for checking if their is any vehicle is their on the country road
    input vehicle;
    /*
    HW: high way
    CR: Country Road
    2 bits for three state of signals
    Red: 0, Yellow: 1, Green: 2
    */
    output [1:0] HW, CR;
    
    reg [1:0] HW, CR;
    
    // status of lights
    parameter RED = 2'd0, YELLOW = 2'd1, GREEN = 2'd2;
    
    // state definition
    /* {High way : Country Road}
    S0 = GREEN RED
    S1 = YELLOW RED
    S2 = RED RED
    S3 = RED GREEN
    S4 = RED YELLOW
    */
    parameter S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3, S4 = 3'd4;
    
    // Internal state variable
    reg [2:0] state;
    reg [2:0] next_state;
    
    // state changes at postive edge of clock only
    always @(posedge clock)
        begin
    //        if (clear) state <= S0;
    //        else state <= next_state;
            
            assign state = clear ? S0 : next_state; 
        end
    
    // assigning the high way and country road values
    always @ (state)
        begin
            case (state)
                S0 : begin HW = GREEN; CR = RED; end
                S1 : begin HW = YELLOW; CR = RED; end
                S2 : begin HW = RED; CR = RED; end
                S3 : begin HW = RED; CR = GREEN; end
                S4 : begin HW = RED; CR = YELLOW; end
            endcase
        end
        
    // state machine using the case statement
    always @ (vehicle or state)
        begin
            case (state)
                S0 : next_state = vehicle ? S1 : S0;
                S1 : begin
                        repeat (Y_to_R_delay) next_state = S1; next_state = S2;
                     end
                S2 : begin
                        repeat (R_to_G_delay) next_state = S2; next_state = S3;
                     end
                S3 : next_state = vehicle ? S3 : S4;
                S4 : begin
                        repeat(Y_to_R_delay) next_state = S4; next_state = S0;
                     end
                default : next_state = S0;
            endcase
        end

endmodule
