{
  config,
  pkgs,
  system,
  inputs,
  pkgs-unstable,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/config/configs/user";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  vars = import ./variables.nix;
  configs = {
    kitty = "kitty";
    nvim = "nvim";
    starship = "starship";
    hypr = "hypr";
    waybar = "waybar";
    television = "television";
    fastfetch = "fastfetch";
    # yazi = "yazi";
  };
in
{
  home.username = "bfoster";
  home.homeDirectory = "/home/bfoster";
  home.stateVersion = "26.05"; # Please read the comment before changing.
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ben Foster";
        email = "dev@athomeadmin.net";
      };
      init.defaultBranch = "main";
    };
  };

  programs.yazi = {
    enable = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "mtime";
      };
    };
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true; # Note: singular "autosuggestion" in Home Manager
    syntaxHighlighting.enable = true;
    shellAliases = {
      zreload = "source /home/bfoster/.zshrc";
      #breload = "source /home/bfoster/.bashrc";
      whosyourdaddy = "echo eat shite";
      rebuildnix = "sudo nixos-rebuild switch --flake ~/config#EXILE";
      conf = "sudo nvim ~/.zshrc";
      devshell = "nix-shell --pure";
      rust = "rustc";
      devnotes = "tjournal";
      collect = "nix-collect-garbage";
      hearthstone = "cd ~/Projects/Hearthstone";
      storbage = "nix-store --gc";
      garbage = "nix-collect-garbage -d";
      python = "python3";
      launcher = "cd ~/Projects/goprojects/project-launcher";
      cordbot = "cd ~/Projects/Python/cordbot";
      gocordbot = "cd ~/Projects/goprojects/gocordbot";
      inventory = "cd ~/Projects/goprojects/go-inv";
      z = "zoxide";
      rebuildstore = "sudo nix-store --verify --check-contents --repair";
      icat = "kitty +kitten icat \"$(kitty +kitten choose-files)\"";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # Enabled by default
    options = [
      "--cmd cd" # Optional: replaces 'cd' with 'z'
    ];
  };
  programs.starship.enable = true;
  services.wpaperd.enable = true;
  services.wpaperd.settings = {
    eDP-1 = {
      path = "/home/bfoster/config/configs/user/hyprpaper/Fuji-Dark.png";
    };
  };
  programs.zsh.initContent = ''

    fastfetch
    export YAZI_CONFIG_HOME="$HOME/config/configs/user/yazi"

  '';
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    (with pkgs; [
      ripgrep
      nil
      #nh
      nixpkgs-fmt
      nodejs
      gcc
      cargo
      wl-clipboard
      starship
      tmux
      nixfmt
      television
      bat
      fd
      fish
      statix
      helix
      fastfetch
      kitty
      git
      unzip
      python3
      go
      tui-journal
      yazi
      gh
      tea
      waybar
      rofi
      #thunar
      wofi
      wpaperd
      nwg-look
      hypridle
      hyprlock
      wdisplays
      dunst
      pavucontrol
      lazygit
      hyprcursor
      terraform
      tealdeer
      pgcli
      usql
      discord
      age
      atac
      lazyssh
      gotify-cli
      lazysql
      nushell
      atuin
      waypaper
      hypridle
      hyprlock
      hyprshot
      pandoc
      sqlite
      postgresql
      sqlitebrowser
      mdfried
    ])

    ++

      (with pkgs-unstable; [
        nh
        warp-terminal
        neovim
        showmethekey
      ]);

  wayland.windowManager.hyprland.systemd.enable = false;

  # Install Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.rose-pine-hyprcursor;
    name = "Rose-Pine-Hyprcursor";
    size = 16;
  };
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/bfoster/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";

  };
  services.ssh-agent.enable = true;
  # Let Home Manager install and manage itself.

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

}
