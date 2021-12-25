module select(
				input  logic in0, in1,
				output logic out);
	always_comb begin
		if (in0 == 1'b1 || in1 == 1'b1)
			out = 1'b1;
		else
			out = 1'b0;
	end
endmodule

