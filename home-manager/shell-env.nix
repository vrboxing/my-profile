{ config, lib, pkgs, ... }:
let
  rev = (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.nixpkgs-hardenedlinux.locked.rev;
  nixpkgs-hardenedlinux = builtins.fetchTarball {
    url = "https://github.com/hardenedlinux/nixpkgs-hardenedlinux/archive/${rev}.tar.gz";
    sha256 = (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.nixpkgs-hardenedlinux.locked.narHash;
  };

  voila = pkgs.writeScriptBin "voila" ''
    nix-shell ${nixpkgs-hardenedlinux}/pkgs/python/env/voila --command "voila $1"
    '';

  timesketch = pkgs.writeScriptBin "timesketch" ''
    nix-shell ${nixpkgs-hardenedlinux}/pkgs/python/env/timesketch/shell.nix --command "tsctl $1"
      '';
in
{
  config = with lib; mkMerge [
    ##public pkgs
    (mkIf pkgs.stdenv.isLinux {
      home.packages = with pkgs;[
        voila
        timesketch
      ];
    })
  ];

}
