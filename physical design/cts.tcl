#90nm technology
#clock tree constraints used for building and balancing the clock tree in cts stage

##creating_NDR rules:
add_ndr -width {Metal1 0.24 Metal2 0.28 Metal3 0.28 Metal4 0.28 Metal5 0.28 Metal6 0.28 Metal7 0.28 Metal8 0.88 Metal9 0.88} -spacing {Metal1 0.24 Metal2 0.28 Metal3 0.28 Metal4 0.28 Metal5 0.28 Metal6 0.28 Metal7 0.28 Metal8 0.88 Metal9 0.88} -name 2w2s

#create a route type to define the NDR & layers to use for routing the clock tree:
create_route_type -name clkroute -non_default_rule 2w2s -bottom_preferred_layer Metal5 -top_preferred_layer Metal6

##specify this route type should be used for trunk and leaf nets:
set_ccopt_property route_type clkroute -net_type trunk
set_ccopt_property route_type clkroute -net_type leaf

##specify the clock buffer, clock inverter & clock gating cells to use
set_ccopt_property buffer_cells {CLKBUFX6 CLKBUFX8 CLKBUFX12}
set_ccopt_property inverter_cells {CLKINVX6 CLKINVX8 CLKINVX12}
set_ccopt_property clock_gating_cells TLATNTSCA*

##generate the ccopt spec file & source it
create_ccopt_clock_tree_spec -file ccopt.spec
source ccopt.spec

#run ccopt-cts
ccopt_design -cts

##generate reports for clock tree and skew groups
report_ccopt_clock_trees -file clk_trees.rpt
report_ccopt_skew_groups -file skew_groups.rpt

#save the design
saveDesign DBS/cts.enc