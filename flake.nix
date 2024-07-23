# flake.nix

{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    stylix.url = "github:danth/stylix";

    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    ags.url = "github:Aylur/ags";
  };

  outputs = { ... }@inputs: {

      nixosConfigurations = {
  
        laptop = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/laptop/configuration.nix
            inputs.self.outputs.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };
  
      };
  
      homeConfigurations = {
  
        "ethanp@laptop" =  inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/laptop/home.nix
            inputs.self.outputs.homeManagerModules.default
          ];
        };

      };
  
      homeManagerModules.default = ./homeManagerModules;
      nixosModules.default = ./nixosModules;
      
    };
}
