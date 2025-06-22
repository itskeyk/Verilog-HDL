module Top_level_module(clk,res,sel,out);

input clk,res,sel;

output out;

wire [2:0] count;


counter_3bit count_inst(clk,res,count);


Mux1 mux_inst(count[0],count[2],sel,out);


endmodule


module Mux1(
    input wire x1,
    input wire x2,
    input wire sel,
    output reg out
);

always @* begin
    if (sel == 1'b0) begin
        out = x1 & x2;
    end else begin
        out = x1 ^ x2;
    end
end

endmodule



module counter_3bit (
    input wire clk,
    input wire reset_n,
    output reg [2:0] count
);

always @(posedge clk or negedge reset_n)
begin
    if (~reset_n)
        count <= 3'b000;
    else
        count <= count + 1;
end

endmodule
