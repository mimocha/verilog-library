/* Verilog HDL Wind-Up Clock Module

	Filters clock signal, outputs the specified number of clock pulses.
	Analogous to a wind-up clock,

	Repo: https://github.com/mimocha/verilog-library
	Copyright (c) 2018 Chawit Leosrisook
*/

`timescale 1 ns / 1 ns

module windup_clock

//=========================================================================
//  Parameters Definition
//=========================================================================
#(
	// Internal counter bit count
	parameter BIT = 16
)

//=========================================================================
//  Ports, Wires & Variables Definition
//=========================================================================
(
	input wire			clk_in,
	input wire			rst,
	input wire			wr_en,
	input wire	[BIT-1 : 0]	wind,
	output wire			clk_out
);

//=========================================================================
//  Structural Coding
//=========================================================================

reg [BIT-1 : 0] counter;

// While any counter bit is set, let CLK signal through.
assign clk_out = clk_in & |counter & ~wr_en;

// Reset
always @ (posedge rst) begin : reset
	counter <= 0;
end

// Wind Up Counter
always @ (posedge wr_en) begin : winding
	counter <= wind;
end

// Countdown to 0, and stops
always @ (posedge clk_in) begin : countdown
	if (wr_en == 1'b0 && counter > 1'b0) begin
		counter = counter - 1'b1;
	end
end


endmodule
