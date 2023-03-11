{ config, lib, pkgs, ... }:

{
  boot = {
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };

    # load modules on boot
    # kernelModules = ["acpi_call" "amdgpu" "amd_pstate"];

    # use latest kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # Panel Self Refresh
    # kernelParams = ["amdgpu.dcfeaturemask=0x8" "initcall_blacklist=acpi_cpufreq_init" "amd_pstate=passive" "amd_pstate.shared_mem=1"];

    loader = {
      # systemd-boot on UEFI
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    plymouth.enable = true;
  };

  environment.systemPackages = [config.boot.kernelPackages.cpupower];

  hardware = {
    bluetooth = {
      enable = true;
      # battery info support
      package = pkgs.bluez5-experimental;
      settings = {
        # make Xbox Series X controller work
        General = {
          Class = "0x000100";
          ControllerMode = "bredr";
          FastConnectable = true;
          JustWorksRepairing = "always";
          Privacy = "device";
          Experimental = true;
        };
      };
    };

    cpu.intel.updateMicrocode = true;

    enableRedistributableFirmware = true;
  };

  programs = {
    zsh.enable = true;
    gnupg.agent.enable = true;
    # backlight control
    light.enable = true;
    # steam.enable = true;
  };

  services = {
    printing.enable = true;

    # power saving
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "conservative";
        NMI_WATCHDOG = 0;
      };
    };

  };

}
