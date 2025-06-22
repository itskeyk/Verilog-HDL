module Top_level_module(
	input Clk, In,
	output Out1, Out2
);
	debouncer_1 deb1(Clk,In,Out1);  //.Out(Out1)
	debouncer_2 deb2(Clk,In,Out2); 
	
endmodule




module debouncer_1(  // Debouncer 1: Waits 4ms of stability before changing output


input Clk,In, 

output reg Out

);

reg [2:0] register;  

always @(posedge Clk) begin

	register[0] <= In;
	register[2:1] <= register[1:0]; 
	
	if((register[0]==register[1])&&(register[0] ==register[2]))  //&&(register[0] == register[3])
		
		Out <= register[0];
		
	else 
		
		Out<=Out;
	
	end
	
endmodule



module debouncer_2(  // Debouncer 2: Immediate update, then lock for 4ms

	input Clk,In, 
	output reg Out
	
);
	
	reg [1:0] Count;
	
	always @(posedge Clk)begin
	
	
		if (Count == 2'b11)begin
				
					//Out <= In;
					Count <= 2'b00;
			
				
		end
			
		else begin
			
			if(Count == 2'b00)begin
			Count <= Count + 2'b01;
			 
			Out <= (Out==In) ? Out:In;

			end
			
			else if ((Count != 2'b11)&&(Count != 2'b00))begin
			
			Out<=Out;
			Count <= Count + 2'b01;
			end
			
			else begin
				Out<=Out;
				Count <= Count;
			end
	
			
		end
		
		
	end
endmodule

