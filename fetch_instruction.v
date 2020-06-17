`define NAND   4'b0000
`define ADD  4'b0001
`define ADDF  4'b0010
`define ADDi 4'b0011
`define LT   4'b0100
`define LTF  4'b0101
`define SRL   4'b0110
`define SRLi   4'b0111
`define MUL    4'b1000
`define MULF   4'b1001

`define CP   4'b1010
`define CPi  4'b1011
`define CPI   4'b1100
`define CPIr  4'b1101

`define BZ   4'b1110
`define JMP  4'b1111



`define ADDR_WIDTH 10

`define normal_operation 0
`define interrupt_stage_1 1
`define interrupt_stage_2 2





module fetch_instruction(

	input wire clk,
	input wire rst,
	
	output reg [`ADDR_WIDTH-1:0] program_counter_for_instruction_read,
	output reg [`ADDR_WIDTH-1:0] program_counter_for_stages,

	output reg instruction_valid_out_from_FI_to_FOA,

	input wire flush,
	input wire [`ADDR_WIDTH-1:0] flush_pc,


	input wire stall




	);

	reg [`ADDR_WIDTH-1:0] keep_program_counter_for_stages_next;
	reg [`ADDR_WIDTH-1:0] keep_program_counter_for_stages_current;


	reg [`ADDR_WIDTH-1:0] pc_current,pc_next;



	always@(posedge clk)begin
		if(rst)begin
			pc_current <= 0;
			instruction_valid_out_from_FI_to_FOA <= 0;
		end else begin
			pc_current <= pc_next;
			if(flush)begin
				instruction_valid_out_from_FI_to_FOA <= 0;
			end else if(stall)begin
				instruction_valid_out_from_FI_to_FOA <= 0;
			end else begin
				instruction_valid_out_from_FI_to_FOA <= 1;
				keep_program_counter_for_stages_current <= keep_program_counter_for_stages_next;
			end
			
		end
	end
	
	always@(*)begin
		pc_next = pc_current;
		keep_program_counter_for_stages_next = keep_program_counter_for_stages_current;

		if(flush)begin
			pc_next = flush_pc;
		end else if(stall)begin
			pc_next = pc_current;
		end else begin
			pc_next = pc_current + 1;
		end
	end
	
	
	always@(*)begin
			program_counter_for_instruction_read = pc_current;
			program_counter_for_stages = pc_current;	
	end
	


endmodule






