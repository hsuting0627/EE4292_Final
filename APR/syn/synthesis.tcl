set_host_options -max_cores 16
# Set your TOPLEVEL here
set TOPLEVEL "top"

# Change your timing constraint here
set TEST_CYCLE 3.2

source -echo -verbose 0_readfile.tcl 
source -echo -verbose 1_setting.tcl 
source -echo -verbose 2_compile.tcl 
source -echo -verbose 3_report.tcl 

exit
