CC = clang
CFLAGS = -Wall -Wextra -std=c11 -Wno-deprecated-declarations -Isrc
CFLAGS+= $(shell pkg-config --cflags glfw3)
LDFLAGS = -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo
LDFLAGS+= $(shell pkg-config --libs glfw3)

SRC = src/main.c src/shader.c
OUT = build/app

all: $(OUT)

$(OUT): $(SRC)
	mkdir -p build
	$(CC) $(CFLAGS) $(SRC) -o $(OUT) $(LDFLAGS)

run: all
	./$(OUT)

clean:
	rm -rf build

compile_commands.json:
	mkdir -p build
	echo '[' > compile_commands.json
	echo '  {' >> compile_commands.json
	echo '    "directory": "'$(PWD)'",' >> compile_commands.json
	echo '    "command": "'$(CC) $(CFLAGS) $(SRC) -Iinclude'",' >> compile_commands.json
	echo '    "file": "'$(SRC)'"' >> compile_commands.json
	echo '  }' >> compile_commands.json
	echo ']' >> compile_commands.json
