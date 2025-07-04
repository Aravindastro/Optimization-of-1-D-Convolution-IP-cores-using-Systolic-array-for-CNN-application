
# Optional: Limit frequency of clk if your design is not timing-critical
create_clock -name clk -period 10.000 [get_ports clk]
