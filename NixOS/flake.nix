{
  description = "NixOS configurations for the development";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
  };

  outputs = { nixpkgs, ... }: {
    nixos = nixpkgs.lib.nixosSystem {
      modules = [ ./configs/configuration.nix ];
      system = "x86_64-linux";
    };
  };
}
