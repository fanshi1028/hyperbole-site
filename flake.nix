{
  nixConfig.extra-substituters = [
    "https://fanshi1028-personal.cachix.org"
  ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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
            overrides = hself: hsuper: {
              hyperbole = hself.callHackageDirect {
                pkg = "hyperbole";
                ver = "0.6.0";
                sha256 = "sha256-9kJhNbqN20SYfqdRoeDzdus8DXxka5Gqu5oWyhUgmHY=";
              } { };
              atomic-css = hself.callHackageDirect {
                pkg = "atomic-css";
                ver = "0.2.0";
                sha256 = "sha256-16vwXrrWJm2zIKUDbhjpYOJA/vK9zXM6Qm1rd/x0PYg=";
              } { };
              skeletest = hself.callHackageDirect {
                pkg = "skeletest";
                ver = "0.3.2";
                sha256 = "sha256-B8hFzph73qdHAMm0AJmP0XNjehc1kZYRCe19hPRbHy4=";
              } { };

              effectful = hself.callHackageDirect {
                pkg = "effectful";
                ver = "2.6.1.0";
                sha256 = "sha256-krNjGxqdbmFpt1g3anTd5ajGtYnyvGaG+AiDLfJN8No=";
              } { };

              effectful-core = hself.callHackageDirect {
                pkg = "effectful-core";
                ver = "2.6.1.0";
                sha256 = "sha256-0UTeE7JnUkNx77QobyjKjQFpUVQsz6a1E55WEohJ+hI=";
              } { };

              Diff = hself.callHackageDirect {
                pkg = "Diff";
                ver = "1.0.2";
                sha256 = "sha256-fRxDSt8/CSGyUrmGNwF22ASjEzIRGifNk3M9j9HrC2g=";
              } { };
            };
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
