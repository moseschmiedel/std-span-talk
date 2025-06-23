{
  description = "Presentation and code examples for talk over `std::span`";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pname = "std-span-examples";
        lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
        version = builtins.substring 0 8 lastModifiedDate;
        src = ./examples;

        pkgs = nixpkgs.legacyPackages.${system};
        depsBuildBuild = with pkgs; [
          clang
          ninja
          cmake
        ];
        buildInputs = with pkgs; [ ];

        cmakeFlags = [ "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" ];
        cmakeBuildDir = "build";

        inherit (pkgs) stdenv;
      in
      {
        apps = {
          construction = {
            type = "app";
            program = "${self.packages.${system}.std-span-examples}/bin/std-span-construction";
            meta.description = "C++23 example showcasing several ways to construct a std::span.";
          };

          dangling-span = {
            type = "app";
            program = "${self.packages.${system}.std-span-examples}/bin/std-span-dangling-span";
            meta.description = "C++23 example showcasing the danger of a dangling std::span.";
          };

          my-container = {
            type = "app";
            program = "${self.packages.${system}.std-span-examples}/bin/std-span-my-container";
            meta.description = "C++23 example showcasing how to implement conversion from custom container type (`MyContainer`) to std::span.";
          };

          mdspan = {
            type = "app";
            program = "${self.packages.${system}.std-span-examples}/bin/std-span-mdspan";
            meta.description = "C++23 example showcasing a simple std::mdspan instantiation and member access.";
          };

          parallel = {
            type = "app";
            program = "${self.packages.${system}.std-span-examples}/bin/std-span-parallel";
            meta.description = "C++23 example showcasing the performance of std::span in parallel computations in contrast to std::vector.";
          };
        };

        packages = rec {
          std-span-examples = stdenv.mkDerivation rec {
            inherit
              pname
              version
              src
              depsBuildBuild
              buildInputs
              cmakeFlags
              cmakeBuildDir
              ;
          };

          default = std-span-examples;
        };

        devShells.default = pkgs.mkShell {
          inherit
            pname
            version
            src
            depsBuildBuild
            buildInputs
            cmakeBuildDir
            cmakeFlags
            ;

          name = "${pname}-${version}-shell";

          shellHook = ''
            		    rm -rf ${cmakeBuildDir}
            		    mkdir -p ${cmakeBuildDir}
            		    cmake -B ${cmakeBuildDir} -S ${src} -G Ninja ${builtins.concatStringsSep " " cmakeFlags}
            		'';
        };
      }
    );
}
