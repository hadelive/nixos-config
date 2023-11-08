{ ... }:
{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # XMonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    # Lock screen
    displayManager.lightdm.enable = true;
    xautolock.enable = true;
  };
}
