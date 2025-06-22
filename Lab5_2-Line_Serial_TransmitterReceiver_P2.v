module Top_level_module(
	input Clk,              
    input Send,  
               
    input [7:0] PDin,       

    output SoClk,         
    output SDout, 
               
    output [7:0] PDout,  
        
    output PDready,
    
    output ParErr 
    
          
);
	
    wire SC_internal;  
 
    wire SD_internal;  

   
    serial_transmitter transmitter (Clk,Send,PDin,SC_internal,SD_internal);
    serial_receiver receiver (SC_internal,SD_internal,PDout,PDready,ParErr);

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


    assign SCout = Clk;

    reg [9:0] ShReg;
    reg [3:0] count = 0;
    reg sending = 0;
    
    reg send_flag = 0;
    reg Send_prev = 0;
    reg Flag;
    
	
    always @(Send or Flag) begin
    
        if (Send == 1 && Send_prev == 0) begin
          
            send_flag = 1'b1;  
        end
        
        else if(Flag) begin
        send_flag = 1'b0;
        
        end
        
        else 
        send_flag = send_flag;
         
        Send_prev = Send;
    end
 
   
    always @(posedge Clk) begin
    
        if (send_flag && !sending) begin
        
            ShReg <= {1'b1,PDin,^PDin};  
            sending <= 1'b1;
            count <= 1'b0;
			Flag <= 1'b1;
            
        end 
        
        else if (sending) begin
        
			Flag <= 1'b0;
        
            ShReg <= {ShReg[8:0], 1'b0};  
            count <= count + 1'b1;

            if (count == 8) begin
            
                sending <= 0;  
            end
            
        end
        
        else 
        ShReg <= 10'b0;
        
    end

    assign SDout = ShReg[9];

endmodule




module serial_receiver(

    input SCin,
    input SDin,
    
    output reg [7:0] PDout,
    output reg PDready,
    output reg ParErr
);

    reg [7:0] ShReg = 0;
    
    reg [8:0] bit_count = 0;
    
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
                ParErr <= ParErr;
					
			end
			
        end 
        
        else begin
        
            ShReg <= {ShReg[6:0], SDin};
              
            bit_count <= bit_count + 1'b1;


            if (bit_count == 4'd8) begin  
            
                PDout <= ShReg[7:0];
                ParErr <= (SDin != ^ShReg[7:0]);
                PDready <= 1;
                receiving <= 0;  
            end 
            
            
            else begin
                PDready <= 0;
            end
            
        end
        
    end

endmodule


