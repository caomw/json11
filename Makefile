all: test

test: build/CMakeFiles
	cmake --build build --target tests
	bin/tests

build/CMakeFiles:
	mkdir -p build
	cd build && cmake ..

