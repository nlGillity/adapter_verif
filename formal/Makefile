main:
	-sby -f -d ./build/main/ tests/main/adapter.sby

h0:
	-sby -f -E -d ./build/h0/ tests/h0/adapter.sby

h1:
	-sby -f -d ./build/h1/ tests/h1/adapter.sby

h2:
	-sby -f -d ./build/h2/ tests/h2/adapter.sby

h3:
	-sby -f -d ./build/h3/ tests/h3/adapter.sby

h4:
	-sby -f -d ./build/h4/ tests/h4/adapter.sby

h5:
	-sby -f -d ./build/h5/ tests/h5/adapter.sby

run: $(TARGET)

run_all: main h0 h1 h2 h3 h4 h5

run_robot: run_all
	robot -d build formal.robot