set TOP_DIR $TOPLEVEL
set RPT_DIR report
set NET_DIR netlist

sh rm -rf ./$TOP_DIR
sh rm -rf ./$RPT_DIR
sh rm -rf ./$NET_DIR
sh mkdir ./$TOP_DIR
sh mkdir ./$RPT_DIR
sh mkdir ./$NET_DIR

# Define a lib path
define_design_lib $TOPLEVEL -path ./$TOPLEVEL

# Add your hdl files here
analyze -library $TOPLEVEL -format verilog "../hdl/top.v
../hdl/controller.v
../hdl/dct_1d_8to10.v
../hdl/dct_1d.v
../hdl/dct_2d.v
../hdl/rgb2ycbcr.v
../hdl/rgb2ycbcr_2d.v
../hdl/quantizer.v"

# Elaborate your design
elaborate $TOPLEVEL -architecture verilog -library $TOPLEVEL

# Solve multiple instance
set uniquify_naming_style "%s_mydesign_%d"
uniquify

# Link the design
current_design $TOPLEVEL
link
