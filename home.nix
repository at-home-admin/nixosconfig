{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/config/configs/user";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    kitty = "kitty";
    nvim = "nvim";
    starship = "starship";
  };
in
{
  home.username = "bfoster";
  home.homeDirectory = "/home/bfoster";
  home.stateVersion = "25.11"; # Please read the comment before changing.
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

  programs.zsh = {
    enable = true;
    shellAliases = {
      zreload = "source /home/bfoster/.zshrc";
      #breload = "source /home/bfoster/.bashrc";
      whosyourdaddy = "echo eat shite";
      rebuildnix = "sudo nixos-rebuild switch --flake ~/config#EXILE";
      conf = "sudo nvim ~/.zshrc";
      devshell = "nix-shell --pure";
      rust = "rustc";
    };

  };
  programs.starship.enable = true;

  programs.zsh.initExtra = "fastfetch";
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nh
    nixpkgs-fmt
    nodejs
    gcc
    cargo
    wl-clipboard
    starship
    zoxide
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
    opencode
    git
    unzip
    python3
    go
    tui-journal

  ];

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
    EDITOR = "neovim";
  };

  # Let Home Manager install and manage itself.

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

}
