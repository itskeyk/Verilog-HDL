/*----------------------------------------------------------------------
File: Exp7_Top.v - Top-level module to implement bidirectional data
transfer through an 8-bit bus.

Cyclone FPGAs do not support internal tri-state output connections.
Quartus-II Verilog compiler replaces tri-state drivers with logic
operations that arbitrate net signals according to the driver status. 
------------------------------------------------------------------------
Revision History:
14 Mar 15 - Barbaros Ozdemirel
Created the module.
----------------------------------------------------------------------*/
module Exp7Top(Clock, Sel1, RnW1, Sel2, RnW2, Sel3, RnW3, Sel4, RnW4, DioExt, Dbus_Obs);
input Clock;  // clock input for all modules
input Sel1, Sel2, Sel3, Sel4;  // module select inputs
input RnW1, RnW2, RnW3, RnW4;  // module read/write control inputs
inout [7:0] DioExt; // IO connection to external data pins

output wire [7:0] Dbus_Obs;


tri [7:0] Dbus;  // internal data bus connecting all modules and
                 // DioExt[7:0] external data pins
assign Dbus_Obs = Dbus;                             
               
Reg8bit R1(Clock, Sel1, RnW1, Dbus);  // register modules
Reg8bit R2(Clock, Sel2, RnW2, Dbus);
Reg8bit R3(Clock, Sel3, RnW3, Dbus);

Accu Akuu(Clock, Sel4, RnW4, Dbus);


// DioExt[7:0] drive Dbus[7:0] while writing to a register module.
assign Dbus[7:0] = ( (RnW1 | RnW2 | RnW3 |RnW4) == 1'b0 ) ?
                   DioExt[7:0] : 8'bZ;
// Dbus[7:0] drive DioExt[7:0] while reading from a register module.
assign DioExt[7:0] = ( (RnW1 | RnW2 | RnW3 |RnW4) == 1'b1 ) ?
                     Dbus[7:0] : 8'bZ;

endmodule
//----------------------------------------------------------------------

module Reg8bit(Clk, Sel, RnW, Dio); 

input Clk;  
input Sel;  
input RnW;  
inout [7:0] Dio; 

reg [7:0] Store_FF=8'd0;

                     
 always @(posedge Clk)begin
    
    if(Sel&& ~RnW)
    Store_FF <= Dio;
           
	else
    Store_FF[7:0]<=Store_FF[7:0]; 
	    
	    
end
    
    assign Dio=(Sel&&RnW)? Store_FF:8'bZ;

endmodule



module Accu(Clk, Sel, RnW, Dio); 

input Clk;  
input Sel;  
input RnW;  
inout [7:0] Dio;

reg [7:0] accu_FF=8'd0;

reg Res = 1'b0;

 always @(posedge Clk)begin


	if(Sel&&!RnW)begin

		if(Res)begin              
		   accu_FF <=Dio;
			Res<=1'b0;
		end
    
		else
		 accu_FF <=accu_FF+Dio;
	
end

	else if(Sel&&RnW)
		Res <=1'b1;
        
        
	else if(Res) begin
		accu_FF<= 8'h00;
		Res <=1'b0;
	end


end

assign Dio =(Sel&&RnW)? accu_FF:8'bZ;

endmodule





    
         






