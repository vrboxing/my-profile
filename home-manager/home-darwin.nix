{ config, lib, pkgs, ... }:
let

  overlays = [ (import ../nixos-flk/overlays/pkgs.nix)
             ];


  nixpkgs = (import ~/.config/nixpkgs/nixos/channel/nixpkgs) { inherit overlays;};

  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/4b6aab017cdf96a90641dc287437685675d598da") {};
  my-pkgs = pkgs.fetchFromGitHub {
    owner = "hardenedlinux";
    repo = "NSM-data-analysis";
    rev = "1bc6bc22c63c034d272150a26d74b149cc677ab8";
    sha256 = "18yrwg6xyhwmf02l6j7rcmqyckfqg0xy3nx4lcf6lbhc16mfncnf";
  };

  juliaEnv = (import "${my-pkgs}/pkgs/julia-non-cuda.nix" {});
  customVscode = (import ../nixos-flk/profiles/code/vscode.nix { pkgs=nixpkgs; });

  R-with-my-packages = nixpkgs.rWrapper.override{
    packages = with nixpkgs.rPackages; [ ggplot2 dplyr xts ]; };
in

{
  config = with lib; mkMerge [
    (mkIf pkgs.stdenv.isDarwin {
      home.packages = with nixpkgs;[
        customVscode
        govet
        #R-with-my-packages
        (python3.withPackages (pkgs: with pkgs; [
          shapely
          matplotlib
          sqlalchemy
          pandas
          numpy
          scikitlearn
          jupyter
          # (pylint.overridePythonAttrs (oldAttrs: {
          #     src = fetchPypi {
          #       pname = "pylint";
          #       version = "2.5.2";
          #       sha256 = "1344f6zrv3airdls19pbqs7vrb2ky0r09m1y53167w9s1y2k2pmr";
          #     };
          # }))
        ]))
        #vips
        ##cachix use ghcide-nix
        (import ../nixos/channel/ghcide-nix {}).ghcide-ghc883
        bat
        gron
        (all-hies.unstable.selection { selector = p: { inherit (p) ghc865; }; })
        exa
        pet
        juliaEnv
        (texlive.combine # latex + packages
          { inherit (texlive)
            collection-plaingeneric
            collection-latexextra
            collection-fontsrecommended
            collection-pictures
            collection-bibtexextra
            collection-mathscience
            collection-langgerman
            scheme-basic
            xetex
            cjk
            ctex
            xecjk
            fontspec
            euenc;
          }
          #org-mode roam-server
        )
      ];
    })
  ];

}
