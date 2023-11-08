## Credits

This repository contains content that was sourced from external resources and is not originally created by me. I have collected this material for educational and reference purposes, ensuring it aligns with the original terms and licenses. All rights and acknowledgments belong to the respective creators.


### VM

We can test the configurations here by using the `build-vm` option for `nixos-rebuild`:

``` sh
sudo nixos-rebuild build-vm -I nixos-config=NixOS/configs/configuration.nix
```

Once the build completes, we should see the path to the VM, which we can start and test.

``` sh
Done.  The virtual machine can be started by running /nix/store/h9nfc6ndzfr64ygfqjp7lzfza094q54h-nixos-vm/bin/run-nixos-vm
```

After starting the VM, we can log in using these credentials:

``` sh
user: hade
password: hade
```

### NixOS

We can also apply the configurations to a typical NixOS installation through the following steps.

1. Copy over the NixOS configurations. Remember to backup your own modifications if needed.

```sh
# Root
$ sudo cp NixOS/configs/configuration.nix /etc/nixos/configuration.nix

# Boot
$ sudo cp NixOS/configs/boot/single.nix /etc/nixos/boot.nix

# Locale
$ sudo cp NixOS/configs/locale.nix /etc/nixos/locale.nix

# Networking
$ sudo cp NixOS/configs/networking.nix /etc/nixos/networking.nix

# Users
$ sudo cp NixOS/configs/users.nix /etc/nixos/users.nix

# XServer
$ sudo cp NixOS/configs/xserver.nix /etc/nixos/xserver.nix
```

2. Make further custom changes. For example, to update `users.nix` with your own users, or to update `networking.nix` with the correct local networking interface.

3. Rebuild your NixOS to get everything you need for the development!

```sh
sudo nixos-rebuild test
sudo nixos-rebuild switch
```

## XMonad (with XMobar)

1. Copy the config files to the correct places:

```sh
cp xmonad/xmonad.hs ~/.xmonad/
cp xmonad/xmobarrc ~/.config/xmobar/
```

2. Hit `Win/Super Q`!
