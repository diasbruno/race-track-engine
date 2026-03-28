#define GL_SILENCE_DEPRECATION
#include <OpenGL/gl3.h>
#include <stdio.h>
#include <stdlib.h>

static char* read_file(const char* path) {
    FILE* file = fopen(path, "rb");
    if (!file) return NULL;

    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    rewind(file);

    char* buffer = malloc(size + 1);
    fread(buffer, 1, size, file);
    buffer[size] = '\0';

    fclose(file);
    return buffer;
}

static unsigned int compile_shader(unsigned int type, const char* source) {
    unsigned int shader = glCreateShader(type);
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);

    int success;
    char log[512];
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

    if (!success) {
        glGetShaderInfoLog(shader, 512, NULL, log);
        fprintf(stderr, "Shader compile error:\n%s\n", log);
    }

    return shader;
}

unsigned int create_shader_program(const char* vertex_path, const char* fragment_path) {
    char* vertex_src = read_file(vertex_path);
    char* fragment_src = read_file(fragment_path);

    unsigned int vs = compile_shader(GL_VERTEX_SHADER, vertex_src);
    unsigned int fs = compile_shader(GL_FRAGMENT_SHADER, fragment_src);

    unsigned int program = glCreateProgram();
    glAttachShader(program, vs);
    glAttachShader(program, fs);
    glLinkProgram(program);

    glDeleteShader(vs);
    glDeleteShader(fs);

    free(vertex_src);
    free(fragment_src);

    return program;
}
