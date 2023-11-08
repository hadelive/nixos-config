{ pkgs, ... }:
# For newer versions of software that pushes users for new updates.
let pkgsUnstable = import (builtins.fetchTarball {
  url = "https://github.com/nixos/nixpkgs/archive/9478ec747c459cf96a46f2ae4148cc3451df65c5.tar.gz";
  sha256 = "1knal44ikpcybhyw53z034aps5vd8kvqlv022hgszl9xxl0kiphh";
}) {
  config.allowUnfree = true;
};
in
{
  imports = [
    ./boot.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./xserver.nix
    ./users.nix
  ];

  # Latest stable release please.
  system.stateVersion = "21.11";

  # For Google Chrome, Slack, etc.
  nixpkgs.config.allowUnfree = true;

  # Audio.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.pulseaudio = true;

  # Nix.
  nix = {
    # Nix flakes for several Cardano projects.
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Nix caches for the and Cardano projects.
    binaryCaches = [
      "https://hydra.iohk.io"
      "https://iohk.cachix.org"
      "https://cache.nixos.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  # Docker
  virtualisation.docker.enable = true;

  # System packages
  environment.systemPackages = [
    # Communication
    pkgs.slack
    pkgsUnstable.discord
    pkgsUnstable.signal-desktop
    pkgsUnstable.tdesktop

    # Dev tools
    pkgs.alacritty
    pkgs.emacs
    pkgs.git
    pkgs.vim
    pkgsUnstable.vscode

    # Signing
    pkgs.gnupg
    pkgs.pinentry

    # Utility
    pkgs.dmenu
    pkgs.haskellPackages.xmobar
    pkgsUnstable.google-chrome
  ];
}
