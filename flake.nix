{
  description = "stable-diffusion";

  inputs = {
    nixlib.url = "github:nix-community/nixpkgs.lib";
    nixpkgs.url = "github:colemickens/nixpkgs/stable-diff";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://stable-diff.cachix.org"
    ];
    extra-trusted-public-keys = [
      "stable-diff.cachix.org-1:liYFm3f3q1dAoilj2Ag2IEKzW3Q9/HJcLlrAIytAcy0="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
  };

  outputs = inputs:
    let
      nixlib = inputs.nixlib.outputs.lib;
      nixpkgs_ = forAllSystems (system: import inputs.nixpkgs { inherit system; });
      supportedSystems = [
        "x86_64-linux"
      ];
      forAllSystems = nixlib.genAttrs supportedSystems;
    in rec {
      devShells = forAllSystems (system: rec {
        webui = (import ./stable-diffusion-webui.nix { nixpkgs = inputs.nixpkgs; inherit system; });
        webui-pip = (import ./stable-diffusion-webui-pip.nix { nixpkgs = inputs.nixpkgs; inherit system; });
        default = nixpkgs_.${system}.mkShell {
          name = "stable-diffusion-flake";
          nativeBuildInputs = with nixpkgs_."${system}"; [
            nixUnstable git
          ];
        };
      });
      
      # TODO: nixlib should have a function for this:
      # cachable = [
      #   inputs.self.devShells.working.x86_64-linux.working.inputDerivation
      #   inputs.self.devShells.working.x86_64-linux.default.inputDerivation
      # ]

      # apps = forAllSystems (system: {
      #    stable-diffusion = { type = "app"; program = "${packages.${system}.stable-diffusion}"; };
      # });

      # packages = forAllSystems (system: rec {
      #   default = stable-diffusion;
      #   stable-diffusion = ;
      # });
    };
}
