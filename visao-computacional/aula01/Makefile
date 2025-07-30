.DEFAULT_GOAL := build

build:
	g++ -std=gnu++14 $(p).cpp -o $(p) -fmax-errors=2 `pkg-config opencv4 --libs --cflags` -O3 -s
	./$(p)
