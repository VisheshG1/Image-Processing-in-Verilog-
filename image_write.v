
module image_write #(parameter 
WIDTH = 768, // Image width 
HEIGHT = 512, // Image height 
INFILE = "output.bmp", // Output image 
BMP_HEADER_NUM = 54 // Header for bmp image 
) 
( 
input HCLK, // Clock input 
HRESETn, // Reset active low 
input hsync, // Hsync pulse 
input [7:0] DATA_WRITE_R0, // Red 8-bit data (odd) 
input [7:0] DATA_WRITE_G0, // Green 8-bit data (odd) 
input [7:0] DATA_WRITE_B0, // Blue 8-bit data (odd) 
input [7:0] DATA_WRITE_R1, // Red 8-bit data (even) 
input [7:0] DATA_WRITE_G1, // Green 8-bit data (even) 
input [7:0] DATA_WRITE_B1, // Blue 8-bit data (even) 
output reg Write_Done 
); 

reg fd;
reg [7:0] BMP_header [0:53]; // Change here: Declare BMP_header as an array of 8-bit registers
integer i;

// fpga4student.com FPGA projects, Verilog projects, VHDL projects
//-----------------------------------// 
//-------Header data for bmp image-----// 
//-------------------------------------// 
// Windows BMP files begin with a 54-byte header
initial  begin 
BMP_header[0] = 8'h42; BMP_header[1] = 8'h4D; // 'BM' for BMP file type
BMP_header[2] = 8'h36; BMP_header[3] = 8'h00;
BMP_header[4] = 8'h00; BMP_header[5] = 8'h00;
BMP_header[6] = 8'h00; BMP_header[7] = 8'h00;
BMP_header[8] = 8'h00; BMP_header[9] = 8'h00;
BMP_header[10] = 8'h36; BMP_header[11] = 8'h00;
BMP_header[12] = 8'h00; BMP_header[13] = 8'h00;
BMP_header[14] = 8'h28; BMP_header[15] = 8'h00;
BMP_header[16] = 8'h00; BMP_header[17] = 8'h00;
BMP_header[18] = 8'h00; BMP_header[19] = 8'h00;
BMP_header[20] = 8'h00; BMP_header[21] = 8'h00;
BMP_header[22] = 8'h01; BMP_header[23] = 8'h00;
BMP_header[24] = 8'h18; BMP_header[25] = 8'h00;
BMP_header[26] = 8'h00; BMP_header[27] = 8'h00;
BMP_header[28] = 8'h24; BMP_header[29] = 8'h00;
BMP_header[30] = 8'h00; BMP_header[31] = 8'h00;
BMP_header[32] = 8'h00; BMP_header[33] = 8'h00;
BMP_header[34] = 8'h00; BMP_header[35] = 8'h00;
BMP_header[36] = 8'h00; BMP_header[37] = 8'h00;
BMP_header[38] = 8'h00; BMP_header[39] = 8'h00;
BMP_header[40] = 8'h00; BMP_header[41] = 8'h00;
BMP_header[42] = 8'h00; BMP_header[43] = 8'h00;
BMP_header[44] = 8'h00; BMP_header[45] = 8'h00;
BMP_header[46] = 8'h00; BMP_header[47] = 8'h00;
BMP_header[48] = 8'h00; BMP_header[49] = 8'h00;
BMP_header[50] = 8'h00; BMP_header[51] = 8'h00;
BMP_header[52] = 8'h00; BMP_header[53] = 8'h00;
end
//---------------------------------------------------------//
//--------------Write .bmp file  ----------------------//
//----------------------------------------------------------//
initial begin
    fd = $fopen(INFILE, "wb+");
end
always@(Write_Done) begin // once the processing was done, bmp image will be created
    if(Write_Done == 1'b1) begin
        for(i=0; i<BMP_HEADER_NUM; i=i+1) begin
            $fwrite(fd, "%c", BMP_header[i]); // write the header
        end
        
        for(i=0; i<WIDTH*HEIGHT*3; i=i+6) begin
  // write R0B0G0 and R1B1G1 (6 bytes) in a loop
            $fwrite(fd, "%c", out_BMP[i  ]);
            $fwrite(fd, "%c", out_BMP[i+1]);
            $fwrite(fd, "%c", out_BMP[i+2]);
            $fwrite(fd, "%c", out_BMP[i+3]);
            $fwrite(fd, "%c", out_BMP[i+4]);
            $fwrite(fd, "%c", out_BMP[i+5]);
        end
    end
end
endmodule
