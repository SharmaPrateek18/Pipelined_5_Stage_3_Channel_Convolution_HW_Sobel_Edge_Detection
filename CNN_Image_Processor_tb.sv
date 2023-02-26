`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2023 12:10:18 AM
// Design Name: 
// Module Name: CNN_Image_Processor_tb
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


module CNN_Image_Processor_tb();
logic clk=0;
integer File_R;
integer File_G;
integer File_B;
integer File_OUT;
integer z = 0;

logic reset;
logic [7:0]X;
logic [7:0]Y;
logic [7:0]Z;
logic S = 0;
logic signed [12:0]E;
logic Save;

top_CNN_Image_Processor uut(clk,reset,S,X,Y,Z,E,Save);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial
begin
    reset=0;
    #10
    reset=1;
    S = 1;
end
    
initial
begin
    #10
    File_R = $fopen("C:/Users/RAJESH KUMAR/Desktop/Digital_IC_Assign/CNN_Assign_03/Image_Array/R_1.txt","r");
    while (!$feof(File_R))
    begin
        $fscanf(File_R,"%d\n",X);
        #10;
    end
    $fclose(File_R);
end
    
initial
begin
    #10
    File_G = $fopen("C:/Users/RAJESH KUMAR/Desktop/Digital_IC_Assign/CNN_Assign_03/Image_Array/G_1.txt","r");
    while (!$feof(File_G))
    begin
        $fscanf(File_G,"%d\n",Y);
        #10;
    end
    $fclose(File_G);
end 
    
initial
begin
    #10
    File_B = $fopen("C:/Users/RAJESH KUMAR/Desktop/Digital_IC_Assign/CNN_Assign_03/Image_Array/B_1.txt","r");
    while (!$feof(File_B))
        begin
            $fscanf(File_B,"%d\n",Z);
            #10;
        end
    $fclose(File_B);
end 

initial 
begin
    #50
    while(Save!=1) 
    #1;
    File_OUT = $fopen("C:/Users/RAJESH KUMAR/Desktop/Digital_IC_Assign/CNN_Assign_03/Image_Array/Output_Image_Pixels.txt","w");
    while ( Save == 1 && z < 126*126 )
        begin
            $fwrite(File_OUT,"%d\n",E);
            #10;
            z++;
        end
    $fclose(File_OUT);
end

endmodule

//initial #10
//    begin
//        while (!$feof(input_data))
//                begin
//                    B=input_data[j+8]; 
//                    #10;
//                end
//    end
