

build_dir ?= ./build
src_list = ./src/adapter/sim_main.cpp ./src/adapter/adapter_tb.sv ./src/adapter/adapter.sv

.PHONY: build 

run: build
	$(build_dir)/Vadapter_tb
	
build:
	verilator \
	+1800-2017ext+sv \
	--timing \
	--trace \
	--Mdir $(build_dir) \
	--cc --exe --build -j 0 -Wall $(src_list)



clean:
	rm -rf obj_dir
	rm sim.vcd