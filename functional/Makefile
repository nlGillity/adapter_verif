

build_dir ?= ./build

pkg_src  = ./src/adapter/test_pkg.sv
dut_src  = ./src/adapter/adapter.sv
intf_src = ./src/adapter/interfaces/valid_ready_intf.sv ./src/adapter/interfaces/valid_credit_intf.sv 
tb_src   = ./src/adapter/adapter_tb.sv



src_list = ./src/adapter/sim_main.cpp $(pkg_src) $(intf_src) $(dut_src) $(tb_src)
.PHONY: build 

run: build
	$(build_dir)/Vadapter_tb
	
build:
	verilator \
	+1800-2017ext+sv \
	--timescale 1ns/1ps \
	--timing \
	--trace \
	--Mdir $(build_dir) \
	-I./src/adapter \
	--cc --exe --build -j 0 \
	-Wall -Wno-UNUSEDSIGNAL -Wno-UNUSEDPARAM \
	$(src_list) --top adapter_tb \



clean:
	rm -rf obj_dir
	rm sim.vcd