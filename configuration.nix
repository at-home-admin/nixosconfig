# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "EXILE"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/"
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  # Set Boot parameters to stop overwriting on Login Screen
  boot.kernelParams = [
    "quiet"
    "splash"
    "intel_iommu=igfx_off"
    "i915.fastboot=1"
    "i915.enable_psr=0"
    "i915.enable_fbc=0"
    "intel_idle.max_cstate=2"
  ];
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
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --cmd Hyprland";
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

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bfoster = {
    isNormalUser = true;
    description = "Ben Foster";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Enable Dynamic Linking
  programs.nix-ld.enable = true;
  # Install firefox.
  programs.firefox.enable = false;
  # Disable nano
  programs.nano.enable = false;
  # Enable zsh and set it as default for user
  programs.zsh.enable = true;
  users.users.bfoster.shell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    magic-wormhole
    zsh
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    wireplumber
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

  # Enable Automatic Garbage Collection (Clear Out Old COnfigurations and Packages)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-7-d";
  };

  # Enable Automatic Upgrades and Turn Off Auto Reboot
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.11";

}
