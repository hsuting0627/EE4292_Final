# Before synthesis settings
set case_analysis_with_logic_constants true
set_fix_multiple_port_nets -feedthroughs -outputs -constants -buffer_constants

# Check design
check_design > ./$RPT_DIR/check_design.log
check_timing > ./$RPT_DIR/check_timing.log

set_clock_gating_style -max_fanout 10

# compile_enable_register_merging false
# Synthesis all design (using : compile_ultra)
compile_ultra -gate_clock -exact_map -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
compile_ultra -incremental -exact_map -no_autoungroup -no_seq_output_inversion -no_boundary_optimization

# Remove dummy ports
remove_unconnected_ports [get_cells -hierarchical *]
remove_unconnected_ports [get_cells -hierarchical *] -blast_buses
