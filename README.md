# Pipelined_5_Stage_3_Channel_Convolution_HW_Sobel_Edge_Detection
This is a Parameterized Verilog module that implements a CNN (Convolutional Neural Network) image processor. It takes in an RGB image with dimensions 128x128 and applies a Laplacian filter of size 3x3 to each channel to detect edges. The output is stored in an array Image_Add that can be sent to a testbench and converted into an image using Python or other scripts.

The module has six inputs: clk, reset, S, X, Y, and Z. The clk input is the clock signal, reset is the reset signal, and S is a start switch that is used to enable the module. The X, Y, and Z inputs represent the red, green, and blue channels of the input image, respectively.

The module has two outputs: E and Save. E is a signed 13-bit output that is used to take the output of the module to a testbench and save it to a .txt file. Save is a flag that enables saving the output data into an output file once the conversion process is complete.

The module uses several parameters to define constants, including the image width and height, filter width and height, stride, and number of channels. It also uses several arrays to store intermediate data during the image processing, including arrays to store the input data for each channel, intermediate values for each channel, and the final output data.

The module uses two always blocks to implement the image processing pipeline. The first always block reads in the input image data and stores it in the appropriate channel array. The second always block applies the Laplacian filter to each channel and stores the output in the Image_Add array. Both always blocks are triggered by the clock signal or the reset signal.

Overall, this Verilog module provides a basic implementation of a CNN image processor that can detect edges in an RGB image using a Laplacian filter. The module can be used as a starting point for more complex image processing applications or integrated into a larger system for computer vision tasks.

In the code, the channel array is directly multiplied with the laplacian filter. The user can also modify the code and input to the laplacian filter can be given form the testbench.

The used Laplacial filter for Sobel Edge Detection is:  [0	 1	0
                                                         1	-4	1
                                                         0	 1	0 ]
