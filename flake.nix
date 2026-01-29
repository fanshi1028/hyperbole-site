{
  nixConfig.extra-substituters = [
    "https://fanshi1028-personal.cachix.org"
  ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      ghcVersion = "9122";
    in
    {
      packages = builtins.mapAttrs (system: pkgs: { }) nixpkgs.legacyPackages;

      devShells = builtins.mapAttrs (
        system: pkgs:
        let
          hsPkgs = pkgs.haskell.packages."ghc${ghcVersion}";
        in
        {
          default = hsPkgs.developPackage {
            root = ./.;
            modifier =
              drv:
              pkgs.lib.pipe drv (
                with pkgs.haskell.lib.compose;
                [
                  (addBuildTools (
                    with pkgs;
                    [
                      cabal-install
                      tailwindcss
                      ghciwatch
                      # NOTE: tailwindcss_4 when trying to run
                      # dyld: Symbol not found: _ubrk_clone
                      #   Referenced from: /nix/store/2dxgd64421azhmwp63h9h3hzczgvh9w7-tailwindcss_4-4.1.7/bin/.tailwindcss-wrapped (which was built for Mac OS X 13.0)
                      #   Expected in: /usr/lib/libicucore.A.dylib
                      (haskell-language-server.override {
                        supportedGhcVersions = [ ghcVersion ];
                        supportedFormatters = [ "ormolu" ];
                      })
                      emacs-lsp-booster

                      hsPkgs.cabal-gild_1_6_0_0
                      hsPkgs.ormolu_0_8_0_0
                    ]
                  ))
                ]
              );
            returnShellEnv = true;
          };
        }
      ) nixpkgs.legacyPackages;
    };
}
