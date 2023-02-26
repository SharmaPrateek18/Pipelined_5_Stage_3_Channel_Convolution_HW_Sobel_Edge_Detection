`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2023 12:08:15 AM
// Design Name: 
// Module Name: top_CNN_Image_Processor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Define constants
parameter IMAGE_WIDTH = 128;
parameter IMAGE_HEIGHT = 128;
parameter FILTER_WIDTH = 3;
parameter FILTER_HEIGHT = 3;
parameter STRIDE = 1;
parameter NUM_CHANNELS = 3;

module top_CNN_Image_Processor(clk,reset,S,X,Y,Z,E,Save);
  
  input clk;
  input reset;
  input S;
  input [7:0]X;
  input [7:0]Y;
  input [7:0]Z;
  
  output logic signed [12:0]E;
  output logic Save;
  
  integer i = 0;
  integer j = 0;
  integer k = 0;
  integer l = 0;
  integer p = 0;
  integer q = 0;
  integer r = 0;
  integer s = 0;
  integer t = 0;
  integer u = 0;
  integer v = 0;
  integer w = 0;
  integer x = 0; 
  
  bit Fill_Flag = 0;
  bit Mul_Flag = 0;
  bit Add_Flag = 0;
  bit Done_Flag = 0;
  
  logic  [7:0] R_data [IMAGE_WIDTH-1:0][IMAGE_HEIGHT-1:0];
  logic  [7:0] G_data [IMAGE_WIDTH-1:0][IMAGE_HEIGHT-1:0];
  logic  [7:0] B_data [IMAGE_WIDTH-1:0][IMAGE_HEIGHT-1:0];
  
  logic  signed [10:0] R_Int [(IMAGE_WIDTH-FILTER_WIDTH):0][(IMAGE_HEIGHT-FILTER_HEIGHT):0];
  logic  signed [10:0] G_Int [(IMAGE_WIDTH-FILTER_WIDTH):0][(IMAGE_HEIGHT-FILTER_HEIGHT):0];
  logic  signed [10:0] B_Int [(IMAGE_WIDTH-FILTER_WIDTH):0][(IMAGE_HEIGHT-FILTER_HEIGHT):0];  
  
  logic signed [12:0] Image_Add [(IMAGE_WIDTH-FILTER_WIDTH):0][(IMAGE_WIDTH-FILTER_WIDTH):0];
 
  always_ff @(posedge clk or negedge reset)
  begin
    if (!reset)
    begin
        i = 0;
        j = 0;
        Fill_Flag = 0;
    end
    
    else if ((i <= IMAGE_WIDTH) && (j <= IMAGE_HEIGHT) && (S == 1))  // stage 1 begin
    begin
        if (i < IMAGE_WIDTH) 
        begin
            if (j < IMAGE_HEIGHT) 
            begin
                R_data[i][j] <= X;
                G_data[i][j] <= Y;
                B_data[i][j] <= Z;
                j++;
            end
            
            if(j == IMAGE_HEIGHT)
            begin
                i++;
                j = 0;
            end
        end
    
        else if ((i == IMAGE_WIDTH))
        begin
            Fill_Flag = 1;
        end
    end
  end
  
always_ff @ (posedge clk or negedge reset)
begin
    if (!reset)
    begin
        k = 0;
        l = 0;  
        Mul_Flag = 0;      
    end  
    
    else
    begin
        if ((k <= (IMAGE_WIDTH-FILTER_WIDTH+2)) && (Fill_Flag == 1))
        begin        
            if (k < (IMAGE_WIDTH-(FILTER_WIDTH)+2)) 
            begin
                if (l < (IMAGE_HEIGHT-(FILTER_HEIGHT)+2)) 
                begin
                    R_Int[k][l] = $signed((R_data[k][l]*0)+(R_data[k][l+1]*1)+(R_data[k][l+2]*0)+(R_data[k+1][l]*1)-(R_data[k+1][l+1]*(4))+(R_data[k+1][l+2]*1)+(R_data[k+2][l]*0)+(R_data[k+2][l+1]*1)+(R_data[k+2][l+2]*0));
                    G_Int[k][l] = $signed((G_data[k][l]*0)+(G_data[k][l+1]*1)+(G_data[k][l+2]*0)+(G_data[k+1][l]*1)-(G_data[k+1][l+1]*(4))+(G_data[k+1][l+2]*1)+(G_data[k+2][l]*0)+(G_data[k+2][l+1]*1)+(G_data[k+2][l+2]*0));
                    B_Int[k][l] = $signed((B_data[k][l]*0)+(B_data[k][l+1]*1)+(B_data[k][l+2]*0)+(B_data[k+1][l]*1)-(B_data[k+1][l+1]*(4))+(B_data[k+1][l+2]*1)+(B_data[k+2][l]*0)+(B_data[k+2][l+1]*1)+(B_data[k+2][l+2]*0));
                    l=l+1;
                end
                    
                if ((l == (IMAGE_HEIGHT-(FILTER_HEIGHT)+2) ) && (l == (IMAGE_HEIGHT-(FILTER_HEIGHT)+2)))
                begin
                    k++;
                    l = 0;                     
                end 
            end
            
            else if (k == (IMAGE_WIDTH-(FILTER_WIDTH)+2))
            begin
                Fill_Flag = 0;
                Mul_Flag = 1;
            end  
        end
    end
end

always_ff @ (posedge clk or negedge reset)
begin
    if (!reset)
    begin
        p = 0;
        q = 0;
        Add_Flag = 0;     
    end  
    
    else
    begin
        if ((p <= (IMAGE_WIDTH-FILTER_WIDTH+2)) && (Mul_Flag == 1))
        begin 
            if (p < (IMAGE_WIDTH-(FILTER_WIDTH)+2)) 
            begin
                if (q < (IMAGE_HEIGHT-(FILTER_HEIGHT)+2)) 
                begin
                    Image_Add[p][q] <= R_Int[p][q] + G_Int[p][q] + B_Int[p][q];
                    q++;
                end
                
                if (q == (IMAGE_HEIGHT-(FILTER_HEIGHT)+2))
                begin
                    p++;
                    q = 0;                        
                end
            end
                
            else if (p == (IMAGE_WIDTH-(FILTER_WIDTH)+2))
            begin
                Add_Flag = 1;
                Mul_Flag = 0;
            end  
        end
    end     
end

always_ff @(posedge clk or negedge reset)
begin
    if (!reset)
    begin
        r = 0;
        s = 0;
        t = 0; 
        Done_Flag = 0;
        Save = 0;      
    end  
    
    else
    begin
        if ((r <= (IMAGE_WIDTH-(FILTER_WIDTH))) && (Add_Flag == 1))
        begin
            Save = 1;
            if (r < (IMAGE_WIDTH-(FILTER_WIDTH)+1)) 
            begin
                if (s < (IMAGE_HEIGHT-(FILTER_HEIGHT)+1)) 
                begin
                    E <= Image_Add[r][s];
                    s++;
                end
                
                if (s == (IMAGE_HEIGHT-(FILTER_HEIGHT)+1))
                begin
                    r++;
                    s = 0;                        
                end    
            end
        end
        else if (r == (IMAGE_HEIGHT-(FILTER_HEIGHT)+1))
        begin
            Add_Flag = 0;
            Done_Flag = 1;
        end      
    end
end
  
endmodule  
