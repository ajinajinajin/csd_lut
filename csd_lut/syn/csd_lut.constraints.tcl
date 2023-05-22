################################################################################
# Filename: csd_lut.constraints.tcl
# Author: ZHU Jingyang
# Email: jzhuak@connect.ust.hk
# Affiliation: Hong Kong University of Science and Technology
# -------------------------------------------------------------------------------
# This is the template constraint script for ELEC5160/EESM5020.
################################################################################

################################################################################
# Timing constraint
################################################################################
# Critical path constraint: set the desired clock frequency
create_clock -period 5.0 -name VCLK
# Input delay and output delay
set_input_delay -max 2.7 -clock VCLK\
   [get_ports A]
set_output_delay -max 1.2 -clock VCLK\
set_input_delay -min 2.3 -clock VCLK\
   [get_ports B]
set_output_delay -min 0.8 -clock clk\
################################################################################
# Enviornement attribute constraint
################################################################################
# Load on the output ports
set_load 1 [all_outputs]

# Input transition time on all inputs except clock
set_input_transition 0.1 \
  [remove_from_collection [all_inputs] [get_ports clk]]
