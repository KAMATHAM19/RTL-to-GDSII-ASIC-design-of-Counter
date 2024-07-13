# RTL-to-GDSII-ASIC-design-of-Counter
The objective is to take a simple counter design from the RTL (Register Transfer Level) stage to the GDSII format using Cadence tools with a 90nm Process Design Kit (PDK). The tools used in this process include Xcelium for simulation and coverage analysis, Genus for synthesis, Innovus for physical design, and Pegasus/PVS for physical verification.


## RTL and Simulation
Verilog code for the counter module
```
`timescale 1ns/1ns
module counter(clk,m,rst,count);
input clk,m,rst;
output reg[7:0]count;
always@(posedge clk or negedge rst)
 begin
  if(!rst)
  count=0;
   else if(m)
   count = count+1;
  else
   count = count-1;
 end
endmodule
```
Testbench code for the counter module
```
`timescale 1ns/1ns
module counter_test;
reg clk,rst,m;
wire[7:0]count;
initial
	begin
	 clk=0; rst=0; 
	 #5; rst=1;
	end
initial
	begin
	m=1;
	#160; m=0; //till #160ns - up_counter after it will be down_counter
	end

counter counter1(clk,m,rst,count);
always #5 clk = ~clk;

initial $monitor("Time=%t rst=%b clk=%b m=%b count=%b", $time,rst,clk,m,count);
//$monitor will display the simulation results on the screen
initial
	#320 $finish;
endmodule
```
To run simulations for the module, use the Xcelium tool with the following command:
```
irun/xrun module_name.v module_test_name.v -access +rwc -gui
```
```
irun counter.v counter_test.v -access +rwc -gui
```
<img width="719" alt="1" src="https://github.com/user-attachments/assets/ef3d1526-aa05-4fea-ab84-a693429f53d6">

The simulation output and waveform results were generated as shown below:
<img width="720" alt="2" src="https://github.com/user-attachments/assets/e5474b18-2c71-4666-9fdc-20c5585107b8">

<img width="721" alt="3" src="https://github.com/user-attachments/assets/7cc9ee32-f1d9-4163-aaa9-5df6e807ef7f">

<img width="722" alt="4-waveform" src="https://github.com/user-attachments/assets/28a0c6f0-7aaf-4b1a-8a55-d2a3f01306fc">

## Synthesis
The process of converting rtl code into gate-level netlist. It involves 3 stages - translation, mapping, and optimization.

Inputs - 1. verilog file (counter.v)
         2. constraints.sdc file
         3. library file (.lib)

Outputs - 1. Gate-level netlist
          2. Tool constraints file
          3. Reports - gates, power, timing, cells...

to run the script file invoke the genus synthesis tool by using the command:
```
genus
```
```
source run.tcl
```
```
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
```
<img width="712" alt="schematic" src="https://github.com/user-attachments/assets/b25e48e3-16a2-42b4-8847-1a9a5f90dcc8">

## Physical Design
Invoke the innovus tool using the command
```
innovus
```
Creating the Multi-Mode Multi-Corner (MMMC) scenarios for the timing analysis
<img width="719" alt="M-1" src="https://github.com/user-attachments/assets/5c4fbf6b-830c-4922-a6c3-74879034be83">

<img width="716" alt="M-2" src="https://github.com/user-attachments/assets/05ff68bf-8687-4102-89b6-877f58c1033d">

<img width="719" alt="m-3" src="https://github.com/user-attachments/assets/2b8b6cff-f28b-4a8b-9f68-497c94081e10">

<img width="716" alt="M-4" src="https://github.com/user-attachments/assets/e61ff040-5126-499f-a7a2-3338967a19c6">

<img width="366" alt="M-5" src="https://github.com/user-attachments/assets/fa4a8949-8640-4744-baf5-cd2a2a67abc2">

<img width="316" alt="M-6" src="https://github.com/user-attachments/assets/690dccc8-a788-4959-a58d-3f6d36fc82a2">

<img width="201" alt="M-7" src="https://github.com/user-attachments/assets/6ba15745-77b9-49c9-88ed-cae6e2759d28">

<img width="717" alt="1" src="https://github.com/user-attachments/assets/eecc18aa-829e-4ed6-95d2-cc4b262ffddd">

### floorplan

<img width="336" alt="FP-1" src="https://github.com/user-attachments/assets/97f31aa4-d8d1-492b-810e-9b5deaca8c39">

<img width="719" alt="fp-2" src="https://github.com/user-attachments/assets/63cefe79-5c75-46b8-9490-4dcbd6d02754">

### powerplan

<img width="451" alt="pp-1" src="https://github.com/user-attachments/assets/fe7af010-5ae5-4694-a918-ecac2f273eb1">

<img width="418" alt="pp-2" src="https://github.com/user-attachments/assets/9c4608f6-4c4a-4ebd-a50c-4bc1caba5b15">

<img width="717" alt="pp-3" src="https://github.com/user-attachments/assets/b5780c86-5487-4393-8cc5-b7c17f647d98">

<img width="422" alt="pp-4" src="https://github.com/user-attachments/assets/5f920630-7a4e-48b5-8105-b5195f9c70a5">

<img width="715" alt="pp-5" src="https://github.com/user-attachments/assets/de036fb0-94af-49c4-9eed-ccaa1caa75b4">

<img width="394" alt="pp-6" src="https://github.com/user-attachments/assets/f754b039-9d6e-4b40-ad07-e309746fac66">

<img width="713" alt="pp-7" src="https://github.com/user-attachments/assets/7c46883f-6487-44c0-9b68-5c8c36cffab6">

### placement

<img width="717" alt="place-1" src="https://github.com/user-attachments/assets/9125c516-9e2d-40fb-a2dc-eb0595723a79">

<img width="720" alt="place-2" src="https://github.com/user-attachments/assets/1894cc29-79d6-43d4-9abb-27a3b8e13cd9">

<img width="717" alt="place-4" src="https://github.com/user-attachments/assets/f9f77f4e-cf83-4d8c-8b42-afbffdb9b0ee">

### clock tree synthesis

```
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
```
<img width="716" alt="cts-1" src="https://github.com/user-attachments/assets/4f3acd81-806f-4982-a5cb-d5671c5e0603">

<img width="719" alt="cts-2" src="https://github.com/user-attachments/assets/ab34f0ae-62dc-46b2-ac54-ffe3e6e13502">

### routing

<img width="408" alt="route" src="https://github.com/user-attachments/assets/8f792211-08f4-4465-bd2f-96a192f7062a">

<img width="716" alt="route-1" src="https://github.com/user-attachments/assets/bd6d2f1b-da7c-41f6-9bab-e0714836a869">

<img width="719" alt="route-3" src="https://github.com/user-attachments/assets/3fb3fd8d-6e70-480e-9726-c6ed66e15873">

### rc extraction

### physical verification

