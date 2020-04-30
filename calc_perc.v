// Percent Calculator
// ===========================================================================
// Calculates the ratio of two numbers times 100. Illustrates the uses for FSMs
// ===========================================================================
// Based on a module Nutter showed to Rice Rodriguez and then showed to me.
//Changes made: Changed Bit sizes to accomadate my needs.
module calc_perc   
(
     input clk,
     input reset,
     input [18:0] numerator,
     input [18:0] denominator,
     input enable,
     output reg done = 0,
     output reg [7:0] percent = 0
);
     reg [7:0] final_per = 0;
     reg [1:0] state = 0;
     // 22 bits because (18^*100)/2  needs at least 22 bits
     reg [22:0] sum = 0;
     parameter start       = 0,
               calculating = 1,
               finish      = 2;

     always @ (posedge clk)
          if(reset || ~enable) begin
               state = 0;
               sum = 0;
               done = 0;
               final_per = 0;
               percent = 0;
          end
          else
          case(state)
               start:
                    if(enable && denominator >= 0) begin
                         sum = numerator * 100 + denominator / 2;
                         state = calculating;
                    end
               calculating:
                    if(sum >= denominator) begin
                         sum = sum - denominator;
                         final_per = final_per + 1;
                         state = calculating;
                    end
                    else state = finish;
               finish:
               begin
                    percent = final_per;
                    done = 1;
               end
          endcase

endmodule
