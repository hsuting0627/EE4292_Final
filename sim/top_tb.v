`timescale 1ns/100ps
`define End_CYCLE 1000

`define Golden_RGB "SRAM_RGB.dat"
`define Golden_YCbCr "SRAM_YCbCr.dat"
`define Golden_DCT "SRAM_DCT.dat"
`define CYCLE 10
module top_tb;
//====== nWave ================
initial begin
    $fsdbDumpfile("top.fsdb");
    $fsdbDumpvars;
    $fsdbDumpMDA();
end

//====== module I/O =====
reg clk;
reg rst_n;
reg enable;
wire [511:0] data_read;
wire [511:0] data_write;
wire [11-1:0] sram_raddr;
wire [11-1:0] sram_waddr;
wire wen;
wire valid;

//====== clock generation =====
initial begin : proc_system
    clk = 0; //
    rst_n = 1;
    // system reset
    #(`CYCLE) rst_n = 0;
    #(`CYCLE) rst_n = 1;
    #(`CYCLE * 10000000) $finish;
end
always #(`CYCLE/2) clk=~clk;
//====== top connection =====
top top(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .data_read(data_read),
    .sram_raddr(sram_raddr),
    .sram_waddr(sram_waddr),
    .data_write(data_write),
    .wen(wen),
    .valid(valid)
);

//====== SRAM ===========
sram_1728x512b sram_1728x512b(
.clk(clk),
.csb(1'b0),
.wsb(wen),
.wdata(data_write), 
.waddr(sram_waddr), 
.raddr(sram_raddr), 
.rdata(data_read)
);

//====== LOAD PATTERN =====
reg [511:0] RGB_pattern [0:1728-1];
reg [511:0] YCbCr_pattern [0:1728-1];
reg [704-1:0] DCT_pattern [0:1728-1];

initial begin
    $readmemb(`Golden_RGB, RGB_pattern);
    $readmemb(`Golden_YCbCr, YCbCr_pattern);
    $readmemb(`Golden_DCT, DCT_pattern);
end

//====== LOAD SRAM ========
initial begin
    load_RGB;
end
integer m;
task load_RGB;
    begin
        for(m=0; m<1728; m=m+1) begin
            sram_1728x512b.load_param(m, RGB_pattern[m]);
        end
    end
endtask



//======== FEED ===========
initial begin
    wait(rst_n == 0);
    wait(rst_n == 1);
    enable = 1;
    // wait(valid);
    // enable = 0;
    #(`CYCLE*10000000) $finish;
end    
//========= OUTPUT CONCAT ===
wire [704-1:0] dct;
integer i;
// assign dct = {dct00, dct01, dct02, dct03, dct04, dct05, dct06, dct07, dct10, dct11, dct12, dct13, dct14, dct15, dct16, dct17, dct20, dct21, dct22, dct23, dct24, dct25, dct26, dct27, dct30, dct31, dct32, dct33, dct34, dct35, dct36, dct37, dct40, dct41, dct42, dct43, dct44, dct45, dct46, dct47, dct50, dct51, dct52, dct53, dct54, dct55, dct56, dct57, dct60, dct61, dct62, dct63, dct64, dct65, dct66, dct67, dct70, dct71, dct72, dct73, dct74, dct75, dct76, dct77};
//======== TEST ===========
integer f, j, k, l;
integer index;
initial begin
    wait(valid);
    for(l=0; l<3; l=l+1) begin
        for(j=0; j<1728; j=j+3) begin
            @(negedge clk);
            index = l+j;
            // $display("%d, %d",l , j);
            if (top.dct !== DCT_pattern[index]) begin
                $display("fuck! %d line \n", index);
                $finish;
                // $display("GOL : %b \n",DCT_pattern[index]);
                // $display("RTL : %b \n",top.dct);
    //                $display("%4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d, %4d", dct00, dct01, dct02, dct03, dct04, dct05, dct06, dct07, dct10, dct11, dct12, dct13, dct14, dct15, dct16, dct17, dct20, dct21, dct22, dct23, dct24, dct25, dct26, dct27, dct30, dct31, dct32, dct33, dct34, dct35, dct36, dct37, dct40, dct41, dct42, dct43, dct44, dct45, dct46, dct47, dct50, dct51, dct52, dct53, dct54, dct55, dct56, dct57, dct60, dct61, dct62, dct63, dct64, dct65, dct66, dct67, dct70, dct71, dct72, dct73, dct74, dct75, dct76, dct77);
            end
            else begin
                // $display("!!!!Pass %d line \n", index);
            end
        end
        if(l==0) $display("pass Y");
        if(l==1) $display("pass Cb");
        if(l==2) $display("pass Cr");
    end
    $display("pass all!");
    $finish;
end

endmodule