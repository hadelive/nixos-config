{ ... }:
{
  users = {
    mutableUsers = false;
    users.hade = {
      isNormalUser = true;
      # mkpasswd -m sha-512 -s
      hashedPassword = "****";
      extraGroups = [ "audio" "docker" "sound" "wheel" ];
    };
  };
}
