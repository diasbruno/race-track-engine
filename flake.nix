{
  description = "race-track-engine – a toy C/GLFW racing engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { };
        };

        buildInputs = with pkgs; [
          glfw
        ];

        nativeBuildInputs = with pkgs; [
          cmake
          pkg-config
        ];
      in
      {
        # Build the engine as a Nix package.
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "race-track-engine";
          version = "0.1.0";
          src = ./.;

          inherit nativeBuildInputs buildInputs;

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
          ];
        };

        # Development shell: `nix develop`
        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;

          packages = with pkgs; [
            # Helpful during development
            clang-tools   # clangd, clang-format
            gdb
          ];

          shellHook = ''
            echo "race-track-engine dev shell ready."
            echo "  cmake -B build && cmake --build build"
          '';
        };
      });
}
