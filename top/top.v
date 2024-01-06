module top(
    input clk,
    input rst_n,
    input enable,
    input [512-1:0] data_read,
    output [11-1:0] sram_raddr,
    output [11-1:0] sram_waddr,
    output [512-1:0] data_write,
    output wen,
    output valid
);
//====== Control Unit =======
wire enable_rgb2ycbcr;
wire valid_rgb2ycbcr;
wire enable_dct;
wire valid_dct;
wire [10:0] sram_raddr_dct, sram_raddr_rgb2ycbcr;
assign sram_raddr = enable_rgb2ycbcr ? sram_raddr_rgb2ycbcr : sram_raddr_dct;

// === variable here is for testing dat format and can be deleted if you have other purposes.
    wire signed [11-1:0] dct00, dct01, dct02, dct03, dct04, dct05, dct06, dct07;
    wire signed [11-1:0] dct10, dct11, dct12, dct13, dct14, dct15, dct16, dct17;
    wire signed [11-1:0] dct20, dct21, dct22, dct23, dct24, dct25, dct26, dct27;
    wire signed [11-1:0] dct30, dct31, dct32, dct33, dct34, dct35, dct36, dct37;
    wire signed [11-1:0] dct40, dct41, dct42, dct43, dct44, dct45, dct46, dct47;
    wire signed [11-1:0] dct50, dct51, dct52, dct53, dct54, dct55, dct56, dct57;
    wire signed [11-1:0] dct60, dct61, dct62, dct63, dct64, dct65, dct66, dct67;
    wire signed [11-1:0] dct70, dct71, dct72, dct73, dct74, dct75, dct76, dct77;
//===========================================================================================

// controller here is for rgb2ycbcr and dct.
// the valid_dct means that the data can be quantized !
// the done_dct is for testing here for rgb2ycbcr, and can be removed if you want to add quantization module.
// add control signal here to control the quantization and huffman table !
// good luck! (I need to study RFIC q_q)

controller controller (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable),
    .enable_rgb2ycbcr(enable_rgb2ycbcr),
    .valid_rgb2ycbcr(valid_rgb2ycbcr),
    .enable_dct(enable_dct),
    .valid_dct(valid_dct),//
    .valid(valid)//
);

rgb2ycbcr_2d rgb2ycbcr_2d (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_rgb2ycbcr),
    .data_read(data_read), 
    .sram_raddr(sram_raddr_rgb2ycbcr),
    .sram_waddr(sram_waddr),
    .data_write(data_write), 
    .wen(wen),
    .valid(valid_rgb2ycbcr)
);

dct_2d dct_2d (
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct),
    .data_read(data_read),
    .sram_raddr(sram_raddr_dct),
    .valid(valid_dct),
    .done(done_dct),
    .dct00(dct00),
    .dct01(dct01),
    .dct02(dct02),
    .dct03(dct03),
    .dct04(dct04),
    .dct05(dct05),
    .dct06(dct06),
    .dct07(dct07),
    .dct10(dct10),
    .dct11(dct11),
    .dct12(dct12),
    .dct13(dct13),
    .dct14(dct14),
    .dct15(dct15),
    .dct16(dct16),
    .dct17(dct17),
    .dct20(dct20),
    .dct21(dct21),
    .dct22(dct22),
    .dct23(dct23),
    .dct24(dct24),
    .dct25(dct25),
    .dct26(dct26),
    .dct27(dct27),
    .dct30(dct30),
    .dct31(dct31),
    .dct32(dct32),
    .dct33(dct33),
    .dct34(dct34),
    .dct35(dct35),
    .dct36(dct36),
    .dct37(dct37),
    .dct40(dct40),
    .dct41(dct41),
    .dct42(dct42),
    .dct43(dct43),
    .dct44(dct44),
    .dct45(dct45),
    .dct46(dct46),
    .dct47(dct47),
    .dct50(dct50),
    .dct51(dct51),
    .dct52(dct52),
    .dct53(dct53),
    .dct54(dct54),
    .dct55(dct55),
    .dct56(dct56),
    .dct57(dct57),
    .dct60(dct60),
    .dct61(dct61),
    .dct62(dct62),
    .dct63(dct63),
    .dct64(dct64),
    .dct65(dct65),
    .dct66(dct66),
    .dct67(dct67),
    .dct70(dct70),
    .dct71(dct71),
    .dct72(dct72),
    .dct73(dct73),
    .dct74(dct74),
    .dct75(dct75),
    .dct76(dct76),
    .dct77(dct77)
);

// === variable here is for testing dat format and can be deleted if you have other purposes.
wire [704-1:0] dct;
assign dct = {dct00, dct01, dct02, dct03, dct04, dct05, dct06, dct07, dct10, dct11, dct12, dct13, dct14, dct15, dct16, dct17, dct20, dct21, dct22, dct23, dct24, dct25, dct26, dct27, dct30, dct31, dct32, dct33, dct34, dct35, dct36, dct37, dct40, dct41, dct42, dct43, dct44, dct45, dct46, dct47, dct50, dct51, dct52, dct53, dct54, dct55, dct56, dct57, dct60, dct61, dct62, dct63, dct64, dct65, dct66, dct67, dct70, dct71, dct72, dct73, dct74, dct75, dct76, dct77};
//===========================================================================================
endmodule