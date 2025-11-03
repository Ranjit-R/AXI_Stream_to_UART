module uart_tx #(
    parameter CLK_FREQ = 50_000_000,   // 50 MHz
    parameter BAUD_RATE = 115200
)(
    input  logic clk,
    input  logic rst_n,
    input  logic tx_start,
    input  logic [7:0] tx_data,
    output logic tx,
    output logic tx_done
);

    localparam integer BAUD_CNT_MAX = CLK_FREQ / BAUD_RATE;

    logic [15:0] baud_cnt;
    logic baud_tick;
    logic [3:0] bit_index;
    logic [9:0] tx_shift;
    logic tx_busy;

    // Baud rate generator
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            baud_cnt <= 0;
        else if (tx_busy && baud_cnt == BAUD_CNT_MAX - 1)
            baud_cnt <= 0;
        else if (tx_busy)
            baud_cnt <= baud_cnt + 1;
    end

    assign baud_tick = (baud_cnt == BAUD_CNT_MAX - 1);

    // TX logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx <= 1'b1;
            tx_busy <= 0;
            tx_done <= 0;
            bit_index <= 0;
        end else begin
            tx_done <= 0;
            if (tx_start && !tx_busy) begin
                // Start + Data + Stop bits
                tx_shift <= {1'b1, tx_data, 1'b0};
                tx_busy <= 1;
                bit_index <= 0;
            end else if (baud_tick && tx_busy) begin
                tx <= tx_shift[bit_index];
                bit_index <= bit_index + 1;
                if (bit_index == 9) begin
                    tx_busy <= 0;
                    tx_done <= 1;
                end
            end
        end
    end

endmodule

