module rgb2ycbcr
(
    input clk,
    input rst_n,
    // input enable,

    input [7:0] R,
    input [7:0] G,
    input [7:0] B,
    output reg [7:0] Y,
    output reg [7:0] Cb,
    output reg [7:0] Cr
    // output valid
);
reg [7:0] R_ff, G_ff, B_ff;
reg [7:0] Y_ff, Cb_ff, Cr_ff;
// STEP1

reg [15:0] r0, r1, r2;
reg [15:0] g0, g1, g2;
reg [15:0] b0, b1, b2;

reg [15:0] r0_next, r1_next, r2_next;
reg [15:0] g0_next, g1_next, g2_next;
reg [15:0] b0_next, b1_next, b2_next;

always @(posedge clk) begin
    if(!rst_n) begin
        r0 <= 0;
        r1 <= 0;
        r2 <= 0;
        g0 <= 0;
        g1 <= 0;
        g2 <= 0;
        b0 <= 0;
        b1 <= 0;
        b2 <= 0;
    end
    else begin
        r0 <= r0_next;
        r1 <= r1_next;
        r2 <= r2_next;
        g0 <= g0_next;
        g1 <= g1_next;
        g2 <= g2_next;
        b0 <= b0_next;
        b1 <= b1_next;
        b2 <= b2_next;
    end
end
always @(posedge clk) begin
    if(!rst_n) begin
        R_ff <= 0;
        G_ff <= 0;
        B_ff <= 0;
    end
    else begin
        R_ff <= R;
        G_ff <= G;
        B_ff <= B;
    end
end
always @* begin
    r0_next = R_ff * 8'd66;
    r1_next = R_ff * 8'd38;
    r2_next = R_ff * 8'd112;
    g0_next = G_ff * 8'd129;
    g1_next = G_ff * 8'd74;
    g2_next = G_ff * 8'd94;
    b0_next = B_ff * 8'd25;
    b1_next = B_ff * 8'd112;
    b2_next = B_ff * 8'd18;
end

reg [15:0] Y0, Y0_next;
reg [15:0] Cb0, Cb0_next;
reg [15:0] Cr0, Cr0_next;

always @(posedge clk) begin
    if(!rst_n) begin
        Y0 <= 0;
        Cb0 <= 0;
        Cr0 <= 0;
    end
    else begin
        Y0 <= Y0_next;
        Cb0 <= Cb0_next;
        Cr0 <= Cr0_next;
    end
end

always@* begin
    Y0_next = r0 + g0 + b0 + 16'd4096;
    Cb0_next = b1 - r1 - g1 + 16'd32768;
    Cr0_next = r2 - g2 - b2 + 16'd32768;
end

reg [7:0] Y1, Cb1, Cr1;
always @(posedge clk) begin
    if(!rst_n) begin
        Y <= 0;
        Cb <= 0;
        Cr <= 0;
    end
    else begin
        Y <= Y_ff;
        Cb <= Cb_ff;
        Cr <= Cr_ff;
    end
end

always @* begin
    Y_ff = Y0[15:8] + Y0[7];
    Cb_ff = Cb0[15:8] + Cb0[7];
    Cr_ff = Cr0[15:8] + Cr0[7];
end

// reg [3:0] pipeline;
// always @ (posedge clk) begin
//     if(!rst_n) begin
//         pipeline <= 4'd0;
//     end
//     else begin
//         pipeline <= {pipeline[2:0], enable};
//     end
// end
// assign valid = pipeline[3];

endmodule 