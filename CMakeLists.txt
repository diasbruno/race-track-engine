cmake_minimum_required(VERSION 3.20)
project(race-track-engine C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# ── Sources ──────────────────────────────────────────────────────────────────
add_executable(race-track-engine
    src/main.c
)

# ── Dependencies ─────────────────────────────────────────────────────────────
find_package(glfw3 REQUIRED)
target_link_libraries(race-track-engine PRIVATE glfw)

# macOS needs the system OpenGL / Cocoa frameworks.
if(APPLE)
    target_link_libraries(race-track-engine PRIVATE
        "-framework Cocoa"
        "-framework OpenGL"
        "-framework IOKit"
        "-framework CoreFoundation"
        "-framework CoreVideo"
        "-framework QuartzCore"
    )
endif()

# ── Compiler warnings ─────────────────────────────────────────────────────────
target_compile_options(race-track-engine PRIVATE
    -Wall -Wextra -Wpedantic
)

# ── Install ───────────────────────────────────────────────────────────────────
install(TARGETS race-track-engine RUNTIME DESTINATION bin)
