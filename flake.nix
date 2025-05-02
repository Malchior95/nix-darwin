{
  description = "IronChe's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #nixstable.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
    ...
  }: let
    system = "aarch64-darwin";
    #pkgsStable = inputs.nixstable.legacyPackages.${system};
    configuration = {
      pkgs,
      config,
      ...
    }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.home-manager
      ];
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      homebrew = {
        enable = true;
        casks = [
          "dotnet-sdk" #required for godot-mono
          "godot-mono"
          "blender"
          "krita"
          "qbittorrent"
        ];
        onActivation.cleanup = "zap";
      };

      #services.netbird.enable = true;
      services.tailscale.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = system;
      nixpkgs.config.allowUnfree = true;
    };
    user = "ironche";
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."iron-mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = user;
          };
        }
      ];
    };

    homeConfigurations.${user} = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        ./home-manager
        #inputs.sops-nix.homeManagerModules.sops
      ];
      extraSpecialArgs = {
        inherit user system inputs; #pkgsStable;
      };
    };
  };
}
