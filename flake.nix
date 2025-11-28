{
  description = "A flake for Ronema and its module.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }: let
    version = self.rev or "git";
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {pkgs, ...}: {
        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              networkmanager
              libnotify
              networkmanagerapplet
              qrencode
            ];
          };
        };

        packages = rec {
          default = ronema;

          ronema = pkgs.callPackage ./nix {
            version = version;
            src = ./.;
          };
        };
      };

      flake = {
        homeManagerModules = rec {
          default = {...}: {
            imports = [
              ronema
            ];
          };

          ronema = {pkgs, ...}: let
            hm-module = import ./nix/hm-module.nix {
              package = withSystem pkgs.stdenv.hostPlatform.system ({config, ...}: config.packages.ronema);
            };
          in {
            imports = [hm-module];
          };
        };

        overlays.default = final: prev: let
          packages = withSystem prev.stdenv.hostPlatform.system ({config, ...}: config.packages);
        in {ronema = packages.ronema;};
      };
    });
}
