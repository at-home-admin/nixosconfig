# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  pkgs-unstable,
  lib,
  ...
}:
let
  gotifyUrl = "https://notification.athomeadmin.net";
  gotifyToken = "ACeTrqPOxl6UTnA";

  # Helper script to send the push notification
  gotifyNotify =
    title: message: priority:
    pkgs.writeShellScript "gotify-notify" ''
      ${pkgs.curl}/bin/curl -s -X POST "${gotifyUrl}/message" \
        -F "title=${title}" \
        -F "message=${message}" \
        -F "priority=${priority}" \
        -F "token=${gotifyToken}" > /dev/null
    '';
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./variables.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.systemd.tpm2.enable = false;
  security.tpm2.enable = false;
  networking.hostName = "EXILE"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/"
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # Enable nm-applet (installs networkmanagerapplet)
  programs.nm-applet.enable = true;
  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  boot.initrd.kernelModules = [ ];
  systemd.services."NetworkManager-wait-online".enable = false;

  systemd.units."dev-ttyS1.device".text = "";
  systemd.units."sys-devices-platform-serial8250.0-tty-ttyS1.device".text = "";
  # Set Boot parameters to stop overwriting on Login Screen
  boot.kernelParams = [
    "quiet"
    "splash"
    "intel_iommu=igfx_off"
    "i915.fastboot=1"
    "i915.enable_psr=0"
    "i915.enable_fbc=0"
    "intel_idle.max_cstate=2"
    "systemd.tpm2_wait=false"
    "systemd.tpm2_automount=false"
    "tpm_tis.interrupts=0"
    "initcall_blacklist=tpm_tim_init"
    "systemd.tpm2_wait=false"
    "systemd.default_device_timeout_sec=1"
    "acpi_os_name=Linux"
    "acpi_enforce_resources=lax"
    "tpm_tis.force=0"

  ];
  # Kernel Modules Blacklisted
  boot.blacklistedKernelModules = [
    "tpm_tis"
    "tpm_tis_core"
    "tpm"
    "tpm_tis_core"
    "tpm_crb"
    "efivarfs"
    "tpm"
    "tpm_tis"
    "tpm_tis_core"
    "tpm_crb"
  ];
  systemd.services."dev-tpm0.device".enable = false;
  #
  systemd.services."dev-tpmrm0.device".enable = false;
  #
  systemd.targets."tpm2.target".enable = false;
  systemd.targets.tpm2.enable = false;
  systemd.targets.tpm2.wantedBy = lib.mkForce [ ];
  boot.initrd.services.udev.rules = ''
    SUBSYSTEM=="tpm", ENV{SYSTEMD_READY}="0"
    KERNEL=="tpm0", ENV{SYSTEMD_READY}="0"
    KERNEL=="tpmrm0", ENV{SYSTEMD_READY}="0"
  '';
  boot.initrd.systemd.enable = true;
  # Enable the X11 windowing system.
  #  services.xserver.enable = true;

  # Disable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.desktopManager.xfce.enable = false;

  # Enable Hyprland DE
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.sessionVariables = {
    QT_LOGGING_RULES = "qt.qpa.wayland.debug=false";
  };
  # Optional: Recommended for Electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable Tui-Greet As Login Manager
  services.greetd = {
    enable = true;
    settings = {
      serviceConfig.Type = "idle";
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --cmd start-hyprland";
        user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig.Type = "idle";
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.pipewire.wireplumber.extraConfig."10-bluez" = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = [
        "hsp_hs"
        "hsp_ag"
        "hfp_hf"
        "hfp_ag"
      ];
    };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bfoster = {
    isNormalUser = true;
    description = "Ben Foster";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "input"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Enable users in group wheel to run pkexec without entering sudo password

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          action.lookup("program") == "/nix/store/.../bin/showmethekey-cli" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Enable Dynamic Linking
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    # Add the specific missing library here
  ];
  # Disable firefox to use zen browser instead.
  programs.firefox.enable = false;
  # Disable nano
  programs.nano.enable = false;
  # Enable zsh and set it as default for user
  programs.zsh.enable = true;
  users.users.bfoster.shell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.wrappers.sniffnet = {
    source = "${pkgs.sniffnet}/bin/sniffnet";
    capabilities = "cap_net_raw,cap_net_admin=eip";
    owner = "root";
    group = "root";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: [
      ps.tzlocal
      ps.pytz
    ]))
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    magic-wormhole
    zsh
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    networkmanagerapplet
    lazydocker
    hyprpolkitagent
    zlib
    ov
  ];
  # Install and enable FiraCode Font
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  # List services that you want to enable:

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Enable Automatic Garbage Collection (Clear Out Old COnfigurations and Packages)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-7d";
  };
  # Delay the GC service until after the system is fully booted and online
  systemd.services.nix-gc = {
    after = [
      "network.target"
      "time-sync.target"
    ];
    requires = [ "network.target" ];
  };
  nix.optimise.automatic = true; # Optimise storage
  # Enable Automatic Upgrades and Turn Off Auto Reboot
  system.autoUpgrade = {
    enable = true;
    flake = "github:at-home-admin/nixosconfig"; # Path to your configuration directory
    dates = "17:00";
    randomizedDelaySec = "15min";
    operation = "switch";
    persistent = true;
    flags = [
      "--print-build-logs"
      "--commit-lock-file" # Automatically saves your updated flake.lock
    ];
  };

  # 2. Templated Service for Notifications
  systemd.services."notify-gotify@" = {
    description = "Send Gotify notification for %I";
    serviceConfig.Type = "oneshot";
    script = ''
      SERVICE_NAME="%I"
      # Check if service succeeded or failed
      if ${pkgs.systemd}/bin/systemctl is-active --quiet $SERVICE_NAME; then
        ${gotifyNotify "NixOS Update Succeeded" "System successfully rebuilt and updated via flakes." "3"}
      else
        LOG=$(${pkgs.systemd}/bin/systemctl status --no-pager $SERVICE_NAME)
        ${gotifyNotify "NixOS Update Failed" "System update failed! \n\n$LOG" "8"}
      fi
    '';
  };

  # 3. Trigger notification on Upgrade failure or success
  systemd.services.nixos-upgrade = {
    onFailure = [ "notify-gotify@%n.service" ];
    postStart = ''
      ${pkgs.systemd}/bin/systemctl start notify-gotify@%n.service
    '';
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "26.05";

}
