module random_num_generator(q,clk,rst);
input clk;
input rst;
output[15:0]q;
reg [15:0]q;
always@(posedge rst or posedge clk )begin
    if(rst)begin
        q[15:0]<=16'b1111_1111_1111_1111;
    end
    else begin
        q[0]<=q[3]^q[12]^q[14]^q[15];
        q[1]<=q[0];
        q[2]<=q[1];
        q[3]<=q[2];
        q[4]<=q[3];
        q[5]<=q[4];
        q[6]<=q[5];
        q[7]<=q[6];
        q[8]<=q[7];
        q[9]<=q[8];
        q[10]<=q[9];
        q[11]<=q[10];
        q[12]<=q[11];
        q[13]<=q[12];
        q[14]<=q[13];
        q[15]<=q[14];
    end
end

endmodule
