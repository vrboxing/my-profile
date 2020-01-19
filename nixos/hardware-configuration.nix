# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/CF48-6C3C";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a8b91326-9a5f-47c9-b827-19e1ce17cfe8";
      fsType = "xfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/d05ef9fb-1433-4819-b1a7-e15b5a7b9a90"; }
    ];

    fileSystems."/qemu-img" =
    { device = "/dev/disk/by-uuid/749df476-c355-469a-9d00-4565a07901bf";
      fsType = "xfs";
    };

  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
