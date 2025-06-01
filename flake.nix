{
    description = "Presentation and code examples for talk over `std::span`";

    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
      flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }:
	flake-utils.lib.eachDefaultSystem (system: 
        let 
	    pname = "example";
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
	    	examples = stdenv.mkDerivation rec {
                    inherit pname version src depsBuildBuild buildInputs cmakeFlags cmakeBuildDir;
	        };

		default = examples;
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
