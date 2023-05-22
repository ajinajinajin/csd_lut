`timescale  1ns / 1ps

module csd_lut_tb;

parameter PERIOD  = 50;

// csd_lut Inputs
reg   reset                                = 0 ;
reg   [6:0]  input_y                       = 0 ;
reg   [6:0]  input_x                       = 0 ;

// csd_lut Outputs
wire    [14:0]      result                     ;

csd_lut  uut(
    .reset                    ( reset                          ),
    .input_y                  ( input_y                        ),
    .input_x                  ( input_x                        ),
    .result                   ( result                         )   
);

initial
begin

reset  =  1;
input_y = 7'b1111111;
input_x = 7'b0111111;
#(PERIOD) ;

reset  =  0;
#(PERIOD) ;   
input_y = 7'b0111111;
#(PERIOD) ;

input_y = 7'b1000011;
#(PERIOD) ;

input_y = 7'b1111111;
#(PERIOD) ;

input_y = 7'b0101110;
#(PERIOD) ;

input_y = 7'b0000000;
#(PERIOD) ;

input_y = 7'b0111100;
#(PERIOD) ;

input_y = 7'b1000000;
#(PERIOD) ;

input_x = 7'b1111111;
#(PERIOD) ;

input_x = 7'b0000000;
#(PERIOD) ;

input_x = 7'b1010101;
#(PERIOD) ;

input_x = 7'b0101010;
#(PERIOD) ;

reset  =  1;
#(PERIOD) ;
$finish;
end

endmodule