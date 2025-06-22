module Top_level_module(
    input Clk,              
    input Send,  
               
    input [7:0] PDin,       

    output SoClk,         
    output SDout, 
               
    output [7:0] PDout,  
        
    output PDready           
);

    wire SC_internal;  
    
    
    
    wire SD_internal;  

   
    serial_transmitter transmitter (Clk,Send,PDin,SC_internal,SD_internal);
    serial_receiver receiver (SC_internal,SD_internal,PDout,PDready);

    assign SoClk = SC_internal;
    assign SDout = SD_internal;

endmodule



module serial_transmitter(
    input Clk,
    input Send,
    
    input [7:0] PDin,
    
    output SCout,
    
    output SDout
);

    reg [8:0] ShReg;

    assign SCout = Clk;  

    always @(posedge Clk) begin
       
         if (Send) begin
            
            ShReg <= {1'b1,PDin};
        end 
        
        
        else begin
     
            ShReg <= {ShReg[7:0],1'b0};
        end
        
    end

    assign SDout = ShReg[8];  

endmodule



module serial_receiver(
    input SCin,
    input SDin,
    
    output reg [7:0] PDout,
    output reg PDready
);

    reg [7:0] ShReg = 0;
    
    reg [3:0] bit_count = 0;
    
    reg receiving = 0;  

    always @(posedge SCin) begin
    
        if (!receiving) begin
       
            if (SDin == 1'b1) begin
                receiving <= 1;
                bit_count <= 0;
            end
            
            
            else begin
				
				ShReg<=ShReg;
				receiving <= 0;
                bit_count <= 0;
                PDready <= 0;
					
			end
			
        end 
        
        else begin
        
            ShReg <= {ShReg[6:0], SDin};
              
            bit_count <= bit_count + 1;


            if (bit_count == 4'd7) begin  
                PDout <= {ShReg[6:0], SDin}; 
                PDready <= 1;
                receiving <= 0;  
            end 
            
            
            else begin
                PDready <= 0;
            end
            
        end
        
    end

endmodule


