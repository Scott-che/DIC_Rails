module rails(clk, reset, data, valid, result);

input        clk;
input        reset;
input  [3:0] data;
output  reg    valid;
output  reg     result;
reg [3:0] count;
reg [3:0] high_bit; 
reg [9:0] station;
reg [9:0] mask;
reg [9:0] onehot;
reg [9:0] pop;
reg o;
always @(posedge clk) begin
	if (reset)begin
		count <= 4'b0;
		pop <= 10'b0;
		o <= 1'b1;
		high_bit <= 4'b0;
		station <= 10'b0;
		valid <= 1'b0;
		result <= 1'b0;
	end
	else if (count == 0)begin
		high_bit <= data;
		count <= count + 4'b0001;
	end
	else if ((count == 1) && (count < high_bit))begin
		station <= (mask ^ onehot) ^ pop ;
		pop <= onehot | pop;
		count <= count + 4'b0001;
	end
	else if ((count >= 2) && (count < high_bit) && (station >= onehot) && ((station^onehot)< onehot) && (o == 1))begin
		station <= station ^ onehot;
		pop <= onehot | pop;
		o <= 1;
		count <= count + 4'b0001;
	end
	else if ((count >= 2) && (count < high_bit) && (station < onehot) && (o == 1))begin
		station <= (mask ^ onehot) ^ pop ;
		pop <= onehot | pop;
		o <= 1;
		count <= count + 4'b0001;
	end
	else if ((count >= 2) && (count < high_bit) && (station >= onehot) && ((station^onehot)> onehot) && (o == 1))begin
		o <= 0;
		count <= count + 4'b0001;
	end
	else if ((o == 0) && (count < high_bit))begin
		count <= count + 4'b0001;
	end
	else if ((o == 0) && (count == high_bit) && (valid == 0))begin
		valid <= 1'b1;
		result <= 1'b0;
	end
	else if ((o == 1) && (count == high_bit) && (valid == 0))begin
		valid <= 1'b1;
		result <= 1'b1;
	end
	else if (valid == 1)begin
		valid <= 1'b0;
		result <= 1'b0;
		count <= 4'b0;
		pop <= 10'b0;
		o <= 1'b1;
	end
end
always @(data) begin
	case (data)
		4'b0001: mask = 10'b0000000001;
		4'b0010: mask = 10'b0000000011;
		4'b0011: mask = 10'b0000000111;
		4'b0100: mask = 10'b0000001111;
		4'b0101: mask = 10'b0000011111;
		4'b0110: mask = 10'b0000111111;
		4'b0111: mask = 10'b0001111111;
		4'b1000: mask = 10'b0011111111;
		4'b1001: mask = 10'b0111111111;
		default: mask = 10'b1111111111;
	endcase
end
always @(data) begin
	case (data)
		4'b0001: onehot = 10'b0000000001;
		4'b0010: onehot = 10'b0000000010;
		4'b0011: onehot = 10'b0000000100;
		4'b0100: onehot = 10'b0000001000;
		4'b0101: onehot = 10'b0000010000;
		4'b0110: onehot = 10'b0000100000;
		4'b0111: onehot = 10'b0001000000;
		4'b1000: onehot = 10'b0010000000;
		4'b1001: onehot = 10'b0100000000;
		default: onehot = 10'b1000000000;
	endcase
end

endmodule
