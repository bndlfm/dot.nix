{ config, inputs, lib, pkgs, ... }:

let
  cfg = config.hardware.logitech-trueforce;
  kernel = config.boot.kernelPackages.kernel;
  trueforce = inputs.logitech-trueforce;
  upstreamKernelModule = trueforce.packages.${pkgs.system}.kernel-module;

  signedKernelModule = upstreamKernelModule.overrideAttrs (old: {
    # Build against the host kernel, not the package output's default kernel.
    makeFlags = [
      "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ];
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.kmodigest ];
    installPhase = ''
      moddir=$out/lib/modules/${kernel.modDirVersion}/extra
      mkdir -p "$moddir"
      cp mainline/hid-logitech-dd.ko "$moddir/"
      kmodigest "$moddir/hid-logitech-dd.ko"
    '';
  });
in
{
  options.hardware.logitech-trueforce.enable = lib.mkEnableOption "Logitech TrueForce wheel driver";

  config = lib.mkIf cfg.enable {
    # Ordinary list merging preserves NVIDIA and other external modules.
    boot.extraModulePackages = [ signedKernelModule ];
    boot.kernelModules = [ "hid-logitech-dd" "uhid" ];
    boot.initrd.kernelModules = [ "hid-logitech-dd" ];
    boot.extraModprobeConfig = ''
      softdep hid-logitech-hidpp pre: hid-logitech-dd
      softdep hid-logitech pre: hid-logitech-dd
      blacklist hid-logitech-new
    '';
    services.udev.packages = [ trueforce.packages.${pkgs.system}.udev-rules ];
    environment.systemPackages = [
      trueforce.packages.${pkgs.system}.logi-wheel
      trueforce.packages.${pkgs.system}.logi-wheel-modeswitch
    ];
  };
}
