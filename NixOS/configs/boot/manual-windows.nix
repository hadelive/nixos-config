{ ... }:
{
  # Dual boot with Windows through GRUB.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      device = "nodev";
      efiSupport = true;
      enable = true;
      # Replace `86BC-0081` with the UUID of the EFI partition.
      # One can find it with, for example, `blkid /dev/nvme0n1p1`.
      extraEntries = ''
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root 86BC-0081
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      version = 2;
    };
  };
}
