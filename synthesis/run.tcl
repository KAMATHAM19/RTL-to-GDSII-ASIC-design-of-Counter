
set_db init_lib_search_path /cad/FOUNDRY/digital/90nm/dig/lib

#set_attribute lef_library /cad/FOUNDRY/digital/90nm/dig/lef/gsclib090_tech.lef

set_db library  slow.lib

read_hdl {./counter.v}

elaborate

read_sdc ./constraints_input.sdc


set_db syn_generic_effort medium
set_db syn_map_effort  medium
set_db syn_opt_effort  medium

syn_generic
syn_map
syn_opt

write_hdl > counter_netlist.vconsta
write_sdc  > counter_tool.sdc

gui_show

report timing > counter_timing.rpt
report power > counter_power.rpt
report area > counter_cell.rpt
report gates > counter_gates.rpt