{
  description = "Guangtao's home-manager profile";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/0cdf13328905da1d35c9395ad1de89424c511943";
    master.url = "nixpkgs/703f052de185c3dd1218165e62b105a68e05e15f";

    nixpkgs-hardenedlinux.url = "github:hardenedlinux/nixpkgs-hardenedlinux/master";
    emacs-overlay.url = "github:nix-community/emacs-overlay/1b1fc523f4286a28193f70bfdbf6c2098e3e8967";

  };

  #outputs = inputs@{ self, nixpkgs, nixpkgs-hardenedlinux, master, flake-utils, emacs-overlay }:
  outputs = inputs: with builtins;let
      python-packages-overlay = (import "${inputs.nixpkgs-hardenedlinux}/nix/python-packages-overlay.nix");
      packages-overlay = (import "${inputs.nixpkgs-hardenedlinux}/nix/packages-overlay.nix");
      in
    (inputs.flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                python-packages-overlay
                packages-overlay
          ];
        };
          in
          {

            devShell = import ./shell.nix { inherit pkgs; pkgsChannel = inputs.nixpkgs;};

          }
        )
    );
  }
