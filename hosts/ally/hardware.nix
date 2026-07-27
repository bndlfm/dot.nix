# This is a stub hardware configuration.
# When you boot NixOS on your ROG Ally, generate your hardware config with:
# nixos-generate-config --show-hardware-config > hardware.nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Note: Add your filesystem mounts below!
  # fileSystems."/" =
  #   { device = "/dev/disk/by-uuid/your-uuid-here";
  #     fsType = "ext4";
  #   };

  # fileSystems."/boot" =
  #   { device = "/dev/disk/by-uuid/your-uuid-here";
  #     fsType = "vfat";
  #   };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
