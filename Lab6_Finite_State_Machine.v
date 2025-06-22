bmodule Top_level_module(Clk, D1, D2, Counter,fsm_out);
  
  parameter S0=4'b0000, S1=4'b0001,S2=4'b0010, S3=4'b0011,S4=4'b0100, R1=4'b0101,R2=4'b0110, R3=4'b0111,R4=4'b1000;  
  
  input D1,D2,Clk;  
   
  output reg [2:0] Counter;
  output wire [3:0]fsm_out;
  
  reg [3:0] FSM; 
  assign fsm_out=FSM;

  always@(posedge Clk) begin
  
    case(FSM)
    
      S0:
        begin
        
          if((D1==1)&&(D2==0))
            FSM <= S1;
            
          else if (!D1 && D2)
                   FSM <= R1;
          else 
            FSM <= FSM;
            
        end
  
      S1:
        begin
          if((D1==1)&&(D2==1))
            FSM <= S2;
            
          else if((D1==0)&&(D2==0))
            FSM <= S0;
            
          else
            FSM <= FSM;
        end  
  
      S2:
        begin
          if((D1==0)&&(D2==1))
            FSM <= S3;
            
          else if((D1==1)&&(D2==0))
            FSM <= S1;
            
          else
            FSM <= FSM;
        end
  
      S3:
        begin
        
          if((D1==0)&&(D2==0))begin
            FSM <= S4;
          end
          
          else if((D1==1)&&(D2==1))
            FSM <= S2;
            
          else
            FSM <= FSM;
        end
        
      S4:
       begin
        
          Counter <= Counter + 3'b001;
          FSM <= S0;
          
        end
        
        
			R1:
            
             begin
                if (D1 && D2)
                    FSM <= R2;   
                else if (!D1 && !D2)
                    FSM <= S0;   
                else
                    FSM <= FSM;
            end
            
            R2: 
            
            begin
                if (D1 && !D2)
                    FSM <= R3;   
                else if (!D1 && D2)
                    FSM <= R1;  
                else
                    FSM <= FSM;
            end
            
            R3: 
            
            begin
                if (!D1 && !D2)
                    FSM <= R4; 
                      
                else if (D1 && D2)
                    FSM <= R2;  
                    
                else
                    FSM <= FSM;
            end
            
            R4: 
            
            begin
                Counter <= Counter - 3'b001;  
                FSM     <= S0;
            end
  
      default:
      
        FSM <= S0;
        
    endcase
    
  end
  endmodule