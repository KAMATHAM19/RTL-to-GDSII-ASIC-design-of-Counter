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


