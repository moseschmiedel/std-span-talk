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
	    pkgs = nixpkgs.legacyPackages.${system};
	    inherit (pkgs) stdenv;
        in
	{
            packages = rec {
	    	examples = stdenv.mkDerivation rec {
                    inherit pname version;

                    src = ./examples; 

		    depsBuildBuild = with pkgs; [ clang ninja cmake ];

		    cmakeBuildDir = "build";
	        };

		default = examples;
	    };
        });
}
