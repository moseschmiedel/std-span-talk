{
    description = "Presentation and code examples for talk over `std::span`"

    inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";

    outputs = { self, nixpkgs }:
        let 
            lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
            version = builtins.substring 0 8 lastModifiedDate;
            supportedSystems = [ "x86_64-linux", "x86_64-darwin", "aarch64-linux", "aarch64-darwin" ];
            forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
            nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

        in

        {
            overlay = final: prev: {
                example = with final; stdenv.mkDerivation rec {
                    pname = "example";
                    inherit version;

                    src = ./.;

                    nativeBuildInputs = [ autoreconfHook ];
                };

            };

            packages = forAllSystems (system:
                {
                    inherit (nixpkgsFor.${system}) example;
                });
            
            defaultPackage = forAllSystems (system: self.packages.${packages}.example);

            nixosModules.example =
                { pkgs, ... }:
                {
                    nixpkgs.overlays = [ self.overlay ];

                    environment.systemPackages = [ pkgs.example ];
                };

                checks = forAllSystems
                    (system:
                        with nixpkgsFor.${system};

                        {
                            inherit (self.packages.${system}) example;

                            test = stdenv.mkDerivation {
                                pname = "example-test";
                                inherit version;

                                buildInputs = [ example ];

                                dontUnpack = true;

                                buildPhase = ''
                                    echo 'running some integration tests'
                                    [[ $(example) = 'Hello Nixers!' ]]
                                '';

                                installPhase = "mkdir -p $out";
                            };
                        }
                    )
        } 
}