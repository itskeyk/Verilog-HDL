module Top_level_module(

input nReset,Clock,Enable,

output [3:0]Co1,
output [3:0]Co10,
output [3:0]Co100

);

wire nexten1,nexten2,nexten3;

BCD_Counter BCD1(nReset,Clock,Enable,nexten1,Co1);
BCD_Counter BCD2(nReset,Clock,nexten1&Enable,nexten2,Co10);
BCD_Counter BCD3(nReset,Clock,nexten1&Enable&nexten2,nexten3,Co100);

endmodule




module BCD_Counter(

	input wire nRes, Clock, CntEn,
	output NextEn,
	output reg [3:0] Cout
);


always @(posedge Clock or negedge nRes) begin
	
	if (nRes == 0) begin
		Cout <= 4'b0000;
	end 
	
	else if (CntEn) begin
		if (Cout == 4'd9) begin
			Cout <= 4'b0000;  	
		end
		
		else begin
			Cout <= Cout + 4'b0001;
		end
	end
end

assign NextEn=(Cout == 4'd9)? 1'b1 : 1'b0;

endmodule
