module csd_lut (
input                             reset,  
input                   [6:0]     input_y,//The first bit is a sign bit and the other six bits are numeric bits, as a seven-bit binary complement
input                   [6:0]     input_x,//The first bit is a sign bit and the other six bits are numeric bits, as a seven-bit binary complement
output  reg     signed  [14:0]    result
);
reg                     [6:0]     original_y;
reg                     [3:0]     complement_y_high;
reg                     [3:0]     complement_y_low;   
reg             signed  [11:0]    product_0;
reg             signed  [11:0]    product_1;
reg                     [9:0]     extention_x; 


function [11:0] result_function;

input                   [9:0]     input_function_x;
input                   [3:0]     input_function_y;

reg                               z,y,x,w,v,u;
reg             signed  [9:0]     output_1;
reg             signed  [7:0]     output_2;
reg                     [5:0]     switch;
begin
//Now describe the function of the Table1 in the paper
case(input_function_y)
    4'b0000:   switch = 6'b100000;
    4'b0001:   switch = 6'b100011;
    4'b0010:   switch = 6'b100010;
    4'b0011:   switch = 6'b001111;
    4'b0100:   switch = 6'b001000;
    4'b0101:   switch = 6'b001011;
    4'b0110:   switch = 6'b010110;
    4'b0111:   switch = 6'b010111;
    4'b1000:   switch = 6'b110000;
    4'b1001:   switch = 6'b110011;
    4'b1010:   switch = 6'b110010;
    4'b1011:   switch = 6'b101111;
    4'b1100:   switch = 6'b101000;
    4'b1101:   switch = 6'b101011;
    4'b1110:   switch = 6'b100110;
    4'b1111:   switch = 6'b100111;
    default:   switch = 6'b?;
endcase

z = switch[5];
y = switch[4];
x = switch[3];
w = switch[2];
v = switch[1];
u = switch[0];

if          (y&&(!x))       output_1        =   {input_function_x[6:0],3'b000};  
else if     (x)             output_1        =   {input_function_x[7:0],2'b00};
else                        output_1        =   0;

if          (v&&(!u))       output_2        =   {input_function_x[6:0],1'b0};
else if     (v&&u)          output_2        =   input_function_x[7:0];
else                        output_2        =   0;

if          (z&&w)          result_function =   -output_1 - output_2;
else if     ((!z)&&w)       result_function =   output_1 - output_2;
else if     (z&&(!w))       result_function =   -output_1 + output_2;
else if     ((!z)&&(!w))    result_function =   output_1 + output_2;
else                        result_function =   result_function;

end

endfunction


always @(input_x or input_y or reset) begin

extention_x                             =   {{3{input_x[6]}},input_x};//Doing sign bit extension on input x
///////////////////////////////////////////////////////////////////////////////////////
//Here I want to split the input y into two smaller parts to use the function separately, because the table 
//in the paper only supports four-bit binary complement. However, dividing the complement directly will get wrong results, 
//so the input y can only be converted into the original code for partitioning, 
//and then the two small blocks are transform back to the form of complement respectively.
///////////////////////////////////////////////////////////////////////////////////////

//Change the input_y to the original code, original_y
if (input_y[6])         original_y      =   {1'b1,~(input_y[5:0]-1'b1)};
else if(!input_y[6])    original_y      =   input_y;
else                    original_y      =   input_y;

//Convert every small part of the original code back to a complement,complement_y_high and complement_y_low
if (original_y[6]) begin
            complement_y_high           =   {original_y[6],~original_y[5:3]} + 1'b1;
            complement_y_low            =   {original_y[6],~original_y[2:0]} + 1'b1;
end
else if(!original_y[6]) begin
            complement_y_high           =   original_y[6:3];
            complement_y_low            =   {original_y[6],original_y[2:0]};
end
else begin
            complement_y_high           =   complement_y_high;
            complement_y_low            =   complement_y_low;
end

//But there's a special case, if y is 7'b1000000, I didn't set enough bit width to get the right answer, so I write that case here separately
if (input_y == 7'b1000000)begin
            complement_y_high           =   4'b1000;
            complement_y_low            =   4'b0000;
end
else begin
            complement_y_high           =   complement_y_high;
            complement_y_low            =   complement_y_low;
end

//Then used function and the final result is obtained
if (!reset)begin
            product_1                   =   result_function(extention_x,complement_y_high);   
            product_0                   =   result_function(extention_x,complement_y_low);
            result                      =   {{3{product_0[11]}},product_0} + {product_1,3'b000};
end

else if(reset)          result          =   0;
else                    result          =   result;
end

endmodule