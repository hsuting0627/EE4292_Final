module dct_2d (
    input clk,
    input rst_n,
    input enable,
    input [512-1:0] data_read,
    output reg [11-1:0] sram_raddr,

    output valid,
    output reg done,
    output [11-1:0] dct00,
    output [11-1:0] dct01,
    output [11-1:0] dct02,
    output [11-1:0] dct03,
    output [11-1:0] dct04,
    output [11-1:0] dct05,
    output [11-1:0] dct06,
    output [11-1:0] dct07,
    output [11-1:0] dct10,
    output [11-1:0] dct11,
    output [11-1:0] dct12,
    output [11-1:0] dct13,
    output [11-1:0] dct14,
    output [11-1:0] dct15,
    output [11-1:0] dct16,
    output [11-1:0] dct17,
    output [11-1:0] dct20,
    output [11-1:0] dct21,
    output [11-1:0] dct22,
    output [11-1:0] dct23,
    output [11-1:0] dct24,
    output [11-1:0] dct25,
    output [11-1:0] dct26,
    output [11-1:0] dct27,
    output [11-1:0] dct30,
    output [11-1:0] dct31,
    output [11-1:0] dct32,
    output [11-1:0] dct33,
    output [11-1:0] dct34,
    output [11-1:0] dct35,
    output [11-1:0] dct36,
    output [11-1:0] dct37,
    output [11-1:0] dct40,
    output [11-1:0] dct41,
    output [11-1:0] dct42,
    output [11-1:0] dct43,
    output [11-1:0] dct44,
    output [11-1:0] dct45,
    output [11-1:0] dct46,
    output [11-1:0] dct47,
    output [11-1:0] dct50,
    output [11-1:0] dct51,
    output [11-1:0] dct52,
    output [11-1:0] dct53,
    output [11-1:0] dct54,
    output [11-1:0] dct55,
    output [11-1:0] dct56,
    output [11-1:0] dct57,
    output [11-1:0] dct60,
    output [11-1:0] dct61,
    output [11-1:0] dct62,
    output [11-1:0] dct63,
    output [11-1:0] dct64,
    output [11-1:0] dct65,
    output [11-1:0] dct66,
    output [11-1:0] dct67,
    output [11-1:0] dct70,
    output [11-1:0] dct71,
    output [11-1:0] dct72,
    output [11-1:0] dct73,
    output [11-1:0] dct74,
    output [11-1:0] dct75,
    output [11-1:0] dct76,
    output [11-1:0] dct77
);

wire signed [10-1:0] y00, y01, y02, y03, y04, y05, y06, y07;
wire signed [10-1:0] y10, y11, y12, y13, y14, y15, y16, y17;
wire signed [10-1:0] y20, y21, y22, y23, y24, y25, y26, y27;
wire signed [10-1:0] y30, y31, y32, y33, y34, y35, y36, y37;
wire signed [10-1:0] y40, y41, y42, y43, y44, y45, y46, y47;
wire signed [10-1:0] y50, y51, y52, y53, y54, y55, y56, y57;
wire signed [10-1:0] y60, y61, y62, y63, y64, y65, y66, y67;
wire signed [10-1:0] y70, y71, y72, y73, y74, y75, y76, y77;

wire [7:0] x00f, x01f, x02f, x03f, x04f, x05f, x06f, x07f;
wire [7:0] x10f, x11f, x12f, x13f, x14f, x15f, x16f, x17f;
wire [7:0] x20f, x21f, x22f, x23f, x24f, x25f, x26f, x27f;
wire [7:0] x30f, x31f, x32f, x33f, x34f, x35f, x36f, x37f;
wire [7:0] x40f, x41f, x42f, x43f, x44f, x45f, x46f, x47f;
wire [7:0] x50f, x51f, x52f, x53f, x54f, x55f, x56f, x57f;
wire [7:0] x60f, x61f, x62f, x63f, x64f, x65f, x66f, x67f;
wire [7:0] x70f, x71f, x72f, x73f, x74f, x75f, x76f, x77f;

wire [7:0] x00, x01, x02, x03, x04, x05, x06, x07;
wire [7:0] x10, x11, x12, x13, x14, x15, x16, x17;
wire [7:0] x20, x21, x22, x23, x24, x25, x26, x27;
wire [7:0] x30, x31, x32, x33, x34, x35, x36, x37;
wire [7:0] x40, x41, x42, x43, x44, x45, x46, x47;
wire [7:0] x50, x51, x52, x53, x54, x55, x56, x57;
wire [7:0] x60, x61, x62, x63, x64, x65, x66, x67;
wire [7:0] x70, x71, x72, x73, x74, x75, x76, x77;

wire valid_pre, valid_pre0, valid_pre1, valid_pre2, valid_pre3, valid_pre4, valid_pre5, valid_pre6, valid_pre7;
wire valid_post, valid_post0, valid_post1, valid_post2, valid_post3, valid_post4, valid_post5, valid_post6, valid_post7;
reg valid_next;
wire valid1;
// reg [17:0] pipeline;
// always @ (posedge clk) begin
//     if(!rst_n) begin
//         pipeline <= 18'd0;
//     end
//     else begin
//         pipeline <= {pipeline[16:0], enable};
//     end
// end

// assign valid = pipeline[17];

//=== FSM
localparam IDLE = 3'd0, LOAD_Y = 3'd1, LOAD_Cb = 3'd2, LOAD_Cr = 3'd3, WAIT1 = 3'd5, WAIT2 = 3'd6, FINISH = 3'd4;
reg [2:0] state, state_n;
always @(posedge clk) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= state_n;
    end
end
//=========
reg load_Y_done, load_Cb_done, load_Cr_done;
reg load_Y_done_next, load_Cb_done_next, load_Cr_done_next;
always@* begin
    case(state) 
        IDLE : state_n = enable ? WAIT1 : IDLE;
        WAIT1 : state_n = WAIT2;
        WAIT2 : state_n = LOAD_Y;
        LOAD_Y : state_n = load_Y_done ? LOAD_Cb : LOAD_Y;
        LOAD_Cb : state_n = load_Cb_done ? LOAD_Cr : LOAD_Cb;
        LOAD_Cr : state_n = load_Cr_done ? FINISH : LOAD_Cr;
        default : state_n = IDLE;
    endcase
end
reg [11:0] sram_raddr_next;
reg [11-1:0] cnt_load_Y_next, cnt_load_Y;
reg [11-1:0] cnt_load_Cb_next, cnt_load_Cb;
reg [11-1:0] cnt_load_Cr_next, cnt_load_Cr;
reg done_next;
always @(posedge clk) begin
    if(!rst_n) begin
        cnt_load_Y <= 0;
        cnt_load_Cb <= 0;
        cnt_load_Cr <= 0;
        load_Y_done <= 0;
        load_Cb_done <= 0;
        load_Cr_done <= 0;
        sram_raddr <= 0;
        done <= 0;
    end
    else begin
        cnt_load_Y <= cnt_load_Y_next;
        cnt_load_Cb <= cnt_load_Cb_next;
        cnt_load_Cr <= cnt_load_Cr_next;
        sram_raddr <= sram_raddr_next;
        load_Y_done <= load_Y_done_next;
        load_Cb_done <= load_Cb_done_next;
        load_Cr_done <= load_Cr_done_next;
        done <= done_next;
    end
end
always @* begin
    case(state)
        IDLE : begin
            sram_raddr_next = 0;
            cnt_load_Y_next = 0;
            cnt_load_Cb_next = 1;
            cnt_load_Cr_next = 2;
            load_Y_done_next = 0;
            load_Cb_done_next = 0;
            load_Cr_done_next = 0;
            done_next = 0;
        end
        LOAD_Y : begin
            sram_raddr_next = cnt_load_Y;
            cnt_load_Y_next = cnt_load_Y + 3;
            cnt_load_Cb_next = cnt_load_Cb;
            cnt_load_Cr_next = cnt_load_Cr;      
            if (cnt_load_Y == 1722) load_Y_done_next = 1;
            else load_Y_done_next = 0;
            load_Cb_done_next = 0;
            load_Cr_done_next = 0;
            done_next = 0;
        end
        LOAD_Cb : begin
            sram_raddr_next = cnt_load_Cb;
            cnt_load_Y_next = cnt_load_Y;
            cnt_load_Cb_next = cnt_load_Cb + 3;
            cnt_load_Cr_next = cnt_load_Cr;  
            load_Y_done_next = 0; 
            if (cnt_load_Cb == 1723) load_Cb_done_next = 1;
            else load_Cb_done_next = 0;
            load_Cr_done_next = 0;
            done_next = 0;
        end
        LOAD_Cr : begin
            sram_raddr_next = cnt_load_Cr;
            cnt_load_Y_next = cnt_load_Y;
            cnt_load_Cb_next = cnt_load_Cb;
            cnt_load_Cr_next = cnt_load_Cr + 3;
            load_Y_done_next = 0;
            load_Cb_done_next = 0;
            if (cnt_load_Cr == 1724) load_Cr_done_next = 1;
            else load_Cr_done_next = 0;
            done_next = 0;
        end
        FINISH : begin
            sram_raddr_next = 0;
            cnt_load_Y_next = 0;
            cnt_load_Cb_next = 1;
            cnt_load_Cr_next = 2;
            load_Y_done_next = 0;
            load_Cb_done_next = 0;
            load_Cr_done_next = 0;
            done_next = 1;
        end
        default : begin
            sram_raddr_next = sram_raddr;
            cnt_load_Y_next = cnt_load_Y;
            cnt_load_Cb_next = cnt_load_Cb;
            cnt_load_Cr_next = cnt_load_Cr;    
            load_Y_done_next = 0;
            load_Cb_done_next = 0;
            load_Cr_done_next = 0;
            done_next = done;         
        end
    endcase
end

reg [512-1:0] data_read_ff;
always @(posedge clk) begin
    data_read_ff <= data_read;
end
assign x00 = x00f - 128;
assign x01 = x01f - 128;
assign x02 = x02f - 128;
assign x03 = x03f - 128;
assign x04 = x04f - 128;
assign x05 = x05f - 128;
assign x06 = x06f - 128;
assign x07 = x07f - 128;
assign x10 = x10f - 128;
assign x11 = x11f - 128;
assign x12 = x12f - 128;
assign x13 = x13f - 128;
assign x14 = x14f - 128;
assign x15 = x15f - 128;
assign x16 = x16f - 128;
assign x17 = x17f - 128;
assign x20 = x20f - 128;
assign x21 = x21f - 128;
assign x22 = x22f - 128;
assign x23 = x23f - 128;
assign x24 = x24f - 128;
assign x25 = x25f - 128;
assign x26 = x26f - 128;
assign x27 = x27f - 128;
assign x30 = x30f - 128;
assign x31 = x31f - 128;
assign x32 = x32f - 128;
assign x33 = x33f - 128;
assign x34 = x34f - 128;
assign x35 = x35f - 128;
assign x36 = x36f - 128;
assign x37 = x37f - 128;
assign x40 = x40f - 128;
assign x41 = x41f - 128;
assign x42 = x42f - 128;
assign x43 = x43f - 128;
assign x44 = x44f - 128;
assign x45 = x45f - 128;
assign x46 = x46f - 128;
assign x47 = x47f - 128;
assign x50 = x50f - 128;
assign x51 = x51f - 128;
assign x52 = x52f - 128;
assign x53 = x53f - 128;
assign x54 = x54f - 128;
assign x55 = x55f - 128;
assign x56 = x56f - 128;
assign x57 = x57f - 128;
assign x60 = x60f - 128;
assign x61 = x61f - 128;
assign x62 = x62f - 128;
assign x63 = x63f - 128;
assign x64 = x64f - 128;
assign x65 = x65f - 128;
assign x66 = x66f - 128;
assign x67 = x67f - 128;
assign x70 = x70f - 128;
assign x71 = x71f - 128;
assign x72 = x72f - 128;
assign x73 = x73f - 128;
assign x74 = x74f - 128;
assign x75 = x75f - 128;
assign x76 = x76f - 128;
assign x77 = x77f - 128;


assign {x00f, x01f, x02f, x03f, x04f, x05f, x06f, x07f, x10f, x11f, x12f, x13f, x14f, x15f, x16f, x17f, x20f, x21f, x22f, x23f, x24f, x25f, x26f, x27f, x30f, x31f, x32f, x33f, x34f, x35f, x36f, x37f, x40f, x41f, x42f, x43f, x44f, x45f, x46f, x47f, x50f, x51f, x52f, x53f, x54f, x55f, x56f, x57f, x60f, x61f, x62f, x63f, x64f, x65f, x66f, x67f, x70f, x71f, x72f, x73f, x74f, x75f, x76f, x77f} = data_read_ff;

reg [5:0] enable_dct;
wire enable_dct_p;
always @ (posedge clk) begin
    if(!rst_n) begin
        enable_dct <= 6'd0;
    end
    else begin
        enable_dct <= {enable_dct[4:0], enable};
    end
end

assign enable_dct_p = enable_dct[5];

dct_1d_8to10 U0(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x00),
    .x1(x01),
    .x2(x02),
    .x3(x03),
    .x4(x04),
    .x5(x05),
    .x6(x06),
    .x7(x07),
    .y0(y00),
    .y1(y01),
    .y2(y02),
    .y3(y03),
    .y4(y04),
    .y5(y05),
    .y6(y06),
    .y7(y07),
    .valid(valid_pre0)
);

dct_1d_8to10 U1(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x10),
    .x1(x11),
    .x2(x12),
    .x3(x13),
    .x4(x14),
    .x5(x15),
    .x6(x16),
    .x7(x17),
    .y0(y10),
    .y1(y11),
    .y2(y12),
    .y3(y13),
    .y4(y14),
    .y5(y15),
    .y6(y16),
    .y7(y17),
    .valid(valid_pre1)
);

dct_1d_8to10 U2(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x20),
    .x1(x21),
    .x2(x22),
    .x3(x23),
    .x4(x24),
    .x5(x25),
    .x6(x26),
    .x7(x27),
    .y0(y20),
    .y1(y21),
    .y2(y22),
    .y3(y23),
    .y4(y24),
    .y5(y25),
    .y6(y26),
    .y7(y27),
    .valid(valid_pre2)
);

dct_1d_8to10 U3(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x30),
    .x1(x31),
    .x2(x32),
    .x3(x33),
    .x4(x34),
    .x5(x35),
    .x6(x36),
    .x7(x37),
    .y0(y30),
    .y1(y31),
    .y2(y32),
    .y3(y33),
    .y4(y34),
    .y5(y35),
    .y6(y36),
    .y7(y37),
    .valid(valid_pre3)
);

dct_1d_8to10 U4(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x40),
    .x1(x41),
    .x2(x42),
    .x3(x43),
    .x4(x44),
    .x5(x45),
    .x6(x46),
    .x7(x47),
    .y0(y40),
    .y1(y41),
    .y2(y42),
    .y3(y43),
    .y4(y44),
    .y5(y45),
    .y6(y46),
    .y7(y47),
    .valid(valid_pre4)
);

dct_1d_8to10 U5(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x50),
    .x1(x51),
    .x2(x52),
    .x3(x53),
    .x4(x54),
    .x5(x55),
    .x6(x56),
    .x7(x57),
    .y0(y50),
    .y1(y51),
    .y2(y52),
    .y3(y53),
    .y4(y54),
    .y5(y55),
    .y6(y56),
    .y7(y57),
    .valid(valid_pre5)
);

dct_1d_8to10 U6(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x60),
    .x1(x61),
    .x2(x62),
    .x3(x63),
    .x4(x64),
    .x5(x65),
    .x6(x66),
    .x7(x67),
    .y0(y60),
    .y1(y61),
    .y2(y62),
    .y3(y63),
    .y4(y64),
    .y5(y65),
    .y6(y66),
    .y7(y67),
    .valid(valid_pre6)
);

dct_1d_8to10 U7(
    .clk(clk),
    .rst_n(rst_n),
    .enable(enable_dct_p),
    .x0(x70),
    .x1(x71),
    .x2(x72),
    .x3(x73),
    .x4(x74),
    .x5(x75),
    .x6(x76),
    .x7(x77),
    .y0(y70),
    .y1(y71),
    .y2(y72),
    .y3(y73),
    .y4(y74),
    .y5(y75),
    .y6(y76),
    .y7(y77),
    .valid(valid_pre7)
);

assign valid_pre = valid_pre0 && valid_pre1 && valid_pre2 && valid_pre3 && valid_pre4 && valid_pre5 && valid_pre6 && valid_pre7;
// //calculate Z

dct_1d Z0(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y00),
    .x1(y10),
    .x2(y20),
    .x3(y30),
    .x4(y40),
    .x5(y50),
    .x6(y60),
    .x7(y70),
    .y0(dct00),
    .y1(dct10),
    .y2(dct20),
    .y3(dct30),
    .y4(dct40),
    .y5(dct50),
    .y6(dct60),
    .y7(dct70),
    .valid(valid_post0)
);

dct_1d Z1(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y01),
    .x1(y11),
    .x2(y21),
    .x3(y31),
    .x4(y41),
    .x5(y51),
    .x6(y61),
    .x7(y71),
    .y0(dct01),
    .y1(dct11),
    .y2(dct21),
    .y3(dct31),
    .y4(dct41),
    .y5(dct51),
    .y6(dct61),
    .y7(dct71),
    .valid(valid_post1)
);

dct_1d Z2(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y02),
    .x1(y12),
    .x2(y22),
    .x3(y32),
    .x4(y42),
    .x5(y52),
    .x6(y62),
    .x7(y72),
    .y0(dct02),
    .y1(dct12),
    .y2(dct22),
    .y3(dct32),
    .y4(dct42),
    .y5(dct52),
    .y6(dct62),
    .y7(dct72),
    .valid(valid_post2)
);

dct_1d Z3(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y03),
    .x1(y13),
    .x2(y23),
    .x3(y33),
    .x4(y43),
    .x5(y53),
    .x6(y63),
    .x7(y73),
    .y0(dct03),
    .y1(dct13),
    .y2(dct23),
    .y3(dct33),
    .y4(dct43),
    .y5(dct53),
    .y6(dct63),
    .y7(dct73),
    .valid(valid_post3)
);

dct_1d Z4(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y04),
    .x1(y14),
    .x2(y24),
    .x3(y34),
    .x4(y44),
    .x5(y54),
    .x6(y64),
    .x7(y74),
    .y0(dct04),
    .y1(dct14),
    .y2(dct24),
    .y3(dct34),
    .y4(dct44),
    .y5(dct54),
    .y6(dct64),
    .y7(dct74),
    .valid(valid_post4)
);

dct_1d Z5(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y05),
    .x1(y15),
    .x2(y25),
    .x3(y35),
    .x4(y45),
    .x5(y55),
    .x6(y65),
    .x7(y75),
    .y0(dct05),
    .y1(dct15),
    .y2(dct25),
    .y3(dct35),
    .y4(dct45),
    .y5(dct55),
    .y6(dct65),
    .y7(dct75),
    .valid(valid_post5)
);

dct_1d Z6(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y06),
    .x1(y16),
    .x2(y26),
    .x3(y36),
    .x4(y46),
    .x5(y56),
    .x6(y66),
    .x7(y76),
    .y0(dct06),
    .y1(dct16),
    .y2(dct26),
    .y3(dct36),
    .y4(dct46),
    .y5(dct56),
    .y6(dct66),
    .y7(dct76),
    .valid(valid_post6)
);

dct_1d Z7(
    .clk(clk),
    .rst_n(rst_n),
    .enable(valid_pre),
    .x0(y07),
    .x1(y17),
    .x2(y27),
    .x3(y37),
    .x4(y47),
    .x5(y57),
    .x6(y67),
    .x7(y77),
    .y0(dct07),
    .y1(dct17),
    .y2(dct27),
    .y3(dct37),
    .y4(dct47),
    .y5(dct57),
    .y6(dct67),
    .y7(dct77),
    .valid(valid_post7)
);

assign valid = valid_post0 && valid_post1 && valid_post2 && valid_post3 && valid_post4 && valid_post5 && valid_post6 && valid_post7;

endmodule