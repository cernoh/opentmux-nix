{
  description = "OpenCode tmux integration as a Nix home-manager module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }
      );
    in
    {
      # The opentmux package, built from the local source of this flake.
      packages = forAllSystems (system: {
        default = nixpkgsFor.${system}.opentmux;
        opentmux = nixpkgsFor.${system}.opentmux;
      });

      # Overlay that adds opentmux to pkgs so the module can reference it as
      # pkgs.opentmux when the overlay is applied.
      overlays.default = final: _prev:
        let
          # Inherit esbuild from the same pkgs set so the native binary always
          # matches the build platform.
          inherit (final) esbuild;
        in
        {
          opentmux = final.callPackage ./nix/package.nix {
            src = self;
            inherit esbuild;
          };
        };

      # Home-manager module – the primary deliverable of this flake.
      # Users add this to their home-manager configuration as shown in README.md.
      homeManagerModules = {
        default = import ./nix/module.nix;
        opentmux = import ./nix/module.nix;
      };

      # Expose the home-manager module under nixosModules as well so it can be
      # consumed by callers that pass modules through nixosModules rather than
      # homeManagerModules (e.g. some nixos-rebuild setups).
      nixosModules = {
        default = import ./nix/module.nix;
        opentmux = import ./nix/module.nix;
      };
    };
}
