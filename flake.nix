{
    description = "Presentation and code examples for talk over `std::span`";

    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
      flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }:
	flake-utils.lib.eachDefaultSystem (system: 
        let 
	    pname = "std-span-examples";
            lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
            version = builtins.substring 0 8 lastModifiedDate;
	    src = ./examples;

	    pkgs = nixpkgs.legacyPackages.${system};
	    depsBuildBuild = with pkgs; [ clang ninja cmake ];
	    buildInputs = with pkgs; [ ];

	    cmakeFlags = [ "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" ];
	    cmakeBuildDir = "build";

	    inherit (pkgs) stdenv;
        in
	{
            packages = rec {
	    	std-span-construction = stdenv.mkDerivation rec {
                    inherit pname version src depsBuildBuild buildInputs cmakeFlags cmakeBuildDir;
	        };
	    	std-span-dangling-span = stdenv.mkDerivation rec {
                    inherit pname version src depsBuildBuild buildInputs cmakeFlags cmakeBuildDir;
	        };
	    	std-span-my-container = stdenv.mkDerivation rec {
                    inherit pname version src depsBuildBuild buildInputs cmakeFlags cmakeBuildDir;
	        };
	    	std-span-mdspan = stdenv.mkDerivation rec {
                    inherit pname version src depsBuildBuild buildInputs cmakeFlags cmakeBuildDir;
	        };

		default = std-span-construction;
	    };

	    devShells.default = pkgs.mkShell {
	        inherit pname version src depsBuildBuild buildInputs cmakeBuildDir cmakeFlags;

		name = "${pname}-${version}-shell";

		shellHook = ''
		    rm -rf ${cmakeBuildDir}
		    mkdir -p ${cmakeBuildDir}
		    cmake -B ${cmakeBuildDir} -S ${src} -G Ninja ${builtins.concatStringsSep " " cmakeFlags}
		'';
	    };
        });
}
